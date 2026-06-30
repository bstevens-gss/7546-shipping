# GAB Additional API Surface Reference (Part 1 of 2)
# Sub-agent of agents/AGENTS.GAB.md -- read when working with Automation.*, Communication.*, Global.* through Global.WebService
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

# ADDITIONAL API SURFACE

The following sections document API namespaces and methods not covered in the curated reference files. Where a namespace appears in both this file and the curated files (`API_HTTP.md`, `API_AUTOMATION.md`, `API_PRINTER.md`), the curated file is authoritative; this section provides additional methods only. Some descriptions may be truncated -- do not assume truncated text or hallucinate completions.

---

## Automation.Capture
```
F.Automation.Capture.AcquireImage( )  ' This command starts the scanning process from the source displaying the sourc...
F.Automation.Capture.Camera(filename)  ' We will be using this in conjunction with our biometric shop floor offering. ...
F.Automation.Capture.CapGet(Return Variable[Long])  ' This command returns the capability specified by the Capability property.
F.Automation.Capture.CapGet(Return Variable[String])  ' Returns a delimited(*!*) string of all the detected sources. Note: Windows-De...
F.Automation.Capture.CapGetCurrent(Return Variable[Long])  ' This command returns the current value of the specified capability for the so...
F.Automation.Capture.CapGetDefault(Return Variable[Long])  ' Returns the default value of the specified capability for the source.
F.Automation.Capture.CapGetFrame(Image Index [long], Return Variable[Long])  ' This command returns the value of the specified frame
F.Automation.Capture.CapIfSupported(Message Type [string], Return Variable [boolean])  ' Returns if the source supports a particular operation of the capability.
F.Automation.Capture.CapReset()  ' This command Resets the current Capability.
F.Automation.Capture.CapSet()  ' This command sets the detailed information of the current Capability
F.Automation.Capture.CapSetFrame(image index [long], left margin [long], top margin [long], right margin [long], bottom margin [long])  ' This command sets the values of the specified frame.
F.Automation.Capture.CloseSource()  ' This command Closes data source.
F.Automation.Capture.Crop(image index [long], left margin [long], top margin [long], right margin [long], bottom margin [long])  ' Crops the image of specified index in buffer
F.Automation.Capture.DisableSource()  ' Disables the source. If the source's user interface is displayed when the sou...
F.Automation.Capture.EnableSource()  ' Enables the source, which means start the scanning process
F.Automation.Capture.EnableSourceUI()  ' Displays the user interface of the source to change and save the settings for...
F.Automation.Capture.FeedPage()  ' Ejects the current page and begins scanning the next page in the document fee...
F.Automation.Capture.Flip(image index [long])  ' Flips the image of a specified index in the buffer
F.Automation.Capture.GetBarCodeText(BarCode Index, Return variable)  ' Gets Barcode content by specified index
F.Automation.Capture.GetCapItems(Index, Return Variable)  ' Returns capability property value
F.Automation.Capture.GetCapItemsString(Index, Return variable)  ' Returns capability property value as string
F.Automation.Capture.GetDefaultImageLayout(Return Variable[String])  ' Returns a delimited(*!*) string containing the left, top, right, bottom margi...
F.Automation.Capture.GetImageCoreProperty(Property Name, Return variable)  ' Returns the value of the property specified.
F.Automation.Capture.GetPDFCreatorProperty(Property Name, Return Variable)  ' Returns value of the specified property
F.Automation.Capture.GetTwainManagerProperty(Twain Manager Property[string], Return Variable[any])  ' Returns the value of a specified Twain Manager property.
F.Automation.Capture.GrayScale(Image Index)  ' Converts an image to a gray scale
F.Automation.Capture.Invert(Image Index)  ' Inverts the color of the specified image
F.Automation.Capture.IsBlankImage(Image Index, Return)  ' Checks whether the image is blank
F.Automation.Capture.LoadCustomData(File Name (FQP) [String])  ' Loads the configurations of the source's users interface by SaveCustomDSData.
F.Automation.Capture.LoadCustomDSData(FileName)  ' Loads the configurations of the sources users interface saved by SaveCustomDS...
F.Automation.Capture.Mirror(Image Index)  ' Returns the image of a specified index in the buffer
F.Automation.Capture.MoveImage(Source Image Index, Target Image Index)  ' Moves a specified image
F.Automation.Capture.OpenSource()  ' Loads the currently selected source into main memory and initializes it for i...
F.Automation.Capture.OpenSourceManager()  ' Loads and opens Data Source Manager.
F.Automation.Capture.RemoveAllImages()  ' Removes all the images from the buffer
F.Automation.Capture.RemoveImage(Image Index)  ' Removes the image of a specified index in buffer
F.Automation.Capture.ResetImageLayout()  ' Resets the image layout in the Data Source to default.
F.Automation.Capture.RewindPage()  ' If 'IfFeederEnabled' is true, the source will return the current page to the ...
F.Automation.Capture.Rotate(Image Index, Angle, Keep Size, Interpolation)  ' Rotates the image of a specified index in buffer by specified angle.
F.Automation.Capture.RotateLeft(Image Index)  ' Rotates the image of a specified index in buffer by 90 degrees clockwise to the
F.Automation.Capture.RotateRight(Image Index)  ' Rotates the image of a specified index in buffer by 90 degrees clockwise to the
F.Automation.Capture.SaveImageInBuffer(File Path, File Type)  ' Saves the Image to buffer
F.Automation.Capture.SelectSource()  ' Opens a browser UI containing all detected sources from which the user may se...
F.Automation.Capture.SetCapItems(Index , Value)  ' Sets capability property value
F.Automation.Capture.SetFileXferInfo(file name (FQP) [string], File Format [string])  ' This command sets the File Format.
F.Automation.Capture.SetImageCoreProperty(Index, Value)  ' Sets the value of specified image core property
F.Automation.Capture.SetImageLayout(left margin [long], top margin [long], right margin [long], bottom margin [long])  ' Sets the left, top, right, and bottom sides of the image layout rectangle for...
F.Automation.Capture.SetPDFCreatorProperty(Index, Value)  ' Sets the value of specfied PDF creator property
F.Automation.Capture.SetTwainManagerProperty(Twain Manager Property [string], property value [any])  ' Sets the specified Twain Manager property to the value given.
F.Automation.Capture.SourceExists(source name [string], return variable [boolean])  ' Returns if the given source is a valid detected source.
F.Automation.Capture.SwitchImage(Image Index 1, Image Index 2)  ' Switches two images of specified indices in buffer.
```

## Automation.Generic
```
F.Automation.Generic.LoadAssembly(AssemblyAlias, FullPath)  ' Loads a .NET DLL assembly by alias and fully qualified path
F.Automation.Generic.CreateObject(AssemblyAlias, Namespace.ClassName, InstanceName)  ' Instantiates a class from a loaded assembly
F.Automation.Generic.CallMethod(Object Name, Method, Args)  ' Calls a void method on a .NET object; args are *!*-delimited
F.Automation.Generic.CallMethodReturnVariable(Object Name, Method, Args, Return)  ' Calls a method and stores the return value
F.Automation.Generic.CallMethodReturnObject(ObjectName, ReturnObject, MethodName, Args)  ' Invokes method and saves return value in the specified object; Args are *!*-delimited
F.Automation.Generic.DestroyObject(InstanceName)  ' Releases a .NET object instance created by CreateObject
F.Automation.Generic.CheckPresence(Object Type, Return Boolean)  ' Checks registered classes to determine if object is present on the client com...
F.Automation.Generic.GetProperty(Object Name, Property, String Return Variable)  ' Gets the Data Type of a given property from an object.
F.Automation.Generic.GetPropertyReturnObject(Object Name, Return Object, Property Name, Options Args)  ' Gets the value of the property and stores it in the object instance specified
F.Automation.Generic.LetProperty(Object Name, Property, Value)  ' Sets the Data Type of a property from an object.
F.Automation.Generic.SetProperty(Object Name, Property, Value, Target Object)  ' Sets a property from a source object and sets its Data Type within a target o...
```

## Automation.Graphviz
```
F.Automation.Graphviz.AddNode(GraphName, NodeName)  ' Adds node(s) to graph; both String. Variadic: AddNode("g","n1","n2","n3")
F.Automation.Graphviz.AddRelation(GraphName, SourceNode, TargetNode, [SourceChild], [TargetChild], [Edge properties...])  ' Adds edge; all String. Append * to GraphName for shared edge props
F.Automation.Graphviz.Create(GraphName)  ' Creates a new graph; GraphName as String
F.Automation.Graphviz.Delete(GraphName)  ' Deletes a graph; GraphName as String
F.Automation.Graphviz.DeleteNode(GraphName, NodeName)  ' Deletes node and its relations; both String
F.Automation.Graphviz.DeleteRelation(GraphName, SourceNode, TargetNode, [SourceChild], [TargetChild])  ' Deletes a relation; all String, SourceChild/TargetChild optional
F.Automation.Graphviz.NodeExists(GraphName, NodeName, ReturnVariable)  ' Checks node existence; GraphName/NodeName as String, ReturnVariable as Boolean
F.Automation.Graphviz.OverridePath(FQN)  ' Overrides Graphviz install path; FQN as String (fully qualified path)
F.Automation.Graphviz.Render(GraphName, FQN)  ' Renders graph to image (png/jpg); GraphName as String, FQN as String (output path)
F.Automation.Graphviz.SetNodeProperties(GraphName, NodeName, [properties...])  ' Sets node properties; append * to GraphName for all-node override
F.Automation.Graphviz.SetProperties(GraphName, GraphType, [properties...])  ' Sets graph properties; GraphName/GraphType as String
```

### AddRelation Edge Properties (positional, after TargetChild)
All optional, entered in sequence. Use empty args (,,) to skip:
```
' Minimal relation
F.Automation.Graphviz.AddRelation("samplegraph","node1","node2")
' With label (skip SourceChild, TargetChild, AllEdges, Edgedir)
F.Automation.Graphviz.AddRelation("samplegraph*","node1","node2",,,,"same edge label")
```

| Position | Property | Type | Description |
|----------|----------|------|-------------|
| 1 | AllEdges | Boolean | When True, all edges from this node share these properties |
| 2 | Edgedir | Edgedir enum | Edge direction: `forward`, `back`, `both`, `none` |
| 3 | Label | String | Edge label text |
| 4 | EdgeStyle | EdgeStyle enum | `bold`, `dashed`, `dotted`, `invis`, `solid`, `none` |
| 5 | Color | Color | Edge color (e.g. `V.Color.Blue`) |
| 6 | HeadLabel | String | Label at arrowhead |
| 7 | TailLabel | String | Label at arrow tail |
| 8 | LabelDistance | Double | Distance of label from edge |
| 9 | FontColor | Color | Label font color |
| 10 | FontName | String | Label font name |
| 11 | FontSize | Double | Label font size |
| 12 | Arrowhead | ArrowStyle enum | Arrowhead style |
| 13 | ArrowTail | ArrowStyle enum | Arrow tail style |
| 14 | ArrowSize | Double | Arrow size |
| 15 | Weight | Double | Edge weight (heavier = shorter/straighter/more vertical) |
| 16 | Headport | Port enum | Where head attaches to node |
| 17 | Tailport | Port enum | Where tail attaches to node |
| 18 | Lhead | String (NodeName) | For clusters: clip head to cluster boundary |
| 19 | Ltail | String (NodeName) | For clusters: clip tail to cluster boundary |

### SetProperties Graph Properties (positional, after GraphType)
All optional, entered in sequence. Use empty args (,,) to skip:
```
F.Automation.Graphviz.SetProperties("sampleGraph","FLOWCHART")
F.Automation.Graphviz.Render("sampleGraph","C:\Users\Desktop\Samplegraph.png")
```

| Position | Property | Type | Description |
|----------|----------|------|-------------|
| 1 | Label | String | Graph label |
| 2 | Direction | Direction enum | Graph direction: `TB`, `LR`, `BT`, `RL` |
| 3 | Labeljust | Labeljustification enum | Label justification |
| 4 | Labellocation | LabelLocation enum | Label location: `bottom`, `top` |
| 5 | Center | Boolean | When True, graph is centered in output |
| 6 | FontName | String | Graph label font |
| 7 | FontSize | Double | Graph label font size |
| 8 | FontColor | Color | Graph label color |
| 9 | Bgcolor | Color | Background color |
| 10 | Spline | Spline enum | Edge routing: `curved`, `line`, `none`, `ortho`, `polyline`, `spline` |
| 11 | Nodeseparation | Double | Min space between adjacent nodes in same rank |
| 12 | Rankseparation | Double | Vertical distance between levels |
| 13 | Compound | Boolean | For clusters: allows edges between clusters |
| 14 | Orientation | Orientation enum | `Landscape`, `Portrait` |
| 15 | Width | Double | Drawing width |
| 16 | Height | Double | Drawing height |
| 17 | Penwidth | Double | Pen width for lines/curves/boundaries |
| 18 | Margin | Double | Empty space around drawing |
| 19 | Rotation | Double | Counter-clockwise rotation in degrees |

### SetNodeProperties Node Properties (positional, after NodeName)
All optional, entered in sequence. Append `*` to GraphName to apply to all nodes:
```
' Apply same label to all nodes matching pattern
F.Automation.Graphviz.SetNodeProperties("samplegraph*","node1","same label- node1,node3")
' Apply different label to specific node
F.Automation.Graphviz.SetNodeProperties("samplegraph","node2","different label -node2")
```

| Position | Property | Type | Description |
|----------|----------|------|-------------|
| 1 | Label | String | Node label |
| 2 | Children | String (`*!*`-delimited) | Children (cluster/table graphs only) |
| 3 | FontName | String | Label font |
| 4 | FontSize | Double | Label font size |
| 5 | FontColor | Color | Label font color |
| 6 | Labeljustify | Boolean | Label justification |
| 7 | Shape | Shape enum | Node shape |
| 8 | Sides | Integer | Number of sides (when Shape=polygon) |
| 9 | NodeColor | Color | Node shape color |
| 10 | Style | NodeStyle enum | Node style (e.g. `NodeStyle.filled`) |
| 11 | Penwidth | Double | Pen width for boundaries |
| 12 | FillColor | Color | Fill color (requires Style=filled) |
| 13 | ImagePath | String | FQN of image file |
| 14 | ImageScale | ImageScale enum | How image fills node |
| 15 | FixedSize | FixedSize enum | `yes`=use Width/Height only, `no`=auto-size, `shape`=shape-based |
| 16 | Height | Double | Node height |
| 17 | Width | Double | Node width |
| 18 | Skew | Double | Skew factor (Shape=polygon); positive=right, negative=left |
| 19 | Peripheries | Integer | Number of node boundaries |
| 20 | Distortion | Double | Distortion factor (Shape=polygon); positive=top larger |

### Graphviz Enums
| Enum | Values |
|------|--------|
| GraphType | `FLOWCHART`, `CIRCLE`, `CLUSTER`, `ER`, `ORG`, `TABLE` |
| Direction | `TB`, `LR`, `BT`, `RL` |
| Orientation | `Landscape`, `Portrait` |
| Spline | `curved`, `line`, `none`, `ortho`, `polyline`, `spline` |
| LabelLocation | `bottom`, `top` |
| Labeljustification | `left`, `right`, `centered` |
| Port | `n`, `ne`, `e`, `se`, `s`, `sw`, `w`, `nw`, `center` |
| EdgeStyle | `bold`, `dashed`, `dotted`, `invis`, `solid`, `none` |
| Edgedir | `forward`, `back`, `both`, `none` |
| ArrowStyle | `box`, `curve`, `crow`, `dot`, `diamond`, `icurve`, `inv`, `none`, `normal`, `tee`, `vee` + l/r/o prefixed variants (e.g. `lbox`, `rbox`, `obox`, `olbox`, `orbox`) |
| Shape | `assembly`, `box`, `box3d`, `circle`, `component`, `cds`, `cylinder`, `diamond`, `doublecircle`, `doubleoctagon`, `egg`, `ellipse`, `folder`, `hexagon`, `house`, `invhouse`, `invtrapezium`, `invtriangle`, `larrow`, `Mcircle`, `Mdiamond`, `Mrecord`, `Msquare`, `none`, `note`, `octagon`, `oval`, `parallelogram`, `pentagon`, `plain`, `plaintext`, `point`, `polygon`, `record`, `rectangle`, `rpromoter`, `septagon`, `square`, `star`, `tab`, `trapezium`, `triangle`, `tripleoctagon`, `underline` |
| NodeStyle | `bold`, `dashed`, `diagonals`, `dotted`, `filled`, `invis`, `rounded`, `solid`, `none` |
| ImageScale | `yes`, `no`, `width`, `height`, `both` |
| FixedSize | `yes`, `no`, `shape` |

## Automation.GroupWare
```
F.Automation.GroupWare.AddLDIFentry(FirstName, LastName, FullName, Email, WorkPhone, HomePhone, Fax, Pager, Mobile, Street, City, State, PostalCode, Country, JobTitle, Department)  ' All 16 params String; only first 3 need values, rest can be ""
F.Automation.GroupWare.WriteLDIF(Filename)  ' Writes RFC 2849-compliant LDIF file from AddLDIFentry calls; Filename as String
F.Automation.Groupware.CreatevCard(ContactName, CompanyName, ContactTitle, WorkPhone, CellPhone, Addr1, Addr2, Addr3, City, State, Zip, Email, Filename)  ' All 13 params String; use .VCF extension
F.Automation.Groupware.CreateiCalEvent(Filename, Summary, Description, StartDateTime, EndDateTime, TimeZone, [Attendees], [Priority], [Status], [Sequence], [Class], [Location], [Organizer], [Category], [Action], [Trigger], [AlarmDesc], [Rule])
F.Automation.Groupware.CreateiCalToDo(Filename, Summary, Description, StartDateTime, EndDateTime, TimeZone, [Attendees], [Priority], [Status], [Sequence], [Class], [Location], [Organizer], [Category], [Action], [Trigger], [AlarmDesc], [Rule])
```

### LDIF Workflow
Call `AddLDIFentry` once per contact, then call `WriteLDIF` to write the file. LDIF is a portable address book format importable into Outlook, Thunderbird, PIMs, smartphones.

### CreateiCalEvent / CreateiCalToDo
Three overload forms (identical for both Event and ToDo):
1. **6 params** -- `(Filename, Summary, Description, StartDateTime, EndDateTime, TimeZone)` -- minimal
2. **7 params** -- adds `Attendees` (String, `*!*`-delimited emails)
3. **17 params** -- full with all optional scheduling properties

| Param | Type | Description |
|-------|------|-------------|
| Filename | String | Output .ics file path |
| Summary | String | Event/task title |
| Description | String | Event/task body |
| StartDateTime | Date | Start date/time |
| EndDateTime | Date | End date/time |
| TimeZone | String | `CENTRAL`, `MOUNTAIN`, `EASTERN`, or `PACIFIC` |
| Attendees | String | `*!*`-delimited mailto: addresses |
| Priority | Long | Priority level (e.g. 5) |
| Status | String | e.g. `NEEDS-ACTION`, `CONFIRMED`, `TENTATIVE` |
| Sequence | Long | Sequence number (0 for new) |
| Class | String | e.g. `PUBLIC`, `PRIVATE` |
| Location | String | Event location |
| Organizer | String | mailto: address |
| Category | Long | Category ID (e.g. `PERSONAL`) |
| Action | String | Alarm action (e.g. `DISPLAY`) |
| Trigger | String | Alarm trigger (e.g. `-PT15M` for 15 min before) |
| AlarmDesc | String | Alarm description (e.g. `Reminder`) |
| Rule | String | Recurrence rule (e.g. `FREQ=WEEKLY;COUNT=5;INTERVAL=1;BYDAY=WE`) |

```
' Minimal event
F.Automation.Groupware.CreateiCalEvent("C:\myevent.ics","Rock Band","Rock Band night",V.Local.dateStart,V.Local.dateEnd,"CENTRAL",V.Local.sAttendees)

' Full event with alarm and recurrence
F.Automation.Groupware.CreateiCalEvent("C:\myevent.ics","Rock Band","Rock Band night",V.Local.dateStart,V.Local.dateEnd,"CENTRAL",V.Local.sAttendees,5,"NEEDS-ACTION",0,"PUBLIC","OFFICE","mailto:jdavis@gssmail.com","PERSONAL","DISPLAY","-PT15M","Reminder","")
```

### CreatevCard
All 13 params are String. Use `.VCF` file extension. Works well with `F.Global.Messaging.CreateEMMessage` for email attachments.

## Automation.HubSpot
Requires OCTSRS.Net.EXE 2019.1+.
```
F.Automation.HubSpot.SetLoginInfo(ClientID, ClientSecret, InitiateOAuth)  ' Sets OAuth credentials; all String. InitiateOAuth: OFF|GETANDREFRESH|REFRESH
F.Automation.HubSpot.SetConnectionString  ' Builds connection string from base + login info (no params)
F.Automation.HubSpot.SetBaseConnectionString(ConnectionString)  ' Sets base connection string; ConnectionString as String
F.Automation.HubSpot.SelectToDatatable(DataTableName, Global, Query)  ' Fills DataTable from query; DataTableName as String, Global as Boolean, Query as String
F.Automation.HubSpot.ExecuteSQL(Query, [Parameters])  ' Executes SQL/stored proc; Query as String, Parameters as String (optional)
F.Automation.HubSpot.ExecuteSQLReturnID(SQLCommand, IDReturn)  ' Executes SQL and returns inserted ID; both String. Parameterized overload available
```

