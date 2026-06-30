> **Sub-file of** [`agents/AGENTS.HOOKS.md`](../AGENTS.HOOKS.md) — program-to-hook count tables for Sales Order Entry and Quotes.

# Sales Order & Quote Hooks

Sub-file of agents/AGENTS.HOOKS.md — loaded when developing Sales Order or Quote customizations.

## ORD/OE — Order Entry & Sales Orders

| Program | Hooks | Notes |
|---------|-------|-------|
| ORD201 | 120 | Order Entry Line Detail (3rd most hooks) |
| ORD200 | 77 | Order Entry Header |
| OrderEntry.exe | 34 | .NET Order Entry |
| ORD202 | 25 | Order Entry Summary |
| ORD0FSGI | 24 | Order Flex Schedule |
| ORD072GI | 21 | Order Inquiry |
| ORD133GI | 20 | Order Reports |
| Ord098 | 19 | Order Custom Fields |
| ORD099GI | 19 | Order Custom Inquiry |
| ORD045EX | 17 | Order Export |
| ORD055 | 17 | Order Browser |
| ORD064U | 17 | Order User Screen |
| ORD172 | 17 | Order Reports |
| ORD064GM | 15 | Order Grid Maintenance |
| ORD858 | 13 | Order Inquiry |
| ORD096C | 12 | Order Processing |
| ORD910GI | 12 | Order Custom Fields |
| ORD101 | 12 | Order Processing |
| ORD046 | 11 | Order Processing |
| ORD193GI | 10 | Order Reports |
| ORD744 | 10 | Order Reports |
| ORD745 | 9 | Order Reports |
| ORD040AK | 8 | Order Acknowledgement |
| ORD100GI | 8 | Order Inquiry |
| ORD501GI | 8 | Order Inquiry |
| ORD203 | 8 | Order Entry Tab |
| ORD221 | 8 | Order Scheduling |
| ORD1FRT | 8 | Order Freight |
| ORD0FRT | 8 | Order Freight |
| ORD074GI | 8 | Order Reports |
| ORD181ON | 7 | Order Online |
| ORD0ACKN | 7 | Order Acknowledgement |
| ORD181GI | 6 | Order Inquiry |
| ORD504 | 6 | Order Reports |
| ORD210 | 6 | Order Shipping |
| ORD211 | 6 | Order Shipping |
| ORD205 | 6 | Order Tab |
| ORD138 | 6 | Order Inquiry |
| ORD144 | 6 | Order Reports |
| Ord085 | 5 | Order |
| ORD239 | 5 | Order Reports |
| ORD246 | 5 | Order Reports |
| ORD040GI | 4 | Order Inquiry |
| ORD044GH | 4 | Order History |
| ORD100 | 4 | Order Processing |
| ORD809 | 2 | Order |
| ORD825 | 2 | Order |
| ORD085 | 2 | Order |
| ORD227 | 1 | Order BOM/Router |
| ORD601 | 1 | Order |
| ORD886 | 1 | Order |
| ORD141 | 1 | Order |
| ORD921GI | 1 | Order Inquiry |
| GSS_OpenSalesOrders | 6 | .NET Open Sales Orders |
| GSS_SalesHistory | 6 | .NET Sales History |
| GSS_SalesHistory.exe | 6 | .NET Sales History (alt) |
| GSS_SalesSummary.exe | 6 | .NET Sales Summary |
| GSS_ShipSchedule | 6 | .NET Ship Schedule |
| GSS_OrdersShippedNotInvoiced | 2 | .NET Orders Shipped |

## QTE — Quotes

| Program | Hooks | Notes |
|---------|-------|-------|
| QTE200 | 59 | Quote Header (5th most hooks) |
| QTE201 | 54 | Quote Line Detail |
| QTE003GI | 21 | Quote Inquiry |
| QTE203 | 10 | Quote Tab |
| QTE008GI | 7 | Quote Reports |
| QTAPP01 | 6 | Quote Approval |
| QTE504 | 6 | Quote Reports |
| QTE020 | 1 | Quote Entry |
| QTEM01 | 1 | Quote Module |

---

For the complete hook catalog (all 4,884 entries with ID, screen, description, menu path, and hook type), see [`all_hooks_table.md`](all_hooks_table.md). For GAB hook coding patterns and V.Caller/V.Passed reference, see [`agents/gab/HOOKS.md`](../gab/HOOKS.md).
