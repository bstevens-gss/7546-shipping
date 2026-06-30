# GAB String, Math & Date Operations Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with string manipulation, math, or date operations
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---
# STRING OPERATIONS

```
F.Intrinsic.String.Build("{0} has {1} items",V.Local.sName,V.Local.iCount,V.Local.sResult)
```

**Signature:** `F.Intrinsic.String.Build(sFormatTemplate, substArg1 [, substArg2, ...], sResultVariable)`

**Minimum 3 arguments:** format string + at least one substitution argument + result variable. The format string MUST contain at least one `{N}` placeholder. Calling with zero substitution args (e.g., `String.Build("static text", sResult)`) fails with **Error 405: Expected at least 3 argument(s)**.

**For literal strings with no placeholders**, use `V.Local.s.Set("...")` or `String.Concat` instead.

```
F.Intrinsic.String.Concat(sA,sB,sResult)             ' Concat 2 strings
F.Intrinsic.String.Concat(sA,sB,sC,sResult)         ' Concat 3 strings (variadic: last param is always result)
F.Intrinsic.String.Split(sSource,"*!*",sArray)        ' Split to array
F.Intrinsic.String.Replace(sSource,"find","repl",sResult)
F.Intrinsic.String.LPad(sSource,"0",6,sResult)        ' Left pad string
F.Intrinsic.String.LPad(iValue,"0",7,sResult)         ' Left pad numeric (auto-converts)
F.Intrinsic.String.RPad(sSource," ",20,sResult)        ' Right pad string
F.Intrinsic.String.RPad(iValue,0,4,sResult)           ' Right pad numeric
F.Intrinsic.String.Left(sSource,5,sResult)             ' Left substring
F.Intrinsic.String.Right(sSource,3,sResult)            ' Right substring
F.Intrinsic.String.Mid(sSource,3,5,sResult)            ' Mid substring
F.Intrinsic.String.Trim(sSource,sResult)               ' Trim
F.Intrinsic.String.Format(fValue,"#,##0.00",sResult)   ' Format number
F.Intrinsic.String.Format(iValue,"000000",sResult)     ' Format with leading zeros
F.Intrinsic.String.IsInString(sHaystack,sNeedle,True,bResult)  ' Contains
F.Intrinsic.String.RegExMatch(sSource,sPattern,True,sResult)   ' Regex
F.Intrinsic.String.MakeURLFriendly(sSource,sResult)
F.Intrinsic.String.DateString(dDate,sResult)
F.Intrinsic.String.TimeString(tTime,sResult)
F.Intrinsic.String.GSSPartString(sPart,sRev,sResult)
F.Intrinsic.String.LimitSplit(sSource,17,sResult)
F.Intrinsic.String.StringListToString(slSource,sResult)
F.Intrinsic.String.ConcatCallWrapperArgs(sArg1,sArg2,sResult)         ' 2-arg concat
F.Intrinsic.String.ConcatCallWrapperArgs(sArg1,sArg2,sArg3,sResult)  ' 3-arg concat (variadic)
F.Intrinsic.String.Join(sArray,sDelimiter,sResult)                     ' Join array elements
F.Intrinsic.String.Len(sSource,iResult)                                ' String length to variable
F.Intrinsic.String.Occurs(sSource,sSearchFor,iResult)                  ' Count occurrences
F.Intrinsic.String.RTrim(sSource,sResult)                              ' Right trim
F.Intrinsic.String.SplitCSV(sSource,sArray)                            ' Split CSV-formatted string
F.Intrinsic.String.StripCharacters(sSource,sCharsToStrip,sResult)      ' Remove specific characters
F.Intrinsic.String.TimeStringSec(tTime,sResult)                        ' Time to string with seconds
F.Intrinsic.String.TrimChar(sSource,sChar,sResult)                     ' Trim specific character from both ends
F.Intrinsic.String.TrimCharL(sSource,sChar,sResult)                    ' Trim specific character from left
F.Intrinsic.String.TrimCharR(sSource,sChar,sResult)                    ' Trim specific character from right
F.Intrinsic.String.RemoveArrayDuplicates(sArray,sResult)               ' Deduplicate array
```