### HubSpot Connection Workflow
```
' 1. Set OAuth credentials
F.Automation.HubSpot.SetLoginInfo("12345678-00fc-4e38-9959-f23297ad919e","a5b77af3f-bac1-470b-93d4-5ddcc5d64190","GETANDREFRESH;")
' 2. Build connection string
F.Automation.HubSpot.SetConnectionString
' 3. Query or execute
F.Automation.HubSpot.SelectToDatatable("HubSpotData","True","SELECT top 10 * FROM Contacts")
F.Automation.HubSpot.ExecuteSQL("UPDATE Contacts SET City = 'Dallas' WHERE VID = 1")
```

### ExecuteSQLReturnID Overloads
```
' Simple
F.Automation.HubSpot.ExecuteSQLReturnID("INSERT INTO table VALUES('Val1','Val2')", V.Local.sReturnID)
' Parameterized (param0..paramN name/value pairs before IDReturn)
F.Automation.HubSpot.ExecuteSQLReturnID("INSERT INTO table VALUES(@p0,@p1)", "@p0","Val1","@p1","Val2", V.Local.sReturnID)
```

### InitiateOAuth Values
| Value | Description |
|-------|-------------|
| `OFF` | Default; no OAuth initiation |
| `GETANDREFRESH` | Obtain and auto-refresh OAuth token on connect |
| `REFRESH` | Refresh existing OAuth token only |

## Automation.MSAccess
```
F.Automation.MSAccess.CheckPresence(Return Boolean)
F.Automation.MSAccess.CompactDB(Source DB Path, Target DB Path)
```

## Automation.MSExcel
```
F.Automation.MSExcel.CheckPresence(ReturnVariable [Boolean])  ' Returns a boolean to state if MSExcel is on the machine
F.Automation.MSExcel.CopyCellFormat(source worksheet object, target worksheet object, starting column number, starting row number, ending column number, ending row number, target starting column number, target starting row number, ignore errors boolean)  ' This function copies the formatting block in the source worksheet to the spec...
F.Automation.MSExcel.CreateAppObject(Object Name[String])  ' Creates the Application Object for Excel.
F.Automation.MSExcel.CreateWorkbook(App Object Name [String], Workbook Object Name [String], File Path [String])  ' Creates a workbook and workbook object for Excel.
F.Automation.MSExcel.CreateWorksheet(Workbook Object Name [String], Worksheet Object Name [String], Sheet Name [String])  ' Creates a worksheet and worksheet object for Excel.
F.Automation.MSExcel.DestroyAllObjects(App Object Name [String], WorkBook Object Name [String], WorkSheet Object Name [String])  ' Destroys the application, workbook, and worksheet objects that have been crea...
F.Automation.MSExcel.EnumerateWorksheets(workbook object Name [String],Return Variable [string])
F.Automation.MSExcel.FormatCell(Worksheet objectName[String], Row[Long], Column[Long], Value [String])  ' Sets the format for a cell in a given worksheet
F.Automation.MSExcel.GetWorksheetCount(WorkBook Object Name [String], ReturnVariable [Long])  ' Returns the number of worksheets in the specified workbook.
F.Automation.MSExcel.NameWorkSheet(Worksheet Object Name [String], Sheet Name [String])  ' Renames specified worksheet in Excel
F.Automation.MSExcel.OpenWorkbook(App Object Name [string], Workbook Object Name [String], File Path [String])  ' Opens a workbook and creates a WorkBook object for Excel
F.Automation.MSExcel.OpenWorkSheet(Workbook Object Name [String], Worksheet Object Name [String], Sheet Number[Long])  ' Opens a worksheet and creates a worksheet object for Excel.
F.Automation.MSExcel.ReadCell(Worksheet Object Name [String], Row [Long], Column [Long], Return Variable [String])  ' Reads a cell within a worksheet of a workbook in Excel.
F.Automation.MSExcel.ReadRow(Worksheet Object Name [String], Row [Long], Starting Column [Long], Ending Column [Long], Return Variable [String])  ' Reads a selection of cells within a row in Excel.
F.Automation.MSExcel.ReadSpreadsheet(File Path, Return Variable)  ' These functions return an entire spreadsheet in a triple-delimited string. Th...
F.Automation.MSExcel.RowCount(Worksheet object [String], Return Variable [Long])  ' This gives a number representing the number of rows being used in the worksheet.
F.Automation.MSExcel.SaveWorkbook(Workbook Object name [String])  ' Saves the entire workbook in Excel
F.Automation.MSExcel.WriteCell(Worksheet Object Name [String], Row [Long], Column [Long], Data [String])  ' Writes data to a cell within a worksheet of a workbook in Excel
F.Automation.MSExcel.WriteFormula(Worksheet Object Name[String], Row [Long], Column [Long], Formula [String])  ' Writes a formula into a cell in Excel.
F.Automation.MSExcel.WriteSpreadSheet(File Path, Return Variable)  ' This command writes an entire spreadsheet from a triple-delimited string. The...
```

## Automation.MSOutlook
```
F.Automation.MSOutlook.AddContact(First Name [String], Last Name [String], Email Address [String], Email Display Name [String], Job Title [String], User [String], Category [String], Company Name [String], Customer ID [String], Business Address [String], Street [String], City [String], Zip [String], State [String], Phone [String], Cell [String])  ' Adds a contact to MS Outlook
F.Automation.MSOutlook.ComposeEmail(Recipients [string], Subject [string], Body [string])
F.Automation.MSOutlook.ComposeEmailHTML(Recipients [string], Subject [string], Body [string])  ' The command launches the message composition window in Microsoft Outlook, wit...
F.Automation.MSOutlook.ComposeEmailHTMLModal(Recipients [string], Subject [string], Body [string])  ' This command accepts HTML in the message body text.
F.Automation.MSOutlook.ComposeEmailModal(Recipients [string], Subject [string], Body [string])  ' Composes outlook Email with body and attachments.
F.Automation.MSOutlook.CreateFolder(Folder Name)  ' Creates a new folder and adds it to the folder collection
F.Automation.MSOutlook.DeleteEmail(Folder Path[String], EntryID[String])  ' Deletes the email in the specified folder path
F.Automation.MSOutlook.FolderPathPicker(Return Variable [String])  ' Pops up a dialog box displaying all the folders in MSOutlook
F.Automation.MSOutlook.GetContacts(Return Variable [String])  ' This reads the Outlook address book and returns a string array, with the cont...
F.Automation.MSOutlook.GetContactsExt(Return Variable [String])  ' This function returns contact information from MS Outlook in a double delimit...
F.Automation.MSOutlook.GetEmailAttachments(Folder Path [String], Entry ID [String], Return Variable [String]))  ' Returns the filenames of email attachments
F.Automation.MSOutlook.GetEmailBody(Folder Path [String], Entry ID [String], Return Variable [String])  ' This function returns a specified emails body text.
F.Automation.MSOutlook.GetEmailListing(Return Variable [String])  ' This function returns a triple delimited string of email folders contents. Fi...
F.Automation.MSOutlook.MoveEmail(Source Folder Path[String], EntryID[String], Destination Folder Path[String])  ' Moves the email to the specified folder
F.Automation.MSOutlook.QueueEmail(Recipients [string], Subject [string], Body [string], Attachments [string])
F.Automation.MSOutlook.QueueEmail(Recipients [string], Subject [string], Body [string], Attachments [string])  ' The command launches the message composition window in Microsoft Outlook, wit...
F.Automation.MSOutlook.QueueEmailHTML(Recipients [string], Subject [string], Body [string], Attachments [string])  ' Same as QueueEmail but accepts HTML in the message body text. Requires MS Outlook 2003+. Not compatible with Outlook "New".
F.Automation.MSOutlook.QueuePost(Subject [String], Body [String],Importance [String], Sensitivity [String])
F.Automation.MSOutlook.QueuePostHTML(Subject [String], Body [String],Importance [String], Sensitivity [String])  ' Queues the message. This command accepts HTML in the message body text.
F.Automation.MSOutlook.SaveEmail(Folder Path[String], EntryID/Subject[String], FilePath[String])  ' This function saves a specified email to a file.
F.Automation.MSOutlook.SaveEmailAttachments(Folder Path[String], Entry ID[String],LocalDiskFolderPath[String])  ' Saves the email attachments from the specified folder and ID to the FQN
```

## Automation.MSWord
```
F.Automation.MSWord.CheckPresence(boolean return)  ' This command return status on the presence of a properly installed copy of MS...
F.Automation.MSWord.Replace(file, find string, replace string)
```

## Automation.OOCalc
```
F.Automation.OOCalc.CreateWorkbook(Container Object Name, app object name, workbook object name)  ' Creates the Open Office Workbook (OOCalc)
F.Automation.OOCalc.CreateWorksheet(workbook object, sheet name, sheet position)  ' Creates a worksheet within a given workbook
F.Automation.OOCalc.GetWorksheetCount(workbook object, long return)  ' This function returns the number of worksheets in the specified workbook.
F.Automation.OOCalc.OpenWorkbook(container object name, app Object Name, workbook object name)  ' Opens a workbook for Open Office Calc
F.Automation.OOCalc.OpenWorksheet(Workbook object name, Worksheet object name, worksheet number)  ' Opens the Open Office Worksheet (Calc)
F.Automation.OOCalc.ReadCell(Worksheet Object, Row, Column, Return Variable)  ' Reads a cell within a worksheet of a workbook
F.Automation.OOCalc.ReadRow(Worksheet Object Name, Row, Starting Column, Ending Column, String Return Variable)  ' Reads multiple cells within a worksheet of a workbook
F.Automation.OOCalc.ReadSpreadsheet(File, As Excel, Return)  ' These functions return an entire spreadsheet in a triple-delimited string. Th...
F.Automation.OOCalc.SaveWorkbook(Container Object, Workbook Object name, Filename)  ' Saves the entire workbook
F.Automation.OOCalc.WriteCell(Worksheet Object, Row, Column, Value or Variable)  ' Writes data to a cell within a worksheet of a workbook.
F.Automation.OOCalc.WriteSpreadsheet(file, as Excel, data) or  ' These functions write an entire spreadsheet from a triple-delimited string. T...
```

## Automation.OOGeneral
```
F.Automation.OOGeneral.CheckPresence(Boolean Return)  ' Returns a boolean to state if Open Office is on the machine.
F.Automation.OOGeneral.CreateAppObject(Container Object Name, App Object Name)  ' Creates the Application Object in Open Office.
F.Automation.OOGeneral.CreateContainer(Container Object Name)  ' Creates the Container Object in Open Office.
F.Automation.OOGeneral.TerminateApp(App Object Name)
```

## Automation.OOWriter
```
F.Automation.OOWriter.Replace(file, find string, replace string)
```

## Automation.PDF
```
F.Automation.PDF.AddText(InputFilePath[string],OutputFilePath[string],Text[string],Page[long],X Position[long],Y Position[long],Rotation[float],Font[string],FontSize[float])  ' Adds text to the pdf file
F.Automation.PDF.Close(Reference Name [string])  ' This function closes the specified PDF.
F.Automation.PDF.CreateFromImage(sPathImage [string], sPathPDF [string], PreserveSize [boolean])  ' This method converts an image file (from sPathImage) to a PDF file (to sPathP...
F.Automation.PDF.ExtractPages(InputFile [string],OutputFile [string],StartPage [long],EndPage [long])  ' Extracts Pages from source PDF and copies to the target PDF
F.Automation.PDF.GetFieldNames(Reference Name [string], Return [string])  ' This function returns the form field names from the opens the specified PDF r...
F.Automation.PDF.GetFieldNamesAndValues(reference name [string], return [string])
F.Automation.PDF.GetPageCount(PDF ReferenceName[string], Return[long])  ' Gets the page count
F.Automation.PDF.IsOpen(Reference Name [String], Return [Boolean])  ' This function returns the open status of the PDF specified.
F.Automation.PDF.Merge(InputFile[string],OutputFile[string])  ' This function merges the specified input PDFs into an output PDF.
F.Automation.PDF.Open(Reference Name [string], Fully Qualified Filename [string])  ' Opens an instance of a pdf file
F.Automation.PDF.Resize(InputFile[string],Outputfile[string],Size[string])  ' Resizes the PDF
F.Automation.PDF.SetFormFields(reference name [string], target filename [string], field names [string], field values [string], flatten [Boolean])  ' Creates a PDF file with fields and values
F.Automation.PDF.TextSearch(PDF Reference name [string], search text [string], return [string])  ' Searches for the text in PDF and returns *!* delimited string with page numbers
```

## Automation.Pervasive
```
F.Automation.Pervasive.ArchiveTable(table name[String], archive filename[String])  ' Archives the specified table
F.Automation.Pervasive.ClearRebuildLog  ' This function clears the Pervasive file rebuild log.
F.Automation.Pervasive.DisplayRebuildLog  ' This function launches the Pervasive file rebuild log in Notepad.
F.Automation.Pervasive.GetClientVersion(ReturnVariable [String])  ' Returns the driver version
F.Automation.Pervasive.GetFileNameFromTableName(Table Name [string], Return Filename [string])  ' This function returns a fully-qualified filename, given a table name.
F.Automation.Pervasive.GetServerVersion(Return Variable[String])  ' Returns DBMS version
F.Automation.Pervasive.GetTableNameFromFilename(filename [string], returned table name [string])  ' Returns table name
F.Automation.Pervasive.RebuildFile(Filename [string], Elapsed Time [Long])  ' This function rebuilds the specified file. If the filename is not fully-qual...
```

## Automation.SalesForce
```
F.Automation.SalesForce.SetConnectionString  ' No-arg overload: builds connection string from SetLoginInfo values + base connection string
F.Automation.SalesForce.SetConnectionString(Connection String [string])  ' Explicit overload: sets the connection string directly; SetLoginInfo values are ignored
F.Automation.SalesForce.ExecuteSQL(SQL command [string])  ' Executes a SOQL query against SalesForce
F.Automation.SalesForce.ExecuteSQL(SQL command [string], param0 name [string], param0 value [any], .., paramN name [string], paramN value [any])  ' Parameterized overload with named parameters
F.Automation.SalesForce.ExecuteSQLReturnID(SQL command [string], ID Return [string])  ' Executes the SQL query and returns the last identity value inserted into the ...
F.Automation.SalesForce.ExecuteSQLReturnID(SQL command [string], param0 name [string], param0 value [any], .., paramN name [string], paramN value [any], ID Return [string])  ' Parameterized overload; ID Return is the last argument
F.Automation.SalesForce.SelectToDataTable(DataTable name [string], Global Scope [Boolean], SQL query [string])  ' Fills the datatable with SQL query return data
F.Automation.SalesForce.SetBaseConnectionString(Connection String [string])  ' Sets the base connection string of the connection
F.Automation.SalesForce.SetLoginInfo(UserName [string], Password [string], Token [string])  ' Sets the login info of salesforce connection
```

## Automation.SmartSheet
```
F.Automation.SmartSheet.SetConnectionString(Token, CallbackURL)  ' Sets SmartSheet connection; Token as String, CallbackURL as String
F.Automation.SmartSheet.SelectToDatatable(DatatableName, Query, [Global])  ' Fills DataTable from query; DatatableName/Query as String, Global as Boolean (optional)
F.Automation.SmartSheet.ExecuteSQL(Query, RowsAffectedReturn)  ' Executes SQL (INSERT/UPDATE/DELETE); Query as String, RowsAffectedReturn as Long
F.Automation.SmartSheet.Export(SheetName, OutputPath, ColumnNames, [Condition], RowsAffectedReturn)  ' Exports columns to file; all String except RowsAffectedReturn as Long
```

### SmartSheet Workflow
```
V.Local.iReturn.Declare(Long,-1)
V.Local.sToken.Declare(String,"123CatsToken")
V.Local.sURL.Declare(String,"http://123Cats")

' 1. Connect
F.Automation.SmartSheet.SetConnectionString(V.Local.sToken,V.Local.sURL)

' 2. Read data into DataTable
F.Automation.SmartSheet.SelectToDatatable("SmartSheetDataTable1","Select CatName,CatAge from Sheet_Cats")

' 3. Manipulate data
F.Automation.SmartSheet.ExecuteSQL("UPDATE Sheet_Cats SET CatAge=157 WHERE CatName='Lucy'",V.Local.iReturn)

' 4. Export to file (columns *!*-delimited)
F.Automation.SmartSheet.Export("Sheet_Cats","C:\Export\Cats.txt","MyCat*!*CatName*!*CatAge*!*CatHomeAddress",V.Local.iReturn)

' 4b. Export with ORDER BY condition
F.Automation.SmartSheet.Export("Sheet_Cats","C:\Export\Cats.csv","CatName*!*CatHomeAddress","ORDER by CatName",V.Local.iReturn)
```

## Automation.Stripe
```
F.Automation.Stripe.AttachPaymentMethodToCustomer(Payment Method ID [String], Customer ID [String])
F.Automation.Stripe.CancelPaymentIntent(Payment Intent ID [String])
F.Automation.Stripe.ConfirmPaymentIntent(Payment Intent ID [String])
F.Automation.Stripe.CreateCheckoutSession(Amount [Long], Currency [String], Description [String], Success URL [String], Cancel URL [String], Customer Email [String])
F.Automation.Stripe.CreateCheckoutSessionForManufacturer(Manufacturer Account ID [String], Amount [Long], Currency [String], Description [String], Success URL [String], Cancel URL [String], Customer Email [String], Application Fee Amount [Long], Invoice Number [String], Sales Order Number [Integer], Shipment Sequence [Integer])
F.Automation.Stripe.CreateConnectAccount(Email [String], Business Name [String], Country [String])
F.Automation.Stripe.CreateCustomer(Email [String], Name [String])
F.Automation.Stripe.CreateOnboardingLink(Account ID [String], Return URL [String], Refresh URL [String])
F.Automation.Stripe.CreatePaymentIntent(Amount [Long], Currency [String], Description [String])
F.Automation.Stripe.CreatePaymentLink(Amount [Long], Currency [String], Description [String], Customer Email [String], Customer Name [String])
F.Automation.Stripe.CreatePaymentMethod(Card Number [String], Exp Month [Integer], Exp Year [Integer], CVC [String])
F.Automation.Stripe.CreateRefund(Charge ID [String], Amount [Long], Reason [String], Manufacturer Account ID [String])
F.Automation.Stripe.CreateTimeDependentCoupon(Manufacturer Account ID [String], Percent Off [Decimal], Redeem By [DateTime], Name [String], ID [String], Duration [String])
F.Automation.Stripe.DeleteConnectAccount(Account ID [String])
F.Automation.Stripe.DeleteCoupon(Coupon ID [String], Manufacturer Account ID [String])
F.Automation.Stripe.GetCharge(Charge ID [String], Manufacturer Account ID [String])
F.Automation.Stripe.GetCheckoutSession(Session ID [String], Manufacturer Account ID [String])
F.Automation.Stripe.GetConnectAccount(Account ID [String])
F.Automation.Stripe.GetCoupon(Coupon ID [String], Manufacturer Account ID [String])
F.Automation.Stripe.GetPaymentIntent(Payment Intent ID [String])
F.Automation.Stripe.GetPaymentLink(Payment Link ID [String])
F.Automation.Stripe.SetApiKey(API Key [String])
F.Automation.Stripe.UpdateConnectAccount(Account ID [String], Email [String], Business Name [String])
F.Automation.Stripe.UpdatePayoutSchedule(Account ID [String], Schedule [String], Weekly Anchor [String], Monthly Anchor [Integer])
```

## Automation.Zip
```
F.Automation.Zip.UnZip(ArchiveFilePath, DestinationFilePath, FileName)  ' Extracts a single file or entirely, from the archive.
F.Automation.Zip.Zip(FileNames, ArchiveFilePath, StoredPath)  ' Creates the compressed archive.
F.Automation.Zip.ZipContents(ArchiveFilePath, Value)  ' Returns a list of files in GAB delimited format
```

## Automation.ZIPPro
```
F.Automation.ZIPPro.Abort()  ' Aborts the current operation.
F.Automation.ZIPPro.AppendFiles()  ' Adds specified files to an existing archive.
F.Automation.ZIPPro.Compress()  ' Creates the compressed archive.
F.Automation.Zippro.Config(Configuration as String)  ' Sets configuration string
F.Automation.ZIPPro.Delete(FileName as String)  ' Deletes one or more files from an existing archive.
F.Automation.ZIPPro.Extract("FileNames as String")  ' Extracts a single file, directory, or group of files, from the archive.
F.Automation.ZIPPro.ExtractAll()  ' Extracts all files from the compressed archive.
F.Automation.ZIPPro.IncludeFiles(V.Local.FileNamesArgument)  ' Specifies that the indicated files should be added to the archive.
F.Automation.ZIPPro.ReadProperty(Name as String,Property as Object)  ' Gets a property value. The available properties can be found http://cdn.nsoft...
F.Automation.ZIPPro.Reset()  ' Resets the component.
F.Automation.ZIPPro.Scan()  ' Scans the compressed archive. This method will scan the archive specified by ...
F.Automation.ZIPPro.SetProperty(Name as String,Property as Object)  ' Sets a property value. The available properties can be found http://cdn.nsoft...
F.Automation.ZIPPro.Update("FileName as String")  ' Will update certain files in an archive.
```

