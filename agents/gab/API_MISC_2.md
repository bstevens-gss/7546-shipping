# GAB Additional API Surface Reference (Part 2 of 2)
# Sub-agent of agents/AGENTS.GAB.md -- read when working with Global.WorkFlow through Program.* and sample controls
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass

> Where a namespace appears in both this file and the curated files (`API_HTTP.md`, `API_AUTOMATION.md`, `API_PRINTER.md`), the curated file is authoritative. Some descriptions may be truncated -- do not assume truncated text or hallucinate completions.
---

## Global.WorkFlow
```
F.Global.WorkFlow.AddDocument(File Name, Document ID, Return)  ' Adds a document to the workflow
F.Global.WorkFlow.AddLine(WorkflowId, Description, Notify, Status, SignoffReq, DependencyId, UserGroup, UserGroupFlag, WidChain, PercentCompleted, SignoffUserGroup, SignoffUserGroupFlag, User1, User2, User3, User4, User5, StartDate, DueDate, ReturnVariable)
F.Global.WorkFlow.AddLineDependency(WorkflowId, Line, DepType, DepWorkflowId, DepLine)  ' Add a line dependency. DepType is 1 Header, 0 Line
F.Global.WorkFlow.AddTemplateDocument(File Name, Template Flag, Return)
F.Global.WorkFlow.AddTemplateLine(Id, Description, Notify, Status, SignoffReq, DependencyId, UserGroup, UserGroupFlag, WidChain, PercentCompleted, SignoffUserGroup, SignoffUserGroupFlag, User1, User2, User3, User4, User5, ReturnVariable, ReturnVariable)  ' Adds template line
F.Global.WorkFlow.AddTemplateLineDependency(WorkflowId, Line, DepType, DepWorkflowId, DepLine)  ' Add a line dependency. DepType is 1 Header, 0 Line
F.Global.WorkFlow.CheckDuplicateTitle(Title, IsTemplate, ReturnVariable)  ' Check duplicate title
F.Global.WorkFlow.CheckLineDependency(WorkflowId, Line, ReturnVariable)  ' Check line dependency
F.Global.WorkFlow.CompleteLine(WorkflowId, Line)  ' Set worklow line as completed
F.Global.WorkFlow.Create(Title, DueDate, StartDate, ParentId, User, Status, ReturnVariable)  ' Creates a WorkFlow
F.Global.WorkFlow.CreateDocumentReference(WorkflowId, Line, DocId, ReturnVariable)  ' Create doc reference for a work flow line
F.Global.WorkFlow.CreateFromTemplate(Id, Title, StartDate, DueDate, User, Status, ReturnVariable)  ' Create workflow from a template ID, Returns workflow IDcreated.
F.Global.WorkFlow.CreateTemplate(Title, ParentId, User, Status, ReturnVariable)  ' Create a work flow template
F.Global.WorkFlow.CreateTemplateDocumentReference(Association ID, Association Type, Doc ID)
F.Global.WorkFlow.Delete(WorkflowId)  ' Deletes a WorkFlow
F.Global.WorkFlow.DeleteDocument(Document ID)
F.Global.WorkFlow.DeleteDocumentReference(Association ID, Line, Doc ID)
F.Global.WorkFlow.DeleteLine(WorkflowLineId)  ' Deletes WorkFlow Line
F.Global.WorkFlow.DeleteLineDepepedency(WorkflowId, Line, DepType, DepWorkflowId, DepLine)
F.Global.WorkFlow.DeleteNote(WorkflowLineId)  ' Delete workflow note
F.Global.WorkFlow.DeleteTemplate(Id)  ' Deletes WorkFlow template
F.Global.WorkFlow.DeleteTemplateDocument(Doc ID)
F.Global.WorkFlow.DeleteTemplateDocumentReference(Association ID, Line, Doc ID)
F.Global.WorkFlow.DeleteTemplateLine(Id, Line)  ' Delete Line
F.Global.WorkFlow.DeleteTemplateLineDependency(WorkflowId, Line, DepType, DepWorkflowId, DepLine)  ' Delete line dependency. DepType
F.Global.WorkFlow.DeleteTemplateNote(Work FLow Line ID)
F.Global.WorkFlow.Export(Document ID, File Name)  ' Exports the document to the file specified
F.Global.WorkFlow.ExportTemplate(Document ID, File Name)
F.Global.WorkFlow.GetDocumentReferenceID(WorkflowId, Line, DocId, ReturnVariable)  ' Returns Doc ID
F.Global.WorkFlow.GetDocumentReferences(WorkflowId, Line, DocId, ReturnVariable)  ' Returns document reference or file
F.Global.WorkFlow.GetIDFromTitle(Title, IsTemplate, ReturnVariable)
F.Global.WorkFlow.GetLineID(WorkflowId, LineNo, IsTemplate, ReturnVariable)  ' Returns line ID
F.Global.WorkFlow.GetTemplateDocumentIDFromFileName(File Name, Return)
F.Global.WorkFlow.GetTemplateDocumentReferenceID(Association ID, Line ID, Doc ID, Return)
F.Global.WorkFlow.GetTemplateDocumentReferences(Assciation ID, Association Type, Doc ID, Return)
F.Global.WorkFlow.GetTemplateIDFromTitle(Title, ReturnID)
F.Global.WorkFlow.GetTemplateLineID(Id, LineNo, ReturnVariable)
F.Global.WorkFlow.Import(File Path, Return)  ' Imports the file into the workflow
F.Global.WorkFlow.ImportTemplate(File Path, Return)
F.Global.WorkFlow.Read(WorkflowId, Title, DueDate, StartDate, ParentId, Status, CompletionDate, CreationDate, UserCreated, Template)  ' Reads a WorkFlow
F.Global.WorkFlow.ReadAllRefenceData(WorkflowId, Position, ReturnVariable, IsTemplate)
F.Global.WorkFlow.ReadAllTemplateReferenceData(WorkflowId, Position, ReturnVariable)
F.Global.WorkFlow.ReadAssignedLines(User, Groups, Filter, Order, Return)
F.Global.WorkFlow.ReadAssignedLinesWithFilter(User, Groups, Filter, order, Return)
F.Global.WorkFlow.ReadCompletion(Work Flow ID, Return)
F.Global.WorkFlow.ReadDocument(Document ID, Return)
F.Global.WorkFlow.ReadExploded(WorkFlow ID, Return)
F.Global.WorkFlow.ReadLineByID(WorkflowLineId, ReturnVariable)
F.Global.WorkFlow.ReadLineByNum(WorkflowId, LineNo, ReturnVariable)
F.Global.WorkFlow.ReadLineDependency(Work Flow ID, Line ID, Return)
F.Global.WorkFlow.ReadLinePriority(Work Flow ID, Line ID, Return)
F.Global.WorkFlow.ReadLines(WorkflowId, ReturnVariable, ReturnVariable)  ' Return delimited strings of line ID and Line Numbers
F.Global.WorkFlow.ReadLinesTemplate(Work Flow ID, Return Line IDs, return Line Numbers)
F.Global.WorkFlow.ReadMetaData(Id, IdType, Position, ReturnVariable)  ' Read header or line work flow meta 0 to 9 with data – 1 to return all as a de...
F.Global.WorkFlow.ReadNote(WorkflowLineId, ReturnVariable)  ' Read workflow note
F.Global.WorkFlow.ReadPriority(Work Flow ID, Return)
F.Global.WorkFlow.ReadReferenceData(WorkflowId, Position, ReturnVariable)  ' Read header work flow reference 0 to 9 with data
F.Global.WorkFlow.ReadReferenceLineData(Work Flow ID, Line ID, Position, Return)
F.Global.WorkFlow.ReadTemplate(Id, Title, ParentId, Status, CreationDate, UserCreated)  ' Reads template
F.Global.WorkFlow.ReadTemplateDocument(Document ID, Return)
F.Global.WorkFlow.ReadTemplateExploded(Work Flow ID, Return)
F.Global.WorkFlow.ReadTemplateLine(Work Flow Template ID, Line Number, By Line, Return)
F.Global.WorkFlow.ReadTemplateLineByID(LineId, ReturnVariable)
F.Global.WorkFlow.ReadTemplateLineByNum(Id, LineNo, ReturnVariable)
F.Global.WorkFlow.ReadTemplateLineDependency(Work Flow Template ID, Line Number, Return)
F.Global.WorkFlow.ReadTemplateLinePriorityOffset(WorkFlow Template ID, Line, Return)
F.Global.WorkFlow.ReadTemplateLines(Id, ReturnVariable, ReturnVariable)  ' Returns two delimited strings one with line ids and line number
F.Global.WorkFlow.ReadTemplateMetaData(Id, IdType, Position, ReturnVariable)  ' Read header or line work flow meta 0 to 9 with data – 1 to return all as a de...
F.Global.WorkFlow.ReadTemplateNote(Work Flow Line ID, Return Notes)
F.Global.WorkFlow.ReadTemplateReferenceData(WorkflowId, Position, ReturnVariable)  ' Read header work flow reference 0 to 9 with data
F.Global.WorkFlow.ReadTemplateReferenceLineData(Work Flow ID, Line Number, Position, Return)
F.Global.WorkFlow.Save(Work Flow ID, Title, Date Due, Date Start, Parent ID, User, Status)
F.Global.WorkFlow.SaveLine(Work Flow ID, Line, Description, Notify, Status, SignOff Req, Department ID, UserGroup, User Group Flag, WID Chain, Pct Complete, SignOff Group, SignOff User Group Flag, User0, User1, User2, user3, User4, DateStart, DateDue)
F.Global.WorkFlow.SaveNote(WorkflowLineId, Notes)  ' Save workflow note to line id
F.Global.WorkFlow.SaveTemplate(Work Flow ID, Title, Parent ID, User, Status, Template Type)
F.Global.WorkFlow.SaveTemplateLine(Work Flow ID, Line, Description, Notify, Status, SignOffReq, Department ID, User Group, User Group Flag, WID Chain, Pct Completion, SignOff Group, SgnOff User Group Flag, User0, User1, User2, User3, User4, Complete Time, Complete Type)
F.Global.WorkFlow.SaveTemplateLinePriorityOffset(Work Flow ID, Line Number, Priority)
F.Global.WorkFlow.SaveTemplateNote(Work Flow Line ID, Notes)
F.Global.WorkFlow.SetLineCompletionPercentage(WorkflowId, Line, PercentCompleted)
F.Global.WorkFlow.SetMetaData(Id, IdType, Position, MetaData)  ' Set header or line work flow meta 0 to 9 with data, ID Type 1 is for header 0...
F.Global.WorkFlow.SetPriority(WorkFlow ID, Priority)
F.Global.WorkFlow.SetReferenceData(WorkflowId, Position, RefData)  ' Set header work flow reference 0 to 9 with data
F.Global.WorkFlow.SetReferenceLineData(Work Flow ID, Line ID, Position, Data)
F.Global.WorkFlow.SetTemplateMetadata(ID, Id Type, Position, MetaData)
F.Global.WorkFlow.SetTemplateReferenceData(WorkflowId, Position, RefData)  ' Set header work flow reference 0 to 9 with data
F.Global.WorkFlow.SignOffLine(WorkflowId, Line, UserGroup, SignoffType)
```

