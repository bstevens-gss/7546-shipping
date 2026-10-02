using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;

namespace PickListMrpUdf
{
    public sealed class Runner
    {
        public string Execute(string workDirectory)
        {
            if (string.IsNullOrWhiteSpace(workDirectory))
            {
                return "ERR missing work directory";
            }
            var options = ReadOptions(Path.Combine(workDirectory, "PickListMrpUdf_options.csv"));
            if (!options.UseMrp)
            {
                return "SKIP";
            }
            var lines = SelectAndOrder(ReadLines(Path.Combine(workDirectory, "PickListMrpUdf_lines.csv")), options);
            WriteSequence(Path.Combine(workDirectory, "PickListMrpUdf_sequence.csv"), lines);
            var items = options.LotBinDetail
                ? Engine.BuildItemRows(lines, ReadItems(Path.Combine(workDirectory, "PickListMrpUdf_items.csv")), options)
                : new List<ItemBinRow>();
            WriteItems(Path.Combine(workDirectory, "PickListMrpUdf_itembins.csv"), items);
            return options.LotBinDetail ? "WRITE" : "OK";
        }

        public static RunOptions ReadOptions(string path)
        {
            var rows = Csv.Read(path);
            string Text(int id)
            {
                var row = rows.FirstOrDefault(x => Engine.ParseInt(Cell(x, "ID")) == id);
                return row == null ? string.Empty : Cell(row, "TEXT1");
            }
            bool Flag(int id)
            {
                var row = rows.FirstOrDefault(x => Engine.ParseInt(Cell(x, "ID")) == id);
                if (row == null)
                {
                    return false;
                }
                var raw = Cell(row, "F_BOOLEAN").Trim();
                return raw == "1" || raw.Equals("true", StringComparison.OrdinalIgnoreCase) || raw == "-1";
            }
            int Long(int id)
            {
                var row = rows.FirstOrDefault(x => Engine.ParseInt(Cell(x, "ID")) == id);
                return row == null ? 0 : Engine.ParseInt(Cell(row, "F_LONG"));
            }
            var allocated = string.Equals(Text(402680).Trim(), "Only Display Records Allocated to the Sales Order", StringComparison.OrdinalIgnoreCase);
            string field = null;
            if (allocated)
            {
                var which = Long(401187);
                if (which == 1) field = "LOT";
                else if (which == 2) field = "HEAT";
                else if (which == 3) field = "SERIAL_NUMBER";
            }
            return new RunOptions
            {
                UseMrp = Flag(402676),
                UseLoadPlanning = Flag(402674),
                AutoPopulate = Flag(402677),
                PickWindowWorkDays = Long(402678),
                LotBinDetail = Flag(402679),
                Today = DateTime.Today,
                BinRules = new BinRules
                {
                    AllocatedToSalesOrder = allocated,
                    UnallocateFromSalesToStaging = Flag(402598),
                    AllocatedField = field
                }
            };
        }

        private static List<PickLine> SelectAndOrder(IEnumerable<PickLine> lines, RunOptions options)
        {
            return Engine.OrderWalk(Engine.SelectLines(lines, options)).ToList();
        }

        public static List<PickLine> ReadLines(string path)
        {
            return Csv.Read(path).Select(row =>
            {
                var rawLine = Cell(row, "ORDER_LINE");
                var lineNo = Engine.ParseInt(rawLine);
                return new PickLine
                {
                    Customer = Cell(row, "CUSTOMER").Trim(),
                    OrderNo = Cell(row, "ORDER_NO").Trim(),
                    OrderSuffix = Cell(row, "ORDER_SUFFIX").Trim(),
                    OrderLineRaw = rawLine.Trim(),
                    OrderLineNumber = lineNo / 10,
                    PickByDate = ParseDate(Cell(row, "PICK_BY_DATE")),
                    LoadNo = Engine.ParseInt(Cell(row, "LOAD_NO")),
                    LoadSeq = Engine.ParseInt(Cell(row, "LOAD_SEQ")),
                    Part = Cell(row, "PART").Trim(),
                    Location = Cell(row, "LOCATION").Trim(),
                    SourceCode = Cell(row, "KEY_SOURCE").Trim(),
                    QtyBo = ParseDouble(Cell(row, "QTY_BO")),
                    Picked = FlagValue(Cell(row, "PICKED")),
                    DisplayFlag = FlagValue(Cell(row, "PCKLST_DISP_FLAG"))
                };
            }).ToList();
        }

        public static List<OnHandBin> ReadItems(string path)
        {
            return Csv.Read(path).Select(row => new OnHandBin
            {
                Part = Cell(row, "PART").Trim(),
                Location = Cell(row, "LOCATION").Trim(),
                Lot = Cell(row, "LOT").Trim(),
                Bin = Cell(row, "BIN").Trim(),
                Heat = Cell(row, "HEAT").Trim(),
                Serial = Cell(row, "SERIAL_NUMBER").Trim(),
                Quantity = ParseDouble(Cell(row, "QUANTITY")),
                Allocated = IsYes(Cell(row, "ALLOCATED")),
                AllocType = Cell(row, "ALLOC_TYPE").Trim()
            }).ToList();
        }