## Communication.CALDAV
```
F.Communication.CALDAV.AddCookie(Name, Value)  ' Adds a cookie and the corresponding value to the outgoing request headers.
F.Communication.CALDAV.AddCustomProperty(Name as String, Value as String)  ' Adds a form variable and the corresponding value.
F.Communication.CALDAV.Config(Name as String, Value as String)  ' Sets or retrieves a configuration setting.
F.Communication.CALDAV.CopyCalendarEvent(SourceResourceURI [string], DestinationResourceURI [string])  ' Copy events to a new location.
F.Communication.CALDAV.CreateCalendar(ResourceURI [string])  ' Creates a new calendar collection resource.
F.Communication.CALDAV.DeleteCalendarEvent(ResourceURI [string])  ' Delete a resource or collection.
F.Communication.CALDAV.DoEvents()  ' Processes events from the internal message queue.
F.Communication.CALDAV.ExportICS(Return)  ' Generates an event from the properties in the iCal (.ICS) format.
F.Communication.CALDAV.GetCalendarEvent(ResourceURI [string])  ' Retrieves a single event from the CalDAV server.
F.Communication.CALDAV.GetCalendarOptions(ResourceURI)  ' Retrieves options for the ResourceURI to determines whether it supports calen...
F.Communication.CALDAV.GetCalendarReport(ResourceURI [string])  ' Generates a report on the indicated calendar collection resource.
F.Communication.CALDAV.GetFreeBusyReport(ResourceURI[string])  ' Generates a report as to when the calendar owner is free and/or busy.
F.Communication.CALDAV.ImportICS(CalendarData)  ' Imports iCal data (loaded from an ICS file) into the components property list.
F.Communication.CALDAV.Interrupt()  ' Interrupt the current method.
F.Communication.CALDAV.LockCalendar(ResourceURI [string])  ' Obtain a lock for a specified calendar resource.
F.Communication.CALDAV.MoveCalendarEvent(SourceResourceURI, DestinationResourceURI)  ' Moves one calendar resource to a new location.
F.Communication.CALDAV.PutCalendarEvent(ResourceURI)  ' Adds a calendar resource at the specified ResourceURI using the CalDAV PUT me...
F.Communication.CALDAV.ReadProperty(Name [string], Value [any])
F.Communication.CALDAV.Reset()  ' This method will reset the component properties to their default value when c...
F.Communication.CALDAV.SetProperty(Name, Value)  ' Sets a property value. The available properties can be found http://cdn.nsoft...
F.Communication.CALDAV.UnlockCalendar(ResourceURI)  ' Unlocks a calendar resource.
```

## Communication.Email
```
F.Communication.Email.ResolveMx(Email Address, Return)  ' Resolves Email address and returns mail server and ipaddress
```

## Communication.FTP
```
F.Communication.FTP.Abort()  ' Abort Current Upload/Download.
F.Communication.FTP.Append()  ' Append data from LocalFile to a RemoteFile on an FTP server.
F.Communication.FTP.Command(Command)  ' Used to send additional commands directly to the server.
F.Communication.FTP.DeleteFile(FileName)  ' Remove a file specified by FileName from an FTP server.
F.Communication.FTP.Download()  ' Download a RemoteFile from an FTP server.
F.Communication.FTP.Interrupt()  ' Interrupt the current method.
F.Communication.FTP.ListDirectoryLong()  ' List extended directory information for RemotePath.
F.Communication.FTP.MakeDirectory(DirectoryName)  ' Create a directory on an FTP server.
F.Communication.FTP.RemoveDirectory(DirectoryName)  ' Remove a directory specified by DirName from an FTP server.
F.Communication.FTP.ReadProperty(Name, Value)  ' Gets a property value; available properties: https://cdn.nsoftware.com/help/IPF/cs/FTP.htm
F.Communication.FTP.RenameFile(Name)  ' Change the name of RemoteFile to Name.
F.Communication.FTP.Reset()  ' Reset the component.
F.Communication.FTP.StoreUnique()  ' Upload a file with a Unique Name to an FTP server.
```

## Communication.FTPS
```
F.Communication.FTPS.Abort()  ' Abort Current Upload/Download.
F.Communication.FTPS.Append()  ' Append data from LocalFile to a RemoteFile on an FTP server.
F.Communication.FTPS.Command(Command)  ' Used to send additional commands directly to the server.
F.Communication.FTPS.DeleteFile(FileName)  ' Remove a file specified by FileName from an FTP server.
F.Communication.FTPS.Download()  ' Download a RemoteFile from an FTP server.
F.Communication.FTPS.Interrupt()  ' Interrupt the current method.
F.Communication.FTPS.ListDirectory()  ' List the current directory specified by RemotePath on an FTP server.
F.Communication.FTPS.ListDirectoryLong()  ' List extended directory information for RemotePath.
F.Communication.FTPS.Logoff()  ' Logoff from the FTP server by posting a QUIT command.
F.Communication.FTPS.Logon()  ' Logon to the FTP RemoteHost using the current User and Password.
F.Communication.FTPS.MakeDirectory(DirectoryName)  ' Create a directory on an FTP server.
F.Communication.FTPS.ReadProperty(Name, Value)  ' Gets a property value. The available properties can be found http://cdn.nsoft...
F.Communication.FTPS.RemoveDirectory(DirectoryName)  ' Remove a directory specified by DirName from an FTP server.
F.Communication.FTPS.RenameFile(Name)  ' Change the name of RemoteFile to NewName.
F.Communication.FTPS.Reset()  ' Reset the component.
F.Communication.FTPS.SetProperty(Name, Value)  ' Sets a property value. The available properties can be found http://cdn.nsoft...
F.Communication.FTPS.StoreUnique()  ' Upload a file with a Unique Name to an FTP server.
F.Communication.FTPS.Upload()  ' Upload a file specified by LocalFile to an FTP server.
```

## Communication.HTTP
```
F.Communication.HTTP.AddCookie(Name, Value)  ' Adds a cookie and the corresponding value to the outgoing request headers.
F.Communication.HTTP.Head(Url)  ' Fetches the document headers using the HTTP HEAD method.
F.Communication.HTTP.Interrupt()  ' Interrupt the current method.
F.Communication.HTTP.Reset()  ' Reset the HTTP component (clears all properties and headers)
F.Communication.HTTP.WebRequest(Url, Value)  ' Returns a string response of the passed URL
```

## Communication.HTTPS
```
F.Communication.HTTPS.AddCertificate(PropertyName)  ' Initializes a new certificate on the property.
F.Communication.HTTPS.AddCookie(Name, Value)  ' Adds a cookie and the corresponding value to the outgoing request headers.
F.Communication.HTTPS.Config(Name, Value)  ' Sets or retrieves a configuration setting.
F.Communication.HTTPS.DoEvents()  ' Processes events from the internal message queue.
F.Communication.HTTPS.DownloadFile()  ' Downloads a file.
F.Communication.HTTPS.Get(Url)  ' Fetch the document using the HTTP GET method.
F.Communication.HTTPS.Head(Url)  ' Fetches the document headers using the HTTP HEAD method.
F.Communication.HTTPS.Interrupt()  ' Interrupt the current method.
F.Communication.HTTPS.Post(Url)  ' Posts data to the HTTP server using the HTTP POST method.
F.Communication.HTTPS.Put(Url)  ' Sends data to the HTTP server using the HTTP PUT method.
F.Communication.HTTPS.ReadProperty(Name, Value)  ' Gets a property value. The available properties can be found http://cdn.nsoft...
F.Communication.HTTPS.Reset()  ' Reset the component.
F.Communication.HTTPS.ResetHeaders()  ' Resets all HTTP Headers, Cookies, LocalFile , and AttachedFile.
F.Communication.HTTPS.SetProperty(Name, Value)  ' Sets a property value. The available properties can be found http://cdn.nsoft...
F.Communication.HTTPS.WebRequest(Url, Value)  ' Returns a string response of the passed URL
```

## Communication.IMAP
```
F.Communication.IMAP.AddMessageFlags(Flags)  ' Adds the specified flags to the messages specified by MessageSet
F.Communication.IMAP.AppendToMailBox()  ' Appends the message in MessageText to the mailbox specified by Mailbox
F.Communication.IMAP.CheckMailBox()  ' This method sends a CHECK command to the server, asking it to perform any nec...
F.Communication.IMAP.CloseMailBox()  ' Removes all messages marked with Deleted flag from the currently selected mai...
F.Communication.IMAP.Config(Configuration String)  ' Sets a configuration setting
F.Communication.IMAP.Connect()  ' Connects to an IMAP server
F.Communication.IMAP.CopyToMailBox()  ' Copies the messages specified by MessageSet to the mailbox specified by Mailbox
F.Communication.IMAP.CreateMailBox()  ' Creates a new mailbox specified by Mailbox
F.Communication.IMAP.DeleteFromMailBox()  ' Marks the messages specified by MessageSet as deleted.
F.Communication.IMAP.DeleteMailBox()  ' This method deletes a mailbox. The mailbox name is specified by the Mailbox p...
F.Communication.IMAP.DeleteMailBoxACL(User )  ' Deletes mailbox access control rights for a user.
F.Communication.IMAP.Disconnect()  ' Disconnects from an IMAP server
F.Communication.IMAP.DoEvents()  ' Processes events from the internal message queue.
F.Communication.IMAP.ExamineMailBox()  ' Selects a Mailbox (Read-only mode).
F.Communication.IMAP.ExpungeMailBox()  ' Removes all messages marked with Deleted flag from the currently selected mai...
F.Communication.IMAP.FetchMessageHeaders()  ' Retrieves the message headers of messages specified by the MessageSet property.
F.Communication.IMAP.FetchMessageInfo()  ' Retrieves information about messages specified by the MessageSet property.
F.Communication.IMAP.FetchMessagePart()  ' Retrieves the message part specified by PartID.
F.Communication.IMAP.FetchMessagePartHeaders()  ' Retrieves the headers of message part specified by PartID
F.Communication.IMAP.FetchMessageText()  ' Retrieves the message text of messages specified by the MessageSet property.
F.Communication.IMAP.GetMailBoxACL()  ' Retrieves mailbox access control rights
F.Communication.IMAP.GetProperty(Property Name, Return Value)  ' Returns value of the property specified
F.Communication.IMAP.Interrupt()  ' Interrupt the current method.
F.Communication.IMAP.ListMailBoxes()  ' Lists all mailboxes matching all criteria in the Mailbox property.
F.Communication.IMAP.ListSubscribeMailBoxes()  ' Lists all subscribed mailboxes matching all criteria in the Mailbox property.
F.Communication.IMAP.MoveToMailBox()  ' Moves the messages specified by MessageSet to the mailbox specified by Mailbox
F.Communication.IMAP.Noop()  ' This method sends an IMAP NOOP command to the server. This is useful when the...
F.Communication.IMAP.Reset()  ' Reset the component.
F.Communication.IMAP.ResetMessageFlags()  ' Replaces the flags of the messages specified by MessageSet with the flags spe...
F.Communication.IMAP.SearchMailBox(Search criteria)  ' Search selected mailbox for specified text.
F.Communication.IMAP.SetMailBoxACL(User, Rights)  ' Sets mailbox access control rights for a specific user.
F.Communication.IMAP.SetProperty(Property Name, Property Value)  ' Sets value of the property sepcified
F.Communication.IMAP.StopIdle()  ' Stops idling.
F.Communication.IMAP.SubscribeMailBox()  ' Subscribes to the mailbox specified by Mailbox .
F.Communication.IMAP.UnsetMessageFlags()  ' Removes the flags specified by MessageFlags from the messages specified by Me...
F.Communication.IMAP.UnSubscribeMailBox()  ' Unsubscribes from the mailbox specified by Mailbox
```

## Communication.IPDaemon
```
F.Communication.IPDaemon.IPDAcceptData(Listen)  ' Starts/stops listening on the port set by IPDSetLocalPort; Listen as Boolean
F.Communication.IPDaemon.IPDDisconnect(Connection ID)  ' Disconnects the specified client; Connection ID as String
F.Communication.IPDaemon.IPDReadProperty(Property name, Property Value)  ' Gets a daemon property; Property name as String, Property Value as Any
F.Communication.IPDaemon.IPDSendData(Connection ID, Text)  ' Sends data to remote host; Connection ID as String, Text as String
F.Communication.IPDaemon.IPDSetKA(KeepAlive)  ' Enables/disables KEEPALIVE packets; KeepAlive as Boolean
F.Communication.IPDaemon.IPDSetLocalPort(Port Number)  ' Sets the TCP listen port; Port Number as Long
F.Communication.IPDaemon.IPDShutDown()  ' Shuts down the server (no params)
```

## Communication.IpPort
```
F.Communication.IpPort.IPPAcceptData(Listen)  ' Starts/stops listening on the configured port; Listen as Boolean
F.Communication.IpPort.IPPConnect(Host, Port)  ' Connects to a remote host; Host as String, Port as Long
F.Communication.IpPort.IPPDisconnect()  ' Disconnects from the remote host (no params)
F.Communication.IpPort.IPPReadProperty(Property name, Property Value)  ' Gets a port property; Property name as String, Property Value as Any
F.Communication.IpPort.IPPSend(Data)  ' Sends data to remote host; Data as String
F.Communication.IpPort.IPPSendLine(Data)  ' Sends data followed by a newline; Data as String
F.Communication.IpPort.IPPSetEOL(EOL)  ' Sets end-of-line delimiter for incoming data stream; EOL as String
F.Communication.IpPort.IPPSetFirewall(Host, Port, Firewalltype, UserName, Password)  ' Configures firewall; Host as String, Port as Long, Firewalltype as String, UserName as String, Password as String
F.Communication.IpPort.IPPSetKA(Keep Alive)  ' Enables/disables KEEPALIVE packets; Keep Alive as Boolean
F.Communication.IpPort.IPPSetProperty(Property Name, Property Value)  ' Sets a port property; Property Name as String, Property Value as Any
F.Communication.IpPort.IPPSetTimeout(Timeout)  ' Sets component timeout; Timeout as Long
```

## Communication.MIME
```
F.Communication.MIME.Config(Configuration)  ' Sets the specified configuration string
F.Communication.MIME.DecodeFromFile()  ' Decodes from file
F.Communication.MIME.DecodeFromString()  ' Decodes from string.
F.Communication.MIME.EncodeToFile()  ' Encodes to File
F.Communication.MIME.EncodeToString()  ' Encodes to string.
F.Communication.MIME.GetProperty(Property Name, Property Value)  ' Retrieves the value property specified
F.Communication.MIME.Reset()  ' Resets the component.
F.Communication.MIME.ResetData()  ' Resets the values of all headers and encode/decode properties.
F.Communication.MIME.SetProperty(Property Name , Property Value)  ' Sets the value of property specified
```

## Communication.Netcode
```
F.Communication.Netcode.DecodeToString(DecodeFormat, Text, Value)  ' Decodes a string based on the format. (http://cdn.nsoftware.com/help/IPF/cs/N...
F.Communication.Netcode.EncodeToFile(EncodeFormat, SourceFilePath, TargetFilePath)  ' Encodes the files contents based on the format. (http://cdn.nsoftware.com/hel...
F.Communication.Netcode.EncodeToString(EncodeFormat, Text, Value)  ' Encodes a string based on the format. (http://cdn.nsoftware.com/help/IPF/cs/N...
F.Communication.Netcode.SetCodingParameter(Name, Value)  ' Sets a configuration setting.
```

## Communication.Network
```
F.Communication.Network.AuthenticateUser(Username, Password, Domain, ReturnVariable)  ' This function will take the passed username, password and domain to validate ...
F.Communication.Network.GetAuxUserInfo(Info, User, ReturnVariable)
F.Communication.Network.GetHostNameFromIP()
F.Communication.Network.GetIPFromHostName()
F.Communication.Network.GetThreadUser(ReturnVariable)
F.Communication.Network.GetTime(SourceMachine, ReturnVariable)
```

## Communication.oAuth
```
F.Communication.oAuth.AddCookie(Cookie Name, Cookie Value)  ' Adds a cookie and the corresponding value to the outgoing request headers.
F.Communication.oAuth.AddParam(Param Name, Param value)  ' Adds a name-value pair to the query string parameters of outgoing request.
F.Communication.oAuth.DoEvents()  ' Processes events from the internal message queue.
F.Communication.oAuth.GetAuthorization(Return Variable)  ' Gets the authorization string required to access the protected resource.
F.Communication.oAuth.GetAuthorizationUrl()  ' Builds and returns the URL to which the user should be re-directed for author...
F.Communication.oAuth.Interrupt()  ' Interrupts the current method.
F.Communication.oAuth.ReadProperty(Property Name, Property Value)  ' Retrieves the value of the property specified
F.Communication.oAuth.Reset()  ' Resets the component
F.Communication.oAuth.StartWebServer()  ' Starts the embedded web server.
F.Communication.oAuth.StopWebServer()  ' Stops the embedded web server.
```

## Communication.REST
```
F.Communication.REST.AddCookie(Name, Value)  ' Adds a cookie and the corresponding value to the outgoing request headers.
F.Communication.REST.Attr(AttrName)
F.Communication.REST.Config(Name, Value)
F.Communication.REST.HasXPath(XPath, Return)
F.Communication.REST.Interrupt()
F.Communication.REST.Put(URL)
```

## Communication.RSS
```
F.Communication.RSS.AddCookie(Name, Value)  ' Adds a cookie and the corresponding value to the outgoing request headers.
F.Communication.RSS.AddItem(Title, Description, Link)  ' Inserts a new item into the beginning of an RSS feed.
F.Communication.RSS.AddNamespace(Prefix, NamespaceUri)  ' Adds a namespace to the Namespaces properties.
F.Communication.RSS.Config(Name, Value)  ' Sets or retrieves a configuration setting.
F.Communication.RSS.DoEvents()  ' Processes events from the internal message queue.
F.Communication.RSS.GetFeed(Url)  ' Fetches an RSS feed. The component will then attempt to parse the RSS feed, f...
F.Communication.RSS.GetRSSProperty(Name, Value)  ' Gets the value of a specific RSS feed item element or attribute. The availabl...
F.Communication.RSS.GetURL(Url)  ' Fetches an RSS feed.
F.Communication.RSS.Interrupt()  ' Interrupt the current method.
F.Communication.RSS.OPMLAttr(AttributeName, Value)  ' Returns the value of the attribute specified in the parameter.
F.Communication.RSS.Put(Url)  ' Sends data to the HTTP server using the HTTP PUT method.
F.Communication.RSS.ReadFile(FileName)  ' Loads an RSS file into the component.
F.Communication.RSS.ReadOPML(OPMLFile)  ' Reads and parses an OPML file.
F.Communication.RSS.ReadProperty(Name, Value)  ' Gets a property value. The available properties can be found http://cdn.nsoft...
F.Communication.RSS.Reset()  ' Resets all properties of the component.
F.Communication.RSS.SetProperty(Name, Value)  ' Sets a property value. The available properties can be found http://cdn.nsoft...
F.Communication.RSS.SetRSSProperty(Name, Value)  ' Sets the value of a specific RSS feed property. The available properties can ...
F.Communication.RSS.WriteFile(FileName)  ' Writes an RSS feed from the component.
```

## Communication.SFTP
```
F.Communication.SFTP.AddCertificate(PropertyName)  ' Initializes a new certificate on the property.
F.Communication.SFTP.Append()  ' Append data from LocalFile to a RemoteFile on an FTP server.
F.Communication.SFTP.Config(Configuration)  ' Sets the specified configuration string
F.Communication.SFTP.DeleteFile(FileName)  ' Remove a file specified by FileName from an FTP server.
F.Communication.SFTP.Download()  ' Download a RemoteFile from an FTP server.
F.Communication.SFTP.Interrupt()  ' Interrupt the current method.
F.Communication.SFTP.MakeDirectory(DirectoryName)  ' Create a directory on an FTP server.
F.Communication.SFTP.RemoveDirectory(DirectoryName)  ' Remove a directory specified by DirName from an FTP server.
F.Communication.SFTP.GetProperty(Name, Value)  ' Gets a property value; see https://cdn.nsoftware.com/help/IFF/cs/SFTP.htm
F.Communication.SFTP.RenameFile(Name)  ' Change the name of RemoteFile to NewName.
F.Communication.SFTP.Reset()  ' Reset the component.
```

## Communication.SOAP
```
F.Communication.SOAP.AddCookie(Name, Value)  ' This method adds a cookie and the corresponding value to the outgoing request...
F.Communication.SOAP.Attr(AttrName, ReturnValue)
F.Communication.SOAP.Config(Name, Value)
F.Communication.SOAP.DoEvents()
F.Communication.SOAP.EvalPacket()
F.Communication.SOAP.HasXPath(XPath, Return)
F.Communication.SOAP.Interrupt()
F.Communication.SOAP.SendPacket()
F.Communication.SOAP.Value(ParamName, ReturnValue)
```

## Communication.Web
```
F.Communication.Web.MethodInvoke(ServiceName, MethodName, ReturnResult)  ' Access a WebReference by name, specified by ServiceName.
```

## Communication.WebForm
```
F.Communication.WebForm.AddCookie(Name, Value)
F.Communication.WebForm.AddFormVar(Name, Value)
F.Communication.WebForm.Config(Configuration String)  ' Sets the specified configuration string
F.Communication.WebForm.DoEvents()
F.Communication.WebForm.Interrupt()
F.Communication.WebForm.ReadProperty(PropertyName, ReturnVariable)
F.Communication.WebForm.Reset()
F.Communication.WebForm.SetProperty(PropertyName, Value)
F.Communication.WebForm.Submit(URL)
```