## Global.Workstation
```
F.Global.Workstation.GetComponentStatus(Component ID, Return Status)  ' Returns component status
```

## Global.XML
```
F.Global.XML.AppendNode(DocumentName, NodeName, Value)
F.Global.XML.AppendNodeInSet(DocName, SetName, NodeName)  ' Appends node to current node in the set
F.Global.XML.AppendNodeToRoot(DocumentName, NodeName)
F.Global.XML.AppendTextNode(DocumentName, NodeName, Value)
F.Global.XML.Back(DocName, SetName, ReturnVariable)  ' Returns boolean if at BOF
F.Global.XML.CloseDocument(DocumentName)
F.Global.XML.CreateAttributeNode(DocumentName, NodeName, Value)
F.Global.XML.CreateDocument(Name, AsynchronousFlag, PreserveWhitespaceFlag, ValidateOnParseFlag, ResolveExternalsFlag)
F.Global.XML.CreateElementNode(DocumentName, NodeName, Value)
F.Global.XML.DeleteChildInSet(DocName, SetName, NodeName)  ' Deletes node in current node in the set
F.Global.XML.DestroyAttributeNode(Document Name, Node)
F.Global.XML.DestroyNode(DocumentName, NodeName)
F.Global.XML.LoadDocument(DocName, FilePath, Async, PreserveWhitespace, ValidateOnParse, ResolveExternals)  ' Loads an existing XML document
F.Global.XML.Next(DocName, SetName, ReturnVariable)  ' Returns boolean if at EOF
F.Global.XML.ReadNodeAttribute()
F.Global.XML.ReadNodeSetAttribute()  ' Returns the attribute value of the active node in the document.  Note Attribu...
F.Global.XML.ReadNodeSetBound(DocumentName, SetName, ReturnVariable)
F.Global.XML.ReadNodeValue(DocName, NodeName, Argument, ReturnVariable)  ' Retrieves information from Nodes, populated when they use commands like Creat...
F.Global.XML.SaveDocument(DocumentName, Path, File)
F.Global.XML.SetAttributeToNode(DocumentName, Parent, Attribute)
F.Global.XML.SetAttributeToRoot(DocumentName, Attribute)
F.Global.XML.SetNodeSetPosition(DocumentName, SetName, Position, ReturnVariable)
F.Global.XML.SetNodeSetValue(DocName, SetName, Argument, Value)  ' Sets the current value of the current position of the node set
F.Global.XML.SetRoot(DocumentName, RootName)
F.Global.XML.TraverseNode(DocName, NodeName, ReturnNodeName, Direction, ReturnVariable)
F.Global.XML.TraverseNodeSet(DocName, SetName, ReturnNodeName, Direction, ReturnVariable)  ' Function.Global.XML.TraverseNodeSet(DocName, SetName, ReturnNodeName, Directi...
```

