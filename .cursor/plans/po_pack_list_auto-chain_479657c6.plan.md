---
name: PO Pack List Auto-Chain
overview: Modify `Click_Print_PL_Certs` in the Shipping Dashboard to auto-chain the PO Pack Report print for any PO lines (ORDER_SUFFIX='P') after the standard packing list with certs flow completes, reusing the existing `Click_Print_POPackList` logic.
todos:
  - id: extract-sub
    content: Create new subroutine PrintPOPackForLoad with bSuppressLotBin parameter, extracted from Click_Print_POPackList
    status: completed
  - id: chain-into-certs
    content: Add CallSub(PrintPOPackForLoad) gated behind v.Global.b7551 into Click_Print_PL_Certs, passing SUPPRESS_LOTBIN=Y
    status: completed
  - id: refactor-existing
    content: Update Click_Print_POPackList to delegate to PrintPOPackForLoad, passing SUPPRESS_LOTBIN=N (standalone keeps lot/bin)
    status: completed
  - id: crystal-param
    content: Add SUPPRESS_LOTBIN parameter to GCG_7551_PO_PACK.rpt and use it to conditionally suppress the lot/bin subreport section
    status: completed
  - id: sign-and-test
    content: Sign and run the script to verify auto-chain suppresses lot/bin, standalone preserves it
    status: completed
isProject: false
---

# Auto-Chain PO Pack Report into Print Packing Lists w/Certs

## Current State

**`Click_Print_PL_Certs`** (lines 7985-8204 in `GAB_7546_OE_ShippingReview_Load.g2u`):
- Filters `dtLoad` for `[SELECT] = 1 AND [PACKING LIST] <> ''`
- Opens printer dialog, then loops through distinct packing list numbers
- For each: CallWrapperSyncBIO(910070) with CRYSTAL-OVERRIDE, builds lot/bin data, merges cert documents, prints via `BI.PrintReport`
- Restores default printer, cleans up DataTables/DataViews

**`Click_Print_POPackList`** (lines 8350-8413):
- Already exists as a separate context menu handler (gated behind `b7551`)
- Filters `dtLoad` for `[SELECT] = 1 AND [Carrier Load Number] <> '' AND [ORDER_SUFFIX] = 'P'`
- Loops through distinct `Carrier Load Number` values
- For each: prints `GCG_7551_PO_PACK.rpt` via `BI.PrintReport` with parameter `PO_PACK_NUM`

## Approach

After the main packing-list-with-certs loop completes (but before cleanup), call the PO Pack Report logic for any PO lines on the selected load. Two options:

### Option A: Extract + CallSub (recommended)

1. **Extract** the core PO Pack print logic from `Click_Print_POPackList` into a new subroutine `PrintPOPackForLoad` that does not depend on `V.Args.ItemName` (remove the `SelectCase` wrapper)
2. **Call** `PrintPOPackForLoad` from the end of `Click_Print_PL_Certs`, after the ODBC connection is closed and before DataTable cleanup, gated behind `v.Global.b7551`
3. **Update** `Click_Print_POPackList` to call `PrintPOPackForLoad` instead of inlining the logic (DRY)

### Option B: Inline CallSub to existing handler

1. At the end of `Click_Print_PL_Certs` (after `F.ODBC.Connection!ConP.Close` at line 8181, before the Else/cleanup), add `CallSub(Click_Print_POPackList_Core)` gated behind `v.Global.b7551`
2. This is simpler but slightly less clean

**Recommendation: Option A** -- keeps the logic reusable and testable.

## Insertion Point

In `Click_Print_PL_Certs`, after line 8181 (`F.ODBC.Connection!ConP.Close`) and before line 8183 (`F.Intrinsic.Control.Else`):

```gab
F.Intrinsic.Control.If(v.Global.b7551)
    F.Intrinsic.Control.CallSub(PrintPOPackForLoad)
F.Intrinsic.Control.EndIf
```

## New Subroutine: `PrintPOPackForLoad`

