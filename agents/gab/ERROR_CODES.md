# GAB Runtime Error Codes -- Quick Diagnosis
# When you see an error number in OCTSRS traces, look it up here FIRST.
# Source: OCTSRS M_Debug.vb + runtime verification across 13 agent sessions
---

## Error Lookup Table

| Error | Name | Meaning | Common Cause | Fix |
|------:|------|---------|--------------|-----|
| 113 | Parse error | Line could not be tokenized | Wrong delimiter (`.` vs `!`), malformed ScreenSU syntax, `V.Color.Gray` in ScreenSU, dot-separated form name (`Gui.Form.Name.` should be `Gui.Form_Name.`) | Check read uses `!`, write uses `.`; use underscore in form names |
| 117 | Wrong argument count | Method called with too many or too few parameters | Missing or extra arguments in function call | Check exact signature in reference file; count commas carefully |
| 119 | Variable not found | Variable scope/name does not exist | `V.Caller.*` or `V.Ambient.*` that is not in the runtime | Check VARIABLES.md for the valid list of ambient/caller vars |
| 405 | Expected N arguments | Specific arg-count validation | `String.Build` with 0 substitution args (needs min 3), wrong DataTable function arity | Read function doc; `String.Build` needs format + 1+ subs + result |
| 600 | Invalid property/method | Property or method not valid for this object | `.Text()` on form/button (use `.Caption()`), unknown method on a control | Check GUI_FORMS.md for that control's valid properties |
| 999000 | Invalid method specified | Function does not exist in GAB runtime | **Invented/hallucinated function** -- agent guessed an API that doesn't exist | Run `Validate-GabApi.ps1`; find correct function in reference files |
| 3000 | Property not supported by object | Valid property used on wrong control/context | `.PervasiveDate` on wrong control, `.ExecuteScript()` on WebView2, `.Scrolling()` on TextBox | Check which controls support this property in reference docs |
| 5010 | Subroutine not found | Event handler targets non-existent sub | Typo in subroutine name in `.Event()` wiring | Verify sub name matches exactly (case-insensitive but must exist) |
| 5150 | Variable does not exist | V.Enum or V.Args reference invalid | Wrong `V.Args.*` name for this event, enum member typo, GSSVersion < 2023.1 for new enums | Check GUI_EVENTS.md for exact V.Args names per event type |
| 10003 | Control event does not exist | Event name is not valid for this control | `OnClick` instead of `Click`, `Change` on Tab (only `Click`), misspelled event | Drop "On" prefix; check CHEATSHEET.md §4 or screensu-registry.json |
| 10060 | Control creation arg error | Wrong args in `.Create()` call | Inline Create params when they're not supported, or wrong param count for special creates like ProgressPanel | Use `.Create(Type)` then separate `.Size()`, `.Position()` calls |
| 20010 | ODBC error | Database operation failed | Wrong SQL table/column name, unclosed connection, connection name too long (>10 chars), Zen SQL syntax error | Check schema files; verify table exists; use short connection names |
| 20011 | ODBC connection error | Cannot connect to database | DSN not configured, wrong credentials, database locked | Verify V.Ambient.PDSN is correct; check Zen service running |
| 21001 | Recordset error | Recordset operation on closed/invalid recordset | Accessing fields after `.Close`, using wrong recordset name, not checking EOF first | Always check EOF before field access; ensure open before navigate |
| 21015 | DataTable column type invalid | Column type string not recognized | Used .NET type (`System.String`, `System.Decimal`) instead of GAB type | Use GAB types only: `"String"`, `"Float"`, `"Long"`, `"Boolean"`, `"Date"` |
| 21034 | AddRelation key not unique | Relation key column has duplicate values in parent | Parent DataTable has non-unique values in the key column(s) | Use composite key, `SELECT DISTINCT`, or `GROUP BY` in source query |
| 121000 | View not found | Grid view name doesn't exist | Wrong gridview name in `AddGridViewFromDataView` -- 2nd param must be root GV name | For child views, always pass the ROOT gridview name as 2nd param |

## Silent Failures (NO error, NO log -- only detectable via Validate-ScreenSU.ps1)

| Symptom | Runtime Behavior | Root Cause | How to Detect |
|---------|------------------|------------|---------------|
| Form builds incomplete / control missing | `WriteDebugLine("Can't create ...")` + silent return | Invalid control type (`CommandButton`, `Panel`, etc.) | Run `Validate-ScreenSU.ps1` before launch |
| Property not applied / wrong appearance | `WriteDebugLine("Failed ConvertToInteger call")` | Wrong value type for property (string where int expected) | Check screensu-registry.json for property type |
| Script immediately exits after launch | Form never showed → event loop never started | Missing `.Show` + `AlwaysOnTop` flash in Main | Ensure `.Show` is called; add AlwaysOnTop(True/False) |
| Process crashes with no output | Unhandled .NET exception in control constructor | Corrupted ScreenSU or incompatible control create | Run `Validate-ScreenSU.ps1`; simplify ScreenSU |

## OCTSRS Trace Error Patterns

When reading `octsrs.*.debug` trace files, these patterns indicate errors:

```
ERROR    999000  Invalid method specified: F.Intrinsic.String.Find
ERROR    10003   The specified control event {ONCLICK} does not exist
ERROR    600     unhandled control: TEXT (for Button)
WARN     ---     Can't create COMMANDBUTTON    ← SILENT (no error number)
```

## Error Resolution Workflow

1. See error number → look up in table above
2. If 999000: method doesn't exist → `Validate-GabApi.ps1` to find what you used wrong
3. If 10003: event doesn't exist for that control → check `screensu-registry.json` for valid events
4. If 600/3000: property/method wrong for that control → check control docs in GUI_FORMS.md
5. If silent (no error): run `Validate-ScreenSU.ps1` → it catches what the runtime won't tell you