## Intrinsic.API
```
F.Intrinsic.API.AppActivate()  ' Activates the application window (no params)
F.Intrinsic.API.ChangeCaption(Hwnd, Text)  ' Changes a control's caption; Hwnd as Long (window handle), Text as String (new caption)
F.Intrinsic.API.CreateFileAssociation(Extension, AssociationName, FullyQualifiedProgramToCall, Verb)  ' Creates file association; all params String. Requires HKCR write access
F.Intrinsic.API.ExtractIcon(ExeName, IconIndex, ReturnVariable)  ' Extracts icon handle from EXE; ExeName as String, IconIndex as Long, ReturnVariable as Long
F.Intrinsic.API.FindWindow(WindowText, Handle)  ' Finds window by text; WindowText as String, Handle as Long (returns hwnd)
F.Intrinsic.API.FlashWindowCount(WindowHandle, Frequency, Count)  ' Flashes window and taskbar; all params Long (WindowHandle, Frequency, Count)
F.Intrinsic.API.GetHandleFromPID(Pid, ReturnVariable)  ' Returns window handle from process ID; Pid as Long, ReturnVariable as Long
F.Intrinsic.API.GetHandleFromPosition(X, Y, ReturnVariable)  ' Returns window handle at screen coords; X as Long, Y as Long, ReturnVariable as Long
F.Intrinsic.API.GetMouseButtonState(Button(s), ReturnVariable)  ' Gets mouse button state; Button(s) as Long, ReturnVariable as Boolean
F.Intrinsic.API.GetMousePosition(ReturnVariableX, ReturnVariableY)  ' Gets current mouse position; both params Float (pixels)
F.Intrinsic.API.GetWindowDimensions(Handle, ReturnWidth, ReturnHeight)  ' Gets window size; Handle as Long, ReturnWidth as Long, ReturnHeight as Long
F.Intrinsic.API.GetWindowPosition(Handle, ReturnVariableX, ReturnVariableY)  ' Gets window position; Handle as Long, ReturnVariableX as Long, ReturnVariableY as Long
F.Intrinsic.API.GetWindowText(Handle, ReturnVariable)  ' Gets window caption text; Handle as Long, ReturnVariable as String
F.Intrinsic.API.HideWindow(Hwnd)  ' Hides a window; Hwnd as Long (window handle)
F.Intrinsic.API.LockWindowUpdate()  ' Locks textbox from draw function (disables drawing in the window)
F.Intrinsic.API.ReadRegistryKey(Base, Key, SubkeyName, ReturnVariable)  ' All params String. Base: HKLM, HKCR, HKCC, HKCU, HKPD, HKU
F.Intrinsic.API.SendMessageL(Hwnd, WindowsMessage, Param1, Param2)  ' CAUTION: may BSOD. All params Long (Hwnd, WindowsMessage, Param1, Param2)
F.Intrinsic.API.SendMessageS(Hwnd, WindowsMessage, Param1, Param2)  ' CAUTION: may BSOD. Hwnd/WindowsMessage/Param1 as Long; Param2 as String
F.Intrinsic.API.SendMessageU(Hwnd, WindowsMessage, Param1, Param2)  ' CAUTION: may BSOD. Hwnd/WindowsMessage/Param1 as Long; Param2 as Any (variant)
F.Intrinsic.API.SetAlwaysOnTop()  ' This function sets the "always on top" property of the specified window.
F.Intrinsic.API.SetControlFocus(Handle)  ' Sets focus to a control by window handle; Handle as Long
F.Intrinsic.API.SetMouseClipRegion(X1, Y1, X2, Y2)  ' Clips mouse cursor to a rectangular region; all params Float (pixels)
F.Intrinsic.API.SetMousePosition(X, Y)  ' Sets the current mouse cursor position; X as Float, Y as Float (pixels)
F.Intrinsic.API.SetParent(ChildHwnd, ParentHwnd)  ' Makes one control the “parent” of another control
F.Intrinsic.API.SetWindowFocus(WindowsHandle)
F.Intrinsic.API.SetWindowPosition(Handle, X, Y, [Width], [Height])  ' Sets window position by handle; Width and Height are optional
F.Intrinsic.API.SetWindowPositions(ParentHandle, ChildHandle, Mode)  ' Positions a child window relative to a parent. Mode: 1=center, 2=left-bottom align, 3=right-top align, 4=left-bottom shift left, 5=right-top shift up, 6=left-bottom stretch width, 7=right-top stretch height, 8=left-bottom stretch width shift up, 9=right-top stretch height shift left, 10=child masks parent
F.Intrinsic.API.SetWindowText(Handle, Text)
F.Intrinsic.API.UnhideWindow(Hwnd)  ' Will unhide a window the user wants to show again
F.Intrinsic.API.UnlockWindowUpdate()  ' Enables drawing in the window
```

