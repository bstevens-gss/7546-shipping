using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using PickListMrpUdf;
using Xunit;

namespace PickListMrpUdf.Tests
{
    public class EngineTests
    {
        [Fact]
        public void WalkOrder_MatchesHultecSort()
        {
            var lines = new[]
            {
                Line("2026-10-03", 2, 1, "100", "20"),
                Line("2026-10-02", 2, 5, "200", "10"),
                Line("2026-10-02", 1, 1, "300", "10"),
                Line("2026-10-02", 2, 9, "150", "30")
            };

            var ordered = Engine.OrderWalk(lines).ToList();

            Assert.Equal(new[] { "300", "150", "200", "100" }, ordered.Select(x => x.OrderNo).ToArray());
            Assert.Equal(new[] { 1, 2, 3, 4 }, ordered.Select(x => x.MobileSequence).ToArray());
        }

        [Fact]
        public void Bins_ListEveryOnHandBin_WithELocationsFirst()
        {
            var line = new PickLine
            {
                OrderNo = "10967",
                OrderLineNumber = 5,
                Part = "WIDGET",
                Location = "MAIN",
                SourceCode = "F",
                QtyBo = 10
            };
            var bins = new[]
            {
                Bin("D01", 20),
                Bin("E02", 4),
                Bin("A01", 3),
                Bin("E01", 5),
                Bin("D02", 0)
            };
            var rules = new BinRules
            {
                AllocatedToSalesOrder = false,
                UnallocateFromSalesToStaging = false
            };

            var rows = Engine.BinsForLine(line, bins, rules).ToList();

            Assert.Equal(new[] { "E01", "E02", "A01", "D01" }, rows.Select(x => x.Bin).ToArray());
            Assert.Equal(new[] { 5d, 4d, 3d, 20d }, rows.Select(x => x.Quantity).ToArray());
            Assert.DoesNotContain(rows, x => x.Quantity == 10 && x.Bin == "D01");
        }

        [Fact]
        public void Bins_SkipBinsThatBeginWithO()
        {
            var line = new PickLine
            {
                OrderNo = "10967",
                OrderLineNumber = 5,
                Part = "WIDGET",
                Location = "MAIN",
                SourceCode = "F"
            };
            var bins = new[]
            {
                Bin("O01", 4),
                Bin("E01", 5),
                Bin("D01", 2)
            };
            var rules = new BinRules
            {
                AllocatedToSalesOrder = false,
                UnallocateFromSalesToStaging = false
            };

            var rows = Engine.BinsForLine(line, bins, rules).ToList();

            Assert.Equal(new[] { "E01", "D01" }, rows.Select(x => x.Bin).ToArray());
        }

        [Fact]
        public void Bins_OPrefix_IgnoresCaseAndKeepsBinsThatOnlyContainO()
        {
            var line = new PickLine
            {
                OrderNo = "10967",
                OrderLineNumber = 5,
                Part = "WIDGET",
                Location = "MAIN",
                SourceCode = "F"
            };
            var bins = new[]
            {
                Bin("o02", 1),
                Bin(" O03", 1),
                Bin("AO01", 7),
                Bin("", 3)
            };
            var rules = new BinRules
            {
                AllocatedToSalesOrder = false,
                UnallocateFromSalesToStaging = false
            };

            var rows = Engine.BinsForLine(line, bins, rules).ToList();

            Assert.Equal(new[] { "", "AO01" }, rows.Select(x => (x.Bin ?? string.Empty).Trim()).OrderBy(x => x).ToArray());
        }

        [Fact]
        public void Bins_AllocatedManufacturedLines_KeepOnlyThatOrder()
        {
            var line = new PickLine
            {
                OrderNo = "10967",
                OrderLineNumber = 5,
                Part = "WIDGET",
                Location = "MAIN",
                SourceCode = "M"
            };
            var key = Engine.AllocationKey(10967, 5);
            var bins = new[]
            {
                new OnHandBin { Part = "WIDGET", Location = "MAIN", Bin = "E01", Quantity = 2, Allocated = true, AllocType = "S", Lot = key },
                new OnHandBin { Part = "WIDGET", Location = "MAIN", Bin = "E02", Quantity = 2, Allocated = true, AllocType = "S", Lot = "0000001-001" },
                new OnHandBin { Part = "WIDGET", Location = "MAIN", Bin = "D01", Quantity = 2, Allocated = false, AllocType = "", Lot = "" }
            };
            var rules = new BinRules
            {
                AllocatedToSalesOrder = true,
                UnallocateFromSalesToStaging = true,
                AllocatedField = "LOT"
            };

            var rows = Engine.BinsForLine(line, bins, rules).ToList();

            Assert.Equal(new[] { "E01" }, rows.Select(x => x.Bin).ToArray());
        }

