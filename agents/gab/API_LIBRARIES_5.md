# GAB Standard Libraries Reference (Part 5 of 5)
# Sub-agent of agents/AGENTS.GAB.md -- read when working with standard .lib includes (Part 5: lines 9247-9344)
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

## 930000.lib -- Build Payroll Report Table (JB032BGI)

**Wraps:** CallWrapper `930000` — Build Payroll Report Table / JB032BGI

```
Program.External.Include.Library("930000.lib",False)
```

This library invokes the `930000` callwrapper to build a payroll report table via the JB032BGI program. It accepts a date range, a process-by grouping, a start/end range for the grouping, and several Y/N flags. It uses `ConcatCallWrapperArgs`, is invoked **per row**, and exposes **four invocation modes** (Sync, Async, SyncBio, AsyncBio).

> **Warning — SyncBio Bug:** The source code contains a bug in `930000SyncBio`: it passes `CallWrapperType` = 3 instead of 2. Since `Case(3)` maps to `CallWrapperAsyncBio`, calling `930000SyncBio` actually executes **AsyncBio** (not SyncBio). The `Case(2)` path (`CallWrapperSyncBio`) is unreachable — no subroutine passes `CallWrapperType` = 2. Only `930000Sync`, `930000Async`, and `930000AsyncBio` behave as expected.

### DataTable Schema — `930000`

| Column | Description | Type | Format | Default |
|--------|-------------|------|--------|---------|
| BegDate | Start date | String | `YYYYMMDD` | |
| EndDate | End date | String | `YYYYMMDD` | |
| ProcessBy | Process-by grouping | String | See `ProcessBy` enum below | |
| Start | Starting value for grouping | String | `9(5)` | |
| End | Ending value for grouping | String | `9(5)` | |
| Print | Print balances only flag | String | `Y`/`N` | |
| Page | Page flag | String | `Y`/`N` | |
| ExcludeAbsences | Exclude absences flag | String | `Y`/`N` | |
| EmplBy | Employee-by parameter | String | | `"N"` — **must always be `"N"`**; defaults automatically; do not change |

### ProcessBy Enum

| Value | Meaning |
|-------|---------|
| `"E"` | Employee |
| `"D"` | Department |
| `"G"` | Group |

### Global Variables

| Variable | Format | Default |
|----------|--------|---------|
| `V.Global.s930000Error` | `Sub*!*ErrNo*!*ErrDesc*!*Row` (4-part; Row is 1-based, `-1` for wrapper-level errors) | `""` |

### Exposed Subroutines

| Subroutine | Description |
|------------|-------------|
| `930000Sync` | Calls `F.Global.General.CallWrapperSync(930000, ...)` per row |
| `930000Async` | Calls `F.Global.General.CallWrapperAsync(930000, ...)` per row |
| `930000SyncBio` | **Intended** to call SyncBio, but **actually calls AsyncBio** due to source bug |
| `930000AsyncBio` | Calls `F.Global.General.CallWrapperAsyncBio(930000, ...)` per row |

### How It Works

1. The library creates a `930000` DataTable with nine columns (`BegDate`, `EndDate`, `ProcessBy`, `Start`, `End`, `Print`, `Page`, `ExcludeAbsences`, `EmplBy`). `EmplBy` defaults to `"N"`.
2. When any of the four exposed subroutines is called, it loops through each row in the DataTable.
3. For each row, all nine columns are concatenated via `F.Intrinsic.String.ConcatCallWrapperArgs` into a single parameter string.
4. The callwrapper `930000` is invoked with the concatenated parameters.
5. After all rows are processed, the DataTable rows are deleted.
6. On error, `V.Global.s930000Error` is set with the 4-part format `Sub*!*ErrNo*!*ErrDesc*!*Row` where `Row` is 1-based (or `-1` for wrapper-level errors caught in the exposed subroutines).

**Usage Pattern (build payroll report by employee for a date range):**

```
Program.External.Include.Library("930000.lib",False)

F.Data.DataTable.AddRow("930000")
F.Data.DataTable.SetValue("930000","BegDate","20260301",0)
F.Data.DataTable.SetValue("930000","EndDate","20260315",0)
F.Data.DataTable.SetValue("930000","ProcessBy","E",0)
F.Data.DataTable.SetValue("930000","Start","00001",0)
F.Data.DataTable.SetValue("930000","End","99999",0)
F.Data.DataTable.SetValue("930000","Print","N",0)
F.Data.DataTable.SetValue("930000","Page","N",0)
F.Data.DataTable.SetValue("930000","ExcludeAbsences","N",0)

F.Intrinsic.Control.CallSub(930000Sync)
```

**Usage Pattern (build payroll report by department, print balances only, exclude absences):**

```
Program.External.Include.Library("930000.lib",False)

F.Data.DataTable.AddRow("930000")
F.Data.DataTable.SetValue("930000","BegDate","20260301",0)
F.Data.DataTable.SetValue("930000","EndDate","20260331",0)
F.Data.DataTable.SetValue("930000","ProcessBy","D",0)
F.Data.DataTable.SetValue("930000","Start","00010",0)
F.Data.DataTable.SetValue("930000","End","00050",0)
F.Data.DataTable.SetValue("930000","Print","Y",0)
F.Data.DataTable.SetValue("930000","Page","Y",0)
F.Data.DataTable.SetValue("930000","ExcludeAbsences","Y",0)

F.Intrinsic.Control.CallSub(930000Sync)
```

> **Note:** The DataTable rows are cleared after processing. The callwrapper is invoked **per row** — each row triggers its own call. No file generation and no field padding. Parameters are passed in order: `BegDate`, `EndDate`, `ProcessBy`, `Start`, `End`, `Print`, `Page`, `ExcludeAbsences`, `EmplBy`. Dates use `YYYYMMDD` format. The `EmplBy` column defaults to `"N"` and must not be changed. The `Start`/`End` range values correspond to the `ProcessBy` grouping (employee number, department number, or group number). **Caution:** `930000SyncBio` does not call SyncBio — it calls AsyncBio due to a source bug.

---

