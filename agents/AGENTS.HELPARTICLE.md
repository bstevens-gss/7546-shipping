---
AGENT_TITLE: GSS Help Article Generator
AGENT_DESCRIPTION: Generates Global Shop Solutions help articles as PDF and Word documents from GAB .g2u scripts.
AGENT_USAGE: Load when producing help articles or end-user documentation from GAB scripts.
---

# GSS Help Article Generator

Generate Global Shop Solutions help articles from GAB `.g2u` scripts.
Produces a professional PDF **and** Word document (.docx) with title block,
business use case, solution, custom components, step-by-step walkthrough,
and screen mockup screenshots.

**Trigger:** When user asks to create a help article, help document, documentation
PDF, or knowledge base entry for a GAB script or GSS customization.

> **Cross-reference:** If stakeholder-provided PDFs or DOCX files are involved (e.g., RFQs, spec attachments), follow the extraction protocol in `agents/AGENTS.DOCUMENTS.md` before beginning the article workflow.

---

## Workflow

### Phase 1: Analyze the GAB Script

1. Read the entire `.g2u` file. Extract from each section:
   - **ScreenSU** — all controls: type, position, size, caption, visibility, events, colors, fonts
   - **Preflight** — global variables, included libraries (`.lib`)
   - **Main** — hooks used (`V.Caller.Hook`), entry logic
   - **Subroutines** — purpose, trigger, data flow
   - **SQL queries** — tables read/written, joins, filters
2. Build a mental model of the screen states (initial, per-workcenter-type, dialogs)
3. Identify custom components: tables, libraries, hooks, scripts, menu items

### Phase 2: Create Screen Mockups

Build HTML mockup pages for each distinct screen state. Use the control definitions
from `ScreenSU` to determine layout. Populate grids with **realistic sample data**
(3-5 rows) matching the column schema.

### Phase 3: Generate Screenshots

Use Chrome headless to capture each mockup as a PNG. Delete temporary HTML after.

```powershell
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
# Full screen
& $chrome --headless --disable-gpu --no-sandbox --window-size=1060,780 --screenshot="screenshots/01_name.png" "mockup.html"
# Dialog
& $chrome --headless --disable-gpu --no-sandbox --window-size=420,220 --screenshot="screenshots/04_dialog.png" "mockup_dialog.html"
```

Fallback: `"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"` (same flags).

### Phase 4: Write the Article HTML

Use the article template below. Structure:

1. **Title block** — `{FeatureNumber} - {FeatureTitle}`
2. **Meta line** — `Developed by: {Author}` / `Created on: {Date}` / `Customer: {CustomerName}` / `Contact(s):`
3. **Tags** — "Special Instruction" (yellow) (green)
4. **Business Use Case** — What this feature does for you, in plain language
5. **Solution** — Brief, non-technical description of the feature's behavior
6. **Assumptions** — What you need to have ready before using this feature
7. **Custom Component(s)** — Tables, Libraries, Hooks, Scripts, Menu Items
8. **How to Use** — End-user walkthrough: numbered steps with screenshots showing where to click, what to enter, and what to expect
9. **Technical Reference** — Global variables, DataTables, Subroutine map (optional)
10. **Project Step-by-step** — Developer/implementer walkthrough with screenshots and callouts (appended at end)

**Writing guidelines for "Business Use Case", "Solution", and "Assumptions":**
- Write as if explaining the feature to someone who will use it daily
- Use "you" and "your" — never "the user" or "the customer"
- No technical implementation details (no script names, hook numbers, table names, SQL)
- Focus on what the feature does and why it matters, not how it was built
- "Assumptions" items should be things the end user can verify or act on themselves

**Writing guidelines for "How to Use":**
- Address the reader directly ("you")
- Use imperative verbs: Navigate, Click, Select, Enter, Review, Confirm
- Each step = one action the user performs
- Attach screenshots to the step where the action happens, not after the full sequence
- Describe what the user will **see** after each action (expected result)
- Avoid technical jargon (no GAB script names, hook numbers, or SQL references in this section)

