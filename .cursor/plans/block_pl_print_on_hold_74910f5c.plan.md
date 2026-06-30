---
name: Block PL Print on Hold
overview: Add shipping-hold validation gates to all four packing list print/view paths on the Load tab, blocking the operation with a message when any selected row has SHP_HLD_FLAG = True. Scoped to ServiceWeb customer POR020 only via F.Global.General.ReadOptionCommon(3280) guard.
todos:
  - id: sw-customer-check
    content: Read SW customer from option 3280 in Preflight, set V.Global.bIsPOR020
    status: completed
  - id: declare-global
    content: Declare V.Global.bLoadHoldBlock in Preflight
    status: completed
  - id: create-validate-sub
    content: Create ValidateLoad_ShipHold subroutine (shared hold check for context menu paths)
    status: completed
  - id: gate-print-pl
    content: Add hold gate to Click_Print_PL (line ~8240)
    status: completed
  - id: gate-print-pl-certs
    content: Add hold gate to Click_Print_PL_Certs (after variable declarations)
    status: completed
  - id: gate-staged-forms
    content: Add hold gate to Click_Launch_PrintStagedForms (line ~8217)
    status: completed
  - id: gate-hyperlink
    content: Add hold check to GsGCLoad_RowCellClick PACKING LIST case (line ~4692)
    status: completed
  - id: sign-script
    content: Sign the .g2u file to regenerate .sig
    status: completed
isProject: false
---

# Block Packing List Printing When Sales Order Is on Shipping Hold

## Context

The Load tab in `GAB_7546_OE_ShippingReview_Load.g2u` already loads `SHP_HLD_FLAG` as a boolean column in `dtLoad` (line 1790). Values 2 and 4 from `V_ORDER_HEADER.SHP_HLD_FLAG` are converted to `True`; all others are `False`. Pink row styling and "On Hold" status text already use this flag (lines 1243-1248). **No validation currently prevents printing packing lists for on-hold orders.**

## Four Code Paths to Gate

| # | Path | Subroutine | Lines | Trigger |
|---|------|-----------|-------|---------|
| 1 | Print Packing Lists | `Click_Print_PL` | 8226-8275 | Right-click context menu |
| 2 | Print Packing Lists w/Certs | `Click_Print_PL_Certs` | 8277-8506 | Right-click context menu |
| 3 | Print Staged Forms | `Click_Launch_PrintStagedForms` | 8216-8219 | Right-click context menu |
| 4 | PL hyperlink click | `GsGCLoad_RowCellClick` (PACKING LIST case) | 4687-4703 | Grid cell click |

## Customer Scoping

The blocking logic applies **only** to ServiceWeb customer `POR020` (Port City). The SW customer code is read from option 3280 using the pattern from `ATG_WirelessOptions.g2u` (line 4980):

```
F.Global.General.ReadOptionCommon(3280,0,0,1,"",V.Local.sSWCust)
```

A global boolean `V.Global.bIsPOR020` will be set once in Preflight and reused in all gates, avoiding repeated option reads.

## Implementation

### 0. Preflight: Read SW customer and set POR020 flag

In Preflight, after database connections are opened, read option 3280 and set the flag:

```
V.Global.bIsPOR020.Declare(Boolean,False)
F.Global.General.ReadOptionCommon(3280,0,0,1,"",V.Local.sSWCust)
F.Intrinsic.Control.If(V.Local.sSWCust.UCase,=,"POR020")
    V.Global.bIsPOR020.Set(True)
F.Intrinsic.Control.EndIf
```

### 1. New shared validation subroutine: `ValidateLoad_ShipHold`

Create a new subroutine that checks whether any selected rows in `dtLoad` are on shipping hold. Only runs the check when `V.Global.bIsPOR020 = True`; otherwise immediately sets `bLoadHoldBlock = False` and returns. Follows the existing validation pattern from [`Click_Load_Ship`](GAB_7546_OE_ShippingReview_Load.g2u) (lines 7771-7797).

