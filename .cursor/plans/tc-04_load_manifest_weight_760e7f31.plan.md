---
name: TC-04 Load Manifest Weight
overview: Inspect the existing OE_LoadReport_MKE.rpt Crystal Report to understand its current data source, formulas, and record selection, then determine the correct approach for adding weight calculation (staged qty x part weight) and validation filtering.
todos:
  - id: inspect-rpt
    content: Run RptToXml.exe on OE_LoadReport_MKE.rpt and analyze the XML output to understand current tables, fields, formulas, and record selection
    status: completed
  - id: determine-approach
    content: Based on inspection, determine the correct weight source, validation filter approach, and whether changes are Crystal-side, GAB-side, or both
    status: completed
  - id: implement
    content: "Implement the chosen approach: provide Crystal Report formulas/instructions for manual changes, and/or modify GAB script"
    status: completed
isProject: false
---

# TC-04: Load Manifest Weight Calculation

## Phase 1: Inspect the Crystal Report

Run `RptToXml.exe` against the workspace copy to extract the report's internal structure:

```
.\Release\RptToXml.exe "OE_LoadReport_MKE.rpt" "OE_LoadReport_MKE.xml"
```

From the resulting XML, identify:
- **Database tables / views** the report queries (e.g., `V_SHIPMENT_LINES`, `BOL_PACK_DTL`, `LOAD_PLAN`)
- **Existing fields and formulas** -- does it already have a weight field? Which columns does it display?
- **Record selection formula** -- does it currently filter on validation status?
- **Group/summary fields** -- does it already have a total weight summary?
- **Parameters** -- currently only "Load Number" is passed from GAB

## Phase 2: Determine Approach (after inspection)

Based on findings, choose between:

1. **Crystal Report modification (manual by user):**
   - Add a calculated formula field: `{StagedQty} * {PartWeight}` per line
   - Add record selection filter: `{Table.SHIP_VALIDATE} = 1` (or equivalent)
   - Add summary field for grand total weight
   - Provide exact formula text for the user to apply in Crystal Reports designer

2. **GAB pre-processor approach:**
   - Create a pre-proc that builds a pre-filtered, pre-calculated temp table
   - Filter out non-validated lines before passing data to the report
   - Add a `TOTAL_WEIGHT` computed column (staged qty x per-piece weight)

3. **Hybrid approach:**
   - Pass validation filter as a new parameter from [`Click_Print_LoadManifest`](c:\Users\bstevens\AI\Cursor\7546\GAB_7546_OE_ShippingReview_Load.g2u) (lines 6118-6179)
   - Let the report handle weight calculation internally using its existing data source

## Key Code Reference

The GAB print subroutine is `Click_Print_LoadManifest` in [GAB_7546_OE_ShippingReview_Load.g2u](c:\Users\bstevens\AI\Cursor\7546\GAB_7546_OE_ShippingReview_Load.g2u):
- Lines 6137-6144: Report path resolution (`Busint\Custom\OE_LoadReport.rpt`)
- Lines 6150-6153: Load selection filter (no validation check currently)
- Lines 6158-6165: Report invocation via `BI.RunReportPreProcessor` with param "Load Number"

## Schema Context

- **Staged qty:** `V_SHIPMENT_LINES.QTY_SHIPPED` (aliased as "Staged Qty" in dashboard)
- **Part weight candidates:** `V_INVENTORY_ALL.LBS`, `BOL_PACK_DTL.LBS_PER_PC`, `V_ORDER_LINES.WEIGHT`
- **Validation:** `BOL_PACK_DTL.SHIP_VALIDATE` (BIT), outside PO uses `PO_LINES.USER_4`
- Exact weight source to use will be determined from report inspection

## Deliverables

- Inspection results with current report structure
- Recommended approach with specific formulas or code changes
- Implementation (Crystal Report instructions for user, and/or GAB script changes)
- Date/initials comments ("5/20/26 BS") on all code changes
