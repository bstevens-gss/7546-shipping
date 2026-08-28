# Carrier Pallet Label — Codesoft field contract

Office label used when prepping UDF Walmart shipments. Printed from the Freight Class grid **Carrier Pallet** column. This is **not** S20 pallet label 77.

## File

| Item | Value |
|------|--------|
| Template | `GAB_7546_CARRIER_PALLET.lab` |
| Path | `{V.Caller.BusintDir}\labels\custom\GAB_7546_CARRIER_PALLET.lab` |
| Typical clinic path | `C:\Apps\Global\BUSINT\LABELS\custom\GAB_7546_CARRIER_PALLET.lab` |
| Artwork reference | `GAB_7546_CARRIER_PALLET_sample.png` (same folder as this spec) |

The `.lab` is a real Codesoft OLE document (not a text placeholder). It was created with CODESOFT 2024 `Lppx2.Application` and must stay a binary `.lab`. Rebuild with `docs/7546_shipping/_work/build-carrier-pallet-lab.vbs` if it is overwritten. The 7546 column stays hidden until this file exists.

## Layout (match the sample)

**Size:** 4 in x 6 in portrait (4 wide, 6 tall).

Centered, bold sans-serif, portrait pallet label:

1. Universal logo (static graphic in the `.lab`, not a data field)
2. Underlined **Ship from:**
3. Ship-from name and address
4. Underlined **DELIVER TO**
5. Deliver-to name and address
6. `PRO#` + `PRO_NO`
7. Large `PALLET_COUNT` at the bottom (`PALLET X OF Y`)

## Codesoft variables (must match DataTable columns)

| Variable | Sample | Notes |
|----------|--------|--------|
| `SHIP_FROM_NAME` | UNIVERSAL DISPLAY & FIXTURES | BOL_HEADER.FROM_NAME, else location, else UDF Denton fallback |
| `SHIP_FROM_ADRS1` | 3333 WEST UNIVERSITY DRIVE | |
| `SHIP_FROM_ADRS2` | SUITE 1109 | |
| `SHIP_FROM_CITYSTZIP` | DENTON, TX 76207 | City, ST ZIP |
| `SHIP_FROM_PHONE` | 972-221-5157 | |
| `DELIVER_TO_NAME` | SALTLAKE RREW 10954 | BOL TO_NAME or V_ORDER_SHIP_TO |
| `DELIVER_TO_ADRS1` | 4884 W 1100 S | |
| `DELIVER_TO_CITYSTZIP` | SALT LAKE CITY UT 84104 | City ST ZIP (no comma, per sample) |
| `PRO_NO` | 7460697425 | SHIPMENT_HEADER.PRO_NO. Print static `PRO# ` in the `.lab` |
| `PALLET_COUNT` | PALLET 1 OF 3 | Built in GAB; do not split X/Y in Codesoft |

## Print behavior

- Freight Class **Carrier Pallet** click → Sentinel printer browse → Yes = this pallet, No = all pallets on the packing list, Cancel = exit.
- Does not write WIRELESS_*, FIELD_24, or BOL_PALLET_NUM.LABEL_FLAG.