## Communication.WebUpload
```
F.Communication.WebUpload.AddCookie(CookieName, CookieValue)
F.Communication.WebUpload.Config(ConfigurationString)
F.Communication.WebUpload.DoEvents()
F.Communication.WebUpload.Interrupt()
F.Communication.WebUpload.Upload()  ' Uploads file; configure URL, LocalFile, RemoteFile via SetProperty first
F.Communication.WebUpload.UploadTo(URL)
```

## Communication.ZIPPro
```
F.Communication.ZIPPro.Config(Name, Value)  ' Sets or retrieves a configuration setting.
```

## Global.1Click
```
F.Global.1Click.UnPack()  ' This function installs a 1-Click application package to the specified company...
```

## Global.BI
```
F.Global.BI.CreateCSFile(Param Name, Param Values, Codesoft File FQP)  ' This command creates a Codesoft label file to be used by Sentinel to generate...
F.Global.BI.DeleteReportSequenceNotes
F.Global.BI.DeleteReportSequenceOverride(ReportID, Sequence, Company)  ' This function deletes a the override report defined on a report sequence.
F.Global.BI.DeleteReportSequencePreProcessor(ReportID, Sequence, Company)  ' This function deletes a the preprocessor defined to use on a user report sequ...
F.Global.BI.EnableOverride(Report ID, Sequence ID, Company Code)
F.Global.BI.GetParameters(CallKey, ReturnVariable)
F.Global.BI.GetReportSequenceEmails(ReportID, Sequence, Company, Return)  ' This function returns report sequence emails in a string delimited with "*!*"...
F.Global.BI.LaunchDashboard(Module, Type, Arg, Sync)
F.Global.BI.PrintBartenderLabel(ReportId, Mode, ParamNames, ParamValues, Synchronous, PrinterName, PrintQuantity)
F.Global.BI.PrintCodeSoftLabelFromUDT(BIRunID, LogID, UDTName, Elements, Printer)
F.Global.BI.PrintGsLabelFromDatatable(Run Id [Long], Report Id [Long], Datatable Name [String], PrinterName [String], Copies [Long], OverridePath [String])  ' Prints a gslabel from datatable writing the table contents to a json file
F.Global.BI.ReplaceMenu(Target ID, Replace ID, Return)
F.Global.BI.ReportExists()  ' This function checks for the existence of a report within the specified compa...
F.Global.BI.SetGSSPreProcessor(Report ID, Sequence ID, Preprocessor FQP, Description, Menu path, Purge Days)
F.Global.BI.SetPrintOptionSelections(BI Run ID, Option ID and Value)
F.Global.BI.SetReportSequenceOutput(Report ID, Sequence ID, Company Code, Output Type)
F.Global.BI.SetReportSequenceOverride(ReportID, Sequence, Company, OverrideFQP)  ' This function sets a report override to use on a sequence *NOTE* This functio...
F.Global.BI.SetUserPreprocessor(Report ID, Sequence ID, Company Code, Preprocessor FQP, Description, Menu Path, Purge Days)
F.Global.BI.ToggleA4
```

## Global.Biometric
```
F.Global.Biometric.DeleteFingerprint(EmployeeId, DigitId)
F.Global.Biometric.FingerprintCount()  ' This command returns count information on fingerprint information stored in G...
F.Global.Biometric.IdentifyRemoteFingerprint(TerminalNumber)  ' This function retrieves a fingerprint posted from a Remote Desktop client ses...
F.Global.Biometric.ReconcileFingerprints()  ' This command determines what fingerprints in the database, by fingerprint min...
F.Global.Biometric.ReloadFingerprints()  ' This function causes a forced reload of the fingerprint database.
F.Global.Biometric.ResumeIdentification()
F.Global.Biometric.SaveFingerprint()  ' This command saves the most recently scanned fingerprint to the fingerprint d...
F.Global.Biometric.SetCaptureThreshold(CaptureThreshold)
F.Global.Biometric.SetMatchThreshold(MatchThreshold)
F.Global.Biometric.SetMultiIdentify(Flag)
F.Global.Biometric.StartIO()
F.Global.Biometric.StopIO()
F.Global.Biometric.SuspendIdentification()
```

## Global.CallWrapper
```
F.Global.CallWrapper.RunAsync(CallWrapper Instance)  ' Runs the callwrapper Aynchronously. Event "RunAsyncCompleted" is fired after ...
```

## Global.Canny
```
F.Global.Canny.CheckUser(Email Address, Service Web UserName)
F.Global.Canny.SendFeedback(Board Name)
```

## Global.CRM
```
F.Global.CRM.GetCitiesFromZip(Zip, ReturnVariable)
F.Global.CRM.GetStateFromAbbr(Abbreviation, Return)
F.Global.CRM.GetZipDistance(Zip1, Zip2, ReturnVariable)
F.Global.CRM.GetZipPosition(Zip, ReturnVariable, ReturnVariable)
F.Global.CRM.GetZipsNearZip(Zip, Distance, ReturnVariable)
F.Global.CRM.IsSupervisor(BooleanReturn)
F.Global.CRM.SaveEvent(EventId, Seq, CompanyNumber, CompanyType, EventTypeId, Title, Description, StartDatetime, EndDatetime, Recipient, UsergroupId, AllDay, Reminder, ReminderInterval, EventLocationId, RequestAcknowledgement, LinkInfo, StatusId, PriorityId, EventGroupId, EventSubgroupId, PurgeDate, OpportunityId, ContactId, CloseDate, Creator, Meta0, Meta1, Meta2, Meta3, Meta4, Meta5, Meta6, Meta7, Meta8, Meta9, EventIdReturn)
F.Global.CRM.SaveOpportunity(OppId, OppGroupId, CompanyNumber, CompanyType, ContactId, OppTypeId, OppDescription, WorkflowId, CloseDate, ExpirationDate, ProjCloseDate, LeadSourceId, Revenue, FunnelId, ProbabilityId, StatusId, InternalAssignment, Salesperson, CloseReasonId, QuoteNumber, QuoteLine, SalesOrderNumber, SalesOrderLine, OppIdReturn)  ' Description
```

## Global.DocumentControl
```
F.Global.DocumentControl.AddDocumentNFC(LinkID, File, Description, Group, FileType)  ' Same as AddDocument but no file copy; also: AddDocumentNFC(LinkID, File, Description, Group, UserFileType)
F.Global.DocumentControl.AddStandAloneLinkType()  ' Creates a new stand-alone link type (no params)
F.Global.DocumentControl.AddStandAloneMetaData()  ' Adds metadata to a document ID and sequence combination (no params)
F.Global.DocumentControl.CheckUserDocumentSecurity(DocId, User, ReturnVariable)  ' Checks document security; DocId as Long, User as String, ReturnVariable as Boolean
F.Global.DocumentControl.CopyExt(SourceLinkID, TargetLinkID, DeleteFlag, Comments, User)  ' Extended copy; SourceLinkID/TargetLinkID as Long, DeleteFlag as Boolean, Comments/User as String
F.Global.DocumentControl.CreateBulkReferences(Text)  ' Creates bulk references; Text as String
F.Global.DocumentControl.GetAllDocumentIDs(DCCKey, LinkIDReturn)  ' Returns ":"-delimited doc IDs; DCCKey as String, LinkIDReturn as String
F.Global.DocumentControl.GetDocument(DocId, ReturnVariable)  ' Gets document info; DocId as Long (FILE_NUM), ReturnVariable as String (*!*-delimited: FileName*!*Path*!**!*GroupID*!*FileType)
F.Global.DocumentControl.GetLinkTypeTitle()  ' Returns text title for a numeric link type (no params)
F.Global.DocumentControl.GetReferenceStatus(DCCKey, DCCKeyType, StatusReturn)  ' Custom DCC Key Types: 2010-2200; DCCKey/DCCKeyType as String, StatusReturn as Long
F.Global.DocumentControl.GetVersion()  ' Returns the version of Link/Document Control (no params)
F.Global.DocumentControl.ReconcileBaseEntries()  ' Reconciles base entries (no params)
F.Global.DocumentControl.SearchStandAloneMetaData()  ' Searches stand-alone metadata for matches (no params)
F.Global.DocumentControl.UpdateStandAloneDocument()  ' Updates a stand-alone document (no params)
F.Global.DocumentControl.UpdateStandAloneLinkType()  ' Updates a stand-alone link type description (no params)
```

### Document Control LinkType IDs
Used by `GetLinkID` and related functions. The Key is the identifier relevant to the type (e.g. part number for Inventory Master).

| ID | Link Type |
|----|-----------|
| 00 | All |
| 10 | Vendor Master |
| 11 | AP Invoice |
| 12 | Contact |
| 14 | AR Cash Check/Ref Number |
| 15 | Customer Master |
| 17 | Ship To |
| 18 | Prospect |
| 19 | Suspect |
| 20 | Work Order Master |
| 25 | Work Order Operation |
| 27 | Project |
| 28 | Project Phase |
| 29 | Forecast |
| 30 | Inventory Master |
| 31 | Item Master |
| 32 | Warranty Master |
| 35 | Router/Estimate |
| 37 | Router/Estimate Sequence |
| 38 | Workcenter |
| 39 | Op Code |
| 40 | General Ledger Master |
| 41 | Fixed Assets |
| 45 | Sales Order Master |
| 50 | Quote Master |
| 55 | Employee Master |
| 60 | Purchase Order Master |
| 61 | Purchase Order Receipts |
| 62 | Vendor Quotes |
| 65 | Configurator Master |
| 70 | Sales Order Line |
| 71 | BOL |
| 75 | Quality Master |
| 76 | Quality Master User Field 1 |
| 80 | Engineering Change Notice |
| 90 | Master Event |
| 91 | Event |
| 92 | Opportunity |
| 93 | Subopportunity |
| 94 | Request Number |
| 95 | CRM Tasks |
| 96 | CRM Campaigns |
| 110 | Work Flow Template |
| 120 | Work Flow |

### GetDocument Return Format
Returns a `*!*`-delimited string: `FileName*!*Path*!**!*GroupID*!*FileType`
```
' Example: DocId 39 returns "500007-.XLS*!*E:\DocControlTest\*!**!*1*!*XLS"
F.Global.DocumentControl.GetDocument(39,V.Local.sRet)
```

### CreateReference Key Format
Keys are fixed-width concatenated fields. Use `GetLinkID` to check if a reference exists first (returns -1 if not found). `CreateReference` creates a new record or returns the existing ID.
```
V.Local.sKey.Set("PartNumber")
F.Global.DocumentControl.CreateReference(V.Local.sKey,30,V.Local.iReturnId)
```

| Type | Key Format | Field Widths |
|------|-----------|--------------|
| 20 | JobSuffix | Job(6) + Suffix(3). e.g. `"500003002"` |
| 25 | JobSuffixSequence | Job(6) + Suffix(3) + Sequence(6). e.g. `"500003002001000"` |
| 30 | PartRev | Part(20) + Rev(2). e.g. `"1234321             44"` (space-padded) |
| 31 | PartRevLocationLotBinHeatSerial | Part(20) + Rev(2) + Location(2) + Lot(15) + Bin(6) + Heat(15) + Serial(30) |

### AddDocument Overloads
```
' Minimal (4 params)
F.Global.DocumentControl.AddDocument(V.Local.iLinkId,"Testfile.txt","a sample file",1)
' With file type (5 params)
F.Global.DocumentControl.AddDocument(V.Local.iLinkId,"Testfile.txt","a sample file",1,"txt")
' Full (7 params)
F.Global.DocumentControl.AddDocument(V.Local.iLinkId,"Testfile.txt","a sample file",1,"txt",True,False)
```

### Invoke Example
```
V.Local.iPID.Declare
F.Global.DocumentControl.Invoke(".50MDF           D",30,"Part document control...",V.Local.iPID)
' DCCKey=".50MDF           D" (part/rev), DCCKeyType=30 (Inventory Master), PID returns async process ID
```

### Document Control Workflow (from ATG_DocControl_V2.g2u)
Real-world pattern for adding documents with security checks:
```
' 1. Receive key and type from caller (zero-padded to 5 chars)
V.Local.sType.Set(V.Passed.DATA-LINK-TYPE)
V.Local.sKey.Set(V.Passed.DATA-LINK-KEY)
F.Intrinsic.String.LPad(V.Local.sType,"0",5,V.Local.sType)

' 2. Get or create the Link ID (version-dependent)
F.Intrinsic.String.Split(V.Caller.GSSVersion,".",V.Local.sVersion)
F.Intrinsic.Control.If(V.Local.sVersion(0),=>,"2016")
    F.Global.DocumentControl.GetLinkID(V.Global.sKey,V.Global.sType,V.Global.iActiveLinkID)
F.Intrinsic.Control.Else
    F.Global.DocumentControl.CreateReference(V.Global.sKey,V.Global.sType,V.Global.iActiveLinkID)
F.Intrinsic.Control.EndIf

' 3. Check user security (skip for SUPERVSR)
F.Intrinsic.Control.If(V.Caller.User,<>,"SUPERVSR")
    F.Global.DocumentControl.CheckUserLinkSecurity(V.Global.sType.Long,V.Caller.User,V.Local.iSecurity)
    F.Intrinsic.Control.If(V.Local.iSecurity,=,0)
        F.Intrinsic.Control.ExitSub
    F.Intrinsic.Control.EndIf
F.Intrinsic.Control.EndIf

' 4. Ensure Link_Data record exists before adding (defensive re-check)
F.Global.DocumentControl.CreateReference(V.Global.sKey,V.Global.sType,V.Global.iActiveLinkID)

' 5. Add document with full params
F.Global.DocumentControl.AddDocument(V.Global.iActiveLinkID,V.Local.sFileName,V.Local.sDescription,V.Local.iGroup,V.Caller.User,V.Local.sFileType,False,V.Local.bRev)

' 6. Print a document
F.Global.DocumentControl.PrintDocument(V.Local.sFilePath)
```

### Key Construction by LinkType (from V.Passed fields)
| LinkType | Key Built From | Description Format |
|----------|---------------|-------------------|
| 20 (WO Master) | `Job + "-" + Suffix` | `Job-Suffix` |
| 25 (WO Operation) | `Job + "-" + Suffix + "-" + Sequence` | `Job-Suffix-Sequence` |
| 30 (Inventory) | `Part + Rev` (concatenated) | Part/Rev key |
| 37 (Router Seq) | `Router + "-" + Sequence` | `Router-Sequence` |
| 41 (Fixed Assets) | Key from passed data | Description from field 009004 |
| 62 (Vendor Quotes) | Key from passed data | Description from field 009005 |

## Global.General
```
F.Global.General.CallWrapperAsyncBio(Mode as Long, Params as String)  ' These commands launch wrapped Global Shop processes (indicated by a long inte...
F.Global.General.CheckSig(Filename, ReturnVariable)  ' Description
F.Global.General.GetMenuPathFromProg(Program, Flag, Return)
F.Global.General.GetPassedIDFromHandle(Handle, ReturnVariable)
F.Global.General.GetServiceWebToken(UserName, Password, Return Token)  ' Retrieves Service Web Token from the crendentials passed by the user
F.Global.General.GSSVersionCheck()  ' This function returns a boolean value to indicate if the specified target GSS...
F.Global.General.InvokeWithLaunchFile(Element List, FQP of Program to Launch, Program Name)
F.Global.General.IsHookActive()  ' This function evaluates a delimited string of hook numbers, and returns a Boo...
F.Global.General.IsInUpdate()  ' This function returns a boolean, indicating if the GAB program is being calle...
F.Global.General.IsLicensed(Module, ReturnVariable)
F.Global.General.IsLicensedByModuleName(Module Name, Return)
F.Global.General.IsOLURunning(Return)
F.Global.General.LaunchGssHelpPage  ' Launches Gss Help page by validating the user credentials
F.Global.General.LaunchHelpPage()  ' This function launches browser that is directed to the specified Global Shop ...
F.Global.General.OverrideCompany(CompanyCode)
F.Global.General.ReadCompanyName()  ' This function returns the company name, given a company code. Note: This com...
F.Global.General.ReadLibraryReferences()  ' This function returns a string, delimited with *!*, containing the include fi...
F.Global.General.ReadOptionCommon(Id, Suffix, Sequence, DataType, DefaultValue, Return)  ' This function reads an option value in the common database, given an ID numbe...
F.Global.General.ReadSoftLock(Mode [String], Key [String], Return [Long])  ' This command checks for the presence of a soft lock by using the provided mod...
F.Global.General.RegisterProcess()  ' This function registers a process with the menu. Registered processes will k...
F.Global.General.SaveOptionCommon(Id, Suffix, Sequence, DataType, Value)  ' This function saves an option value in the common database, given an ID numbe...
F.Global.General.SignalSP2()
F.Global.General.SignGAS(Filename)
F.Global.General.SpellCheck()  ' This function checks/corrects the passed text, returning the corrected text. ...
F.Global.General.SpellingErrorsPresent()  ' This function checks the passed text, and returns a True if the spell checkin...
```

## Global.Hook
```
F.Global.Hook.AddHookSequenceAssociation(HookNumber, SyncFlag, ScriptPath, ScriptName, TraceSeqFlag, ScriptType, Runtime, Notes, WidgetFlag, ReturnVariable)
F.Global.Hook.ReadPassedElement(Passed Element Name [String], Return Value [Any])  ' Reads passed element value passed from called gab program
F.Global.Hook.UpdateHookSequenceAssociation(HookNumber, HookSeq, SyncFlag, ScriptPath, ScriptName, TraceSeqFlag, ScriptType, Runtime, Notes, WidgetFlag)
```

## Global.HotFix
```
F.Global.HotFix.RollBack()  ' This function is used to rollback the last applied hotfix. Note: This command...
F.Global.HotFix.UnPack()  ' This function applies a hotfix to the current Global Shop installation. Note:...
F.Global.HotFix.Validate(FQHotfixFile, MD5Hash, HotfixDirectory)
```

## Global.International
```
F.Global.International.GetLabelTranslation(ID, Default, Language 0, Language1, Return)
F.Global.International.GetLanguagesByUsername()  ' This command will return the primary and secondary languages, in a string del...
```

## Global.Inventory
```
F.Global.Inventory.AddPartToBatch()  ' This function creates an inventory part in a batch to post in Global Shop. P...
F.Global.Inventory.CallSD(Part, Rev, Location, CompanyCode)
F.Global.Inventory.GetDisplayBOM()
F.Global.Inventory.GetDisplayCustomerPart(GssPart, Return Display Part)  ' Return customer display part and revision
F.Global.Inventory.GetDisplayManufacturerPart(GssPart, Dsiplay Part)  ' Return Manufacturer display part
F.Global.Inventory.GetDisplayPart(PartNumber, PartNumberRevision, ReturnDisplayPartResult)  ' This function retrieves the long part and revision, given the 17/3 part and r...
F.Global.Inventory.GetDisplayRouter()  ' This function retrieves the long router and revision, given the 17/3 router a...
F.Global.Inventory.GetDisplayUserPart(GssPart, Return Display Part)  ' Returns user display part
F.Global.Inventory.GetGSSBOM()
F.Global.Inventory.GetGSSCustomerPart(Display Part, Display Rev, Return GssPart)  ' Returns Customer Gss Part
F.Global.Inventory.GetGSSManufacturerPart(Display Part, Display Rev, Return GssPart)  ' Returns Manufacturer Gss Part
F.Global.Inventory.GetGSSRouter()  ' This function retrieves the short (20 character) router designator, given the...
F.Global.Inventory.GetGSSUserPart(Display Part, Display Rev, Return GssPart)  ' Returns User Gss Part
F.Global.Inventory.GetPartInfo(Part, Rev, Loc, ReturnVariable)  ' This function, given a part number, location, and (optionally) revision, retu...
F.Global.Inventory.PostPartBatch  ' This function posts the inventory part batch to Global Shop. This is used in ...
```

## Global.Mapper
```
F.Global.Mapper.CallMapper(Project, Table, Option, Override, Sync)
```