## Intrinsic.Control
```
F.Intrinsic.Control.AddEventHandler(EventName, CalledSubName)  ' Creates an event for a comm control
F.Intrinsic.Control.AndIf(FirstArgument, EvaluationCriteria, SecondArgument)
F.Intrinsic.Control.BlockEvents()  ' This function will stop any events from firing after it is called. Once UnBlo...
F.Intrinsic.Control.CaseAny(variable1, variable2, …., variableN)  ' Matches if SelectCase expression equals ANY of the listed values (variadic)
F.Intrinsic.Control.CaseElse  ' Default branch when no Case/CaseAny/CaseRange matches
F.Intrinsic.Control.CaseRange(StartRange, EndRange)  ' Matches if SelectCase expression falls within the inclusive range [StartRange..EndRange]; both args as Any
F.Intrinsic.Control.Catch()  ' If an exception is raised within a Try block, and no CatchWhen statements wit...
F.Intrinsic.Control.CatchWhen(ErrorNumber)  ' CatchWhen evaluates an exception thrown within a Try block. If the thrown err...
F.Intrinsic.Control.ClearErrors()  ' This will clear out errors that have been “caught” by the Sub Routine.
F.Intrinsic.Control.Do  ' Creates a loop to process data. Can be used to cycle through a recordset and ...
F.Intrinsic.Control.DoEvents()  ' Allows user to speed up processing time
F.Intrinsic.Control.DoUntil(FirstArgument, EvaluationCriteria, SecondArgument)  ' Loop that continues until…
F.Intrinsic.Control.Else()
F.Intrinsic.Control.ElseIf(FirstArgument, EvaluationCriteria, SecondArgument)
F.Intrinsic.Control.End  ' Ends the program. Used in the Unload event for a form, or in any subroutine to terminate the program.
F.Intrinsic.Control.EndIf()
F.Intrinsic.Control.EndTry()  ' This function compalted a Try block within GAB. This will be located after al...
F.Intrinsic.Control.ErrorResume(Expression)
F.Intrinsic.Control.ExitDo()  ' Function.Intrinsic.Control.ExitDo
F.Intrinsic.Control.ExitFor(ControlVariableName)
F.Intrinsic.Control.ExitSub()  ' Function.Intrinsic.Control.ExitSub
F.Intrinsic.Control.ExitTry()  ' This function immediately exits processing within a Try block, skipping every...
F.Intrinsic.Control.Finally()  ' This statement identifies code within a Try block that will execute upon comp...
F.Intrinsic.Control.For(ControlVariableName[Long], StartNumber [Long], EndNumber [Long], StepNumber [Long])  ' A basic For Loop.
F.Intrinsic.Control.GoTo(LabelName)
F.Intrinsic.Control.If(FirstArgument, EvaluationCriteria, SecondArgument) or  ' Selection set to process data, use psuedo-code (Native Language such as Engli...
F.Intrinsic.Control.IIf(Left Expression , Evaluation criteria, Right Expression, true return value, false return value, return variable)  ' Evaluates left and right values and returns the result
F.Intrinsic.Control.IsInCallstack()  ' This function returns a long integer indicating the number of active call sta...
F.Intrinsic.Control.Label(Name)
F.Intrinsic.Control.Loop()  ' Function.Intrinsic.Control.Loop
F.Intrinsic.Control.Next(ControlVariableName)
F.Intrinsic.Control.RaiseError(ErrorNumber, ErrorText)  ' This command can be used to raise user-defined errors within GAB programs. Va...
F.Intrinsic.Control.SetErrorHandler(ErrorHandlerName)
F.Intrinsic.Control.SetVBSErrRepLev(Mode)  ' Turns the VBS Error Log on or off.
F.Intrinsic.Control.Try()  ' This function starts a Try block within GAB, which should contain a Catch, an...
F.Intrinsic.Control.UnBlockEvents()  ' This allows events to fire again in GAB scripts after BlockEvents has been used.
```

## Intrinsic.Debug

> **Authority:** `API_PRINTER.md` is the curated reference for Debug APIs. This dump includes additional functions not in the curated file, but **arity differs** for several shared entries (e.g. `TimerStart`, `TimerElapsed`, `DumpVariableList`, `WatchVariable`). When in conflict, prefer `API_PRINTER.md` signatures.