        [Fact]
        public void AllocationKey_PadsOrderAndLine()
        {
            Assert.Equal("0010967-005", Engine.AllocationKey(10967, 5));
        }

        [Fact]
        public void PickThroughDate_UsesStockWorkdayWalk()
        {
            var friday = new DateTime(2026, 10, 2);
            Assert.Equal(new DateTime(2026, 10, 3), Engine.PickThroughDate(friday, 1));
            Assert.Equal(friday, Engine.PickThroughDate(friday, 0));
        }

        [Fact]
        public void Script_NextPassesTheLoopVariable()
        {
            var script = File.ReadAllText(ScriptPath());
            var bare = System.Text.RegularExpressions.Regex.Matches(script, @"F\.Intrinsic\.Control\.Next(?!\()");
            Assert.Empty(bare);
            Assert.Contains("F.Intrinsic.Control.Next(V.Local.i)", script);
        }

        [Fact]
        public void Script_WritesBinsWhenTheResultIsWrite()
        {
            var script = File.ReadAllText(ScriptPath());
            Assert.Contains("V.Local.sResult,=,\"WRITE\"", script);
            Assert.DoesNotContain("sParts(1)", script);
            var sequenceAt = script.IndexOf("Program.Sub.WriteSequence.Start", StringComparison.Ordinal);
            var sequenceErr = script.IndexOf("Label(\"WriteSequence_Err\")", sequenceAt, StringComparison.Ordinal);
            var beforeErr = script.Substring(sequenceAt, sequenceErr - sequenceAt);
            Assert.Contains("F.Intrinsic.Control.ExitSub", beforeErr);
            Assert.DoesNotContain("F.Intrinsic.Control.End\r", beforeErr);
        }

        [Fact]
        public void Order11376_Line1_ListsEBinBeforeDBin()
        {
            var line = new PickLine
            {
                OrderNo = "0011376",
                OrderLineRaw = "0010",
                OrderLineNumber = 1,
                OrderSuffix = "0000",
                Part = "SDSSTK01",
                Location = "TX",
                Customer = "001000"
            };
            var bins = new[]
            {
                new OnHandBin { Part = "SDSSTK01", Location = "TX", Bin = "D01010", Quantity = 100 },
                new OnHandBin { Part = "SDSSTK01", Location = "TX", Bin = "E01010", Quantity = 100 },
                new OnHandBin { Part = "SDSSTK01", Location = "TX", Lot = "PROTO", Quantity = 18 },
                new OnHandBin { Part = "SDSSTK01", Location = "TX", Lot = "PROTO", Heat = "0011376-000-001", Quantity = 1, Allocated = true, AllocType = "T" }
            };

            var picked = Engine.BinsForLine(line, bins, new BinRules());

            Assert.Equal(new[] { "E01010", "", "D01010" }, picked.Select(b => (b.Bin ?? string.Empty).Trim()).ToArray());
            Assert.Equal(new[] { 100d, 18d, 100d }, picked.Select(b => b.Quantity).ToArray());
        }

        [Fact]
        public void SelectLines_SkipsLetterShipmentSuffix()
        {
            var options = new RunOptions { Today = new DateTime(2026, 10, 2) };
            var lines = new[]
            {
                Line("2026-10-02", 1, 1, "100", "10"),
                Line("2026-10-02", 1, 1, "200", "10")
            };
            lines[1].OrderSuffix = "P";

            var selected = Engine.SelectLines(lines, options).ToList();

            Assert.Equal(new[] { "100" }, selected.Select(x => x.OrderNo).ToArray());
        }