## Global.Messaging
```
F.Global.Messaging.ConsolidateEmails(MetaSearch, CompanyCode, UserID, CallingProgram, Subject, Sender, Body, ReadReceipt, MetaTarget)  ' This function will consolidate emails sent using the QueueMessage command.
F.Global.Messaging.CreateCompanyMessage(Company Code, Message, Priority, Start Date, Start Time, End Date, End Time, Expiry Date, Url, Source, NewArg)
F.Global.Messaging.CreateEMFMessage(RcptEmail, RcptName, SenderEmail, SenderName, Subject, Body)
F.Global.Messaging.CreateEMMessage(RecipientEmail, RecipientName, SenderEmail, SenderName, Subject, Body, Attachment, DeleteAttachment)
F.Global.Messaging.CreateInternalMessage(Recipient, Body)  ' Create and internal message
F.Global.Messaging.CreateSMSMessage(Carrier, SmsNumber, SenderEmail, Subject, Body)
F.Global.Messaging.DeleteMessage(Event ID)  ' Deletes the messages with the specified Event ID
F.Global.Messaging.GetCompanyPrimaryEmail()  ' This function returns the primary email address listed on the company (and no...
F.Global.Messaging.InternalMessageAddConfigurationCondition()  ' Adds a condition to the message configuration.
F.Global.Messaging.InternalMessageAddConfigurationRecipient(ConfigurationID, RecipientType, Recipient, PrimaryLanguageCode, SecondaryLanguageCode)  ' Add a recipient to the message configuration.
F.Global.Messaging.InternalMessageAddEventDynamicRecipient(Event ID, Dynamic Recipient ID)  ' Adds dynamic recipient to event
F.Global.Messaging.InternalMessageAddEventParameter(EventID, ParameterID, EventParameterIDReturned)  ' Adds the specified parameter to the event. Returns a unique ID that identifie...
F.Global.Messaging.InternalMessageAddEventParameterValue(EventParameterID, LiteralValue, DisplayNameInternationalID, DisplayName)  ' This is to be used when creating a parameter with discrete, limited number of...
F.Global.Messaging.InternalMessageCreateConfiguration(CompanyCode, NameInternationalID, Name, EventID, Enabled, AnyCondition, MessageTitle, MessageText, ConfigurationIDReturned)  ' Creates a new message configuration and returns the ID.
F.Global.Messaging.InternalMessageCreateConfigurationPreset(CompanyCode, NameInternationalID, Name, EventID, Enabled, AnyCondition, MessageTitle, MessageText, ConfigurationIDReturned)  ' Creates a new message configuration presset that is available from the Preset...
F.Global.Messaging.InternalMessageCreateDynamicRecipient(Passed Name, Display ID, Recipient Type, Return Dynamic Recipient UD)  ' Creates a dyamic recipient
F.Global.Messaging.InternalMessageCreateEvent(HookID, NameInternationalID, Name, EventIDReturned)  ' Creates a new message event that is available from the Event dropdown list wh...
F.Global.Messaging.InternalMessageCreateEventGSS(HookID, NameInternationalID, Name, EventIDReturned)  ' Same as the Function.Global.Messaging.InternalMessageCreateEvent command, but...
F.Global.Messaging.InternalMessageCreateParameter(PassedVariableName, DisplayNameInternationalID, DataType, BrowserID, ParameterIDReturned)  ' Creates a new parameter that can be used by events. Valid values for Data Typ...
F.Global.Messaging.InternalMessageDeleteConfiguration(ConfigurationID)  ' Deletes the configuration with the specified ID, along with its associated co...
F.Global.Messaging.InternalMessageDeleteConfigurationCondition()  ' Deletes the condition with the specified ID from the configuration.
F.Global.Messaging.InternalMessageDeleteConfigurationRecipient(RecipientID)  ' Deletes the recipient with the specified ID from the configuration.
F.Global.Messaging.InternalMessageDeleteFromQueue(QueueID)  ' Deletes the message with the specified ID from the users internal message que...
F.Global.Messaging.InternalMessageGetConfigurationConditions(ConfigurationID, ConditionsReturned)  ' Returns a double-delimited string of each configuration preset for the specif...
F.Global.Messaging.InternalMessageGetConfigurationPresetsForEvent(EventID, PresetsReturned)  ' Returns a double-delimited string of each configuration preset for the specif...
F.Global.Messaging.InternalMessageGetConfigurationRecipients(ConfigurationID, RecipientsReturned)  ' Returns a double delimited list of each recipient for the specified configura...
F.Global.Messaging.InternalMessageGetConfigurationsForCompany(CompanyCode, ConfigurationsReturned)  ' Returns a double-delimited string of each configuration for the specified com...
F.Global.Messaging.InternalMessageGetConfigurationsForEventName(CompanyCode, EventName, ConfigurationsReturned)  ' Returns a double-delimited string of each configuration for the specified com...
F.Global.Messaging.InternalMessageGetConfigurationsForEventNameID(CompanyCode, EventInternationalNameID, ConfigurationsReturned)  ' Returns a double-delimited string of each configuration for the specified com...
F.Global.Messaging.InternalMessageGetEventDynamicRecipients(Event ID, Return Recipients)  ' Returns dynamic recipients for the event
F.Global.Messaging.InternalMessageGetEventParameters(EventID, Parameters)  ' Returns a double-delimited string of each parameter for the specified event I...
F.Global.Messaging.InternalMessageGetEventParameterValues(EventID, ParameterID, Values)  ' Returns a double-delimited string of each discrete value for the specified pa...
F.Global.Messaging.InternalMessageGetEvents(EventsReturned)  ' Returns a double-delimited string of each event. Each event is delimited by *...
F.Global.Messaging.InternalMessageGetParameterID(ParameterPassedName, ParameterIDReturned)  ' Returns the ID of the parameter with the specified name.
F.Global.Messaging.InternalMessageGetQueueForUser(UserID, MessagesReturned)  ' Returns a double-delimited string of all the messages in the queue of the spe...
F.Global.Messaging.InternalMessageUpdateConfiguration(ConfigurationID, NameInternationalID, Name, EventID, Enabled, AnyCondition, MessageTitle, MessageText)  ' Update the specified configuration.
F.Global.Messaging.InternalMessageUpdateConfigurationCondition(ConditionID, ParameterID, Operation, ValueType, ValueParameterID, Value)  ' Update the specified configuration condition.
F.Global.Messaging.InternalMessageUpdateConfigurationRecipient(MessageRecipientID, RecipientType, Recipient, PrimaryLanguageCode, SecondaryLanguageCode)  ' Update the specified configuration recipient.
F.Global.Messaging.InternalMessageUpdateQueueMessageStatus(QueueID, Status)  ' Updates the status of the specified message. Status: 0 = Unread, 1 = Read, 2 = Archived
F.Global.Messaging.IsCourierRunning()  ' This function returns a long integer indicating the following: 0 - Courier is...
F.Global.Messaging.ResendMessage(EHID, boolean return)  ' This function re-sends an email previously sent through Courier, using the sp...
```

## Global.Mobile
```
F.Global.Mobile.GetCustomHeader()  ' This function will return the following header information from Wireless_head...
F.Global.Mobile.GetCustomLine()  ' This function will return all the field values on a transaction seperated by ...
```

## Global.Object
```
F.Global.Object.CallMethod(ObjectName, DBObjectName, ConnectionIndex, MethodName, Mode, Parameter0, Return)
F.Global.Object.CloseConnection(ObjectName, ConnectionIndex)  ' Dispose EO Object
F.Global.Object.Delete(DataObjectName, DBObjectName, DBConnectionIndex, Status)
F.Global.Object.ExportToMessagePackFile(Filepath, Name)  ' Exports the datatable to the specified message pack file
F.Global.Object.ExportToXML(DataObjectName, FilePath)  ' This function will serialize a object and save the objects current state in t...
F.Global.Object.GetMaxvalue(Name, Property Name, Return )  ' Returns the maximum value of the property in the specified object collection
F.Global.Object.GetMethod(Object Name, Method Name, Optional Method Arguments N, Return Method Instance Name)  ' Creates and returns the instance of the object method
F.Global.Object.GetMinValue(Object Name, Property Name, Return variable)  ' Returns the minimum value of the property in the specified object collection
F.Global.Object.ImportFromMessagePackFile(FilePath, Datatable Name)  ' Imports the datatable from the specified message pack file
F.Global.Object.ImportFromXML(DataObjectName, FilePath)  ' This function will deserialize a xml and restore a object to the state save i...
F.Global.Object.ImportFromXMLCollection(DataObjectName, FilePath)  ' This function will deserialize a xml and restore a collection object to the s...
F.Global.Object.InvokeMethod(Object Name, Method Instance Name, Methods arguments N, Return)  ' Invokes the GSSEO method retrieved using GetMethod command
F.Global.Object.Load(DataObjectName, DBObjectName, DBConnectionIndex, ModeNumber, Arg#, StatusCodeReturn)  ' This would load a collection data object with all parts with a part number ra...
F.Global.Object.LoadChildObject(Parent Object Name, Child EO Type, Child Mode Number, Parent Mode Parameters)  ' Loads a child object using the Mode paramters from the parent object
F.Global.Object.LoadDatatableFromObject(Object Name, Datatable Name, [Global Scope])  ' Populates datatable with rows from GSSEO object
F.Global.Object.LoadDictionary(Dictionary Name, Object Name, Key Property, Value Property)  ' Loads the Object properties into a dictionary
F.Global.Object.LoadDistinct(Object Name, Mode Number, Distinct Key, Args N, Status Code Return)  ' Loads the distinct object collection based on the key specified
F.Global.Object.LoadLookUp(Object Name, Object type, Global)  ' Loads the specified lookup object collection
F.Global.Object.LoadNewFromCurrent(Current Object Name, New Object Name, New Object EO type, New Object Mode Number, Mode paramters, Filter Criteria N)  ' Loads a new object from current object
F.Global.Object.OpenConnection(DBObjectName, CompanyCode, Return)
F.Global.Object.OverridePath(FullyQualifiedPath)
F.Global.Object.RefreshLookUp(Object Name)  ' Refreshes the loaded look up object
F.Global.Object.RemoveAt(Name, Ordinal)  ' This command removes a row(s) from an object collection
F.Global.Object.SetDefaultValue(Object Name, Property Name, Default Value)  ' Sets the default value of a property in the object collection
F.Global.Object.SetValue(ObjectName, PropertyName, PropertyValue)  ' This command is used to set a property value in a single instance object or a...
F.Global.Object.Update(DataObjectName, StatusCodeReturn)  ' In order to use this method, you would first use Function.Global.Object.SetVa...
```


## Global.Presentation
```
F.Global.Presentation.ClearChart(ChartName, MemberOf, MemberName, ReturnVar)  ' Function.Global.Presentation.ClearChart
F.Global.Presentation.RenderChart(ChartName, OutputPath, Overwrite, ReturnVar)  ' Function.Global.Presentation.RenderChart
F.Global.Presentation.SetChartProperty(ChartName, MemberOf, MemberOrdinal, Property, Value, ReturnVar)  ' Description
```

## Global.PDT
```
F.Global.PDT.Playback()  ' Launches PDT (Process Definition Tool) playback
F.Global.PDT.PlaybackFile(Filename, LongPIDReturn)  ' Plays back a PDT recording from the specified file; Filename as String, LongPIDReturn as Long (PID of launched process)
F.Global.PDT.PlaybackID(PDTID, LongPIDReturn)  ' Plays back a PDT recording by its ID; PDTID as Long, LongPIDReturn as Long (PID of launched process)
F.Global.PDT.Record()  ' Starts a PDT recording session
```

## Intrinsic.PDT
The `F.Intrinsic.PDT.*` namespace provides parameterized PDT commands (vs the simpler `F.Global.PDT.*` wrappers above).
```
F.Intrinsic.PDT.PlayBack(ModuleID, SelectionID, JobStream, Return)  ' Plays back a PDT recording; ModuleID as Long, SelectionID as Long, JobStream as Long, Return as String
F.Intrinsic.PDT.PlayBackFile(FileName, Return)  ' Plays back a PDT recording from file; FileName as String, Return as String
F.Intrinsic.PDT.PlayBackID(ID, Return)  ' Plays back a PDT recording by ID; ID as Long, Return as String
F.Intrinsic.PDT.Record(ModuleID, SelectionID, JobStream, FileName, Return)  ' Starts a PDT recording; ModuleID as Long, SelectionID as Long, JobStream as Long, FileName as String, Return as Long
```

## Global.Security
```
F.Global.Security.CheckUserAccess(Username, CompanyCode, Program, ReturnVariable)  ' DEPRECATED since 2010. Use F.Global.Security.CheckUserAccessIPM instead.
F.Global.Security.CheckUserFunctionFeatureToggle(UserID [Long], FunctionID [Long], CompanyCode [String], ReturnVariable [Long])  ' Determines whether a User, Group, or Company should use the new program, old ...
F.Global.Security.CheckUserFunctionPermission(UserID [Long], FunctionID [Long], CompanyCode [String], ReturnVariable [Boolean])  ' Checks whether a User, Group, or Company has access permissions associated wi...
F.Global.Security.GetAllUserGroups(CompanyCode, ReturnVariable)
F.Global.Security.GetAllUsers(CompanyCode, ReturnVariable)
F.Global.Security.GetFullName(Username, CompanyCode, ReturnVariable)
F.Global.Security.GetGroupEmails(Group, CompanyCode, ReturnVariable)
F.Global.Security.GetGroupMembers(Group, CompanyCode, ReturnVariable)
F.Global.Security.GetGroupNameFromGroupID()  ' This command will return the name of the group when passed the group ID. Func...
F.Global.Security.GetLoggedInTerminalCount(ReturnVariable)  ' This command returns the number of users currently logged into Global Shop.
F.Global.Security.GetLoggedInTerminalNumbers(ReturnVariable)  ' This command returns the terminal numbers currently logged into Global Shop.
F.Global.Security.GetPaygroupsFromUserID()  ' This function returns a string value containing the paygroup membership(s) as...
F.Global.Security.GetUserFromEmail(Email, Return)
F.Global.Security.GetUserFromEmpNo(EmpNo, ReturnVariable)  ' Description
F.Global.Security.GetUserGroupsByID()
F.Global.Security.GetUsernameFromID()  ' This function returns a string value containing the Global Shop username and ...
F.Global.Security.UpdateMenuBI(Function, System, Menu, Description, BiReportId, CompanyCode)
F.Global.Security.UpdateMenuGAB(Function, System, Menu, Description, HookNumber, CompanyCode)
F.Global.Security.ValidateUser(CompanyCode, User, Password, ReturnVariable)
```

## Global.ShipIntegration
```
F.Global.ShipIntegration.AddPackage(Session ID, Weight, Length, Width, Height, Package Type, Reference 0, Reference1, Reference2, Reference3, Reference4, Value, InsValue, COD Type)  ' Adds package to ship session
F.Global.ShipIntegration.ClearAllSessions()  ' Clears all ship sessions
F.Global.ShipIntegration.ClearSession(Session ID)  ' Clears a ship session
F.Global.ShipIntegration.CloseShipments()  ' Closes the shipments
F.Global.ShipIntegration.DeletePackage(Session ID, Package)  ' Deletes the package from the specified session
F.Global.ShipIntegration.GetRates(Provider, Sender Address 1, Sender Address 2, Sender State, Sender Zip, Recipient Address 1, Recipient Address 2, Recipient State, Recipient Zip, Package Info, Configuration, Sender Country Code, Recipient Country Code, Return)
F.Global.ShipIntegration.GetSessionID(Order, Suffix, Packing Number, Return Session ID)  ' Returns the session ID
F.Global.ShipIntegration.QuoteSession(Provider, Return)
F.Global.ShipIntegration.RawRequest(Control Type, File Path)
F.Global.ShipIntegration.RawResponse(Control Type, File Path)
F.Global.ShipIntegration.ReadAccount(Provider, Return)
F.Global.ShipIntegration.SaveAccount(ShipType, Enabled, TestMode, MeterNumber, DevKey, AccountNumber, AccessKey, UserName, Password, DocControl, DocGroup)  ' 11-param: basic account with doc control
F.Global.ShipIntegration.SaveAccount(ShipType, Enabled, TestMode, MeterNumber, DevKey, AccountNumber, AccessKey, UserName, Password, GssUser, Address1, Address2, City, State, Zip, Country, Phone, Email, ContactName, Company)  ' 20-param: with address info
F.Global.ShipIntegration.SaveAccount(ShipType, Enabled, TestMode, MeterNumber, DevKey, AccountNumber, AccessKey, UserName, Password, GssUser, Address1, Address2, City, State, Zip, Country, Phone, Email, ContactName, Company, Scale)  ' 21-param: with address + scale
F.Global.ShipIntegration.SetSessionAddress(Session ID, Add Type, Address1, Address2, City, State, Zip, Phone, Email, FirstName, LastName, Company, Country Code)
F.Global.ShipIntegration.ShipSession(Session ID, Configuration)
F.Global.ShipIntegration.StartSession(Provider, User ID, Payor Type, Service Type, Payor Account, Payor Zip, Payor Country Code, Order, Suffix, Packing Number)
F.Global.ShipIntegration.TrackShipment(Provider, Tracking Number, Show Scan Activity, Configuration)
F.Global.ShipIntegration.UPSValidation(Cert)
F.Global.ShipIntegration.ValidateAddress(Provider, Address1, Address2, City, State, Zip, Configuration)
F.Global.ShipIntegration.VoidPackage(Provider, Master Tracking Number, Tracking Number, Configuration)
F.Global.ShipIntegration.VoidShipment(Provider, Session ID, Cert)
```

## Global.SSF
SSF (Settings Storage File) provides INI-style key/value persistence. **Constraints:** No `=` in key names. No CrLf in any parameter.
```
F.Global.SSF.ReadFile(Filename, ReturnVariable)  ' Loads SSF file; Filename as String, ReturnVariable as Boolean (True=file found)
F.Global.SSF.ReadItem(Section, Key, User, Default, ReturnVariable)  ' Reads item; all String. Default returned if key not found. User="" for global or V.Caller.User for user-specific
F.Global.SSF.WriteItem(Section, Key, User, Value)  ' Writes item; all String. User="" for global or V.Caller.User for user-specific
F.Global.SSF.WriteFile(Filename)  ' Saves SSF file to disk; Filename as String
```

### SSF Workflow
```
' Read
F.Global.SSF.ReadFile("MySettings.ssf",V.Local.bFound)
F.Global.SSF.ReadItem("GridLayout","ColumnOrder","","default_value",V.Local.sValue)
F.Global.SSF.ReadItem("UserPrefs","Theme",V.Caller.User,"Light",V.Local.sTheme)

' Write
F.Global.SSF.WriteItem("GridLayout","ColumnOrder","",V.Local.sColumnOrder)
F.Global.SSF.WriteItem("UserPrefs","Theme",V.Caller.User,"Dark")
F.Global.SSF.WriteFile("MySettings.ssf")
```

## Global.Task
```
F.Global.Task.InvokeWithLaunchFile(AdditionalData String. ProgramPath String, ProgramName String, ReturnProcessID Long)  ' Function for Launching External Programs with Context Variables
```

## Global.VMS
```
F.Global.VMS.AddFile()  ' This command adds a Document Control file to VMS.
F.Global.VMS.AddToHistory()  ' This command adds a VMS file to the database to store a revision.
F.Global.VMS.CancelCheckOut(FileID)  ' This command cancels the checking out of a file to the current user.
F.Global.VMS.CheckIn(FileID)  ' This command checks a file back into VMS. If Shadow Directory is left blank, ...
F.Global.VMS.CheckOut(FileID, Notes, OpenFile)  ' This command checks out a VMS document to the current user. If Working Direct...
F.Global.VMS.GetFileTypeMaxVersions(FileExtension)  ' This command returns the maximum number of revisions that will be stored in t...
F.Global.VMS.GetInfoFromFID(FID, Return)
F.Global.VMS.GetSecurity(FileType, LinkType, UserID)  ' This command returns the security level as a long for the given File Type, Li...
F.Global.VMS.GetShadowDirectory()  ' This command returns the default Shadow Directory set up in VMS Options.
F.Global.VMS.GetVMSInfo(FileID)  ' This command returns a delimited string of information for the given VMS File...
F.Global.VMS.GetWorkingDirectory()  ' This command returns the default Working Directory set up in VMS Options.
F.Global.VMS.IsInVMS(FileID)  ' This command checks to see if a file is in VMS, and returns a boolean value.
F.Global.VMS.RemoveFile(FID, Directory)
```

## Global.WebService
```
F.Global.WebService.IssueCommand()  ' This function executes commands on Global Shop web services. Note: This comma...
F.Global.WebService.LoadImplementationPlan(DatatableName, ImplementationPlanID)
```


# OCTSRS Component Reference (Runtime Implementation)

## Component Reference: BdfComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\BdfComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\BdfComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~1,356 lines

### Runtime purpose
The BDF (Binary Data File) Component manages delimited string data files with structured columns and rows. Despite the name, it appears to be a text-based delimited file format.

### Implementation notes (OCTSRS)
#### Legacy Behavior
- Uses custom cBDF class for data storage
- Supports loading to DataTable format
- Column data types tracked separately

#### File Format
- Delimited string format (not binary despite name)
- Supports multiple BDF files in memory
- Each BDF identified by name and ID

#### Migration Notes
- No database interaction
- File I/O operations
- Consider modern alternatives (JSON, CSV)

### Dependencies
#### Components Called
- None directly

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `CLONE` | Clone a BDF structure |
| `REPLACEANDSAVE` | Replace data and save |
| `ADDCOLUMN` | Add a column |
| `READCOLUMNCOUNT` | Get column count |
| `READCOLUMNDATATYPE` | Get column data type |
| `READCOLUMNTITLE` | Get column title |
| `SETCOLUMNTITLE` | Set column title |
| `WRITEROW` | Write a row |
| `SEEKROW` | Seek to a row |
| `READROWCOUNT` | Get row count |
| `TEXTMATRIX` | Access data by row/column |
| `READTITLE` | Read BDF title |
| `READKEY` | Read BDF key |

### Key method signatures & edge cases
#### `LOAD`
**GAB Syntax:** `Subroutine.Global.Bdf.BdfName.Load(FilePath, ID, [LoadToDataTable])`

**Purpose:** Loads a BDF file into memory.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FilePath | String | Yes | Path to BDF file |
| 2 | ID | String | Yes | BDF identifier |
| 3 | LoadToDataTable | Boolean | No | Load to DataTable format |

#### `TEXTMATRIX`
**GAB Syntax:** `Function.Global.Bdf.BdfName.TextMatrix(Row, Column, Variable.Local.Value)`

**Purpose:** Gets or sets a value at a specific row/column position.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Row | Integer | Yes | Row index |
| 2 | Column | Integer | Yes | Column index |
| R | Value | String | Yes | Return - Cell value |