```
F.Intrinsic.Debug.CallWrapperDebugDisable()
F.Intrinsic.Debug.CallWrapperDebugEnable()
F.Intrinsic.Debug.CallWrapperDebugEnableSilent()
F.Intrinsic.Debug.DumpOutputHookfile()
F.Intrinsic.Debug.DumpVariableList()  ' Writes the Variables used in the GAS program in a .debug file in the user’s T...
F.Intrinsic.Debug.EnableLogging  ' This command is used to enable logging from a gab script. The log file has in...
F.Intrinsic.Debug.InvokeDebuggerInDebug()  ' Function.Intrinsic.Debug.InvokeDebuggerInDebug
F.Intrinsic.Debug.OverrideGSSVersion()  ' This function allows for the testing of future version GAB commands, with a c...
F.Intrinsic.Debug.Print(Value)  ' This command places text in the debuggers Immediate window.
F.Intrinsic.Debug.Resume()  ' This function can be used in conjunction with [[Function.Intrinsic.Control.Se...
F.Intrinsic.Debug.SetErrorTimeout(seconds as int)  ' This command will make GAB error dialogs dismiss themselves after the specifi...
F.Intrinsic.Debug.SetLABuild(Base STring, Args)  ' Replaces last Action string with the specified base string
F.Intrinsic.Debug.SetLevel(DebugLevel)  ' Sets the debug level
F.Intrinsic.Debug.SetProgramDirectory(OverrideDirectory)
F.Intrinsic.Debug.TimerElapsed(Name, ReturnVariable)  ' TimerElapsed returns, in seconds, the duration that has passed since TimerSta...
F.Intrinsic.Debug.TimerElapsedTicks(Name, Return)  ' TimerElapsed returns, in ticks,the duration that has passed since TimerStart ...
F.Intrinsic.Debug.TimerStart(Name)  ' TimerStart allows coders to put named, second-resolution performance timers i...
F.Intrinsic.Debug.ToggleOutput(Expression)
F.Intrinsic.Debug.ToggleOutputListing()  ' Creates a .debug file in the Users Temp Directory.
F.Intrinsic.Debug.WatchVariable(FullyQualifiedVariableName, Value)  ' While a program is executing in Debug, this will pause execution when the var...
```

## Intrinsic.Hash
```
F.Intrinsic.Hash.AddItem(HashTable, Key, Value)  ' Adds entry to hash table (first call creates it); all params String
F.Intrinsic.Hash.Clear(HashTable)  ' Clears hash table; HashTable as String. Overload: Clear(Name, IgnoreUninitializedHash) both String
F.Intrinsic.Hash.ItemCount(HashTable, Return)  ' Returns item count; HashTable as String, Return as Long
F.Intrinsic.Hash.LookupByKey(HashTable, Key, TextCompare, ReturnVariable)  ' Finds value by key; HashTable/Key/ReturnVariable as String, TextCompare as Boolean (True=case-insensitive)
F.Intrinsic.Hash.LookupByValue(HashTable, Value, TextCompare, ReturnVariable)  ' Finds key by value; HashTable/Value/ReturnVariable as String, TextCompare as Boolean (True=case-insensitive)
F.Intrinsic.Hash.RemoveItemByKey()  ' Removes hash entry by key
F.Intrinsic.Hash.RemoveItemByValue()  ' Removes all hash entries matching a value
```

## Intrinsic.IPM
See consolidated IPM section in `agents/gab/API_AUTOMATION.md` under **IPM (Inter-Process Messaging)**.

## Intrinsic.Localization
```
F.Intrinsic.Localization.GetProperty(Property Name, Return Value)  ' Gets a localization property; Property Name as String, Return Value as Any
```


## Intrinsic.Printer
```
F.Intrinsic.Printer.SelectPrinterByNameExact(PrinterName, ReturnVariable)
F.Intrinsic.Printer.SelectPrinterByNameFragment(PrinterNameFragment, ReturnVariable)
F.Intrinsic.Printer.SelectPrinterDialog(sResult)  ' Shows a printer dialog box; returns selected printer name in sResult
F.Intrinsic.Printer.SetDefaultPrinter()  ' This function sets the default printer for Windows, system-wide. This can be ...
```

## Intrinsic.Task

> **Authority:** `API_PRINTER.md` is the curated reference for Task APIs. This dump includes additional functions not in the curated file, but **arity and parameter names differ** for several shared entries (e.g. `LaunchSync`, `LaunchGSSAsync`, `CreateLock`). When in conflict, prefer `API_PRINTER.md` signatures.

```
F.Intrinsic.Task.AppActivate(Title/pid)  ' Activate application
F.Intrinsic.Task.AuthLaunchAsync()  ' Allows a user to run a program with another users security credentials
F.Intrinsic.Task.AuxInfoEnable()  ' This function controls extended behavior on F.In.Task.LaunchAsync/LaunchSync....
F.Intrinsic.Task.CheckExtension(File, Verb, ReturnVariable)  ' This function returns details of the program (if any) that is associated with...
F.Intrinsic.Task.CheckLock(Filename, ReturnVariable)  ' Checks to see if a lock is active
F.Intrinsic.Task.CreateLock(Filename)  ' Creates a lock on a program so that it may only run in one place at a time
F.Intrinsic.Task.FindExecutable(Filename, ReturnVariable)
F.Intrinsic.Task.IsProgramRunning(Program, ReturnVariable)  ' This function returns a true or false depending on whether the specified exec...
F.Intrinsic.Task.KillPID(PID)  ' Kills the process with the specified Process ID; PID as String
F.Intrinsic.Task.LaunchGSSAsync(Program, WrunFlags, Params, ReturnVariable)
F.Intrinsic.Task.LaunchSync(Path, Time)  ' Launches program dependant on other programs.
F.Intrinsic.Task.ReadEnvironmentVariableValueByPID(Environment Variable, PID, Return)  ' Gets the value of an environment variable for a specified process ID.
F.Intrinsic.Task.ReadEnvironmentVariableValuesByPID(PID, Return)  ' Gets the envrionment variables and their values for a specified process ID.
F.Intrinsic.Task.SendKeys()  ' Use the sendKeys method to send keystrokes or combinations of keystrokes to t...
F.Intrinsic.Task.TerminatePID()  ' This function terminates a process, given its PID. Note: This command will on...
```

## Unofficial.Script
VBScript hosting engine -- allows executing VBScript code from within GAB. Use `AddCode` to load a VBS sub/function, then `Run` to invoke it.
```
F.Unofficial.Script.AddCode(Code)  ' Adds VBScript code to the script engine; Code as String
F.Unofficial.Script.AllowUI(Flag)  ' Enables/disables UI interaction from the script engine; Flag as Boolean
F.Unofficial.Script.Eval(Expression, Return)  ' Evaluates a VBScript expression and returns the result; Expression as String, Return as Any
F.Unofficial.Script.ExecuteStatement(Value)  ' Executes a single VBScript statement; Value as String
F.Unofficial.Script.Reset()  ' Resets the script engine, clearing all loaded code
F.Unofficial.Script.Run(Expression, [Param1], ..., [Param9])  ' Calls a VBScript sub/function loaded via AddCode; Expression as String, up to 9 optional Any params
F.Unofficial.Script.SetHostHWND(Value)  ' Sets the host window handle for the script engine; Value as Long
```