Extracted from `Click_Print_POPackList` lines 8369-8406, with these changes:
- Remove `SelectCase(v.Args.ItemName.UCase)` wrapper (not triggered by context menu args)
- Accept a global flag `V.Global.bSuppressPOPackLotBin` to control lot/bin suppression
- Keep the same filter: `[SELECT] = 1 AND [Carrier Load Number] <> '' AND [ORDER_SUFFIX] = 'P'`
- Pass an additional parameter `SUPPRESS_LOTBIN` (value `Y` or `N`) to `GCG_7551_PO_PACK.rpt` via `BI.PrintReport`
- Standard error handler

**Parameter passing to Crystal:**

The existing call passes one param (`PO_PACK_NUM`). We add a second:

```gab
V.Local.sParam.Set("PO_PACK_NUM*!*SUPPRESS_LOTBIN")
F.Intrinsic.String.Build("{0}*!*{1}", V.Local.sPOPACKVal, V.Local.sSuppressFlag, V.Local.sValue)
```

When called from certs auto-chain: `V.Local.sSuppressFlag = "Y"`
When called from standalone context menu: `V.Local.sSuppressFlag = "N"`

## Insertion Point (certs auto-chain)

In `Click_Print_PL_Certs`, after line 8181 (`F.ODBC.Connection!ConP.Close`) and before line 8183 (`F.Intrinsic.Control.Else`):

```gab
F.Intrinsic.Control.If(v.Global.b7551)
    V.Global.bSuppressPOPackLotBin.Set(True)
    F.Intrinsic.Control.CallSub(PrintPOPackForLoad)
    V.Global.bSuppressPOPackLotBin.Set(False)
F.Intrinsic.Control.EndIf
```

## Updated `Click_Print_POPackList`

Simplify to just call the extracted sub (lot/bin NOT suppressed for standalone):

```gab
Program.Sub.Click_Print_POPackList.Start
F.Intrinsic.Control.Try
    F.Intrinsic.Control.SelectCase(v.Args.ItemName.UCase)
        F.Intrinsic.Control.Case("PACKREPORT")
            V.Global.bSuppressPOPackLotBin.Set(False)
            F.Intrinsic.Control.CallSub(PrintPOPackForLoad)
    F.Intrinsic.Control.EndSelect
F.Intrinsic.Control.Catch
    ' ... error handler ...
F.Intrinsic.Control.EndTry
Program.Sub.Click_Print_POPackList.End
```

## Crystal Report Change: `GCG_7551_PO_PACK.rpt`

**File:** `c:\Apps\Global\BUSINT\custom\GCG_7551_PO_PACK.rpt`

1. **Add parameter:** Create a new String parameter `SUPPRESS_LOTBIN` with default value `"N"`
2. **Subreport suppression formula:** On the section containing the lot/bin subreport, set the **Suppress** formula to:

```crystal
{?SUPPRESS_LOTBIN} = "Y"
```

This means:
- When called from **certs auto-chain** -- GAB passes `SUPPRESS_LOTBIN = "Y"` -- lot/bin subreport is hidden
- When called from **standalone "Print PO Pack Report"** -- GAB passes `SUPPRESS_LOTBIN = "N"` -- lot/bin subreport shows normally

No other report changes required. The subreport itself is untouched; only its containing section visibility is toggled.

## Dependencies

- `v.Global.b7551` -- already exists, set by `Validate_7551` during `SetContextMenus`
- `V.Global.bSuppressPOPackLotBin` -- **new global** (Boolean), declared in `Preflight` or at top of `PrintPOPackForLoad`
- `dtLoad` DataTable -- already populated and available when `Click_Print_PL_Certs` runs
- `GCG_7551_PO_PACK.rpt` -- Crystal Report in `{BusintDir}\Custom\` (needs new parameter)
- No new tables, no new ODBC connections

## Testing Checklist

- **Certs auto-chain:** Select load rows with PO lines (ORDER_SUFFIX='P'), right-click "Print Packing Lists w/Certs" -- verify standard packing list prints, THEN PO Pack Report prints **without** lot/bin subreport
- **Standalone:** Right-click "Print PO Pack Report" separately -- verify PO Pack Report prints **with** lot/bin subreport
- **No PO lines:** Select load rows with no PO lines, print packing lists w/certs -- verify no PO Pack Report prints (no error)
- **b7551 = False:** Verify PO Pack auto-chain is skipped gracefully when 7551 is not deployed