## Additional String Functions
```
F.Intrinsic.String.ConcatEOL(sSource,sResult)                          ' Concat with end-of-line separator
F.Intrinsic.String.ConcatChr(sA,iAscii,sResult)                       ' Concat with ASCII character between
F.Intrinsic.String.JoinCSV(sArray,bAllStrings,sResult)                 ' Array to CSV string
F.Intrinsic.String.InStr(sSource,sFind,iStartPos,iResult)              ' Find position (1-based return; 0 = not found)
F.Intrinsic.String.InStrRev(sSource,sFind,iStart,iResult)              ' Find position from end
F.Intrinsic.String.IsNullOrWhiteSpace(sInput,bResult)                  ' Null/empty/whitespace check
F.Intrinsic.String.PCase(sSource,sResult)                              ' Proper case (Title Case)
F.Intrinsic.String.StripExtraSpaces(sSource,sResult)                   ' Collapse multiple spaces to single
F.Intrinsic.String.Chunk(sArray,sResult)                               ' Combine string array into single string
F.Intrinsic.String.PositionalSplit(sSource,sPositions,sLengths,sResult)  ' Fixed-width field parsing
F.Intrinsic.String.PositionalString(sValues,sLengths,sAlignments,sResult)  ' Build fixed-width output
F.Intrinsic.String.PrepareSQLStatement(sSelect,sWhere,sOrderBy,sResult)  ' Safe SQL construction
F.Intrinsic.String.CalculateMD5Hash(sInput,sResult)                    ' MD5 hash
F.Intrinsic.String.CalculateSHA1Hash(sInput,sResult)                   ' SHA-1 hash
F.Intrinsic.String.Base62Encode(iValue,sResult)                        ' Long to base-62 string
F.Intrinsic.String.Base62Decode(sInput,iResult)                        ' Base-62 string to Long
F.Intrinsic.String.ConvertDec2Hex(iValue,sResult)                      ' Decimal to hex
F.Intrinsic.String.ConvertHex2Dec(sHex,iResult)                        ' Hex to decimal
F.Intrinsic.String.ExtractHTMLLinks(sHTML,sLinks,sLabels)              ' Extract links from HTML
F.Intrinsic.String.HTMLTableFromUDT(sUDT,sResult)                     ' UDT to HTML table
F.Intrinsic.String.DoubleDelimitedSeek(sData,sOuterDelim,sInnerDelim,sSearch,iCase,sDefault,sResult)  ' Seek in nested delimited string
F.Intrinsic.String.RegExReplace(sInput,sPattern,sReplacement,bIgnoreCase,bMultiLine,bGlobal,sResult)  ' Regex replace
F.Intrinsic.String.Asc(sChar,iResult)                                 ' Character to ASCII value
F.Intrinsic.String.LCase(sSource,sResult)                             ' Lowercase
F.Intrinsic.String.UCase(sSource,sResult)                             ' Uppercase
F.Intrinsic.String.LTrim(sSource,sResult)                             ' Left trim
F.Intrinsic.String.SortAsc(sArray,sResult)                            ' Sort array ascending
F.Intrinsic.String.SortDesc(sArray,sResult)                           ' Sort array descending
F.Intrinsic.String.WeakEncryption(sSource,sResult)                    ' Simple obfuscation
F.Intrinsic.String.WeakDecryption(sSource,sResult)                    ' Reverse WeakEncryption
F.Intrinsic.String.ConvertString2BA(sInput,baResult)                   ' String to byte array
F.Intrinsic.String.ConvertBA2String(baInput,sResult)                   ' Byte array to string
F.Intrinsic.String.DecodeUTF8(sInput,sResult)                         ' UTF-8 to ANSI
F.Intrinsic.String.DelimitedStringToCSV(sInput,sRowDelim,sFieldDelim,sResult)  ' Double-delimited to CSV
F.Intrinsic.String.Base36Increment(sInput,sResult)                            ' Increment base-36 string by 1
F.Intrinsic.String.ColumnToOrdinal(sColumn,iResult)                           ' Excel column letter to ordinal (e.g. "A" -> 1)
F.Intrinsic.String.OrdinalToColumn(iOrdinal,sResult)                          ' Ordinal to Excel column letter (e.g. 1 -> "A")
F.Intrinsic.String.ConvertBA2Hex(baInput,sResult)                             ' Byte array to hex string
F.Intrinsic.String.ConvertHex2BA(sHex,baResult)                               ' Hex string to byte array
F.Intrinsic.String.ConvertToString(value,sResult)                             ' Convert any value to string
F.Intrinsic.String.ConvertCurrencyValueToSpanish(sValue,sResult)              ' Currency to Spanish text
F.Intrinsic.String.ConvertInlineDecimalsToFractions(sInput,sResult)           ' Replace decimals with fraction strings
F.Intrinsic.String.IsLower(sInput,bResult)                                    ' True if all lowercase
F.Intrinsic.String.IsUpper(sInput,bResult)                                    ' True if all uppercase
```