#### `READROW`
**GAB Syntax:** `Function.Global.Bdf.BdfName.ReadRow(RowIndex, Variable.Local.RowData)`

**Purpose:** Reads an entire row as delimited string.

#### `WRITEROW`
**GAB Syntax:** `Subroutine.Global.Bdf.BdfName.WriteRow(RowIndex, RowData)`

**Purpose:** Writes data to a specific row.

---

## Component Reference: BiometricComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\BiometricComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\Biometrics\BiometricComponent.vb`
- **Feature toggle:** `edb4a3a5-ab68-4bb1-94fe-2339639a3db1`
- **OCTSRS conversion status:** ADO.NET Methods Created (Limited Testing Due to Hardware Dependency)
- **Implementation size:** ~1,400 lines (including ADO.NET methods)

### Runtime purpose
The Biometric Component manages fingerprint scanner integration for employee time tracking and identification. It leverages SecuGen fingerprint scanner hardware and SDK for biometric authentication.

### Implementation notes (OCTSRS)
#### Legacy Behavior
- Uses `BiometricWrapper` class for SecuGen SDK integration
- Event-driven fingerprint scanning via `FingerScanned` event
- Fingerprint data stored as encrypted BLOB in database

#### Hardware Configuration
- Device ID (DID) typically represents which finger (1-10)
- Multiple fingerprints can be registered per employee
- Capture and match thresholds are configurable

#### Known Issues
- Requires specific SecuGen hardware drivers
- Device must be connected before `STARTIO`

#### Migration Notes
- ADO.NET methods created for all database operations:
  - `CountFingerprintsAdoNet` - Count fingerprints with parameterized queries
  - `RetrieveRemoteFingerprintAdoNet` - Retrieve and delete remote fingerprints
  - `DeleteFingerprintAdoNet` - Delete fingerprints (BiometricWrapper)
  - `CacheBioDataAdoNet` - Cache fingerprint data from database (BiometricWrapper)
  - `SaveFingerprintAdoNet` - Save fingerprints with INSERT/UPDATE (BiometricWrapper)
  - `DeleteInvalidFingerprintAdoNet` - Delete invalid fingerprints by BIID (BiometricWrapper)
- Feature toggle implemented with GUID: `edb4a3a5-ab68-4bb1-94fe-2339639a3db1`
- Unit tests created with argument validation; hardware-dependent tests documented as skipped
- Table existence checks use `ActianCompanySqlConnection.HasTable()`
- Connection type: Company database (ActianCompanySqlConnection)

#### Hardware Testing LimitationsThe BiometricComponent is heavily dependent on SecuGen fingerprint scanner hardware. The following tests were skipped due to hardware requirements:
- Success path tests for all methods (require fingerprint scanner initialization, error `999000`)
- Remote fingerprint identification tests (require hardware + database setup)
- Fingerprint capture and save tests (require live fingerprint scan)
- Reconcile fingerprints tests (require cached data from hardware initialization)

Unit tests cover:
- Argument count validation (error 405)
- Missing argument validation (error 401)
- Table existence validation where applicable (errors 250000/250001)

### Dependencies
#### Components Called
- `UiComponent` - For setting UI variables (BIOMETRICSCANTIMEOUT)

#### Called By
- Time and attendance screens
- Employee login/authentication
- Shop floor terminals

#### External Dependencies
- SecuGen.FDxSDKPro.Windows SDK
- GlobalShop.Encryption

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `SETCAPTURETIMEOUT` | Set capture timeout duration |

### Key method signatures & edge cases
#### `SAVEFINGERPRINT`
**GAB Syntax:** `Function.Global.Biometric.SaveFingerprint(EmployeeID, DeviceID, [Append], Variable.Local.BiometricID)`

**Purpose:** Registers an employee's fingerprint in the system.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | EmployeeID | String | Yes | Employee identifier (EID) |
| 2 | DeviceID | Integer | Yes | Device/finger identifier (DID) |
| 3 | Append | Boolean | No | Append to existing or replace |
| R | BiometricID | String | Yes | Return - Biometric ID (BIID) |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| EMP_Biometric | INSERT/UPDATE | Store fingerprint template data |

**Error Codes:**

| Code | Condition |
|------|-----------|
| 250000 | EMP_Biometric table does not exist |
| 405 | Wrong argument count |

#### `DELETEFINGERPRINT`
**GAB Syntax:** `Subroutine.Global.Biometric.DeleteFingerprint(EmployeeID, DeviceID)`

**Purpose:** Removes an employee's fingerprint from the system.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | EmployeeID | String | Yes | Employee identifier |
| 2 | DeviceID | Integer | Yes | Device/finger identifier |

#### `FINGERPRINTCOUNT`
**GAB Syntax:** `Function.Global.Biometric.FingerprintCount([EmployeeID], Variable.Local.Count)`

**Purpose:** Returns the number of registered fingerprints for an employee.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | EmployeeID | String | No | Employee ID (optional - if omitted, counts all) |
| R | Count | String | Yes | Return - Count of fingerprints |

---

## Component Reference: CannyComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\CannyComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\Cannys\CannyComponent.vb`
- **Feature toggle:** `1bccbea5-78c9-4cf0-b207-7bfdfc3ed945` (for email lookup)
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~115 lines

### Runtime purpose
The Canny Component provides integration with Canny.io for feedback collection and feature request management.

### Implementation notes (OCTSRS)
#### Feature Toggle
- Uses feature toggle for email lookup method
- ADO.NET version available when enabled

#### Token Management
- Caches Canny token
- HasCannyToken property for validation

#### Migration Notes
- Modern MediatR pattern
- Clean architecture
- Feature toggle controlled

### Dependencies
#### External Dependencies
- MediatR library
- Canny.io API

#### Components Called
- `GlobalShopSecurityComponent` - For user email

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `GETCANNYTOKEN` | Get Canny authentication token |
| `SENDCANNYFEEDBACK` | Send feedback to Canny |

### Key method signatures & edge cases
#### `GETCANNYTOKEN`
**GAB Syntax:** `Function.Global.Canny.GetCannyToken(Variable.Local.Token)`

**Purpose:** Retrieves a Canny authentication token for the current user.

**Returns:** String - Canny SSO token

#### `SENDCANNYFEEDBACK`
**GAB Syntax:** `Subroutine.Global.Canny.SendCannyFeedback(FeedbackData)`

**Purpose:** Sends user feedback to Canny.io.

---

## Component Reference: CreditCardComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\CreditCardComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\CreditCardComponent.vb`
- **Feature toggle:** `TBD - Check Components_FeatureToggles.xlsx`
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~1,360 lines

### Runtime purpose
The Credit Card Component handles credit card payment processing using the NSoftware InPay (now 4D Payments) library. It provides comprehensive payment gateway integration for authorization, capture, refunds, and validation.

### Implementation notes (OCTSRS)
#### Security Considerations
- **PCI Compliance Required**: Card data handling must follow PCI-DSS
- Passwords stored encrypted
- Card numbers should not be logged
- CVV should never be stored

#### Legacy Behavior
- Uses NSoftware InPay (now 4D Payments) library
- `Icharge` class for transactions
- `Cardvalidator` class for validation
- Gateway configuration stored in database

#### Transaction Flow1. Set account info (if not already configured)
2. Authorize (or Charge for immediate capture)
3. Capture (if using auth-only)
4. Void or Refund as needed

#### Error Handling
- Gateway errors returned in response
- Network timeouts handled
- Invalid card formats caught by validation

#### Known Issues
- Gateway timeouts may require retry logic
- Some gateways have different parameter requirements
- Test mode vs production mode configuration

#### Migration Notes
- Uses ADODB Recordset for configuration storage
- Connection type: Company database (ActianCompanySqlConnection)
- Sensitive data handling requires special attention
- Consider PCI compliance during refactoring

### Dependencies
#### Components Called
- `GlobalShopComponent` - For GSS integration

#### Called By
- Sales order payment screens
- Invoice payment processing
- Point of sale systems
- Customer portal payments

#### External Dependencies
- DPayments.InPay library
- Network connectivity to payment gateway
- PCI-compliant environment

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `AUTHORIZEONLY` | Authorize without capture |
| `CREDIT` | Issue a credit to a card |
| `AVSONLY` | Address verification only |
| `SAVECONFIGVALUE` | Save configuration value |
| `DELETEALLCONFIGS` | Delete all configurations |
| `GETGATEWAY` | Get payment gateway setting |
| `SETACCOUNTINFO` | Set merchant account info |
| `GETRESPONSEVALUE` | Get specific response value |

### Key method signatures & edge cases
#### `CHARGE`
**GAB Syntax:** `Function.Global.CreditCard.Charge(FirstName, LastName, Phone, State, Zip, CardNumber, CVS, ExpMonth, ExpYear, Amount, CardType, [Invoice], Variable.Local.Result)`

**Purpose:** Performs a complete sale transaction (authorize + capture).

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FirstName | String | Yes | Cardholder first name |
| 2 | LastName | String | Yes | Cardholder last name |
| 3 | Phone | String | Yes | Phone number |
| 4 | State | String | Yes | Billing state |
| 5 | Zip | String | Yes | Billing zip code |
| 6 | CardNumber | String | Yes | Credit card number |
| 7 | CVS | String | Yes | CVV/CVC security code |
| 8 | ExpMonth | Integer | Yes | Expiration month (1-12) |
| 9 | ExpYear | Integer | Yes | Expiration year (4-digit) |
| 10 | Amount | Double | Yes | Transaction amount |
| 11 | CardType | Integer | Yes | Card type code |
| 12 | Invoice | String | No | Invoice number |
| R | Result | String | Yes | Transaction result/ID |

**Extended Version (17 parameters):** Includes Address1, Address2, City, Country

#### `AUTHORIZEONLY`
**GAB Syntax:** `Function.Global.CreditCard.AuthorizeOnly(FirstName, LastName, Phone, State, Zip, CardNumber, CVS, ExpMonth, ExpYear, Amount, CardType, [Invoice], Variable.Local.Result)`

**Purpose:** Authorizes a card without capturing funds. Used for delayed capture scenarios.

**Business Rules:**
- Authorization holds funds on card
- Must be captured within gateway's time limit (typically 7-30 days)
- Returns authorization code for later capture

#### `CAPTURE`
**GAB Syntax:** `Function.Global.CreditCard.Capture(TransactionID, Amount, Variable.Local.Result)`

**Purpose:** Captures a previously authorized transaction.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | TransactionID | String | Yes | Original authorization ID |
| 2 | Amount | Double | Yes | Amount to capture (can be less than auth) |
| R | Result | String | Yes | Capture result |

#### `CREDIT`
**GAB Syntax:** `Function.Global.CreditCard.Credit(FirstName, LastName, Phone, State, Zip, CardNumber, CVS, ExpMonth, ExpYear, Amount, CardType, [Invoice], Variable.Local.Result)`

**Purpose:** Issues a credit to a card (not tied to a previous transaction).

#### `REFUND`
**GAB Syntax:** `Function.Global.CreditCard.Refund(TransactionID, Amount, Variable.Local.Result)`

**Purpose:** Refunds a previous transaction.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | TransactionID | String | Yes | Original transaction ID |
| 2 | Amount | Double | Yes | Amount to refund |
| R | Result | String | Yes | Refund result |

#### `VOID`
**GAB Syntax:** `Function.Global.CreditCard.Void(TransactionID, Variable.Local.Result)`

**Purpose:** Voids a transaction before settlement.

**Business Rules:**
- Can only void before batch settlement
- After settlement, must use REFUND instead

#### `AVSONLY`
**GAB Syntax:** `Function.Global.CreditCard.AVSOnly(FirstName, LastName, Phone, State, Zip, CardNumber, CVS, ExpMonth, ExpYear, Amount, CardType, [Invoice], Variable.Local.Result)`

**Purpose:** Performs address verification without charging the card.

**Returns:** AVS response code indicating address match status

#### `VALIDATE`
**GAB Syntax:** `Function.Global.CreditCard.Validate(CardNumber, Variable.Local.IsValid)`

**Purpose:** Validates card number format using Luhn algorithm.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | CardNumber | String | Yes | Card number to validate |
| R | IsValid | Boolean | Yes | True if valid format |

#### `SETACCOUNTINFO`
**GAB Syntax:** `Subroutine.Global.CreditCard.SetAccountInfo(MerchantID, Password, ...)`

**Purpose:** Sets merchant account credentials for the payment gateway.

---

## Component Reference: DataTableComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\DataTableComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\DataTableComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~4,515 lines

### Runtime purpose
The DataTable Component provides in-memory data table management for data manipulation, querying, and transformation operations.

### Implementation notes (OCTSRS)
#### In-Memory Storage
- DataTables stored in component's DataTables collection
- Each table identified by name and UID (call stack ID)
- Supports multiple tables per script

#### Query Language
- Uses System.Linq.Dynamic.Core for dynamic queries
- Supports SQL-like expressions
- Filter, sort, and compute operations

#### Serialization
- Supports JSON, XML, CSV formats
- ProtoBuf for efficient binary serialization
- Import/export for data exchange

#### Migration Notes
- Uses ADODB for some data loading
- Modern ADO.NET DataTable underneath
- No direct database modification (uses adapters)

### Dependencies
#### Components Called
- `GlobalShopComponent` - For GSS integration
- `StringComponent` - For part formatting

#### External Dependencies
- System.Data namespace
- Newtonsoft.Json for JSON operations
- ProtoBuf for serialization

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `ACCEPTCHANGES` | Accept pending changes |
| `CLONE` | Clone a DataTable |
| `CREATEFROMSQL` | Create from SQL query |
| `CREATEFROMRECORDSET` | Create from recordset |
| `CREATEFROMJSON` | Create from JSON |
| `CREATEFROMXML` | Create from XML |
| `ADDCOLUMN` | Add a column |
| `ADDDISPLAYPARTCOLUMN` | Add display part column |
| `GETCOLUMNCOUNT` | Get column count |
| `GETCOLUMNINDEX` | Get column index |
| `GETCOLUMNNAME` | Get column name |
| `GETCOLUMNTYPE` | Get column data type |
| `REMOVECOLUMN` | Remove a column |
| `RENAMECOLUMN` | Rename a column |
| `ADDROW` | Add a row |
| `DELETEROW` | Delete a row |
| `GETROWCOUNT` | Get row count |
| `INSERTROW` | Insert a row |
| `NEWROW` | Create new row |
| `GETCELLVALUE` | Get cell value |
| `SETCELLVALUE` | Set cell value |
| `GETROW` | Get row data |
| `SETROW` | Set row data |
| `SORT` | Sort rows |
| `AGGREGATE` | Aggregate operations |
| `COMPUTE` | Compute expression |
| `EXPORTTOCSV` | Export to CSV |
| `EXPORTTOJSON` | Export to JSON |
| `IMPORTFROMCSV` | Import from CSV |
| `SAVETODATABASE` | Save to database |
| `GETCHANGES` | Get changed rows |
| `REJECTCHANGES` | Reject changes |

### Key method signatures & edge cases
#### `CREATEFROMSQL`
**GAB Syntax:** `Subroutine.Global.DataTable.TableName.CreateFromSQL(ConnectionName, SQLQuery)`

**Purpose:** Creates a DataTable from a SQL query result.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | ConnectionName | String | Yes | Database connection name |
| 2 | SQLQuery | String | Yes | SQL query to execute |

#### `GETCELLVALUE`
**GAB Syntax:** `Function.Global.DataTable.TableName.GetCellValue(RowIndex, ColumnName, Variable.Local.Value)`

**Purpose:** Gets the value of a specific cell.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | RowIndex | Integer | Yes | Row index (0-based) |
| 2 | ColumnName | String | Yes | Column name |
| R | Value | Object | Yes | Return - Cell value |

#### `FILTER`
**GAB Syntax:** `Subroutine.Global.DataTable.TableName.Filter(Expression)`

**Purpose:** Filters rows based on an expression.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Expression | String | Yes | Filter expression |

**Example:** `"Status = 'Active' AND Amount > 100"`

#### `SAVETODATABASE`
**GAB Syntax:** `Subroutine.Global.DataTable.TableName.SaveToDatabase(ConnectionName, TableName, [KeyColumns])`

**Purpose:** Saves DataTable changes to a database table.

---

## Component Reference: DataViewComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\DataViewComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\DataViewComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~862 lines

### Runtime purpose
The DataView Component provides filtered and sorted views of DataTable data without modifying the underlying data.

### Implementation notes (OCTSRS)
#### View vs Copy
- DataView is a view, not a copy
- Changes affect underlying DataTable
- Use ToDataTable for independent copy

#### Performance
- Efficient for filtering large datasets
- Sort and filter without copying data

#### Migration Notes
- No database interaction
- Uses .NET DataView
- Integrates with DataTableComponent

### Dependencies
#### Components Called
- `DataTableComponent` - Source data

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `SETFILTER` | Set row filter |
| `SETSORT` | Set sort order |
| `SETROWVIEW` | Set row state filter |
| `SETSERIES` | Set series configuration |
| `DELETEROW` | Delete a row |
| `FILLFROMDICTIONARY` | Fill from dictionary |
| `TODATATABLEDISTINCT` | Convert with distinct rows |

### Key method signatures & edge cases
#### `CREATE`
**GAB Syntax:** `Subroutine.Global.DataView.ViewName.Create(DataTableName)`

**Purpose:** Creates a DataView from an existing DataTable.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | DataTableName | String | Yes | Source DataTable name |

#### `SETFILTER`
**GAB Syntax:** `Subroutine.Global.DataView.ViewName.SetFilter(FilterExpression)`

**Purpose:** Sets the row filter expression.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FilterExpression | String | Yes | Filter expression |

**Example:** `"Status = 'Active' AND Amount > 100"`

#### `SETSORT`
**GAB Syntax:** `Subroutine.Global.DataView.ViewName.SetSort(SortExpression)`

**Purpose:** Sets the sort order.

**Example:** `"LastName ASC, FirstName ASC"`

#### `TODATATABLE`
**GAB Syntax:** `Subroutine.Global.DataView.ViewName.ToDataTable(NewTableName)`

**Purpose:** Creates a new DataTable from the filtered/sorted view.

---

## Component Reference: DateComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\DateComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\DateComponent.vb`
- **Feature toggle:** `TBD - Check Components_FeatureToggles.xlsx`
- **OCTSRS conversion status:** Partially Converted (some methods have ADO.NET versions)
- **Implementation size:** ~927 lines

### Runtime purpose
The Date Component provides comprehensive date and time manipulation functions including date arithmetic, formatting, GL period conversions, and workday calculations.

### Implementation notes (OCTSRS)
#### Feature Toggle
- `GLPERIODFROMDATE` and `DATESFROMGLPERIOD` have feature toggle routing
- ADO.NET versions exist for some methods

#### Method Handler Pattern
- Uses dictionary-based method dispatch
- Part functions (YEAR, MONTH, etc.) handled separately

#### Workday Calculations
- Excludes Saturdays and Sundays
- Holiday exclusion may be configurable

#### Migration Notes
- Uses ADODB for GL period lookups
- Connection type: Company database
- Some methods already use modern patterns

### Dependencies
#### Components Called
- None directly

#### Database Tables
- `GL_Period` - For GL period lookups

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `HOUR` | Get hour from time |
| `MINUTE` | Get minute from time |
| `WEEKDAY` | Get day of week |
| `DATEDIFF` | Difference between dates |
| `DATECOMP` | Compare dates |
| `DATEADDWORKDAYS` | Add workdays to date |
| `DATESUBTRACTWORKDAYS` | Subtract workdays from date |
| `WORKDAYSBETWEENDATES` | Count workdays between dates |
| `WORKDAYSREMAINING` | Workdays remaining in period |
| `DATESERIAL` | Create date from parts |
| `TIMESERIAL` | Create time from parts |
| `DATETIMESERIAL` | Create datetime from parts |
| `COMBINEDATETIME` | Combine date and time |
| `BEGINNINGOFMONTH` | First day of month |
| `ENDOFMONTH` | Last day of month |
| `BEGINNINGOFWEEK` | First day of week |
| `ENDOFWEEK` | Last day of week |
| `GLPERIODFROMDATE` | Get GL period from date |
| `DATESFROMGLPERIOD` | Get dates from GL period |
| `CONVERTDSTRING` | Convert date string |
| `CONVERTTSTRING` | Convert time string |
| `TOJULIANDATE` | Convert to Julian date |
| `FROMJULIANDATE` | Convert from Julian date |
| `TIMEZONENAME` | Get time zone name |
| `UTCOFFSET` | Get UTC offset |
| `ISDST` | Check daylight saving time |
| `ISDATE` | Validate date string |
| `TIMECOMP` | Compare times |
| `HOURSMINUTESSECONDSTODECIMAL` | Convert time to decimal |

### Key method signatures & edge cases
#### `DATEADD`
**GAB Syntax:** `Function.Global.Date.DateAdd(Interval, Number, Date, Variable.Local.Result)`

**Purpose:** Adds a specified interval to a date.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Interval | String | Yes | Interval type (d, m, y, h, n, s) |
| 2 | Number | Integer | Yes | Number to add |
| 3 | Date | Date | Yes | Starting date |
| R | Result | Date | Yes | Return - Resulting date |

**Intervals:**
- `d` - Days
- `m` - Months
- `y` - Years
- `h` - Hours
- `n` - Minutes
- `s` - Seconds