        [Fact]
        public void Execute_WritesEThenD_ForTheMobileList()
        {
            var dir = Path.Combine(Path.GetTempPath(), "mrp-udf-" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(dir);
            try
            {
                File.WriteAllText(Path.Combine(dir, "PickListMrpUdf_options.csv"),
                    "ID,F_BOOLEAN,F_LONG,TEXT1\r\n" +
                    "402676,1,0,\r\n" +
                    "402674,1,0,\r\n" +
                    "402677,0,0,\r\n" +
                    "402678,0,0,\r\n" +
                    "402679,1,0,\r\n" +
                    "402598,0,0,\r\n");
                File.WriteAllText(Path.Combine(dir, "PickListMrpUdf_lines.csv"),
                    "CUSTOMER,ORDER_NO,ORDER_LINE,ORDER_SUFFIX,PICK_BY_DATE,LOAD_NO,LOAD_SEQ,PART,LOCATION,QTY_BO,KEY_SOURCE,PCKLST_DISP_FLAG,PICKED\r\n" +
                    "ACME,0010967,50,0,2026-10-02,1,1,WIDGET,MAIN,10,F,True,False\r\n");
                File.WriteAllText(Path.Combine(dir, "PickListMrpUdf_items.csv"),
                    "PART,LOCATION,LOT,BIN,HEAT,SERIAL_NUMBER,QUANTITY,ALLOCATED,ALLOC_TYPE\r\n" +
                    "WIDGET,MAIN,L1,D01,,,20,0,\r\n" +
                    "WIDGET,MAIN,L2,E01,,,5,0,\r\n");

                var result = new Runner().Execute(dir);

                Assert.Equal("WRITE", result);
                var items = File.ReadAllLines(Path.Combine(dir, "PickListMrpUdf_itembins.csv"));
                Assert.Equal("E01", Field(items[1], "BIN"));
                Assert.Equal("5", Field(items[1], "QUANTITY"));
                Assert.Equal("D01", Field(items[2], "BIN"));
                Assert.Equal("20", Field(items[2], "QUANTITY"));
                Assert.Equal("50", Field(items[1], "ORDER_LINE"));
                Assert.Equal("PICKLIST_MRP", Field(items[1], "MODIFIED_BY_PROG"));
                Assert.Contains(DateTime.Today.ToString("yyyy-MM-dd"), items[1]);
                var sequence = File.ReadAllLines(Path.Combine(dir, "PickListMrpUdf_sequence.csv"));
                Assert.Equal("1", Field(sequence[1], "MOBILE_SEQUENCE"));
            }
            finally
            {
                Directory.Delete(dir, true);
            }
        }

        private static string Field(string line, string name)
        {
            var header = "ORDER_NO,ORDER_LINE,ORDER_SUFFIX,PART,LOC,LOT,BIN,HEAT,SERIAL_NUMBER,QUANTITY,CUSTOMER,MOBILE_SEQUENCE".Split(',');
            var cells = line.Split(',');
            var map = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            var itemHeader = new[] { "ORDER_NO", "ORDER_LINE", "ORDER_SUFFIX", "PART", "LOC", "LOT", "BIN", "HEAT", "SERIAL_NUMBER", "QUANTITY", "MODIFIED_BY_PROG", "MODIFIED_BY_USER", "MODIFIED_BY_DATE" };
            var seqHeader = new[] { "CUSTOMER", "ORDER_NO", "ORDER_LINE", "ORDER_SUFFIX", "MOBILE_SEQUENCE" };
            var names = cells.Length == seqHeader.Length ? seqHeader : itemHeader;
            for (var i = 0; i < names.Length && i < cells.Length; i++)
            {
                map[names[i]] = cells[i];
            }
            header.ToString();
            return map[name];
        }

        private static PickLine Line(string pickBy, int loadNo, int loadSeq, string orderNo, string orderLineRaw)
        {
            return new PickLine
            {
                PickByDate = DateTime.Parse(pickBy),
                LoadNo = loadNo,
                LoadSeq = loadSeq,
                OrderNo = orderNo,
                OrderLineRaw = orderLineRaw,
                OrderLineNumber = int.Parse(orderLineRaw) / 10,
                OrderSuffix = "0",
                Customer = "ACME",
                Part = "WIDGET",
                Location = "MAIN"
            };
        }

        private static string ScriptPath()
        {
            var dir = new DirectoryInfo(AppContext.BaseDirectory);
            while (dir != null)
            {
                var candidate = Path.Combine(dir.FullName, "scripts", "PickListMRP_UDF.g2u");
                if (File.Exists(candidate))
                {
                    return candidate;
                }
                dir = dir.Parent;
            }
            throw new FileNotFoundException("PickListMRP_UDF.g2u");
        }

        private static OnHandBin Bin(string bin, double qty)
        {
            return new OnHandBin
            {
                Part = "WIDGET",
                Location = "MAIN",
                Bin = bin,
                Lot = bin,
                Quantity = qty,
                Allocated = false
            };
        }
    }
}