## Standard Separators
| Separator | Purpose | Context |
|-----------|---------|---------|
| `*!*` | Field/column delimiter | DataTable columns, Split operations, CallWrapper args |
| `$!$` | Row delimiter | Excel rows, multi-value returns |
| `&^&` | Sheet/section delimiter | Excel multi-sheet reads |
| `@!@` | Column mapping | SaveToDB column mapping |
| `!*!` | CallWrapper argument separator | ConcatCallWrapperArgs |
| `:!:` | Secondary/nested delimiter | Nested structures within `*!*`-delimited values |

---

# MATH OPERATIONS

**CRITICAL: GAB has NO inline math operators.** Expressions like `a + b` or `x * y` do NOT exist. All arithmetic uses function calls.

```
F.Intrinsic.Math.Add(a,b,result)
F.Intrinsic.Math.Sub(a,b,result)
F.Intrinsic.Math.Mult(a,b,result)
F.Intrinsic.Math.Div(a,b,result)
F.Intrinsic.Math.Mod(a,b,result)
F.Intrinsic.Math.Floor(fValue,iResult)
F.Intrinsic.Math.SIN(fInput,fResult)
F.Intrinsic.Math.ASIN(fInput,fResult)
F.Intrinsic.Math.ConvertToFloat(sValue,fResult)      ' Parse string to Float
F.Intrinsic.Math.ConvertToLong(sValue,iResult)        ' Parse string to Long
```