**Example -- Run VBScript from GAB:**
```
V.Local.Script.Declare(String,"")
F.Intrinsic.String.Concat("Sub MyProcedure(Param1) : MsgBox ""Param1: "" & Param1 : End Sub", V.Local.Script)
F.Unofficial.Script.AddCode(V.Local.Script)
F.Unofficial.Script.Run("MyProcedure","Hello from GAB!")
```

## Program.Requires.Manifest
```
Program.Requires.Manifest.Add(ManifestFilename)
Program.Requires.Manifest.Check()
```

## Program.Sub.Action
```
Program.Sub.Action.ExitIfSuperseded  ' This function marks the executing call stack entry as being superseded by sub...
```

## Program.Sub.subroutine
```
Program.Sub.subroutine.Start()
```

## Sample.form.SampleControl
```
Sample.form.SampleControl.SampleMethod(Tile View Name [String], Column Name [String], DataType [String], Visible [Boolean])  ' Command Description 1
```

# OCTSRS Component Reference (Runtime Implementation)

## Component Reference: CalcComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\CalcComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\CalcComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~936 lines

### Runtime purpose
The Calc Component provides OpenOffice Calc (spreadsheet) integration for creating, reading, and manipulating spreadsheet files.

### Implementation notes (OCTSRS)
#### Legacy Behavior
- Uses COM Automation for OpenOffice interaction
- UserDefinedObjects collection for object tracking
- Caches registry check result

#### Object Management
- Creates application objects that must be terminated
- Workbook/worksheet objects tracked by name
- Container pattern for object lifecycle

#### Migration Notes
- COM interop dependency
- No database interaction
- Consider modern libraries (EPPlus, ClosedXML) for newer implementations

### Dependencies
#### External Dependencies
- OpenOffice/LibreOffice installation
- COM Automation (com.sun.star.servicemanager)

#### Components Called
- None directly

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `CHECKPRESENCE` | Check if OpenOffice is installed |
| `CREATEAPPOBJECT` | Create OpenOffice application object |
| `CREATECONTAINER` | Create OO container |
| `TERMINATEAPP` | Terminate OpenOffice application |
| `CREATEWORKBOOK` | Create a new workbook |
| `OPENWORKBOOK` | Open an existing workbook |
| `SAVEWORKBOOK` | Save a workbook |
| `CREATEWORKSHEET` | Create a new worksheet |
| `OPENWORKSHEET` | Open/activate a worksheet |
| `GETWORKSHEETCOUNT` | Get number of worksheets |
| `READCELL` | Read a cell value |
| `WRITECELL` | Write a cell value |
| `READROW` | Read an entire row |
| `READSPREADSHEET` | Read entire spreadsheet |
| `WRITESPREADSHEET` | Write entire spreadsheet |

### Key method signatures & edge cases
#### `CHECKPRESENCE`
**GAB Syntax:** `Function.Global.Calc.CheckPresence(Variable.Local.IsInstalled)`

**Purpose:** Checks if OpenOffice is installed by looking for registry entry.

**Returns:** Boolean - True if com.sun.star.servicemanager registry entry exists

#### `READCELL`
**GAB Syntax:** `Function.Global.Calc.ObjectName.ReadCell(Row, Column, Variable.Local.Value)`

**Purpose:** Reads a value from a specific cell.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Row | Integer | Yes | Row number |
| 2 | Column | Integer | Yes | Column number |
| R | Value | String | Yes | Return - Cell value |

#### `WRITECELL`
**GAB Syntax:** `Subroutine.Global.Calc.ObjectName.WriteCell(Row, Column, Value)`

**Purpose:** Writes a value to a specific cell.

---

## Component Reference: ControlComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\ControlComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\ControlComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~1,164 lines

### Runtime purpose
The Control Component provides program flow control operations including conditionals, loops, error handling, and event management. This is a core component that manages script execution flow.

### Implementation notes (OCTSRS)
#### Core Component
- Does not inherit from BaseComponent
- Returns Boolean from InvokeMethod (unlike other components)
- Manages GabProgram execution flow

#### Execution Control
- Manipulates SubroutineLineIndex for flow control
- Manages CallStack for subroutine calls
- Handles HaltExecution flag

#### Migration Notes
- No database interaction
- Core runtime component
- Critical for script execution

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `ENDSELECT` | End select block |

### Key method signatures & edge cases
#### `FOR`
**GAB Syntax:** `Control.For(Variable, Start, End, [Step])`

**Purpose:** Starts a for loop.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Variable | Variable | Yes | Loop counter |
| 2 | Start | Integer | Yes | Start value |
| 3 | End | Integer | Yes | End value |
| 4 | Step | Integer | No | Step increment |

#### `CATCH`
**GAB Syntax:** `Control.Catch([ExceptionType])`

**Purpose:** Catches exceptions in try blocks.

#### `RAISEERROR`
**GAB Syntax:** `Control.RaiseError(ErrorNumber, [ErrorDescription])`

**Purpose:** Raises a custom error.

---

## Component Reference: HashComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\HashComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\HashComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~269 lines

### Runtime purpose
The Hash Component provides hash table (dictionary) functionality for fast key-value lookups.

### Implementation notes (OCTSRS)
#### vs DictionaryComponent
- Simpler than DictionaryComponent
- Uses cHashTables internal class
- Consider DictionaryComponent for more features

#### Migration Notes
- No database interaction
- Pure in-memory storage

### Dependencies
#### External Dependencies
- None (uses cHashTables internal class)

---

### Key method signatures & edge cases
#### `ADDITEM`
**GAB Syntax:** `Subroutine.Global.Hash.HashTableName.AddItem(Key, Value)`