#### `GLPERIODFROMDATE`
**GAB Syntax:** `Function.Global.Date.GLPeriodFromDate(Date, Variable.Local.Period, Variable.Local.Year)`

**Purpose:** Gets the GL period and year from a date.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Date | Date | Yes | Date to convert |
| R1 | Period | Integer | Yes | Return - GL period (1-13) |
| R2 | Year | Integer | Yes | Return - GL year |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| GL_Period | SELECT | GL period definitions |

#### `DATESFROMGLPERIOD`
**GAB Syntax:** `Function.Global.Date.DatesFromGLPeriod(Period, Year, Variable.Local.StartDate, Variable.Local.EndDate)`

**Purpose:** Gets the start and end dates for a GL period.

#### `DATEADDWORKDAYS`
**GAB Syntax:** `Function.Global.Date.DateAddWorkdays(Date, Days, Variable.Local.Result)`

**Purpose:** Adds workdays (excluding weekends) to a date.

#### `WORKDAYSBETWEENDATES`
**GAB Syntax:** `Function.Global.Date.WorkdaysBetweenDates(StartDate, EndDate, Variable.Local.Count)`

**Purpose:** Counts workdays between two dates.

---

## Component Reference: DictionaryComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\DictionaryComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\DictionaryComponent.vb`
- **Feature toggle:** `TBD - Check Components_FeatureToggles.xlsx`
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~784 lines

### Runtime purpose
The Dictionary Component provides key-value pair storage for in-memory data management with support for case-sensitive or case-insensitive keys.

### Implementation notes (OCTSRS)
#### Case Sensitivity
- Default is case-insensitive
- Can be set at creation time
- Affects key lookups and comparisons

#### Feature Toggle
- `CREATEFROMSQL` has feature toggle check
- Also has Pervasive version check

#### Memory Management
- Dictionaries stored in component collection
- Should be closed when no longer needed
- Named by uppercase trimmed identifier

#### Migration Notes
- Uses ADODB for SQL operations
- Connection type: Varies by usage
- Consider ADO.NET conversion for CREATEFROMSQL

### Dependencies
#### Components Called
- None directly

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `REMOVEITEM` | Remove an item |
| `UPDATEITEM` | Update an item |
| `KEYEXISTS` | Check if key exists |
| `CREATEFROMSQL` | Create from SQL query |
| `CREATEFROMDATATABLE` | Create from DataTable |
| `CREATEFROMDATAVIEW` | Create from DataView |
| `GETCOUNT` | Get item count |
| `GETKEYS` | Get all keys |
| `GETVALUES` | Get all values |

### Key method signatures & edge cases
#### `CREATE`
**GAB Syntax:** `Subroutine.Global.Dictionary.DictionaryName.Create([CaseSensitive])`

**Purpose:** Creates a new dictionary.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | CaseSensitive | Boolean | No | Case-sensitive keys (default: false) |

#### `ADDITEM`
**GAB Syntax:** `Subroutine.Global.Dictionary.DictionaryName.AddItem(Key, Value)`

**Purpose:** Adds a key-value pair to the dictionary.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Key | String | Yes | Item key |
| 2 | Value | Object | Yes | Item value |

#### `READITEM`
**GAB Syntax:** `Function.Global.Dictionary.DictionaryName.ReadItem(Key, Variable.Local.Value)`

**Purpose:** Reads a value by key.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Key | String | Yes | Item key |
| R | Value | Object | Yes | Return - Item value |

#### `CREATEFROMSQL`
**GAB Syntax:** `Subroutine.Global.Dictionary.DictionaryName.CreateFromSQL(ConnectionName, SQLQuery, KeyColumn, ValueColumn)`

**Purpose:** Creates a dictionary from SQL query results.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | ConnectionName | String | Yes | Database connection |
| 2 | SQLQuery | String | Yes | SQL query |
| 3 | KeyColumn | String | Yes | Column for keys |
| 4 | ValueColumn | String | Yes | Column for values |

**Note:** Has feature toggle and Pervasive version check

---

## Component Reference: DocumentControlComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\DocumentControlComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\DocumentControlComponent.vb`
- **Feature toggle:** `TBD - Check Components_FeatureToggles.xlsx`
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~2,335 lines

### Runtime purpose
The Document Control Component (DCS - Document Control System) manages document storage, linking, and retrieval within Global Shop Solutions. It provides comprehensive document management including versioning, security, and metadata.

### Implementation notes (OCTSRS)
#### Legacy Behavior
- Uses DCS (Document Control System) tables
- Supports both linked and standalone documents
- Revision control is optional per document
- Security is managed at both document and link level

#### File Handling
- Supports UNC paths for network storage
- File existence check can be bypassed with `NFC` variants
- Encryption available for sensitive documents

#### Hook Integration
- Hook 16120 is used for document launching
- GAS scripts handle document opening logic

#### Known Issues
- Large file handling may timeout
- UNC path resolution can be slow on network issues

#### Migration Notes
- Uses ADODB Recordset extensively
- Multiple table existence checks via `HasTable()`
- Connection type: Company database (ActianCompanySqlConnection)
- Complex multi-table operations need transaction handling

### Dependencies
#### Components Called
- `HookAssociationComponent` - For document launching via hooks
- `GlobalShopEncryption` - For encryption operations

#### Called By
- Part maintenance
- Work order screens
- Job tracking
- Purchase orders
- Sales orders
- Quality control

#### External Dependencies
- nsoftware.IPWorksZip - For compression operations
- File system access for document storage

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `ADDSTANDALONEDOCUMENT` | Add a standalone document |
| `DELETEDOCUMENT` | Delete a document |
| `GETDOCUMENTID` | Get document ID |
| `GETLINKTYPEIDS` | Get all link type IDs |
| `DELETELINKID` | Delete a link ID |
| `REVISIONENABLE` | Enable revision control |
| `REVISIONDISABLE` | Disable revision control |

### Key method signatures & edge cases
#### `ADDDOCUMENT`
**GAB Syntax:** `Function.Global.Document.AddDocument(LinkID, GroupID, UserID, FileType, FilePath, Description, [NoUNC], [NonRevisioned], Variable.Local.DocumentID)`

**Purpose:** Adds a document to the document control system with file validation.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | LinkID | Long | Yes | Link ID to attach document to |
| 2 | GroupID | Long | Yes | Group ID for the document |
| 3 | UserID | String | Yes | User adding the document |
| 4 | FileType | String | Yes | File type/extension |
| 5 | FilePath | String | Yes | Full path to the file |
| 6 | Description | String | Yes | Document description |
| 7 | NoUNC | Boolean | No | Skip UNC path conversion |
| 8 | NonRevisioned | Boolean | No | Non-revisioned document |
| R | DocumentID | Long | Yes | Return - Created document ID |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| ATG_DOC_ASSOC | INSERT | Document association record |
| LINK_DATA | INSERT | Link data record |

#### `CHECKUSERDOCUMENTSECURITY`
**GAB Syntax:** `Function.Global.Document.CheckUserDocumentSecurity(UserID, DocumentID, Variable.Local.HasAccess)`

**Purpose:** Validates if a user has access to a specific document.

**Returns:** Boolean indicating access permission

#### `CREATEREFERENCE`
**GAB Syntax:** `Function.Global.Document.CreateReference(DocumentID, LinkType, LinkKey, Variable.Local.ReferenceID)`

**Purpose:** Creates a reference linking a document to a business object.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | DocumentID | Long | Yes | Document ID to reference |
| 2 | LinkType | String | Yes | Type of link (PART, JOB, etc.) |
| 3 | LinkKey | String | Yes | Key value for the link |
| R | ReferenceID | Long | Yes | Return - Created reference ID |

#### `INVOKE`
**GAB Syntax:** `Function.Global.Document.Invoke(LinkKey, LinkType, LinkDescription, Variable.Local.Result)`

**Purpose:** Opens/launches a document using the associated application.

**Business Rules:**
- Uses Hook 16120 to launch documents
- Passes data elements via GAS script
- Requires active hook configuration

---

## Component Reference: FileComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\FileComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\FileComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~1,611 lines

### Runtime purpose
The File Component provides comprehensive file system operations including file I/O, directory management, and file manipulation.

### Implementation notes (OCTSRS)
#### File Access
- Supports text and binary modes
- Handles file locking
- Supports various encodings

#### Path Handling
- Supports UNC paths
- Handles path normalization
- Regex for pattern matching

#### Migration Notes
- No database interaction
- Uses .NET file I/O
- Some methods use legacy VB file functions

### Dependencies
#### External Dependencies
- System.IO namespace
- Microsoft.VisualBasic.FileIO

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `APPENDTOFILE` | Append text to file |
| `APPENDTOFILENEWLINE` | Append text with newline |
| `PREPENDTOFILE` | Prepend text to file |
| `PREPENDTOFILENEWLINE` | Prepend text with newline |
| `READLINE` | Read single line |
| `READALLLINES` | Read all lines |
| `GETFILECONTENTS` | Get file contents |
| `BINARYGET` | Read binary data |
| `BINARYPUT` | Write binary data |
| `CLOSEFILE` | Close file |
| `COPYFILE` | Copy a file |
| `COPYOPENFILE` | Copy open file |
| `CREATEDIR` | Create directory |
| `DELETEDIR` | Delete directory |
| `COPYDIRECTORY` | Copy directory |
| `CHANGEDIRECTORY` | Change current directory |
| `GETCURRENTDIR` | Get current directory |
| `DIREXISTS` | Check if directory exists |
| `GETFILESIZE` | Get file size |
| `GETFILELIST` | Get files in directory |
| `GETDIRLIST` | Get directories |
| `GETFILEATTRIBUTES` | Get file attributes |
| `SETFILEATTRIBUTES` | Set file attributes |
| `GETFILEDATE` | Get file date |
| `CALCULATEMD5` | Calculate MD5 hash |
| `GETEXTENSION` | Get file extension |
| `GETDIRECTORY` | Get directory path |
| `COMBINEPATH` | Combine path parts |

### Key method signatures & edge cases
#### `READFILE`
**GAB Syntax:** `Function.Global.File.ReadFile(FilePath, Variable.Local.Contents)`

**Purpose:** Reads entire file contents.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FilePath | String | Yes | Path to file |
| R | Contents | String | Yes | Return - File contents |

#### `COPYFILE`
**GAB Syntax:** `Subroutine.Global.File.CopyFile(SourcePath, DestinationPath, [Overwrite])`

**Purpose:** Copies a file to a new location.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | SourcePath | String | Yes | Source file path |
| 2 | DestinationPath | String | Yes | Destination path |
| 3 | Overwrite | Boolean | No | Overwrite if exists |

#### `GETFILELIST`
**GAB Syntax:** `Function.Global.File.GetFileList(DirectoryPath, [Pattern], Variable.Local.FileList)`

**Purpose:** Gets list of files in a directory.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | DirectoryPath | String | Yes | Directory to search |
| 2 | Pattern | String | No | File pattern (*.txt) |
| R | FileList | String | Yes | Return - Delimited file list |

#### `CALCULATEMD5`
**GAB Syntax:** `Function.Global.File.CalculateMD5(FilePath, Variable.Local.Hash)`

**Purpose:** Calculates MD5 hash of a file.

---

## Component Reference: GabChartComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\GabChartComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\GabCharts\GabChartComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started

### Runtime purpose
The GabChart Component provides charting and data visualization functionality for GAB scripts.

### Implementation notes (OCTSRS)
#### Chart Types
- Various chart types supported
- Data-driven visualization

#### Migration Notes
- Check source file for detailed methods
- May use DevExpress charting

### Dependencies
#### External Dependencies
- Charting libraries

---

---

## Component Reference: GlobalShopMapperComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\GlobalShopMapperComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\GlobalShops\GlobalShopMapperComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started

### Runtime purpose
The Global Shop Mapper Component provides data mapping functionality for Global Shop Solutions, facilitating data transformation between different formats and systems.

### Implementation notes (OCTSRS)
#### Migration Notes
- Check source file for detailed methods
- May use ADODB for data access

### Dependencies
#### Components Called
- `GlobalShopComponent` - For GSS integration

---

---

## Component Reference: GlobalShopRegistryComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\GlobalShopRegistryComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\GlobalShops\GlobalShopRegistryComponent.vb`
- **Feature toggle:** `TBD - Check Components_FeatureToggles.xlsx`
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~415 lines

### Runtime purpose
The Global Shop Registry Component provides a key-value storage system for application settings, user preferences, and program-specific data. It uses the GS_REGISTRY table to store typed values with optional encryption.

### Implementation notes (OCTSRS)
#### Legacy Behavior
- Registry table is in the COMMON database, not company database
- Uses `ActianCommonSqlConnection` for database operations
- MD5 hash stored for encrypted value verification
- Long varchar (VVAL) uses parameterized update

#### Encryption
- Uses `EncryptSystemOptionString()` extension method
- MD5 hash stored in DESCRIPTION for verification
- Decryption automatic on read

#### Username vs UserID
- Both string username and numeric UserID accepted
- Username automatically converted to UserID via `GetUserID()`

#### Key Structure
- Composite key: USER_ID + COMPANY + PROGRAM + REG_ID + SEQ
- Program should be uppercase and trimmed
- Company code is first 3 characters

#### Known Issues
- SQL string concatenation (security concern)
- Large VVAL values may have performance impact

#### Migration Notes
- Uses ADODB Recordset
- Connection type: Common database (ActianCommonSqlConnection)
- SQL uses string concatenation - needs parameterization
- Long varchar handling uses `SaveStringToLongVarChar()`

### Dependencies
#### Components Called
- `GlobalShopSecurityComponent` - For username to ID conversion
- `OpenDatabaseConnectivityComponent` - For long varchar operations
- `GlobalShop.Encryption` - For encryption/decryption

#### Called By
- Almost all programs for settings storage
- User preference screens
- Report configurations
- Integration settings

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `ADDVALUE` | Add or update a registry value |
| `READVALUE` | Read a registry value |

### Key method signatures & edge cases
#### `ADDVALUE`
**GAB Syntax:** `Function.Global.Registry.AddValue(UserID, Company, Program, RegID, Seq, Encrypt, StringValue, BoolValue, IntValue, FloatValue, DateValue, TimeValue, [LongVarCharValue])`

**Purpose:** Adds or updates a value in the registry. Supports multiple data types and optional encryption.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | UserID | Long/String | Yes | User ID (numeric) or username |
| 2 | Company | String | Yes | Company code (3 chars) |
| 3 | Program | String | Yes | Program identifier |
| 4 | RegID | Long | Yes | Registry ID |
| 5 | Seq | Long | Yes | Sequence number |
| 6 | Encrypt | Boolean | Yes | Encrypt string values |
| 7 | StringValue | String | No | String value (SVAL) |
| 8 | BoolValue | Boolean | No | Boolean value (BVAL) |
| 9 | IntValue | Long | No | Integer value (IVAL) |
| 10 | FloatValue | Double | No | Float value (FVAL) |
| 11 | DateValue | Date | No | Date value (DVAL) |
| 12 | TimeValue | Time | No | Time value (TVAL) |
| 13 | LongVarCharValue | String | No | Long varchar value (VVAL) |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| GS_REGISTRY | INSERT/UPDATE | Registry storage |

**Business Rules:**
- If UserID is a string (username), it's converted to numeric ID
- If record exists, UPDATE; otherwise INSERT
- String values can be encrypted if Encrypt=True
- MD5 hash stored in DESCRIPTION field for encrypted values
- VVAL (long varchar) requires separate update statement

#### `READVALUE`
**GAB Syntax:** `Function.Global.Registry.ReadValue(UserID, Company, Program, RegID, Seq, ValueType, Variable.Local.Value)`

**Purpose:** Reads a value from the registry.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | UserID | Long/String | Yes | User ID or username |
| 2 | Company | String | Yes | Company code |
| 3 | Program | String | Yes | Program identifier |
| 4 | RegID | Long | Yes | Registry ID |
| 5 | Seq | Long | Yes | Sequence number |
| 6 | ValueType | String | Yes | Type to read (see below) |
| R | Value | Varies | Yes | Return - Retrieved value |

**Value Types:**

| Type | Column | Description |
|------|--------|-------------|
| `SVAL` | SVAL | String value |
| `BVAL` | BVAL | Boolean value |
| `IVAL` | IVAL | Integer value |
| `FVAL` | FVAL | Float value |
| `DVAL` | DVAL | Date value |
| `TVAL` | TVAL | Time value |
| `VVAL` | VVAL | Long varchar value |

**Business Rules:**
- Encrypted values are automatically decrypted
- Returns empty/default if record not found
- Username can be used instead of numeric ID

---

## Component Reference: GlobalShopSecurityComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\GlobalShopSecurityComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\GlobalShops\GlobalShopSecurityComponent.vb`
- **Feature toggle:** `TBD - Check Components_FeatureToggles.xlsx`
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~1,355 lines

### Runtime purpose
The Global Shop Security Component manages user authentication, authorization, permissions, and group membership within Global Shop Solutions. It provides comprehensive security services for access control.

### Implementation notes (OCTSRS)
#### Legacy Behavior
- `CHECKUSERACCESS` is obsolete since 2010 - raises error 599
- Uses internal `UserXRef` structure for caching
- Username comparisons are case-insensitive (ToUpper)

#### Security Model
- IPM (Integrated Permission Management) system
- Group-based permissions
- Function-level access control
- Feature toggles for new functionality

#### User Cross-Reference
- Internal caching via `uUXr()` array
- Caches USER_ID, Username, Company mappings
- Improves performance for repeated lookups

#### Password Handling
- Passwords stored encrypted
- Validation uses encryption comparison
- DSN credentials also encrypted

#### Known Issues
- SQL string concatenation (security concern)
- Large group memberships may impact performance

#### Migration Notes
- Uses ADODB Recordset extensively
- Connection types: Company and Common databases
- SQL uses string concatenation - needs parameterization
- Consider caching strategies for frequently used lookups

### Dependencies
#### Components Called
- `GlobalShop.Encryption` - For password encryption
- `GabLicensingAndEncryption.Project` - For licensing

#### Called By
- Login screens
- Menu systems
- Permission-protected screens
- Report access control
- API authentication

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `GETUSERPERMISSIONDETAIL` | Get detailed permission info |
| `GETGROUPID` | Get group ID from name |
| `ISINGROUP` | Check if user is in a group |
| `GETUSEREMAIL` | Get user's email address |
| `GETUSERID` | Get user ID from username |
| `GETUSERIDFROMEMAIL` | Get user ID from email |
| `GETUSERNAMEFROMEMAIL` | Get username from email |
| `GETEMPNOFROMUSER` | Get employee number from user |
| `GETFUNCTIONGROUPTITLE` | Get function group title |
| `GETFUNCTIONTITLE` | Get function title |
| `GETDSNCREDENTIALS` | Get DSN credentials (encrypted) |

### Key method signatures & edge cases
#### `CHECKUSERACCESSIPM`
**GAB Syntax:** `Function.Global.Security.CheckUserAccessIPM(FunctionID, [SequenceID], Variable.Local.HasAccess)`

**Purpose:** Checks if the current user has access to a specific function via Integrated Permission Management.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FunctionID | Long | Yes | Function ID to check |
| 2 | SequenceID | Long | No | Sequence ID (optional) |
| R | HasAccess | Boolean | Yes | Return - True if access granted |

**Business Rules:**
- Uses IPM (Integrated Permission Management) system
- Checks user's group memberships
- Considers function-level permissions

#### `CHECKUSERFUNCTIONPERMISSION`
**GAB Syntax:** `Function.Global.Security.CheckUserFunctionPermission(UserID, FunctionID, Variable.Local.HasPermission)`

**Purpose:** Checks if a specific user has permission to a function.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | UserID | String | Yes | User to check |
| 2 | FunctionID | Long | Yes | Function ID |
| R | HasPermission | Boolean | Yes | Return - Permission status |

#### `CHECKUSERFUNCTIONFEATURETOGGLE`
**GAB Syntax:** `Function.Global.Security.CheckUserFunctionFeatureToggle(FunctionID, Variable.Local.IsEnabled)`

**Purpose:** Checks if a feature toggle is enabled for a function.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FunctionID | Long | Yes | Function ID |
| R | IsEnabled | Boolean | Yes | Return - Feature toggle status |

**Added:** 9/24/2025

#### `ISINGROUP`
**GAB Syntax:** `Function.Global.Security.IsInGroup(UserName, GroupName, [CompanyCode], Variable.Local.IsInGroup)`

**Purpose:** Checks if a user is a member of a specific group.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | UserName | String | Yes | Username to check |
| 2 | GroupName | String | Yes | Group name |
| 3 | CompanyCode | String | No | Company (defaults to current) |
| R | IsInGroup | Boolean | Yes | Return - True if member |

#### `VALIDATEUSER`
**GAB Syntax:** `Function.Global.Security.ValidateUser(UserName, Password, Variable.Local.IsValid)`

**Purpose:** Validates user credentials.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | UserName | String | Yes | Username |
| 2 | Password | String | Yes | Password |
| R | IsValid | Boolean | Yes | Return - True if valid |

#### `GETUSERID`
**GAB Syntax:** `Function.Global.Security.GetUserID(UserName, Variable.Local.UserID)`

**Purpose:** Converts a username to a numeric user ID.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | UserName | String | Yes | Username |
| R | UserID | Long | Yes | Return - Numeric user ID |