## Additional Math Functions
```
F.Intrinsic.Math.IDiv(a,b,result)                        ' Integer division (no remainder)
F.Intrinsic.Math.XtoY(base,power,result)                 ' Raise to power
F.Intrinsic.Math.Ceiling(fValue,iResult)                 ' Round up to nearest integer
F.Intrinsic.Math.Round(fValue,iDecimals,fResult)         ' Round to N decimal places
F.Intrinsic.Math.Abs(value,result)                       ' Absolute value
F.Intrinsic.Math.Sgn(value,result)                       ' Sign (-1, 0, or 1)
F.Intrinsic.Math.Sqr(value,result)                       ' Square root
F.Intrinsic.Math.Rnd(iMax,iResult)                       ' Random number 0 to iMax
F.Intrinsic.Math.IsNumeric(value,bResult)                ' Check if numeric
F.Intrinsic.Math.Evaluate(sExpression,fResult)           ' Evaluate math expression string
F.Intrinsic.Math.StandardDeviation(sArray,fResult)       ' Std deviation of array
F.Intrinsic.Math.UnitConversion(fValue,sConversion,fResult)  ' Unit conversion
F.Intrinsic.Math.CalculateUPCcheckDigit(sUPC,sResult)   ' UPC check digit
F.Intrinsic.Math.DecimalToFraction(fValue,sResult)       ' Decimal to fraction string
F.Intrinsic.Math.BitwiseL(iOp1,sOperator,iOp2,iResult)  ' Bitwise operations (AND, OR, XOR, NOT)
F.Intrinsic.Math.Int(fValue,iResult)                     ' Truncate to integer (toward negative infinity)
F.Intrinsic.Math.Fix(fValue,iResult)                     ' Truncate to integer (toward zero)
F.Intrinsic.Math.Inv(fValue,fResult)                     ' Inverse (1/x)
F.Intrinsic.Math.Exp(fValue,fResult)                     ' e^x
F.Intrinsic.Math.Log(fValue,fResult)                     ' Log base 10
F.Intrinsic.Math.Logn(fValue,fBase,fResult)              ' Log base N
F.Intrinsic.Math.DegToRad(fDeg,fResult)                  ' Degrees to radians
F.Intrinsic.Math.RadToDeg(fRad,fResult)                  ' Radians to degrees
F.Intrinsic.Math.IsInRange(value,rangeStart,rangeEnd,bResult)  ' Check if value is within range

' Trigonometric
F.Intrinsic.Math.SIN(fExpr,fResult)                          ' Sine
F.Intrinsic.Math.COS(fExpr,fResult)                          ' Cosine
F.Intrinsic.Math.TAN(fExpr,fResult)                          ' Tangent
F.Intrinsic.Math.SEC(fExpr,fResult)                          ' Secant
F.Intrinsic.Math.COSEC(fExpr,fResult)                        ' Cosecant
F.Intrinsic.Math.COTAN(fExpr,fResult)                        ' Cotangent

' Inverse trigonometric
F.Intrinsic.Math.ASIN(fExpr,fResult)                         ' Arc sine
F.Intrinsic.Math.ACOS(fExpr,fResult)                         ' Arc cosine
F.Intrinsic.Math.ATAN(fExpr,fResult)                         ' Arc tangent
F.Intrinsic.Math.ASEC(fExpr,fResult)                         ' Arc secant
F.Intrinsic.Math.ACOSEC(fExpr,fResult)                       ' Arc cosecant
F.Intrinsic.Math.ACOTAN(fExpr,fResult)                       ' Arc cotangent

' Hyperbolic
F.Intrinsic.Math.HSIN(fExpr,fResult)                         ' Hyperbolic sine
F.Intrinsic.Math.HCOS(fExpr,fResult)                         ' Hyperbolic cosine
F.Intrinsic.Math.HTAN(fExpr,fResult)                         ' Hyperbolic tangent
F.Intrinsic.Math.HSEC(fExpr,fResult)                         ' Hyperbolic secant
F.Intrinsic.Math.HCOSEC(fExpr,fResult)                       ' Hyperbolic cosecant
F.Intrinsic.Math.HCOTAN(fExpr,fResult)                       ' Hyperbolic cotangent

' Inverse hyperbolic
F.Intrinsic.Math.HASIN(fExpr,fResult)                        ' Hyperbolic arc sine
F.Intrinsic.Math.HACOS(fExpr,fResult)                        ' Hyperbolic arc cosine
F.Intrinsic.Math.HATAN(fExpr,fResult)                        ' Hyperbolic arc tangent
F.Intrinsic.Math.HASEC(fExpr,fResult)                        ' Hyperbolic arc secant
F.Intrinsic.Math.HACOSEC(fExpr,fResult)                      ' Hyperbolic arc cosecant
F.Intrinsic.Math.HACOTAN(fExpr,fResult)                      ' Hyperbolic arc cotangent

' Polar / rectangular coordinate conversion
F.Intrinsic.Math.PolarToX(fTheta,fRadius,fResult)            ' Polar to X coordinate
F.Intrinsic.Math.PolarToY(fTheta,fRadius,fResult)            ' Polar to Y coordinate
F.Intrinsic.Math.RectToRad(fX,fY,fResult)                    ' Rectangular to radius
F.Intrinsic.Math.RectToTheta(fX,fY,fResult)                  ' Rectangular to theta
```

