---
name: TC-03 Label Copy Count
overview: Modify the existing ARC 6907 pre-proc script to support a copy-count parameter encoded in the label filename (e.g., `_x4` suffix), using the Sentinel LABEL_COPY column mechanism.
todos:
  - id: modify-preproc
    content: "Modify BIR_OE_Wireless_Shipping_Label_Extended.g2u LoadData: add LABEL_COPY column to dtData, parse _x{N} from resolved label filename, set copy count accordingly"
    status: completed
  - id: sign-preproc
    content: Sign the modified pre-proc script
    status: completed
  - id: doc-naming
    content: Document the naming convention for WST (add to AGENTS.PROJECT.md or create a reference document)
    status: completed
isProject: false
---

# TC-03: Customer-Specific Label Printing & Multiple Copies

## How Codesoft/Sentinel Label Printing Works

- `PrintCodesoftLabelFromDataTable` exports `dtData` as field:value pairs to an output file
- Sentinel processes the file and merges data onto the Codesoft `.lab` template
- **If `dtData` contains a column named `LABEL_COPY`, Sentinel prints that many copies per row**
- No print loop needed in GAB -- Sentinel handles the copy count natively

## Existing Mechanism (Already Working)

The pre-proc at [`BIR_OE_Wireless_Shipping_Label_Extended.g2u`](c:\Apps\Global\BUSINT\PREPROC\BIR_OE_Wireless_Shipping_Label_Extended.g2u) already implements:

- **Customer-specific label lookup** with fallback to default (lines 51-58)
- **Naming convention**: `OE_Wireless_Shipping_9001_Extended_{CompanyCode}_{CustNo}.lab` in `{BusintDir}\labels\custom\`
- **Print via**: `F.Global.BI.PrintCodesoftLabelFromDataTable(RunID, LogID, "dtData", Printer, True, [labelpath])`
- The library [`BIR_Codesoft_ExtendedPreProc.lib`](c:\Apps\Global\BUSINT\PREPROC\BIR_Codesoft_ExtendedPreProc.lib) handles data enrichment (inventory, orders, project management, cross-refs, user fields)

Current `LoadData` flow (lines 51-58):

```
'Check customer specific label exist
Build path: {BusintDir}\labels\custom\OE_Wireless_Shipping_9001_Extended_{CC}_{CustNo}.lab
File.Exists check
  If exists  -> PrintCodesoftLabelFromDataTable with custom label path
  Else       -> PrintCodesoftLabelFromDataTable without path (uses default)
```

## What Needs to Change

### 1. Add LABEL_COPY Column + Parse Copy Count from Filename

Modify `LoadData` in `BIR_OE_Wireless_Shipping_Label_Extended.g2u` (lines 46-58):

**New lookup logic** (replaces current customer-specific check):

- Build the base label name: `OE_Wireless_Shipping_9001_Extended_{CC}_{CustNo}`
- Check exact match `{base}.lab` first -- if found, copies = 1
- If not found, scan for `{base}_x*.lab` using `F.Intrinsic.File.Dir` -- if found, parse N from `_x{N}` portion, copies = N
- If neither found, fall back to default, copies = 1
- Add `LABEL_COPY` column to `dtData` and set all rows to the resolved copy count
- Call `PrintCodesoftLabelFromDataTable` once -- Sentinel reads `LABEL_COPY` and handles the rest

**Pseudocode:**

```
V.Local.iCopies.Declare(Long, 1)

'1. Check exact customer match
Build path -> {base}_{CC}_{CustNo}.lab
File.Exists -> if yes, labelexists=True, copies=1

'2. If not found, scan for _x{N} variant
If not found:
    File.Dir("{customDir}\{base}_{CC}_{CustNo}_x*.lab") -> sFoundFile
    If sFoundFile <> "":
        Extract substring between "_x" and ".lab" -> parse as integer N
        copies = N
        labelname = sFoundFile
        labelexists = True

'3. Add LABEL_COPY column to dtData
DataTable.AddColumn("dtData", "LABEL_COPY", "Long", copies)

'4. Print (existing If/Else, unchanged -- Sentinel reads LABEL_COPY)
If labelexists -> PrintCodesoftLabelFromDataTable with custom label
Else           -> PrintCodesoftLabelFromDataTable with default
```

### 2. Naming Convention for WST

- **Label directory**: `{BusintDir}\labels\custom\` (e.g., `c:\Apps\Global\BUSINT\labels\custom\`)
- **Standard naming** (1 copy): `OE_Wireless_Shipping_9001_Extended_{CompanyCode}_{CustomerNumber}.lab`
- **Multi-copy naming** (N copies): `OE_Wireless_Shipping_9001_Extended_{CompanyCode}_{CustomerNumber}_x{N}.lab`
  - Example: `..._x4.lab` prints 4 identical labels per container (e.g., all sides of a pallet)
- **Default fallback**: If no customer-specific file exists, the standard default template is used (1 copy)
- WST designs their own Codesoft `.lab` templates; the pre-proc exposes data from tables A through Z (see lib lines 49-117 for the alias map)

### 3. No Changes to Shipping Dashboard

Label printing is triggered by the native GSS wireless shipping mechanism (GS Mobile shipping by lot), not the 7546 Shipping Dashboard. No changes to `GAB_7546_OE_ShippingReview_Load.g2u` are required.

### 4. Sign the Script

After modifying the `.g2u`, sign it. The library does not need changes.
