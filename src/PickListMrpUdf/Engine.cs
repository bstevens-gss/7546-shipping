using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace PickListMrpUdf
{
    public static class Engine
    {
        public static string AllocationKey(int salesOrderNumber, int salesOrderLineNumber)
        {
            return salesOrderNumber.ToString("0000000", CultureInfo.InvariantCulture)
                + "-"
                + salesOrderLineNumber.ToString("000", CultureInfo.InvariantCulture);
        }

        public static DateTime PickThroughDate(DateTime today, int workDays)
        {
            var result = today.Date;
            var remaining = workDays;
            while (remaining > 0)
            {
                result = result.AddDays(1);
                if (result.DayOfWeek > DayOfWeek.Monday && result.DayOfWeek < (DayOfWeek)7)
                {
                    remaining--;
                }
            }
            return result;
        }

        public static IReadOnlyList<PickLine> OrderWalk(IEnumerable<PickLine> lines)
        {
            var ordered = lines
                .OrderBy(x => x.PickByDate)
                .ThenBy(x => x.LoadNo)
                .ThenByDescending(x => x.LoadSeq)
                .ThenBy(x => ParseInt(x.OrderNo))
                .ThenBy(x => x.OrderLineNumber)
                .ToList();
            for (var i = 0; i < ordered.Count; i++)
            {
                ordered[i].MobileSequence = i + 1;
            }
            return ordered;
        }

        public static IReadOnlyList<PickLine> SelectLines(IEnumerable<PickLine> lines, RunOptions options)
        {
            var through = PickThroughDate(options.Today, options.PickWindowWorkDays);
            return lines.Where(line =>
            {
                if (line.Picked != 0)
                {
                    return false;
                }
                if (options.UseLoadPlanning && (line.DisplayFlag != 1 || line.LoadNo <= 0))
                {
                    return false;
                }
                if (options.AutoPopulate && line.PickByDate.Date > through)
                {
                    return false;
                }
                if (!IsWholeNumber(line.OrderSuffix))
                {
                    return false;
                }
                return true;
            }).ToList();
        }

        public static IReadOnlyList<OnHandBin> BinsForLine(PickLine line, IEnumerable<OnHandBin> bins, BinRules rules)
        {
            var part = (line.Part ?? string.Empty).Trim();
            var location = (line.Location ?? string.Empty).Trim();
            var matched = bins.Where(bin =>
                string.Equals((bin.Part ?? string.Empty).Trim(), part, StringComparison.OrdinalIgnoreCase)
                && string.Equals((bin.Location ?? string.Empty).Trim(), location, StringComparison.OrdinalIgnoreCase)
                && bin.Quantity > 0
                && !IsOLocation(bin.Bin)
                && PassesAllocation(line, bin, rules));

            return matched
                .OrderBy(bin => IsELocation(bin.Bin) ? 0 : 1)
                .ThenBy(bin => (bin.Bin ?? string.Empty).Trim(), StringComparer.OrdinalIgnoreCase)
                .ThenBy(bin => (bin.Lot ?? string.Empty).Trim(), StringComparer.OrdinalIgnoreCase)
                .ThenBy(bin => (bin.Heat ?? string.Empty).Trim(), StringComparer.OrdinalIgnoreCase)
                .ThenBy(bin => (bin.Serial ?? string.Empty).Trim(), StringComparer.OrdinalIgnoreCase)
                .ToList();
        }

        public static IReadOnlyList<ItemBinRow> BuildItemRows(IEnumerable<PickLine> lines, IEnumerable<OnHandBin> bins, RunOptions options)
        {
            if (!options.LotBinDetail)
            {
                return new List<ItemBinRow>();
            }
            var rules = options.BinRules ?? new BinRules();
            var binList = bins.ToList();
            var rows = new List<ItemBinRow>();
            foreach (var line in lines)
            {
                foreach (var bin in BinsForLine(line, binList, rules))
                {
                    rows.Add(new ItemBinRow
                    {
                        OrderNo = (line.OrderNo ?? string.Empty).Trim(),
                        OrderLineRaw = (line.OrderLineRaw ?? string.Empty).Trim(),
                        OrderLineNumber = line.OrderLineNumber,
                        OrderSuffix = (line.OrderSuffix ?? string.Empty).Trim(),
                        Part = (line.Part ?? string.Empty).Trim(),
                        Location = (line.Location ?? string.Empty).Trim(),
                        Lot = (bin.Lot ?? string.Empty).Trim(),
                        Bin = (bin.Bin ?? string.Empty).Trim(),
                        Heat = (bin.Heat ?? string.Empty).Trim(),
                        Serial = (bin.Serial ?? string.Empty).Trim(),
                        Quantity = bin.Quantity
                    });
                }
            }
            return rows;
        }

        private static bool PassesAllocation(PickLine line, OnHandBin bin, BinRules rules)
        {
            var useAllocated = rules.AllocatedToSalesOrder
                && rules.UnallocateFromSalesToStaging
                && IsManufacturedOrPurchased(line.SourceCode);
            if (!useAllocated)
            {
                return !bin.Allocated;
            }
            if (!bin.Allocated || !string.Equals((bin.AllocType ?? string.Empty).Trim(), "S", StringComparison.OrdinalIgnoreCase))
            {
                return false;
            }
            var field = (rules.AllocatedField ?? string.Empty).Trim();
            if (field.Length == 0)
            {
                return true;
            }
            var key = AllocationKey(ParseInt(line.OrderNo), line.OrderLineNumber);
            string actual;
            if (string.Equals(field, "HEAT", StringComparison.OrdinalIgnoreCase))
            {
                actual = bin.Heat;
            }
            else if (string.Equals(field, "SERIAL_NUMBER", StringComparison.OrdinalIgnoreCase))
            {
                actual = bin.Serial;
            }
            else if (string.Equals(field, "LOT", StringComparison.OrdinalIgnoreCase))
            {
                actual = bin.Lot;
            }
            else
            {
                return true;
            }
            return string.Equals((actual ?? string.Empty).Trim(), key, StringComparison.OrdinalIgnoreCase);
        }

        private static bool IsManufacturedOrPurchased(string sourceCode)
        {
            var source = (sourceCode ?? string.Empty).Trim();
            return source.Equals("M", StringComparison.OrdinalIgnoreCase)
                || source.Equals("F", StringComparison.OrdinalIgnoreCase)
                || source.Equals("P", StringComparison.OrdinalIgnoreCase);
        }

        private static bool IsELocation(string bin)
        {
            var trimmed = (bin ?? string.Empty).Trim();
            return trimmed.Length > 0 && (trimmed[0] == 'E' || trimmed[0] == 'e');
        }

        private static bool IsOLocation(string bin)
        {
            var trimmed = (bin ?? string.Empty).Trim();
            return trimmed.Length > 0 && (trimmed[0] == 'O' || trimmed[0] == 'o');
        }

        public static bool IsWholeNumber(string value)
        {
            var trimmed = (value ?? string.Empty).Trim();
            if (trimmed.Length == 0)
            {
                return false;
            }
            for (var i = 0; i < trimmed.Length; i++)
            {
                if (trimmed[i] < '0' || trimmed[i] > '9')
                {
                    return false;
                }
            }
            return true;
        }

        public static int ParseInt(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
            {
                return 0;
            }
            var trimmed = value.Trim();
            if (int.TryParse(trimmed, NumberStyles.Integer, CultureInfo.InvariantCulture, out var parsed))
            {
                return parsed;
            }
            var digits = new string(trimmed.Where(char.IsDigit).ToArray());
            return int.TryParse(digits, NumberStyles.Integer, CultureInfo.InvariantCulture, out parsed) ? parsed : 0;
        }
    }
}