```
Program.Sub.ValidateLoad_ShipHold.Start
V.Local.sFilterString.Declare
V.Local.sSel.Declare

V.Global.bLoadHoldBlock.Set(False)

F.Intrinsic.Control.If(V.Global.bIsPOR020,=,False)
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf

V.Local.sFilterString.Set("[SELECT] = 1 AND [SHP_HLD_FLAG] = True")
F.Data.DataView.Create("dtLoad","dvloadhold",22,V.Local.sFilterString,"")
F.Data.DataView.ToDataTable("dtLoad","dvloadhold","dtloadhold",True)
F.Data.DataTable.Select("dtloadhold","",V.Local.sSel)

F.Intrinsic.Control.If(V.Local.sSel,<>,"***NORETURN***")
    V.Global.bLoadHoldBlock.Set(True)
    F.Intrinsic.UI.Msgbox("Selected rows contain sales orders on shipping hold. Packing lists cannot be printed until the hold is removed.","Warning")
F.Intrinsic.Control.EndIf

F.Data.DataView.Close("dtLoad","dvloadhold")
F.Data.DataTable.Close("dtloadhold")
Program.Sub.ValidateLoad_ShipHold.End
```

- Uses a global boolean `V.Global.bLoadHoldBlock` so callers can check the result after `CallSub`
- Declare `V.Global.bLoadHoldBlock` in Preflight (alongside existing globals like `V.Global.bShipOEPermission`)

### 2. Gate `Click_Print_PL` (lines 8226-8275)

Insert the hold check immediately after the `Try` and variable declarations, before the filter/print logic (before line 8240):

```
F.Intrinsic.Control.CallSub(ValidateLoad_ShipHold)
F.Intrinsic.Control.If(V.Global.bLoadHoldBlock,=,True)
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf
```

### 3. Gate `Click_Print_PL_Certs` (lines 8277-8506)

Same pattern -- insert after variable declarations, before the filter/print logic. This also blocks the auto-chained `PrintPOPackForLoad` call since the parent sub exits early.

### 4. Gate `Click_Launch_PrintStagedForms` (lines 8216-8219)

Insert hold check before `LaunchMenuTask`. Since this sub is very short (no Try/Catch), add:

```
F.Intrinsic.Control.CallSub(ValidateLoad_ShipHold)
F.Intrinsic.Control.If(V.Global.bLoadHoldBlock,=,True)
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf
```

### 5. Gate `GsGCLoad_RowCellClick` PACKING LIST case (lines 4687-4703)

This is a single-row click (not multi-select), so instead of calling the shared validation sub, check the clicked row's `SHP_HLD_FLAG` directly. Guarded by `V.Global.bIsPOR020`:

```
F.Intrinsic.Control.If(V.Global.bIsPOR020,=,True)
    Gui.frmShip.GsGCLoad.GetCellValueByColumnName("gvLoad","SHP_HLD_FLAG",V.Args.RowIndex,V.Local.bHold)
    F.Intrinsic.Control.If(V.Local.bHold,=,True)
        F.Intrinsic.UI.Msgbox("This sales order is on shipping hold. The packing list cannot be opened until the hold is removed.","Warning")
        F.Intrinsic.Control.ExitSub
    F.Intrinsic.Control.EndIf
F.Intrinsic.Control.EndIf
```

Insert this after the permission check (line 4692) but before the `GetCellValueByColumnName` for "Packing List" (line 4693). Add `V.Local.bHold.Declare` at the top of the subroutine's variable declarations.

## Variable Changes

- **Preflight**: Declare `V.Global.bIsPOR020` (Boolean, default False) -- SW customer flag from option 3280
- **Preflight**: Declare `V.Global.bLoadHoldBlock` (Boolean) -- used by `ValidateLoad_ShipHold`
- **`GsGCLoad_RowCellClick`**: Declare `V.Local.bHold` -- used for single-row hyperlink check

## What Is NOT Changed

- **Print PO Pack Report** (`Click_Print_POPackList`) -- this prints PO pack lists, not standard packing lists; not in scope per the requirement. However, the auto-chain from `Click_Print_PL_Certs` to `PrintPOPackForLoad` IS blocked because the parent sub exits early.
- **Print BOL** and **Print Load Manifest** -- not packing list prints
- **Pick list printing** -- separate feature, not in scope

## Sign After Edit

After all edits, sign the `.g2u` file using the `gab-sign` skill to regenerate the `.sig` companion file.