        private static void WriteSequence(string path, IReadOnlyList<PickLine> lines)
        {
            var sb = new StringBuilder();
            sb.AppendLine("CUSTOMER,ORDER_NO,ORDER_LINE,ORDER_SUFFIX,MOBILE_SEQUENCE");
            foreach (var line in lines)
            {
                sb.Append(Csv.Escape(line.Customer)).Append(',')
                    .Append(Csv.Escape(line.OrderNo)).Append(',')
                    .Append(Csv.Escape(line.OrderLineRaw)).Append(',')
                    .Append(Csv.Escape(line.OrderSuffix)).Append(',')
                    .Append(line.MobileSequence.ToString(CultureInfo.InvariantCulture))
                    .AppendLine();
            }
            File.WriteAllText(path, sb.ToString());
        }

        private static void WriteItems(string path, IReadOnlyList<ItemBinRow> rows)
        {
            var sb = new StringBuilder();
            sb.AppendLine("ORDER_NO,ORDER_LINE,ORDER_SUFFIX,PART,LOC,LOT,BIN,HEAT,SERIAL_NUMBER,QUANTITY,MODIFIED_BY_PROG,MODIFIED_BY_USER,MODIFIED_BY_DATE");
            var today = DateTime.Today.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
            foreach (var row in rows)
            {
                sb.Append(Csv.Escape(row.OrderNo)).Append(',')
                    .Append(Csv.Escape(row.OrderLineRaw)).Append(',')
                    .Append(Csv.Escape(row.OrderSuffix)).Append(',')
                    .Append(Csv.Escape(row.Part)).Append(',')
                    .Append(Csv.Escape(row.Location)).Append(',')
                    .Append(Csv.Escape(row.Lot)).Append(',')
                    .Append(Csv.Escape(row.Bin)).Append(',')
                    .Append(Csv.Escape(row.Heat)).Append(',')
                    .Append(Csv.Escape(row.Serial)).Append(',')
                    .Append(row.Quantity.ToString(CultureInfo.InvariantCulture)).Append(',')
                    .Append("PICKLIST_MRP,,")
                    .Append(today)
                    .AppendLine();
            }
            File.WriteAllText(path, sb.ToString());
        }

        private static string Cell(Dictionary<string, string> row, string name)
        {
            string value;
            return row.TryGetValue(name, out value) ? value ?? string.Empty : string.Empty;
        }

        private static DateTime ParseDate(string value)
        {
            DateTime parsed;
            if (DateTime.TryParse(value, CultureInfo.InvariantCulture, DateTimeStyles.AllowWhiteSpaces, out parsed))
            {
                return parsed.Date;
            }
            if (DateTime.TryParse(value, CultureInfo.CurrentCulture, DateTimeStyles.AllowWhiteSpaces, out parsed))
            {
                return parsed.Date;
            }
            return DateTime.Today;
        }

        private static double ParseDouble(string value)
        {
            double parsed;
            if (double.TryParse(value, NumberStyles.Any, CultureInfo.InvariantCulture, out parsed))
            {
                return parsed;
            }
            return double.TryParse(value, NumberStyles.Any, CultureInfo.CurrentCulture, out parsed) ? parsed : 0;
        }

        private static bool IsYes(string value)
        {
            return FlagValue(value) == 1;
        }

        private static int FlagValue(string value)
        {
            var raw = (value ?? string.Empty).Trim();
            if (raw == "1" || raw == "-1")
            {
                return 1;
            }
            if (raw.Equals("true", StringComparison.OrdinalIgnoreCase) || raw.Equals("Y", StringComparison.OrdinalIgnoreCase))
            {
                return 1;
            }
            return 0;
        }
    }

    internal static class Csv
    {
        public static List<Dictionary<string, string>> Read(string path)
        {
            var rows = new List<Dictionary<string, string>>();
            if (!File.Exists(path))
            {
                return rows;
            }
            var lines = Parse(File.ReadAllText(path));
            if (lines.Count == 0)
            {
                return rows;
            }
            var header = lines[0];
            for (var i = 1; i < lines.Count; i++)
            {
                if (lines[i].Count == 1 && string.IsNullOrWhiteSpace(lines[i][0]))
                {
                    continue;
                }
                var map = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                for (var c = 0; c < header.Count && c < lines[i].Count; c++)
                {
                    map[header[c].Trim()] = lines[i][c];
                }
                rows.Add(map);
            }
            return rows;
        }

        public static string Escape(string value)
        {
            var text = value ?? string.Empty;
            if (text.IndexOfAny(new[] { ',', '"', '\r', '\n' }) >= 0)
            {
                return "\"" + text.Replace("\"", "\"\"") + "\"";
            }
            return text;
        }

        private static List<List<string>> Parse(string text)
        {
            var rows = new List<List<string>>();
            var row = new List<string>();
            var cell = new StringBuilder();
            var quoted = false;
            for (var i = 0; i < text.Length; i++)
            {
                var ch = text[i];
                if (quoted)
                {
                    if (ch == '"')
                    {
                        if (i + 1 < text.Length && text[i + 1] == '"')
                        {
                            cell.Append('"');
                            i++;
                        }
                        else
                        {
                            quoted = false;
                        }
                    }
                    else
                    {
                        cell.Append(ch);
                    }
                    continue;
                }
                if (ch == '"')
                {
                    quoted = true;
                }
                else if (ch == ',')
                {
                    row.Add(cell.ToString());
                    cell.Clear();
                }
                else if (ch == '\n')
                {
                    row.Add(cell.ToString().TrimEnd('\r'));
                    cell.Clear();
                    rows.Add(row);
                    row = new List<string>();
                }
                else if (ch != '\r')
                {
                    cell.Append(ch);
                }
            }
            if (cell.Length > 0 || row.Count > 0)
            {
                row.Add(cell.ToString());
                rows.Add(row);
            }
            return rows;
        }
    }
}
