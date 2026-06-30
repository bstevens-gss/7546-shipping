param(
    [Parameter(Mandatory=$true)]
    [string]$Path,
    [switch]$Recurse,
    [ValidateSet("error","warning","convention")]
    [string]$Severity = "error",
    [ValidateSet("text","json")]
    [string]$Format = "text"
)

$severityRank = @{ "error" = 0; "warning" = 1; "convention" = 2 }
$minRank = $severityRank[$Severity]

# ── Rule definitions ──────────────────────────────────────────
# Each rule: [id, severity, regex, message, contextNote]
# Regex is applied per-line unless marked multiline.
# Lines starting with '-- are comments and skipped.

$rules = @(
    # ─── A: Syntax & Operators ───
    ,@("A1","error",
       '(?<!")(?:V\.(?:Local|Global|Screen|DataTable)\.\w+)\s*[\+\-\*/]\s*(?:V\.(?:Local|Global|Screen|DataTable)\.\w+)',
       "Inline math operators (+,-,*,/) do not exist in GAB. Use F.Intrinsic.Math.Add/Sub/Mult/Div.",
       "")
    ,@("A2","error",
       '(?:\.Set\s*\(|\.Append\s*\().+[^"]\s*\+\s*V\.',
       "String concatenation with + does not work in GAB. Use F.Intrinsic.String.Build or .Concat.",
       "")
    ,@("A6","error",
       'F\.Global\.Callwrapper\b',
       "Wrong casing: use F.Global.CallWrapper (capital W).",
       "")
    ,@("A8","error",
       'F\.Intrinsic\.Math\.(?:Add|Sub)\s*\(\s*V\.(?:Local|Global)\.d[A-Z]\w*\s*,\s*\d',
       "Do not use Math.Add/Sub for date arithmetic. Use F.Intrinsic.Date.DateAdd.",
       "")
    ,@("A10","error",
       '\bDoWhile\b',
       "DoWhile does not exist in GAB. Use For/Next or DoUntil/Loop.",
       "")

    # ─── B: Properties & Accessors ───
    ,@("B1","error",
       '(?:V\.(?:Screen|Local|Global|DataTable)\.[^)]+?)\.(?:Text|Tab|ListIndex|PervasiveDate|Caption|UBound|PSQLFriendly|SQLServerFriendly|Exists|Long|Trim|Float|Boolean|Hour|Minute|Second)\s*\(\s*\)',
       "Property reads must not use (). Drop the parentheses.",
       "")
    ,@("B2","error",
       'F\.Intrinsic\.String\.UBound\s*\(',
       ".UBound is a property, not a function. Use V.Local.result.Set(V.Local.arr.UBound).",
       "")
    ,@("B5","error",
       '(?<!F\.Intrinsic\.String)\.(?:Left|Right)\s*\(\s*(?:\d+|V\.)',
       "Dynamic .Left(N)/.Right(N) do not exist. Use F.Intrinsic.String.Left(str,N,result) or fixed .Left3/.Left5.",
       "")
    ,@("B6","error",
       '!FieldVal\.(?:Long|Float|Trim|Boolean)',
       "Dot-chained field accessor is invalid. Use single token: !FieldValLong, !FieldValFloat, !FieldValTrim.",
       "")
    ,@("B7","error",
       '!FieldValTrim\.(?:Long|Float)',
       "Cannot chain accessors. Use !FieldValLong or extract to a variable first.",
       "")
    ,@("B9","error",
       '\.Exists\.Not\b',
       "Cannot chain .Not on .Exists. Use F.Intrinsic.Control.If(V.DataTable.dt.Exists,=,False).",
       "")

    # ─── C: GUI Read/Write & Conventions ───
    ,@("C1","warning",
       "'[^'']*'",
       "Single-quoted string literal detected. GAB convention requires double-quoted strings.",
       "")
    ,@("C4","error",
       'Gui\.\w+\.\w+\.(?:FontBold|FontItalic)\s*\(',
       ".FontBold/.FontItalic do not exist. Use .FontStyle(Bold,Italic,Underline,Strikethrough,Shadow).",
       "")
    ,@("C5","error",
       'Gui\.\w+\.\w+\.Checked\s*\(',
       ".Checked is invalid for set. Use .Value(True) / .Value(False).",
       "")
    ,@("C7","error",
       'Gui\.\w+\.\.Create\s*(?:\(\s*\)|,\s*$|\s*$)',
       "Bare .Create is invalid. Use .Create(BaseForm), .Create(DashForm), or .Create(DialogForm).",
       "")
    ,@("C8","error",
       'Gui\.\w+\.\.Create\s*\(\s*Form\s*\)',
       "Form is not a valid type. Use BaseForm, DashForm, or DialogForm.",
       "")
    ,@("C9","error",
       'Gui\.\w+\.\.Unload\b',
       ".Unload does not exist. Use .Visible(False), .Close, or F.Intrinsic.Control.End.",
       "")
    ,@("C10","warning",
       'Gui\.\w+\.(?:cmd\w+|lbl\w+|chk\w+|frame\w+)\.Text\s*\(',
       ".Text() on buttons/labels/checkboxes/frames causes Error 600. Use .Caption() instead.",
       "")
    ,@("C15","error",
       'Gui\.\w+\.\w+\.ReadOnly\s*\(',
       ".ReadOnly does not exist on GAB TextBox. Use .Locked(True/False).",
       "")

    # ─── D: Grid & Data Binding ───
    ,@("D6","error",
       'GetGridviewProperty\s*\([^)]*"?FocusedRowHandle"?',
       "FocusedRowHandle property not supported. Use GetSelectedRowsInFocus.",
       "")
    ,@("D7","warning",
       '(?:GsFlexGrid|HFlexGrid)\b',
       "Legacy grid control. Use GsGridControl for new code.",
       "")
    ,@("D10","error",
       'GetSelectedRowsInFocus\s*\(\s*"',
       "GetSelectedRowsInFocus takes 1 param (returnVar only). Do not pass a gridview name.",
       "")
    ,@("D11","error",
       'GetSelectedRows\s*\([^)]*,[^)]*,[^)]*\)',
       "GetSelectedRows takes exactly 2 params: (gridViewName, returnVar). Too many arguments.",
       "")
    ,@("D12","error",
       'GetCellValueByColumnName\s*\(\s*"[^"]+"\s*,\s*V\.',
       "GetCellValueByColumnName param order: (gvName, ""ColName"", rowIndex, outVar). 2nd param must be a column name string literal.",
       "")
    ,@("D13","error",
       '\.GetCellValue\s*\(\s*"[^"]+"\s*,\s*"',
       "GetCellValue 2nd param is INTEGER column index, not a string. Use GetCellValueByColumnName for string column names.",
       "")
    ,@("D14","error",
       '\.SetCellValue\s*\(\s*"[^"]+"\s*,\s*"',
       "SetCellValue 2nd param is INTEGER column index, not a string. Use SetCellValueByColumnName for string column names.",
       "")
    ,@("D15","error",
       '\.HideRow\s*\(\s*"[^"]+"\s*,\s*[^,)]+\s*\)',
       "HideRow requires 3 params: (gvName, rowIndex, boolean). Missing the hide/show boolean.",
       "")
    ,@("D16","error",
       '\.ExportDetails\s*\(\s*"gv',
       "ExportDetails params are (format, path, mode). 1st param is file format string, not a gridview name.",
       "")
    ,@("D17","error",
       '\.AddRow\s*\(\s*"[^"]+"\s*\)',
       "GsGridControl.AddRow requires 2 params: (gvName, delimitedValues). Cannot add row without values.",
       "")

    # ─── E: DataTable & ODBC ───
    ,@("E5","error",
       'V\.ODBC\.\w+\.IsOpen\b',
       ".IsOpen does not exist on ODBC connections. Use Try/Catch around Close.",
       "")
    ,@("E6","warning",
       '(?:DSN=|UID=|PWD=)(?!.*V\.Ambient)',
       "Hardcoded connection string detected. Use V.Ambient.PDSN/PUser/PPass.",
       "Ignore in debug/test scripts")
    ,@("E10","error",
       '(?i)\.Open(?:Local)?Recordset(?:RO|RW)\s*\(',
       "OpenRecordset* is banned. Use F.Data.DataTable.CreateFromSQL for queries. ExecuteAndReturn for scalars.",
       "")
    ,@("E11","error",
       '(?i)V\.ODBC\.\w+!\w+\.\w+',
       "ODBC recordset accessors (V.ODBC.*) are banned. Use V.DataTable.dt(row).Col!FieldVal instead.",
       "")

    # ─── F: File I/O ───
    ,@("F3","error",
       'F\.Intrinsic\.File\.AppendToFile\s*\(',
       "AppendToFile does not exist. Use Append2File or Append2FileNewLine.",
       "")

    # ─── G: CallSub & Error Handling ───
    ,@("G1","error",
       'CallSub\s*\([^)]*,\s*V\.Local\.\w+\(\d+\)\s*\)',
       "Never pass array elements directly to CallSub. Extract to a plain variable first.",
       "")
    ,@("G2","error",
       'V\.Args\.\w+\.Declare\s*\(',
       "V.Args is for event arguments, not CallSub params. Use F.Intrinsic.Variable.ArgToVar.",
       "")

    # ─── H: Invented APIs ───
    ,@("H1","error",
       'F\.Global\.Inventory\.Browse\s*\(',
       "F.Global.Inventory.Browse does not exist. Use F.Intrinsic.UI.Browser with SQL.",
       "")
    ,@("H2a","error",
       'F\.Data\.Dictionary\.Set\s*\(',
       "F.Data.Dictionary.Set does not exist. Use .AddItem or .UpdateItem.",
       "")
    ,@("H2b","error",
       'F\.Data\.Dictionary\.Get\s*\(',
       "F.Data.Dictionary.Get does not exist. Use V.Dictionary.dict![key] or .GetItem.",
       "")
    ,@("H3a","error",
       'F\.Intrinsic\.String\.Count\s*\(',
       "F.Intrinsic.String.Count does not exist. Use F.Intrinsic.String.Occurs.",
       "")
    ,@("H3b","error",
       'F\.Intrinsic\.String\.GetElement\s*\(',
       "F.Intrinsic.String.GetElement does not exist. After Split, use V.Local.sArray(iIndex).",
       "")
    ,@("H4","error",
       'V\.Ambient\.UserID\b',
       "V.Ambient.UserID does not exist. Use V.Caller.User.",
       "")
    ,@("H5","error",
       'Gui\.\w+\.\w+\.(?:GetDataSourceRowIndex|GetRowCellValue|GetFocusedRowValue)\s*\(',
       "DevExpress method names do not exist in GAB. Use GetCellValue, GetCellValueByColumnName, GetSelectedRowsInFocus.",
       "")
    ,@("H6","error",
       'AddRepositoryComboBox\b',
       "AddRepositoryComboBox does not exist (Error 600). Use ColumnEdit or RowColumnEdit with Dropdownlist.",
       "")
    ,@("H7","error",
       'F\.Data\.Dictionary\.Create\s*\(\s*"[^"]+"\s*,\s*"',
       "Dictionary.Create takes no type parameters. Use F.Data.Dictionary.Create('name') only.",
       "")
    ,@("H8","error",
       'F\.Intrinsic\.File\.AppendToFile\b',
       "AppendToFile does not exist. Use Append2File or Append2FileNewLine.",
       "")
    ,@("H9","error",
       'V\.Ambient\.ScriptDirectory\b',
       "V.Ambient.ScriptDirectory does not exist. Use V.Ambient.ScriptPath for the script directory.",
       "")
    ,@("H18","error",
       'F\.Data\.DataTable\.(?:GetRowCount|GetColumnCount|GetColumnNames|GetValue)\s*\(',
       "DataTable GetRowCount/GetColumnCount/GetColumnNames/GetValue do not exist. Use V.DataTable.dt.RowCount and V.DataTable.dt(row).Col!FieldVal.",
       "")
    ,@("H19","error",
       'V\.(?:Local|Global|Screen)\.\w+\.Prepend\s*\(',
       ".Prepend() does not exist in GAB. Use .Set() with F.Intrinsic.String.Build to prepend.",
       "")
    ,@("H20","error",
       'F\.Intrinsic\.String\.IsNumeric\s*\(',
       "IsNumeric is in Math namespace, not String. Use F.Intrinsic.Math.IsNumeric.",
       "")
    ,@("H21","error",
       'V\.Args\.\w+\.Set\s*\(',
       "V.Args variables are read-only. Use a V.Global variable for return buffers.",
       "")
    ,@("H22","warning",
       'F\.ODBC\.Connection!\w+\.Open\s*\(',
       "Bare .Open() does not exist on ODBC connections. Use OpenConnection(DSN,user,pass) or OpenCompanyConnection.",
       "")
    ,@("H23","error",
       'F\.Data\.DataView\.Filter\s*\(',
       "F.Data.DataView.Filter does not exist. Use F.Data.DataView.SetFilter('dtName','dvName','filterExpr').",
       "")
    ,@("H24","error",
       'F\.Intrinsic\.String\.Chr\s*\(',
       "F.Intrinsic.String.Chr does not exist. Use V.Ambient.DblQuote for double-quote, V.Ambient.CR for CR, etc.",
       "")
    ,@("H25","error",
       'F\.Intrinsic\.UI\.DropDown\s*\(',
       "F.Intrinsic.UI.DropDown does not exist. Use F.Intrinsic.UI.BrowserFromString for selection lists.",
       "")
    ,@("H26","error",
       '\.Event\s*\(\s*Change\s*,',
       "Change event does not exist on Tab/most controls. Tab uses Click event. Check GUI_EVENTS.md for valid event names.",
       "")
    ,@("H27","error",
       '\.RemoveGridView\s*\(',
       "RemoveGridView does not exist on GsGridControl. Grid views cannot be removed at runtime.",
       "")
    ,@("H28","error",
       '\.SetFocusedRow\s*\(',
       "SetFocusedRow does not exist. Use SelectRow(gvName, rowIndex) or FocusCell(gvName, row, col).",
       "")
    ,@("H29","error",
       '\.SelectedPage\s*\(',
       "SelectedPage does not exist on Tab/NavFrame. Use SetTab(n) for Tab or SelectedIndex(n) for NavFrame.",
       "")
    ,@("H30","error",
       'V\.Ambient\.TempDir\b',
       "V.Ambient.TempDir does not exist. Use V.Caller.TempDir or V.Caller.LocalGSSTempDir.",
       "")
    ,@("H32","error",
       '\.GetTab\s*\(',
       "GetTab does not exist on Tab controls. Read tab index via V.Screen.frmName!tabName.Tab (property read).",
       "")

    # ─── A (expanded): Inline arithmetic inside function arguments ───
    ,@("A1b","error",
       '\(\s*V\.(?:Local|Global)\.\w+\s*[\-\+]\s*\d+',
       "Inline arithmetic in function args (V.Local.x - 1) is invalid. Pre-compute with F.Intrinsic.Math.Sub/Add first.",
       "")
    ,@("A1c","error",
       ',\s*V\.(?:Local|Global)\.\w+\s*[\-\+]\s*\d+',
       "Inline arithmetic in function args is invalid. Pre-compute bounds with F.Intrinsic.Math.Sub/Add.",
       "")
    ,@("A1d","error",
       'V\.(?:Local|Global)\.\w+--',
       "-- suffix only works on RowCount property (V.DataTable.dt.RowCount--). Use F.Intrinsic.Math.Sub to decrement variables.",
       "")

    # ─── I: ScreenSU & Runtime Patterns ───
    ,@("I23","error",
       'V\.DataTable\.\w+\(\s*[^)]+,',
       "Invalid DataTable accessor syntax. Use V.DataTable.dt(row).Col!FieldVal, not V.DataTable.dt(row,'Col').",
       "")

    # ─── P: Legacy ───
    ,@("P1","warning",
       '(?:Variable\.Define|V\.uLocal|V\.uGlobal|F\.Intrinsic\.Variable\.UDT)',
       "UDTs are deprecated for new projects. Use DataTable instead.",
       "")

    # ─── DEP: Deprecated/Obsolete APIs (HelpJuice Deep Audit) ───
    ,@("DEP1","warning",
       '(?i)\.Automation\.Zip\.',
       "Automation.Zip namespace is obsolete.",
       "")
    ,@("DEP2","warning",
       '(?i)\.Communication\.Network\.GetAuxUserInfo',
       "GetAuxUserInfo is obsolete.",
       "")
    ,@("DEP3","warning",
       '(?i)\.Global\.General\.ReadLibraryReferences',
       "ReadLibraryReferences is obsolete.",
       "")
    ,@("DEP4","warning",
       '(?i)\.Global\.Object\.CallMethod\b',
       "Object.CallMethod is obsolete.",
       "")
    ,@("DEP5","warning",
       '(?i)\.Global\.Object\.OpenConnection\b',
       "Object.OpenConnection is obsolete.",
       "")
    ,@("DEP6","warning",
       '(?i)\.Security\.CheckUserAccess\b(?!IPM)',
       "CheckUserAccess is deprecated since 2010. Use CheckUserAccessIPM.",
       "")
    ,@("DEP7","warning",
       '(?i)\.Global\.SSF\.',
       "SSF namespace is deprecated. Do not use.",
       "")
    ,@("DEP8","warning",
       '(?i)\.Debug\.BenchmarkModeEnable',
       "BenchmarkModeEnable is deprecated. Use TimerStart/TimerElapsed.",
       "")
    ,@("DEP9","warning",
       '(?i)\.UI\.AddCalendarFeature',
       "AddCalendarFeature is obsolete.",
       "")
    ,@("DEP10","warning",
       '(?i)\.UI\.ClearCalendarFeatures',
       "ClearCalendarFeatures is obsolete.",
       "")
    ,@("DEP11","warning",
       '(?i)\.UI\.Keyboard\b',
       "UI.Keyboard is obsolete.",
       "")
    ,@("DEP12","error",
       '(?i)F\.ODBC\.Connection!\w+\.(?:MoveNext|MovePrevious|MoveFirst|MoveLast|CloseRecordset|CloseRecordsets)\b',
       "Recordset navigation/close methods are banned. Use DataTable For/Next iteration instead.",
       "")
    ,@("DEP14","warning",
       '(?i)\.ODBC\.Misc\.GetDriverList',
       "GetDriverList is deprecated.",
       "")
    ,@("DEP15","warning",
       '(?i)\.option\.Locked\b',
       "GUI .option.Locked is deprecated. Use .Enabled(False).",
       "")
    ,@("DEP16","warning",
       '(?i)Program\.Requires\.Manifest\.Check',
       "Manifest.Check is obsolete.",
       "")
    ,@("DEP17","warning",
       '(?i)\.Debug\.Resume\b',
       "Debug.Resume does not work at runtime (Invalid method). Remove this call.",
       "")
    ,@("DEP18","warning",
       '(?i)\.Debug\.ShowCallerInfo\b',
       "ShowCallerInfo blocks execution with a dialog. Do not use in unattended scripts.",
       "")
    ,@("DEP19","warning",
       '(?i)\.Debug\.Stop\b',
       "Debug.Stop halts execution. Only use during interactive debugging.",
       "")
    ,@("DEP20","warning",
       '(?i)\.Debug\.InvokeDebugger\b',
       "InvokeDebugger launches debugger GUI. Only use during interactive debugging.",
       "")
    # ─── H: Banned Debug Patterns ───
    ,@("H33","warning",
       '(?i)CallSub\s*\(\s*DebugLog',
       "Custom DebugLog subroutine is banned. Use F.Intrinsic.Debug.EnableLogging + SetLA for diagnostics.",
       "")
    ,@("H34","error",
       '(?i)F\.Intrinsic\.Debug\.SetLevel\s*\(',
       "F.Intrinsic.Debug.SetLevel is banned -- pops a blocking dialog. Use the octsrs.logging sentinel file for trace.",
       "")
)

