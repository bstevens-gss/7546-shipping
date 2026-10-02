using System;

namespace PickListMrpUdf
{
    public sealed class PickLine
    {
        public string Customer { get; set; }
        public string OrderNo { get; set; }
        public string OrderSuffix { get; set; }
        public string OrderLineRaw { get; set; }
        public int OrderLineNumber { get; set; }
        public DateTime PickByDate { get; set; }
        public int LoadNo { get; set; }
        public int LoadSeq { get; set; }
        public string Part { get; set; }
        public string Location { get; set; }
        public string SourceCode { get; set; }
        public double QtyBo { get; set; }
        public int Picked { get; set; }
        public int DisplayFlag { get; set; }
        public int MobileSequence { get; set; }
    }

    public sealed class OnHandBin
    {
        public string Part { get; set; }
        public string Location { get; set; }
        public string Lot { get; set; }
        public string Bin { get; set; }
        public string Heat { get; set; }
        public string Serial { get; set; }
        public double Quantity { get; set; }
        public bool Allocated { get; set; }
        public string AllocType { get; set; }
    }

    public sealed class BinRules
    {
        public bool AllocatedToSalesOrder { get; set; }
        public bool UnallocateFromSalesToStaging { get; set; }
        public string AllocatedField { get; set; }
    }

    public sealed class RunOptions
    {
        public bool UseMrp { get; set; }
        public bool UseLoadPlanning { get; set; }
        public bool AutoPopulate { get; set; }
        public int PickWindowWorkDays { get; set; }
        public bool LotBinDetail { get; set; }
        public BinRules BinRules { get; set; }
        public DateTime Today { get; set; }
    }

    public sealed class ItemBinRow
    {
        public string OrderNo { get; set; }
        public string OrderLineRaw { get; set; }
        public int OrderLineNumber { get; set; }
        public string OrderSuffix { get; set; }
        public string Part { get; set; }
        public string Location { get; set; }
        public string Lot { get; set; }
        public string Bin { get; set; }
        public string Heat { get; set; }
        public string Serial { get; set; }
        public double Quantity { get; set; }
    }
}