### Phase 5: Convert to PDF and Word Document

#### 5a. Build self-contained HTML

Before converting, create a self-contained HTML with all images embedded as
base64 data URIs. **Also strip CSS that Word misinterprets** (`max-width`,
`padding` on body) and add explicit `width` HTML attributes to `<img>` tags.
Word respects HTML `width` attributes but ignores CSS `max-width`.

```powershell
$htmlPath = "<full-path-to-ARTICLE.html>"
$htmlDir  = Split-Path $htmlPath -Parent
$content  = [System.IO.File]::ReadAllText($htmlPath, [System.Text.Encoding]::UTF8)

# Embed images as base64 data URIs
$content = [regex]::Replace($content, 'src="([^"]+\.png)"', {
    param($m)
    $src = $m.Groups[1].Value
    $fullPath = Join-Path $htmlDir $src
    if (Test-Path $fullPath) {
        $bytes = [System.IO.File]::ReadAllBytes($fullPath)
        $b64   = [Convert]::ToBase64String($bytes)
        return "src=`"data:image/png;base64,$b64`""
    }
    return $m.Value
})

# Strip CSS that Word misinterprets (causes content to overflow margins)
$content = $content -replace 'max-width:\s*7\.5in;\s*', ''
$content = $content -replace 'padding:\s*0\.4in;\s*', ''

# Add explicit width="624" (6.5in * 96dpi) to img tags -- Word
# respects HTML width attributes better than CSS max-width
$content = [regex]::Replace($content, '<img\s', '<img width="624" ')

$tempDir  = Join-Path $env:TEMP "helparticle_$(Get-Random)"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
$tempHtml = Join-Path $tempDir "article.html"
[System.IO.File]::WriteAllText($tempHtml, $content, [System.Text.Encoding]::UTF8)
```

#### 5b. Generate PDF

Use Edge headless to print the self-contained HTML to PDF.

```powershell
$edge    = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$tempPdf = Join-Path $tempDir "article.pdf"
$fileUri = "file:///$($tempHtml -replace '\\','/')"

$pInfo = New-Object System.Diagnostics.ProcessStartInfo
$pInfo.FileName = $edge
$pInfo.Arguments = "--headless --disable-gpu --no-pdf-header-footer --print-to-pdf=`"$tempPdf`" `"$fileUri`""
$pInfo.UseShellExecute = $false
$pInfo.RedirectStandardError = $true
$pInfo.CreateNoWindow = $true

$proc = [System.Diagnostics.Process]::Start($pInfo)
$proc.WaitForExit(60000) | Out-Null
Start-Sleep -Seconds 3

Copy-Item $tempPdf "<full-path-to-ARTICLE.pdf>" -Force
```

Verify PDF exists and is >100KB with images. Set `block_until_ms` to at least
**75000** (75 seconds) because Edge headless can take time with large documents.

Fallback browser: `"C:\Program Files\Google\Chrome\Application\chrome.exe"` (same flags).

#### 5c. Generate Word Document (.docx)

**MANDATORY.** Always produce a Word document alongside the PDF.

Use Microsoft Word COM automation to open the self-contained HTML and save as
`.docx`. Word is installed at `C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE`.

After saving, resize all inline images so they fit within the page margins
(preserving aspect ratio). Word's usable width = PageWidth − LeftMargin − RightMargin.

```powershell
$docxPath = "<full-path-to-ARTICLE.docx>"

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0  # wdAlertsNone