# ── Suppression pattern ──
$suppressPattern = [regex]"gab-lint-ignore:\s*([\w,\s]+)"

# ── File collection ──
if (Test-Path $Path -PathType Container) {
    if ($Recurse) {
        $files = @(Get-ChildItem -Path $Path -Include "*.g2u","*.lib","*.gaf" -File -Recurse)
    } else {
        $files = @(
            Get-ChildItem -Path $Path -Filter "*.g2u" -File
            Get-ChildItem -Path $Path -Filter "*.lib" -File
            Get-ChildItem -Path $Path -Filter "*.gaf" -File
        )
    }
} elseif (Test-Path $Path -PathType Leaf) {
    $files = @(Get-Item $Path)
} else {
    Write-Error "Path not found: $Path"
    exit 2
}

if ($files.Count -eq 0) {
    Write-Host "No .g2u, .lib, or .gaf files found."
    exit 0
}

# ── Lint engine ──
$totalIssues = 0
$allFindings = [System.Collections.ArrayList]::new()

foreach ($file in $files) {
    $lines = [System.IO.File]::ReadAllLines($file.FullName)
    $fileFindings = [System.Collections.ArrayList]::new()

    $inCommentsBlock = $false
    for ($lineNum = 0; $lineNum -lt $lines.Count; $lineNum++) {
        $line = $lines[$lineNum]

        if ($line -match 'Program\.Sub\.Comments\.Start\b') { $inCommentsBlock = $true }
        if ($inCommentsBlock) {
            if ($line -match 'Program\.Sub\.Comments\.End\b') { $inCommentsBlock = $false }
            continue
        }

        # Skip comment lines
        if ($line -match "^\s*'") { continue }
        # Skip metadata lines inside Comments block
        if ($line -match '^\$\{\$') { continue }

        # Check for suppression on previous line
        $suppressedIds = @()
        if ($lineNum -gt 0) {
            $prevLine = $lines[$lineNum - 1]
            $m = $suppressPattern.Match($prevLine)
            if ($m.Success) {
                $suppressedIds = $m.Groups[1].Value -split "[,\s]+" | ForEach-Object { $_.Trim() }
            }
        }

        foreach ($rule in $rules) {
            $ruleId = $rule[0]
            $ruleSev = $rule[1]
            $ruleRegex = $rule[2]
            $ruleMsg = $rule[3]

            # Severity filter
            if ($severityRank[$ruleSev] -gt $minRank) { continue }

            # Suppression check
            if ($suppressedIds -contains $ruleId) { continue }

            if ($line -cmatch $ruleRegex) {
                $finding = [PSCustomObject]@{
                    File     = $file.Name
                    FilePath = $file.FullName
                    Line     = $lineNum + 1
                    Rule     = $ruleId
                    Severity = $ruleSev.ToUpper()
                    Message  = $ruleMsg
                    Code     = $line.Trim()
                }
                [void]$fileFindings.Add($finding)
                [void]$allFindings.Add($finding)
                $totalIssues++
            }
        }

        # C2: Multiline function calls (unbalanced parens on same line)
        if ($severityRank["warning"] -le $minRank -and $suppressedIds -notcontains "C2") {
            if ($line -notmatch 'Program\.Sub\.\w+\.(?:Start|End)\b') {
                $openParen = ([regex]::Matches($line, '\(')).Count
                $closeParen = ([regex]::Matches($line, '\)')).Count
                if ($openParen -gt $closeParen) {
                    $finding = [PSCustomObject]@{
                        File     = $file.Name
                        FilePath = $file.FullName
                        Line     = $lineNum + 1
                        Rule     = "C2"
                        Severity = "WARNING"
                        Message  = "Function call appears to span multiple lines. GAB requires single-line statements."
                        Code     = $line.Trim()
                    }
                    [void]$fileFindings.Add($finding)
                    [void]$allFindings.Add($finding)
                    $totalIssues++
                }
            }
        }
    }

    # ── Context-sensitive checks (not per-line) ──
    $fullText = [System.IO.File]::ReadAllText($file.FullName)

    # G4: Nested Try/Catch in same subroutine (sequential is OK; truly nested is not)
    $subPattern = [regex]'Program\.Sub\.(\w+)\.Start([\s\S]*?)Program\.Sub\.\1\.End'
    foreach ($subMatch in $subPattern.Matches($fullText)) {
        $subName = $subMatch.Groups[1].Value
        $subBody = $subMatch.Groups[2].Value
        $subLines = $subBody -split "`n"
        $tryDepth = 0
        $maxDepth = 0
        foreach ($sl in $subLines) {
            if ($sl -match 'F\.Intrinsic\.Control\.Try\b') { $tryDepth++; if ($tryDepth -gt $maxDepth) { $maxDepth = $tryDepth } }
            if ($sl -match 'F\.Intrinsic\.Control\.EndTry\b') { $tryDepth-- }
        }
        if ($maxDepth -gt 1 -and $severityRank["warning"] -le $minRank) {
            $finding = [PSCustomObject]@{
                File     = $file.Name
                FilePath = $file.FullName
                Line     = 0
                Rule     = "G4"
                Severity = "WARNING"
                Message  = 'Nested Try/Catch detected — valid but use sparingly. Prefer SetErrorHandler for outer structure with targeted Try/Catch for single operations.'
                Code     = "Sub: $subName"
            }
            [void]$fileFindings.Add($finding)
            [void]$allFindings.Add($finding)
            $totalIssues++
        }
    }

    # I24: .gaf files must use key::value format, not INI
    if ($file.Extension -eq ".gaf" -and $severityRank["error"] -le $minRank) {
        if ($fullText -match '\[GAF\]' -or $fullText -match 'ScriptPath=') {
            $finding = [PSCustomObject]@{
                File     = $file.Name
                FilePath = $file.FullName
                Line     = 0
                Rule     = "I24"
                Severity = "ERROR"
                Message  = ".gaf files use key::value format (TRANSID::900000, SCRIPT::path), not INI format ([GAF] or ScriptPath=)."
                Code     = "Invalid .gaf format"
            }
            [void]$fileFindings.Add($finding)
            [void]$allFindings.Add($finding)
            $totalIssues++
        }
    }

    # F4: Blank lines in ScreenSU
    $suMatch = [regex]'Program\.Sub\.ScreenSU\.Start([\s\S]*?)Program\.Sub\.ScreenSU\.End'
    $suM = $suMatch.Match($fullText)
    if ($suM.Success -and $severityRank["convention"] -le $minRank) {
        $suBody = $suM.Groups[1].Value
        if ($suBody -match '\n\s*\n') {
            $finding = [PSCustomObject]@{
                File     = $file.Name
                FilePath = $file.FullName
                Line     = 0
                Rule     = "F4"
                Severity = "CONVENTION"
                Message  = "Blank lines inside ScreenSU block. GAB IDE strips them on save."
                Code     = "ScreenSU block"
            }
            [void]$fileFindings.Add($finding)
            [void]$allFindings.Add($finding)
            $totalIssues++
        }
    }

    # C20: ScreenSU present but no UsePixels in file
    if ($fullText -match 'Program\.Sub\.ScreenSU\.Start' -and $fullText -notmatch '(?i)UsePixels' -and $severityRank["error"] -le $minRank) {
        $finding = [PSCustomObject]@{
            File     = $file.Name
            FilePath = $file.FullName
            Line     = 0
            Rule     = "C20"
            Severity = "ERROR"
            Message  = "Script has ScreenSU but missing F.Intrinsic.UI.UsePixels in Main. All GUI scripts MUST call UsePixels. Twips are banned."
            Code     = "ScreenSU without UsePixels"
        }
        [void]$fileFindings.Add($finding)
        [void]$allFindings.Add($finding)
        $totalIssues++
    }

    if ($Format -eq "text" -and $fileFindings.Count -gt 0) {
        Write-Host ""
        Write-Host "=== $($file.Name) ===" -ForegroundColor Cyan
        foreach ($f in $fileFindings) {
            $color = switch ($f.Severity) {
                "ERROR"      { "Red" }
                "WARNING"    { "Yellow" }
                "CONVENTION" { "DarkGray" }
                default      { "White" }
            }
            Write-Host "  L$($f.Line) [$($f.Severity)] $($f.Rule): $($f.Message)" -ForegroundColor $color
            Write-Host "    > $($f.Code)" -ForegroundColor DarkGray
        }
    }
}

# ── Output ──
if ($Format -eq "json") {
    $allFindings | ConvertTo-Json -Depth 3
} else {
    Write-Host ""
    if ($totalIssues -eq 0) {
        Write-Host "OK - No issues found." -ForegroundColor Green
    } else {
        $errors   = @($allFindings | Where-Object { $_.Severity -eq "ERROR" }).Count
        $warnings = @($allFindings | Where-Object { $_.Severity -eq "WARNING" }).Count
        $conventions = @($allFindings | Where-Object { $_.Severity -eq "CONVENTION" }).Count
        Write-Host "TOTAL: $totalIssues issue(s) -- $errors error(s), $warnings warning(s), $conventions convention(s)" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "Yellow" })
    }
}

exit $(if ($totalIssues -gt 0) { 1 } else { 0 })