**Purpose:** Adds a key-value pair to the hash table.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Key | String | Yes | Item key |
| 2 | Value | Object | Yes | Item value |

#### `LOOKUPBYKEY`
**GAB Syntax:** `Function.Global.Hash.HashTableName.LookupByKey(Key, Variable.Local.Value)`

**Purpose:** Finds a value by its key.

#### `LOOKUPBYVALUE`
**GAB Syntax:** `Function.Global.Hash.HashTableName.LookupByValue(Value, Variable.Local.Key)`

**Purpose:** Finds a key by its value (reverse lookup).

---

## Component Reference: StringComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\StringComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\StringComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~3,107 lines

### Runtime purpose
The String Component provides comprehensive string manipulation functions including formatting, searching, encoding, parsing, and transformation operations.

### Implementation notes (OCTSRS)
#### Performance
- Large component with many methods
- Regex operations can be CPU-intensive
- Consider caching compiled regex patterns

#### Encoding
- Supports multiple encodings
- UTF-8, ASCII, Unicode support
- URL and HTML encoding for web

#### Migration Notes
- No database interaction
- Pure string manipulation
- Uses .NET string functions

### Dependencies
#### External Dependencies
- System.Text.RegularExpressions

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `MID` | Get middle portion |
| `TRIM` | Trim whitespace |
| `LTRIM` | Left trim |
| `RTRIM` | Right trim |
| `UCASE` | Convert to uppercase |
| `LCASE` | Convert to lowercase |
| `SPLIT` | Split string |
| `JOIN` | Join array to string |
| `INSTR` | Find substring position |
| `INSTRREV` | Find from end |
| `ISINSTRING` | Check if contains |
| `REGEXMATCH` | Regex match |
| `REGEXREPLACE` | Regex replace |
| `BASE62ENCODE` | Base62 encode |
| `BASE62DECODE` | Base62 decode |
| `BASE64ENCODE` | Base64 encode |
| `BASE64DECODE` | Base64 decode |
| `URLENCODE` | URL encode |
| `URLDECODE` | URL decode |
| `HTMLENCODE` | HTML encode |
| `HTMLDECODE` | HTML decode |
| `DECODEUTF8` | Decode UTF-8 |
| `CONVERTDEC2HEX` | Decimal to hex |
| `CONVERTHEX2DEC` | Hex to decimal |
| `CONVERTTOSTRING` | Convert to string |
| `CONVERTSTRING2BA` | String to byte array |
| `CONVERTBA2STRING` | Byte array to string |
| `CALCULATEMD5HASH` | Calculate MD5 |
| `CALCULATESHA1HASH` | Calculate SHA1 |
| `GSSPARTSTRING` | Format GSS part number |
| `MAKEURLFRIENDLY` | URL-safe string |
| `CHUNK` | Split into chunks |
| `SEEK` | Find in delimited string |
| `DOUBLEDELIMITEDSEEK` | Double-delimited search |
| `DELIMITEDSTRINGTOCSV` | Convert to CSV |

### Key method signatures & edge cases
#### `FORMAT`
**GAB Syntax:** `Function.Global.String.Format(Value, FormatString, Variable.Local.Result)`

**Purpose:** Formats a value using a format string.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Value | Object | Yes | Value to format |
| 2 | FormatString | String | Yes | Format specification |
| R | Result | String | Yes | Return - Formatted string |

#### `GSSPARTSTRING`
**GAB Syntax:** `Function.Global.String.GSSPartString(Part, Revision, Variable.Local.Result)`

**Purpose:** Formats a GSS part number with revision.

#### `REGEXMATCH`
**GAB Syntax:** `Function.Global.String.RegexMatch(Input, Pattern, Variable.Local.Matches)`

**Purpose:** Performs regex pattern matching.

#### `SPLIT`
**GAB Syntax:** `Function.Global.String.Split(Input, Delimiter, Variable.Local.Array)`

**Purpose:** Splits a string into an array.

---

## Component Reference: VariableComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\VariableComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\VariableComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~2,947 lines

### Runtime purpose
The Variable Component provides variable management operations including array manipulation, type checking, argument passing, and user-defined type (UDT) operations.

### Implementation notes (OCTSRS)
#### Call Stack Integration
- Manages argument passing between subroutines
- Integrates with GabProgram call stack
- Handles local vs global variables

#### UDT Support
- User-defined types for complex data
- Can load/save from recordsets
- Supports sorting and manipulation

#### Array Flexibility
- Dynamic array sizing
- Multiple element types
- Stack operations (push/pop)

#### Migration Notes
- Uses ADODB for recordset operations
- Core runtime component
- Variable management is central to script execution

### Dependencies
#### External Dependencies
- ADODB (for recordset operations)

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `ADDPV` | Add passed variable |
| `ADDRV` | Add return variable |
| `CLEARPV` | Clear passed variables |
| `PASSEDEXISTS` | Check if passed exists |
| `ARGEXISTS` | Check if argument exists |
| `ARGTOVAR` | Argument to variable |
| `ADDTOARRAY` | Add element to array |
| `POPARRAY` | Pop from array |
| `PUSHARRAY` | Push to array |
| `REMOVEARRAYELEMENTBYORDINAL` | Remove by index |
| `REMOVEARRAYELEMENTBYVALUE` | Remove by value |
| `ARRAYTRIM` | Trim array |
| `LBOUND` | Get lower bound |
| `UBOUND` | Get upper bound |
| `ISARRAY` | Check if array |
| `ARRAYAVERAGE` | Array average |
| `ARRAYMAX` | Array maximum |
| `ARRAYMIN` | Array minimum |
| `ISNULL` | Check if null |
| `ISARRAY` | Check if array |
| `SETNUMERIC` | Set as numeric |
| `BITARRAYTOLONG` | Bit array to long |
| `LONGTOBITARRAY` | Long to bit array |
| `BITARRAYINSTRINGTOLONG` | String bit array to long |
| `LOADUDTFROMSTRING` | Load UDT from string |
| `LOADUDTFROMRECORDSET` | Load UDT from recordset |
| `SAVEUDTTORECORDSET` | Save UDT to recordset |
| `SETUDTVALUE` | Set UDT field value |
| `GETUDTVALUE` | Get UDT field value |
| `SORTUDTARRAY` | Sort UDT array |
| `FINDIDFROMNAME` | Find variable ID |
| `LISTCALLERVARS` | List caller variables |