---

# DATE OPERATIONS

```
F.Intrinsic.Date.DateAdd("D",iDays,dDate,dResult)       ' Add days
F.Intrinsic.Date.DateAdd("N",iMinutes,dDate,dResult)     ' Add minutes
F.Intrinsic.Date.DateAdd("YYYY",iYears,dDate,dResult)    ' Add years
F.Intrinsic.Date.DateDiff("S",dStart,dEnd,iResult)       ' Diff in seconds
F.Intrinsic.Date.DateDiff("N",dStart,dEnd,iResult)       ' Diff in minutes
F.Intrinsic.Date.BeginningOfMonth(dDate,dResult)
F.Intrinsic.Date.BeginningOfWeek(dDate,dResult)
F.Intrinsic.Date.EndOfMonth(dDate,dResult)
F.Intrinsic.Date.IsDate(sValue,bResult)
F.Intrinsic.Date.ConvertDString(sDate,"YYYY/MM/DD",sResult)
F.Intrinsic.Date.CombineDateTime(dDate,tTime,dResult)       ' Merge date and time into single datetime
```

## Additional Date Functions
```
F.Intrinsic.Date.DateSerial(iYear,iMonth,iDay,dResult)                ' Build date from components
F.Intrinsic.Date.TimeSerial(iHour,iMinute,iSecond,tResult)            ' Build time from components
F.Intrinsic.Date.DateTimeSerial(iYear,iMonth,iDay,iHour,iMinute,iSecond,dResult)  ' Build datetime
F.Intrinsic.Date.DateComp(dDate,sResult)                               ' Date comparison value
F.Intrinsic.Date.TimeComp(dDate,sResult)                               ' Time comparison value
F.Intrinsic.Date.Year(dDate,iResult)                                   ' Extract year
F.Intrinsic.Date.Month(dDate,iResult)                                  ' Extract month
F.Intrinsic.Date.Day(dDate,iResult)                                    ' Extract day
F.Intrinsic.Date.Hour(dDate,iResult)                                   ' Extract hour
F.Intrinsic.Date.Minute(dDate,iResult)                                 ' Extract minute
F.Intrinsic.Date.Second(dDate,iResult)                                 ' Extract second
F.Intrinsic.Date.Weekday(dDate,iResult)                                ' Day of week (1=Sunday)
F.Intrinsic.Date.DateAddWorkdays(dStart,iDays,sMask,dResult)           ' Add workdays (skip weekends)
F.Intrinsic.Date.DateSubtractWorkdays(dStart,iDays,sMask,dResult)     ' Subtract workdays
F.Intrinsic.Date.WorkdaysBetweenDates(dStart,dEnd,sMask,iResult)     ' Count workdays between dates
F.Intrinsic.Date.WorkdaysRemaining(dStart,iResult)                    ' Workdays remaining in month
F.Intrinsic.Date.DatesFromGLPeriod(iPeriod,iYear,sResult)             ' GL period to start/end dates
F.Intrinsic.Date.GLPeriodFromDate(dDate,sResult)                      ' Date to GL period
F.Intrinsic.Date.ToJulianDate(dDate,iResult)                          ' To Julian date
F.Intrinsic.Date.FromJulianDate(iJulian,dResult)                      ' From Julian date
F.Intrinsic.Date.UTCoffset(iResult)                                    ' Hours offset from UTC
F.Intrinsic.Date.TimeZoneName(sResult)                                 ' Local timezone name
F.Intrinsic.Date.HoursMinutesSecondsToDecimal(iH,iM,iS,fResult)     ' Time to decimal hours
F.Intrinsic.Date.IsDST(bResult)                                       ' Is daylight saving time active
F.Intrinsic.Date.EndOfWeek(dDate,dResult)                              ' End of week date
F.Intrinsic.Date.ConvertTString(sTime,sFormat,dResult)                ' Parse string to date/time
```