try {
    $doc = $word.Documents.Open($tempHtml, $false, $true)

    # Set explicit 1-inch page margins (72 pts) to override any CSS confusion
    $doc.PageSetup.TopMargin    = 72
    $doc.PageSetup.BottomMargin = 72
    $doc.PageSetup.LeftMargin   = 72
    $doc.PageSetup.RightMargin  = 72

    # Resize images to fit within page margins (preserving aspect ratio)
    $maxWidth = $doc.PageSetup.PageWidth - $doc.PageSetup.LeftMargin - $doc.PageSetup.RightMargin
    foreach ($shape in $doc.InlineShapes) {
        if ($shape.Width -gt $maxWidth -and $shape.Width -gt 0) {
            $ratio        = $maxWidth / $shape.Width
            $shape.Width  = $maxWidth
            $shape.Height = $shape.Height * $ratio
        }
    }

    # wdFormatXMLDocument = 12 (docx format)
    $doc.SaveAs2([ref]$docxPath, [ref]12)
    $doc.Close($false)

    # Pass 2: Reopen saved docx and verify/fix any shapes still oversized
    $doc = $word.Documents.Open($docxPath)
    $maxWidth = $doc.PageSetup.PageWidth - $doc.PageSetup.LeftMargin - $doc.PageSetup.RightMargin
    $changed = $false
    foreach ($shape in $doc.InlineShapes) {
        if ($shape.Width -gt $maxWidth -and $shape.Width -gt 0) {
            $ratio        = $maxWidth / $shape.Width
            $shape.Width  = $maxWidth
            $shape.Height = $shape.Height * $ratio
            $changed      = $true
        }
    }
    if ($changed) { $doc.Save() }
    $doc.Close($false)
} finally {
    $word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
}
```

Set `block_until_ms` to at least **90000** (90 seconds) for the Word COM call.

#### 5d. Cleanup

```powershell
Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
```

#### 5e. Verify

Confirm both files exist and are non-zero:
- `.pdf` should be >100KB
- `.docx` should be >100KB

## Output Structure

```
docs/
├── screenshots/
│   ├── 01_initial_screen.png
│   ├── 02_feature_screen.png
│   └── ...
├── {SCRIPT_NAME}_ARTICLE.html    (source, keep for regeneration)
├── {SCRIPT_NAME}_ARTICLE.pdf     (deliverable - print-ready)
└── {SCRIPT_NAME}_ARTICLE.docx    (deliverable - editable)
```

---

## GAB Script Extraction Patterns

### Controls inventory
Search for `Gui.FormName.controlName.Create(type` to enumerate all controls.

| GAB Type | HTML Element |
|---|---|
| `TextBox` | `<input type="text">` |
| `Label` | `<span>` or `<div>` |
| `Button` | `<button>` |
| `DropDownList` | `<select>` |
| `GsGridControl` | `<table>` with headers from `SetColumnProperty` calls |
| `Timer` | Not visible — omit |

### GAB-to-CSS style mappings

| GAB Property | CSS Equivalent |
|---|---|
| `.Size(w,h)` | `width:{w}px; height:{h}px` |
| `.Position(x,y)` | `left:{x}px; top:{y}px` |
| `.BackColor(65535)` | `background:#ffff00` (Yellow) |
| `.BackColor(65280)` | `background:#00ff00` (Green) |
| `.ForeColor(255)` | `color:#ff0000` (Red) |
| `.ForeColor(16777215)` | `color:#ffffff` (White) |
| `.BackColor(-2147483635)` | `background:#404040` (System dark) |
| `.FontSize(14)` | `font-size:14px` |
| `.Visible(False)` | omit from that mockup |
| `.Dock(2)` | fill bottom area |

### GAB BackColor/ForeColor Reference

GAB stores colors as BGR: `B*65536 + G*256 + R`

| GAB Integer | Hex | Color |
|---|---|---|
| `255` | `#ff0000` | Red |
| `65280` | `#00ff00` | Green |
| `65535` | `#ffff00` | Yellow |
| `16711680` | `#0000ff` | Blue |
| `16777215` | `#ffffff` | White |
| `0` | `#000000` | Black |
| `-2147483635` | `#404040` | System dark (approx.) |
| `-2147483633` | `#f0f0f0` | System light (approx.) |

### Hook identification
Search for `V.Caller.Hook` and `F.Intrinsic.Control.Case({hookNumber})`.

### Table identification
- `Program.External.Include.Library` — `.lib` files
- `F.Data.DataTable.CreateFromSQL("{name}"` — SQL-backed tables
- `F.Data.DataTable.Create("{name}"` — manual tables
- `GCG_` prefix in SQL queries — custom tables

### Subroutine inventory
Search for `Program.Sub.{name}.Start` / `Program.Sub.{name}.End` blocks.

---

## Article HTML Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>{FeatureNumber} - {FeatureTitle}</title>
<style>
  @page { size: letter; margin: 0.6in 0.75in; }
  body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    font-size: 10.5pt; line-height: 1.55; color: #222;
    max-width: 7.5in; margin: 0 auto; padding: 0.4in;
  }
  .article-title { font-size: 22pt; font-weight: 700; color: #1a3a5c; margin: 0 0 4px 0; }
  .article-meta { font-size: 9.5pt; color: #666; margin-bottom: 12px; }
  .tags { margin-bottom: 16px; }
  .tag { display: inline-block; font-size: 9pt; font-weight: 600;
         padding: 2px 10px; border-radius: 3px; margin-right: 6px; }
  .tag-special { background: #fff3cd; color: #856404; border: 1px solid #ffc107; }
  .tag-customer { background: #d4edda; color: #155724; border: 1px solid #28a745; }
  h2 { font-size: 14pt; color: #1a3a5c; border-bottom: 2px solid #1a3a5c;
       padding-bottom: 3px; margin: 26px 0 10px 0; page-break-after: avoid; }
  h3 { font-size: 12pt; color: #2c5f8a; margin: 16px 0 6px 0; page-break-after: avoid; }
  h4 { font-size: 11pt; color: #333; margin: 12px 0 4px 0; page-break-after: avoid; }
  p { margin: 0 0 8px 0; }
  ul, ol { margin: 4px 0 10px 20px; }
  li { margin-bottom: 4px; }
  code { font-family: 'Consolas', 'Courier New', monospace; font-size: 9.5pt;
         background: #f0f4f8; padding: 1px 4px; border-radius: 3px; color: #c7254e; }
  pre { background: #f0f4f8; border: 1px solid #d0d8e0; border-radius: 4px;
        padding: 8px 12px; font-family: 'Consolas', monospace; font-size: 9.5pt;
        page-break-inside: avoid; overflow-x: auto; margin: 6px 0 12px 0; }
  table { width: 100%; border-collapse: collapse; margin: 8px 0 14px 0;
          font-size: 10pt; page-break-inside: avoid; }
  th { background: #1a3a5c; color: #fff; padding: 5px 8px;
       text-align: left; font-weight: 600; }
  td { padding: 4px 8px; border: 1px solid #d0d8e0; vertical-align: top; }
  tr:nth-child(even) td { background: #f7f9fb; }
  .component-table td:first-child { font-weight: 600; width: 140px; }
  .screenshot { margin: 12px 0 16px 0; text-align: center; page-break-inside: avoid; }
  .screenshot img { max-width: 100%; border: 1px solid #ccc;
                    box-shadow: 1px 1px 4px rgba(0,0,0,.15); }
  .screenshot .caption { font-size: 9pt; color: #666; font-style: italic; margin-top: 4px; }
  .callout { border-left: 4px solid #1a3a5c; background: #f0f4f8;
             padding: 8px 14px; margin: 8px 0 12px 0; page-break-inside: avoid; }
  .callout-warn { border-left-color: #ffc107; background: #fff8e1; }
  .page-break { page-break-before: always; }
  strong { color: #1a3a5c; }
  hr { border: none; border-top: 1px solid #ccc; margin: 20px 0; }
</style>
</head>
<body>

<!-- TITLE BLOCK -->
<div class="article-title">{FeatureNumber} {FeatureTitle}</div>
<div class="article-meta">
  Developed by: {Author}<br>
  Created on: {Date}<br>
  Customer: {CustomerName}<br>
  Contact(s):
</div>
<div class="tags">
  <span class="tag tag-special">Special Instruction</span>
  <span class="tag tag-customer"></span>
</div>

<h2>Business Use Case</h2>
<p>{What does this feature do for you? Describe the benefit in plain language — e.g., "This feature allows you to track labor hours by workcenter type directly from the shop floor screen."}</p>

<h2>Solution</h2>
<p>{Brief, non-technical description of the feature's behavior — e.g., "When you open the screen and select a workcenter type, the system automatically loads the relevant jobs and displays labor details in a grid. You can review, edit, and save entries before closing."}</p>

<h2>Assumptions</h2>
<ul>
  <li>{Prerequisite — e.g., "You must have access to the Inventory module."}</li>
  <li>{Prerequisite — e.g., "Workcenter types must already be configured by your administrator."}</li>
</ul>

<h2>Custom Component(s)</h2>

<h3>Table(s)</h3>
<table class="component-table">
  <tr><th>Table</th><th>Purpose</th></tr>
  <tr><td><code>{TableName}</code></td><td>{Purpose}</td></tr>
</table>

<h3>Library File(s)</h3>
<table class="component-table">
  <tr><th>Library</th><th>Purpose</th></tr>
  <tr><td><code>{LibName}</code></td><td>{Purpose}</td></tr>
</table>

<h3>Hook(s)</h3>
<table>
  <tr><th>Hook</th><th>Script</th><th>Description</th></tr>
  <tr><td>{HookNumber}</td><td><code>{ScriptName}</code></td><td>{Description}</td></tr>
</table>

<h3>GAB Script(s)</h3>
<table class="component-table">
  <tr><th>Script</th><th>Purpose</th></tr>
  <tr><td><code>{ScriptName}</code></td><td>{Purpose}</td></tr>
</table>

<!-- Menu Items (if applicable)
<h3>Menu Item(s)</h3>
<table class="component-table">
  <tr><th>Menu Path</th><th>Purpose</th></tr>
  <tr><td>{Module > File > Name [Feature#]}</td><td>{Purpose}</td></tr>
</table>
-->

<hr>

<h2>How to Use</h2>

<h3>{Section Title}</h3>
<ol>
  <li>
    <p>{Step instruction — e.g., "Navigate to Inventory &gt; Transactions &gt; Adjustments."}</p>
  </li>
  <li>
    <p>{Step instruction — e.g., "Select a workcenter type from the dropdown."}</p>
    <div class="screenshot">
      <img src="screenshots/{filename}.png" alt="{Alt text}">
      <div class="caption">Figure {N}: {Caption}.</div>
    </div>
  </li>
  <li>
    <p>{Step instruction — e.g., "Click <strong>Save</strong> to apply your changes."}</p>
  </li>
</ol>

<div class="callout"><strong>Tip:</strong> {Helpful tip for the end user.}</div>
<div class="callout callout-warn"><strong>Important:</strong> {Something the user must be aware of before proceeding.}</div>

<div class="page-break"></div>

<!-- TECHNICAL REFERENCE (optional) -->
<h3>Global Variables</h3>
<table>
  <tr><th>Variable</th><th>Type</th><th>Purpose</th></tr>
  <tr><td><code>{VarName}</code></td><td>{Type}</td><td>{Purpose}</td></tr>
</table>

<h3>DataTables</h3>
<table>
  <tr><th>DataTable</th><th>Used By</th><th>Description</th></tr>
  <tr><td><code>{DTName}</code></td><td>{Context}</td><td>{Description}</td></tr>
</table>

<h3>Subroutine Map</h3>
<table>
  <tr><th>Subroutine</th><th>Trigger</th><th>Description</th></tr>
  <tr><td><code>{SubName}</code></td><td>{Trigger}</td><td>{Description}</td></tr>
</table>

<div class="page-break"></div>

<!-- PROJECT STEP-BY-STEP (developer/implementer reference) -->
<h2>Project Step-by-step</h2>

<h3>{Section Title}</h3>
<p>{Explanation}</p>

<div class="screenshot">
  <img src="screenshots/{filename}.png" alt="{Alt text}">
  <div class="caption">Figure {N}: {Caption}.</div>
</div>

<div class="callout"><strong>Note:</strong> {Important note.}</div>
<div class="callout callout-warn"><strong>Warning:</strong> {Warning text.}</div>

</body>
</html>
```

---

## Mockup Window Template

```html
<!DOCTYPE html>
<html><head><meta charset="UTF-8">
<style>
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family: Tahoma, sans-serif; background: #e8e8e8; }
  .window { width:1024px; background:#f0f0f0; border:1px solid #888;
            box-shadow: 2px 2px 8px rgba(0,0,0,.3); }
  .titlebar { background: linear-gradient(to bottom, #3b7dd8, #245bab);
              color:#fff; font-size:12px; padding:4px 8px;
              display:flex; justify-content:space-between; align-items:center; }
  .titlebar .buttons { display:flex; gap:2px; }
  .titlebar .btn { width:28px; height:20px; background:#c0c0c0; border:1px solid #888;
                   text-align:center; font-size:11px; line-height:18px; color:#333; }
  .content { padding:0; min-height:700px; background:#f0f0f0; position:relative; }
  .lbl { font-size:14px; color:#000; }
  .ddl { font-size:14px; padding:4px; width:261px; height:30px; border:1px solid #aaa; background:#fff; }
  .txt { font-size:14px; padding:4px; width:261px; height:30px; border:1px solid #aaa; background:#fff; }
  .txt-locked { font-size:14px; padding:4px; width:261px; height:30px; border:1px solid #aaa; background:#f4f4f4; }
  table.grid { width:100%; border-collapse:collapse; font-size:12px; }
  table.grid th { background:#e8e8e8; border:1px solid #ccc; padding:4px 6px;
                  font-weight:600; text-align:left; color:#333; white-space:nowrap; }
  table.grid td { border:1px solid #ddd; padding:3px 6px; white-space:nowrap; }
  table.grid tr:nth-child(even) { background:#f8f8f8; }
  .docs-btn { background:#d0d0d0; border:1px solid #aaa; padding:1px 8px; font-size:11px; }
  .chk { width:16px; height:16px; }
</style></head><body>
<div class="window">
  <div class="titlebar">
    <span>{Form Caption}</span>
    <div class="buttons"><div class="btn">_</div><div class="btn">☐</div><div class="btn">✕</div></div>
  </div>
  <div class="content">
    <!-- Replicate visible controls here with sample data -->
  </div>
</div>
</body></html>
```

## MsgBox Dialog Template

```html
<!DOCTYPE html>
<html><head><meta charset="UTF-8">
<style>
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family: Tahoma, sans-serif; background: #e8e8e8;
         display:flex; align-items:center; justify-content:center; min-height:200px; }
  .msgbox { width:380px; background:#f0f0f0; border:2px solid #888;
            box-shadow: 3px 3px 10px rgba(0,0,0,.35); }
  .msgbox-title { background: linear-gradient(to bottom, #3b7dd8, #245bab);
                  color:#fff; font-size:12px; padding:4px 8px; }
  .msgbox-body { padding:20px 16px 12px; font-size:13px; color:#000; text-align:center; }
  .msgbox-buttons { display:flex; justify-content:center; gap:12px; padding:8px 16px 16px; }
  .msgbox-btn { font-size:12px; padding:4px 24px; border:1px solid #888;
                background:#e0e0e0; min-width:80px; }
</style></head><body>
<div class="msgbox">
  <div class="msgbox-title">{Dialog Title}</div>
  <div class="msgbox-body">{Message text}</div>
  <div class="msgbox-buttons">
    <button class="msgbox-btn">Yes</button>
    <button class="msgbox-btn">No</button>
  </div>
</div>
</body></html>
```