### Key method signatures & edge cases
#### `ADDPV`
**GAB Syntax:** `Subroutine.Global.Variable.AddPV(VariableName, Value)`

**Purpose:** Adds a variable to the passed variables collection for subroutine calls.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | VariableName | String | Yes | Variable name |
| 2 | Value | Object | Yes | Variable value |

#### `ADDTOARRAY`
**GAB Syntax:** `Subroutine.Global.Variable.AddToArray(ArrayName, Value)`

**Purpose:** Adds an element to the end of an array.

#### `LOADUDTFROMRECORDSET`
**GAB Syntax:** `Subroutine.Global.Variable.LoadUDTFromRecordset(UDTName, RecordsetName)`

**Purpose:** Populates a UDT from a database recordset.

#### `SORTUDTARRAY`
**GAB Syntax:** `Subroutine.Global.Variable.SortUDTArray(ArrayName, SortField, [Ascending])`

**Purpose:** Sorts an array of UDTs by a specified field.

---

## Component Reference: WorkflowComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\WorkflowComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\WorkflowComponent.vb`
- **Feature toggle:** `TBD - Check Components_FeatureToggles.xlsx`
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~5,284 lines

### Runtime purpose
The Workflow Component provides comprehensive workflow management functionality including workflow creation, templates, line items, dependencies, documents, notes, and execution tracking.

### Implementation notes (OCTSRS)
#### Legacy Behavior
- Uses `cWorkFlowFunctionality` helper class
- Supports both workflows and templates
- Templates can be used to create multiple workflows
- Hierarchical workflows via WF_PARENT

#### Association Types
- ASSOC_TYPE = 0: Workflow-level
- ASSOC_TYPE = 1: Line-level

#### Dependency System
- Lines can depend on other lines
- `CHECKLINEDEPENDENCY` verifies all dependencies complete
- Prevents out-of-order completion

#### Import/Export
- Workflows can be exported to file
- Templates can be shared between systems
- Import recreates structure with new IDs

#### Known Issues
- Large workflows may have performance impact
- Complex dependency chains need careful management

#### Migration Notes
- Uses ADODB Recordset extensively
- Connection type: Company database (ActianCompanySqlConnection)
- SQL uses string concatenation - needs parameterization
- Multiple related tables need transaction handling
- Table existence checks via `HasTable()`

### Dependencies
#### Components Called
- `GlobalShopComponent` - For GSS integration
- `HookAssociationComponent` - For hook processing
- `DocumentControlComponent` - For document management

#### Called By
- Workflow management screens
- Task assignment
- Process automation
- Quality control checklists
- Approval processes

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `DELETEDEPENDENCY` | Delete a dependency |

### Key method signatures & edge cases
#### `CREATE`
**GAB Syntax:** `Function.Global.Workflow.Create(Title, StartDate, DueDate, ParentID, Variable.Local.WorkflowID)`

**Purpose:** Creates a new workflow instance.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Title | String | Yes | Workflow title |
| 2 | StartDate | Date | Yes | Start date |
| 3 | DueDate | Date | Yes | Due date |
| 4 | ParentID | Long | No | Parent workflow ID |
| R | WorkflowID | Long | Yes | Return - Created workflow ID |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| ATG_WF_Header | INSERT | Workflow header |

#### `CREATEFROMTEMPLATE`
**GAB Syntax:** `Function.Global.Workflow.CreateFromTemplate(TemplateID, Title, StartDate, DueDate, Variable.Local.WorkflowID)`

**Purpose:** Creates a workflow from an existing template, copying all lines, dependencies, and documents.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | TemplateID | Long | Yes | Template ID to copy from |
| 2 | Title | String | Yes | New workflow title |
| 3 | StartDate | Date | Yes | Start date |
| 4 | DueDate | Date | Yes | Due date |
| R | WorkflowID | Long | Yes | Return - Created workflow ID |

#### `ADDLINE`
**GAB Syntax:** `Function.Global.Workflow.AddLine(WorkflowID, LineNumber, Description, AssignedTo, Priority, DueDate, Variable.Local.LineID)`

**Purpose:** Adds a line item (task) to a workflow.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | WorkflowID | Long | Yes | Workflow ID |
| 2 | LineNumber | Integer | Yes | Line number |
| 3 | Description | String | Yes | Task description |
| 4 | AssignedTo | String | Yes | User/group assigned |
| 5 | Priority | Integer | Yes | Priority level |
| 6 | DueDate | Date | Yes | Line due date |
| R | LineID | Long | Yes | Return - Created line ID |

#### `COMPLETELINE`
**GAB Syntax:** `Subroutine.Global.Workflow.CompleteLine(LineID, CompletedBy, CompletionDate)`

**Purpose:** Marks a workflow line as complete.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | LineID | Long | Yes | Line ID to complete |
| 2 | CompletedBy | String | Yes | User completing |
| 3 | CompletionDate | DateTime | Yes | Completion timestamp |

#### `CHECKLINEDEPENDENCY`
**GAB Syntax:** `Function.Global.Workflow.CheckLineDependency(LineID, Variable.Local.DependenciesMet)`

**Purpose:** Checks if all dependencies for a line are satisfied.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | LineID | Long | Yes | Line ID to check |
| R | DependenciesMet | Boolean | Yes | Return - True if all met |

#### `READASSIGNEDLINES`
**GAB Syntax:** `Function.Global.Workflow.ReadAssignedLines(UserID, Variable.Local.LineList)`

**Purpose:** Retrieves all workflow lines assigned to a user.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | UserID | String | Yes | User to check |
| R | LineList | String | Yes | Return - Delimited line list |

---