---

# RECIPES & EDGE CASES

## String Building: When to Use What

| Task | Use | NOT |
|------|-----|-----|
| Concatenate with placeholders | `String.Build("{0} of {1}",a,b,result)` | `+` (no operator exists) |
| Simple concatenation (2-3 parts) | `String.Concat(a,b,result)` | `String.Build` without `{N}` |
| Literal string assignment | `V.Local.s.Set("hello world")` | `String.Build("hello world",result)` |
| Append to existing variable | `V.Local.s.Append(" more text")` | Re-setting with Concat |
| Build with literal braces | Pass `{` and `}` as parameters: `String.Build("{0}literal{1}","{","}",result)` | Putting `{` or `}` directly in the format string |

## Safe SQL String Building

```
'-- Always escape user input before embedding in SQL
V.Local.sInput.Set(V.Local.sInput.PSQLFriendly)
F.Intrinsic.String.Build("SELECT * FROM INVENTORY_MSTR WHERE PART = '{0}'",V.Local.sInput,V.Local.sSQL)
```

> **Critical:** `.PSQLFriendly` is a **property** (no parentheses). It **cannot** chain on `V.Screen` or `V.Passed` reads. Always copy to a local variable first. See `agents/gab/PITFALLS.md`.

## Math Edge Cases

- **`Round` vs `.Float`:** `F.Intrinsic.Math.Round(fVal,2,fResult)` rounds to 2 decimals. Reading a DataTable cell with `.FieldValFloat` also returns a Float, but it does NOT round -- it just converts. Apply `Round` explicitly when decimal precision matters.
- **Integer division:** `F.Intrinsic.Math.Div(7,2,result)` returns `3.5` (Float). Use `F.Intrinsic.Math.IDiv(7,2,result)` for integer division returning `3`.
- **Evaluate:** `F.Intrinsic.Math.Evaluate("2+3*4",result)` evaluates inline math from a **string expression**. This is the ONLY place inline operators exist -- inside a string, not in GAB statements.

## Date Format Codes for ConvertDString

| Code | Meaning | Example |
|------|---------|---------|
| `YYYY` | 4-digit year | 2024 |
| `YY` | 2-digit year | 24 |
| `MM` | 2-digit month | 03 |
| `DD` | 2-digit day | 15 |
| `HH` | 24-hour hour | 14 |
| `NN` | Minute | 30 |
| `SS` | Second | 45 |

Usage: `F.Intrinsic.Date.ConvertDString(dDate,"YYYYMMDD",sResult)` produces `"20240315"`.

## DateAdd Interval Codes

| Code | Interval |
|------|----------|
| `YYYY` | Years |
| `Q` | Quarters |
| `M` | Months |
| `Y` | Day of year |
| `D` | Days |
| `W` | Weekdays |
| `WW` | Weeks |
| `H` | Hours |
| `N` | Minutes |
| `S` | Seconds |

## Common Pitfall: InStr Returns 0 for Not Found

`F.Intrinsic.String.InStr` returns **1-based** position. A return of `0` means "not found" -- not an error. Always check before using the result with `Mid`:

```
F.Intrinsic.String.InStr(V.Local.sSource,"@",1,V.Local.iPos)
F.Intrinsic.Control.If(V.Local.iPos,>,0)
    F.Intrinsic.String.Left(V.Local.sSource,V.Local.iPos,V.Local.sLeft)
F.Intrinsic.Control.EndIf
```

---