#### `GETFULLNAME`
**GAB Syntax:** `Function.Global.Security.GetFullName(UserName, [CompanyCode], Variable.Local.FullName)`

**Purpose:** Gets the full name for a user.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | UserName | String | Yes | Username |
| 2 | CompanyCode | String | No | Company (defaults to current) |
| R | FullName | String | Yes | Return - User's full name |

#### `GETDSNCREDENTIALS`
**GAB Syntax:** `Function.Global.Security.GetDSNCredentials(DSNName, Variable.Local.Username, Variable.Local.Password)`

**Purpose:** Retrieves encrypted DSN credentials.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | DSNName | String | Yes | DSN name |
| R1 | Username | String | Yes | Return - DSN username |
| R2 | Password | String | Yes | Return - DSN password |

---

## Component Reference: GlobalShopTranslationComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\GlobalShopTranslationComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\GlobalShops\GlobalShopTranslationComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~272 lines

### Runtime purpose
The Global Shop Translation Component provides internationalization (i18n) and translation services using IPM (International Product Management) data.

### Implementation notes (OCTSRS)
#### Language Support
- Supports primary and auxiliary languages
- Composite language lookup
- User-specific language preferences

#### IPM Integration
- Uses IPM data for translations
- Label-based translation system

#### Migration Notes
- Uses ADODB for data access
- Connection type: Company database
- Consider caching translations

### Dependencies
#### External Dependencies
- IPM (International Product Management) system

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `GETLANGUAGESBYUSERID` | Get languages by user ID |

### Key method signatures & edge cases
#### `GETLABELTRANSLATION`
**GAB Syntax:** `Function.Global.GssTranslation.GetLabelTranslation(LabelKey, Variable.Local.TranslatedText)`

**Purpose:** Gets the translated text for a label key.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | LabelKey | String | Yes | Label identifier |
| R | TranslatedText | String | Yes | Return - Translated text |

#### `GETLANGUAGESBYUSERID`
**GAB Syntax:** `Function.Global.GssTranslation.GetLanguagesByUserID(UserID, Variable.Local.Languages)`

**Purpose:** Gets language preferences for a user by ID.

#### `GETLANGUAGESBYUSERNAME`
**GAB Syntax:** `Function.Global.GssTranslation.GetLanguagesByUserName(UserName, Variable.Local.Languages)`

**Purpose:** Gets language preferences for a user by name.

---

## Component Reference: ImageComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\ImageComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\ImageComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~209 lines

### Runtime purpose
The Image Component provides basic image manipulation functionality including loading, saving, and transforming images.

### Implementation notes (OCTSRS)
#### Object Management
- Images stored in UserDefinedObjects collection
- Named by identifier for later reference

#### Migration Notes
- No database interaction
- Uses .NET System.Drawing
- Simple image manipulation component

### Dependencies
#### External Dependencies
- System.Drawing namespace

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `TOBYTEARRAY` | Convert image to byte array |
| `ROTATEFLIP` | Rotate or flip image |

### Key method signatures & edge cases
#### `LOAD`
**GAB Syntax:** `Subroutine.Global.Image.ImageName.Load(FilePath)`

**Purpose:** Loads an image from a file.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FilePath | String | Yes | Path to image file |

#### `SAVE`
**GAB Syntax:** `Subroutine.Global.Image.ImageName.Save(FilePath, [Format])`

**Purpose:** Saves an image to a file.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FilePath | String | Yes | Output file path |
| 2 | Format | String | No | Image format (PNG, JPG, etc.) |

#### `ROTATEFLIP`
**GAB Syntax:** `Subroutine.Global.Image.ImageName.RotateFlip(RotateFlipType)`

**Purpose:** Rotates and/or flips an image.

#### `TOBYTEARRAY`
**GAB Syntax:** `Function.Global.Image.ImageName.ToByteArray(Variable.Local.ByteArray)`

**Purpose:** Converts the image to a byte array.

---

## Component Reference: InventoryComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\InventoryComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\InventoryComponent.vb`
- **Feature toggle:** `TBD - Check Components_FeatureToggles.xlsx`
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~500 lines

### Runtime purpose
The Inventory Component manages part/inventory operations in Global Shop Solutions. It provides functionality for creating parts, retrieving part information, and batch part operations.

### Implementation notes (OCTSRS)
#### Legacy Behavior
- Uses `BulkParts` property array for batch operations
- `GenerateBulkParts` and `ClearBulkParts` manage batch processing
- Part formatting uses `StringComponent.GSSPart()`

#### Batch Processing
- Parts are accumulated in `BulkParts` array
- `PostPartBatch` processes all parts and clears the array
- Single part creation uses same batch mechanism

#### Known Issues
- None documented

#### Migration Notes
- Uses ADODB Recordset in some methods
- Connection type: Company database (ActianCompanySqlConnection)
- Some methods already use modern patterns (`GetArgumentValues()`)

### Dependencies
#### Components Called
- `StringComponent` - For GSSPart formatting
- `GlobalShopComponent` - For CallSYS050 (Supply/Demand)

#### Called By
- Part maintenance screens
- Order entry
- Work order processing
- Inventory management

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `CREATEPART` | Create a single inventory part |
| `GETGSSPART` | Get GSS formatted part number |

### Key method signatures & edge cases
#### `CREATEPART`
**GAB Syntax:** `Subroutine.Global.Inventory.CreatePart(Part, UnitOfMeasure, Description, Location, ProductLine, Source, AltDesc1, AltDesc2, Price, [ProgramName])`

**Purpose:** Creates a new inventory part in the system.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Part | String | Yes | Part number |
| 2 | UnitOfMeasure | String | Yes | Unit of measure (EA, LB, etc.) |
| 3 | Description | String | Yes | Part description |
| 4 | Location | String | Yes | Inventory location |
| 5 | ProductLine | String | Yes | Product line code |
| 6 | Source | String | Yes | Source code |
| 7 | AltDesc1 | String | Yes | Alternate description 1 |
| 8 | AltDesc2 | String | Yes | Alternate description 2 |
| 9 | Price | String | Yes | Part price |
| 10 | ProgramName | String | No | Program name (optional) |

**Business Rules:**
- Clears any existing batch before creating
- Adds part to batch, then generates
- Single part creation via batch mechanism

#### `GETPARTINFO`
**GAB Syntax:** `Function.Global.Inventory.GetPartInfo(Part, Variable.Local.Info)`

**Purpose:** Retrieves detailed information about a part.

**Returns:** Part information string (format varies)

#### `CALLSD`
**GAB Syntax:** `Subroutine.Global.Inventory.CallSD(Part, Revision, Location, [CompanyCode])`

**Purpose:** Opens the Supply/Demand screen for a part.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Part | String | Yes | Part number |
| 2 | Revision | String | Yes | Part revision |
| 3 | Location | String | Yes | Location code (2 chars) |
| 4 | CompanyCode | String | No | Company code (defaults to current) |

**Business Rules:**
- Calls SYS050 with function 300010
- Temporarily changes company code if provided
- Location is padded to 2 characters

---

## Component Reference: LinqComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\LinqComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\LinqComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~2,799 lines

### Runtime purpose
The LINQ Component provides Language Integrated Query (LINQ) operations for data manipulation including joins, filtering, sorting, and aggregation.

### Implementation notes (OCTSRS)
#### Dynamic LINQ
- Uses System.Linq.Dynamic.Core
- Expression strings parsed at runtime
- Flexible query building

#### Join Support
- Multiple join types
- Complex join conditions
- JoinInformation class for configuration

#### Performance
- Efficient for in-memory operations
- Consider database queries for large datasets

#### Migration Notes
- No direct database interaction
- Works with in-memory data
- Modern LINQ patterns

### Dependencies
#### External Dependencies
- System.Linq.Dynamic.Core

#### Components Called
- `DataTableComponent` - Data source
- `GlobalShopComponent` - GSS integration

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `ORDERBYRETURN` | Sort and return |
| `JOIN` | Join two data sources |
| `JOINQUERYABLE` | Join with IQueryable |
| `COMPUTE` | Compute aggregates |
| `CONVERTTODATATABLE` | Convert to DataTable |
| `TODYNAMICLIST` | Convert to dynamic list |

### Key method signatures & edge cases
#### `SELECT`
**GAB Syntax:** `Subroutine.Global.Linq.Select(SourceName, SelectExpression, OutputName)`

**Purpose:** Projects data using a select expression.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | SourceName | String | Yes | Source data name |
| 2 | SelectExpression | String | Yes | Select expression |
| 3 | OutputName | String | Yes | Output data name |

#### `WHERE`
**GAB Syntax:** `Subroutine.Global.Linq.Where(SourceName, WhereExpression, OutputName)`

**Purpose:** Filters data using a where expression.

**Example:** `"Age > 18 AND Status = 'Active'"`

#### `JOIN`
**GAB Syntax:** `Subroutine.Global.Linq.Join(LeftSource, RightSource, JoinExpression, OutputName)`

**Purpose:** Joins two data sources.

#### `COMPUTE`
**GAB Syntax:** `Function.Global.Linq.Compute(SourceName, Expression, Variable.Local.Result)`

**Purpose:** Computes an aggregate value.

**Examples:**
- `"Sum(Amount)"`
- `"Count()"`
- `"Average(Price)"`

#### `ORDERBYRETURN`
**GAB Syntax:** `Subroutine.Global.Linq.OrderByReturn(SourceName, OrderExpression, OutputName)`

**Purpose:** Sorts data and returns the result.

---

## Component Reference: MathComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\MathComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\MathComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~1,577 lines

### Runtime purpose
The Math Component provides comprehensive mathematical functions including arithmetic, trigonometry, statistics, and unit conversions.

### Implementation notes (OCTSRS)
#### Expression Evaluator
- Uses org.matheval for complex expressions
- Supports variables in expressions
- Standard math operators supported

#### Precision
- Uses Double for calculations
- Rounding modes available
- Consider precision limits

#### Migration Notes
- No database interaction
- Pure mathematical functions
- Modern math library usage

### Dependencies
#### External Dependencies
- org.matheval library (for expression evaluation)

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `SUBTRACT` | Subtract numbers |
| `MULTIPLY` | Multiply numbers |
| `DIVIDE` | Divide numbers |
| `ABS` | Absolute value |
| `COS` | Cosine |
| `ASIN` | Arc sine |
| `ACOS` | Arc cosine |
| `ATAN` | Arc tangent |
| `COSEC` | Cosecant |
| `COTAN` | Cotangent |
| `CEILING` | Ceiling value |
| `CONVERTTOFLOAT` | Convert to float |
| `CONVERTTOLONG` | Convert to long |
| `DEGTORAD` | Degrees to radians |
| `RADTODEG` | Radians to degrees |
| `DECIMALTOFRACTION` | Decimal to fraction |
| `SQRT` | Square root |
| `POWER` | Power/exponent |
| `FACTORIAL` | Factorial |
| `EVALUATEEXPRESSION` | Evaluate math expression |
| `AVERAGE` | Average value |
| `RANDOM` | Random number |
| `BITWISEL` | Bitwise left shift |
| `BITWISER` | Bitwise right shift |
| `BITWISEAND` | Bitwise AND |
| `BITWISEOR` | Bitwise OR |
| `BITWISEXOR` | Bitwise XOR |
| `CALCULATEUPCCHECKDIGIT` | Calculate UPC check digit |
| `ISNUMERIC` | Check if numeric |
| `SGN` | Sign of number |

### Key method signatures & edge cases
#### `EVALUATEEXPRESSION`
**GAB Syntax:** `Function.Global.Math.EvaluateExpression(Expression, Variable.Local.Result)`

**Purpose:** Evaluates a mathematical expression string.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Expression | String | Yes | Math expression |
| R | Result | Double | Yes | Return - Calculated result |

**Example:** `"(5 + 3) * 2"` returns `16`

#### `ROUND`
**GAB Syntax:** `Function.Global.Math.Round(Value, [Decimals], Variable.Local.Result)`

**Purpose:** Rounds a number to specified decimal places.

#### `RANDOM`
**GAB Syntax:** `Function.Global.Math.Random([Min], [Max], Variable.Local.Result)`

**Purpose:** Generates a random number.

---

# OCTSRS Component Reference (Runtime Implementation)

## Component Reference: VersionManagementSystemComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\VersionManagementSystemComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\VersionManagementSystemComponent.vb`
- **Feature toggle:** `549c32a2-2bae-42c9-ade9-05931119b0aa`
- **OCTSRS conversion status:** Done

### Runtime purpose
Provides version management system (VMS) functionality for files tracked in Global Shop Solutions. Manages file storage as BLOBs in the database, check-out/check-in workflow, file history with versioning, shadow directory management, and security permissions.

### Implementation notes (OCTSRS)
#### Migration Notes
- **Approach A** used: All methods converted to ADO.NET in `AdoNetVersionManagementSystemComponent.vb`
- Feature toggle routes via `InvokeComponentByFeatureToggle` in `GabProgram.vb`
- BLOB operations converted from `ADODB.Stream` / `SaveBLOBtoFile` to `File.ReadAllBytes` / `File.WriteAllBytes`
- SQL injection in `GetMaxGroupPermission` fixed with parameterized queries
- Original ADODB methods preserved in `VersionManagementSystemComponent.vb` for toggle-off fallback

### Dependencies
#### Components Called
- `GlobalShopComponent` - License check (`IsLicensedIPM`), company options
- `GlobalShopSecurityComponent` - User info, user groups, user ID lookup
- `OpenDatabaseConnectivityComponent` - BLOB save/load (legacy ADODB path)

#### Called By
- GAB scripts via `Function.Global.VMS.*`

---

### Key method signatures & edge cases
#### `ADDFILE`
**GAB Syntax:** `Function.Global.VMS.AddFile(FID, Compress)`

**Purpose:** Adds a file to VMS control. Reads the file from its document path, optionally compresses it, stores the BLOB in `VMS_ACTIVE`, creates a `VMS_FILE_TYPE` record if the extension is new, and copies to the shadow directory.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FID | Integer | Yes | File number (FILE_NUM in ATG_DOC_ASSOC) |
| 2 | Compress | Boolean | Yes | Whether to compress the file before storing |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| ATG_DOC_ASSOC | SELECT | Reads file info (path, name, extension) |
| VMS_ACTIVE | SELECT/INSERT/UPDATE | Stores the file BLOB |
| VMS_FILE_TYPE | SELECT/INSERT | Creates extension record if not exists |

**Error Codes:**

| Code | Condition | Message |
|------|-----------|---------|
| 200 | Source file not found | File path |
| 266000 | FID not found in ATG_DOC_ASSOC | FID |
| 266075 | Shadow copy failed | Exception details |
| 266300 | Shadow directory does not exist | |

#### `ADDTOHISTORY`
**GAB Syntax:** `Function.Global.VMS.AddToHistory(FID, Notes)`

**Purpose:** Creates a history snapshot of the current active file. Enforces max version limits per file type and adds user notes.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FID | Integer | Yes | File number |
| 2 | Notes | String | Yes | History notes |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| VMS_ACTIVE | SELECT | Reads current file BLOB |
| VMS_HISTORY | SELECT/INSERT/DELETE | Creates history record, enforces max versions |
| VMS_NOTES | INSERT/UPDATE | Adds notes for history record |
| ATG_DOC_ASSOC | SELECT | Gets file type for max version lookup |
| VMS_FILE_TYPE | SELECT | Gets max saved versions |

**Error Codes:**

| Code | Condition | Message |
|------|-----------|---------|
| 266000 | FID not found in ATG_DOC_ASSOC | FID |
| 266020 | FID not found in VMS_ACTIVE | FID |

#### `CANCELCHECKOUT`
**GAB Syntax:** `Function.Global.VMS.CancelCheckOut(FID)`

**Purpose:** Cancels a file checkout. Deletes the working copy from disk and resets VMS_ACTIVE state.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FID | Integer | Yes | File number |

**Error Codes:**

| Code | Condition | Message |
|------|-----------|---------|
| 266060 | File not checked out | FID |

#### `CHECKIN`
**GAB Syntax:** `Function.Global.VMS.CheckIn(FID, ShadowDir)`

**Purpose:** Checks in a file. Reads from working directory, optionally compresses, stores BLOB, verifies integrity via MD5, copies to shadow directory, and cleans up working copy.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FID | Integer | Yes | File number |
| 2 | ShadowDir | String | Yes | Shadow directory (empty = auto-resolve) |

**Error Codes:**

| Code | Condition | Message |
|------|-----------|---------|
| 266005 | File not found in working directory | File path |
| 266006 | Integrity check failed | File path |
| 266007 | File already checked in | FID |
| 266009 | Source and shadow are same path | File path |
| 266010 | FID not found in ATG_DOC_ASSOC | FID |
| 266015 | FID not found in VMS_ACTIVE | FID |
| 266076 | Shadow copy failed | Exception |
| 266090 | Compressed file not created | File path |

#### `CHECKOUT`
**GAB Syntax:** `Function.Global.VMS.CheckOut(FID, WorkingDir, Reason, Open)`

**Purpose:** Checks out a file. Extracts BLOB to working directory, verifies MD5 integrity, decompresses if needed, optionally opens the file, and marks as checked out.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FID | Integer | Yes | File number |
| 2 | WorkingDir | String | Yes | Working directory (empty = auto-resolve) |
| 3 | Reason | String | Yes | Checkout reason |
| 4 | Open | Boolean | Yes | Open file after checkout |

**Error Codes:**

| Code | Condition | Message |
|------|-----------|---------|
| 266010 | FID not found in ATG_DOC_ASSOC | FID |
| 266015 | FID not found in VMS_ACTIVE | FID |
| 266070 | Integrity check failed | File path |
| 266071 | File already exists in working directory | File path |

#### `GETFILETYPEMAXVERSIONS`
**GAB Syntax:** `Function.Global.VMS.GetFileTypeMaxVersions(Extension, Variable.Local.Result)`

**Purpose:** Returns the maximum number of saved versions for a file extension.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Extension | String | Yes | File extension (e.g. "PDF") |
| R | Result | Integer | Yes | MaxSaved value (1 if extension not found) |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| VMS_FILE_TYPE | SELECT | Reads MaxSaved for extension |

#### `GETINFOFROMFID`
**GAB Syntax:** `Function.Global.VMS.GetInfoFromFID(FID, Variable.Local.Result)`

**Purpose:** Returns delimited VMS file information for a file ID.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FID | Integer | Yes | File number |
| R | Result | String | Yes | Delimited: File*!*Description*!*GSUser*!*Reason*!*FileType*!*LinkID*!*Type*!*Compressed, or "***NORETURN***" |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| ATG_DOC_ASSOC | SELECT (JOIN) | File info |
| VMS_ACTIVE | SELECT (JOIN) | VMS state |
| LINK_DATA | SELECT (JOIN) | Link type |

#### `GETSECURITY`
**GAB Syntax:** `Function.Global.VMS.GetSecurity(TID, LinkType, UserID, Variable.Local.Result)`

**Purpose:** Returns VMS security permission level for a user. Checks user-level, then group-level permissions with cascading fallback. Returns 62 for supervisors.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | TID | Integer | Yes | Template ID |
| 2 | LinkType | Integer | Yes | Link type |
| 3 | UserID | Integer | Yes | User ID |
| R | Result | Integer | Yes | Permission level (0-62) |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| VMS_SECURITY | SELECT | Permission lookup |

**Error Codes:**

| Code | Condition | Message |
|------|-----------|---------|
| 266200 | Security lookup failed | Exception message |

#### `GETSHADOWDIRECTORY`
**GAB Syntax:** `Function.Global.VMS.GetShadowDirectory(Extension, Variable.Local.Result)`

**Purpose:** Returns the shadow directory path for a file extension. Uses company options 401054 (base) and 401055 (path template) with `%BASE%` and `%FileExt%` substitution.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Extension | String | Yes | File extension |
| R | Result | String | Yes | Shadow directory path (empty if not configured) |

#### `GETWORKINGDIRECTORY`
**GAB Syntax:** `Function.Global.VMS.GetWorkingDirectory(Variable.Local.Result)`

**Purpose:** Returns the user's working directory. Checks USER_OPTIONS_COM (option 1000) first, falls back to company options 401052/401053 with `%BASE%` and `%USER%` substitution.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| R | Result | String | Yes | Working directory path |

**Error Codes:**

| Code | Condition | Message |
|------|-----------|---------|
| 266080 | No working directory configured | |

#### `ISINVMS`
**GAB Syntax:** `Function.Global.VMS.IsInVMS(FID, Variable.Local.Result)`

**Purpose:** Checks if a file ID exists in VMS_ACTIVE.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FID | Integer | Yes | File number |
| R | Result | Boolean | Yes | True if FID exists in VMS_ACTIVE |

#### `REMOVEFILE`
**GAB Syntax:** `Function.Global.VMS.RemoveFile(FID, Directory)`

**Purpose:** Removes a file from VMS control. Extracts BLOB to target directory, verifies integrity, deletes VMS records, and updates ATG_DOC_ASSOC path.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FID | Integer | Yes | File number |
| 2 | Directory | String | Yes | Target directory for extracted file |

**Error Codes:**

| Code | Condition | Message |
|------|-----------|---------|
| 266005 | File already exists in target directory | File path |
| 266006 | Integrity check failed | File path |
| 266007 | File is currently checked out | FID |
| 266009 | Source and shadow are same path | File path |
| 266010 | FID not found in ATG_DOC_ASSOC | FID |
| 266015 | FID not found in VMS_ACTIVE | FID |

---
