# GAB External Automation & Global Functions Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with .NET interop, CallWrappers, and F.Global.* surface documented in the Global Functions section
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

# EXTERNAL AUTOMATION (.NET)

Import a .NET DLL into GAB to integrate external business logic directly into GAB workflows without building custom executables. The process is: add the DLL to File References, load it with `LoadAssembly`, instantiate a class with `CreateObject`, call methods with `CallMethod` / `CallMethodReturnVariable`, and clean up with `DestroyObject`.

## Quick Reference
```
F.Automation.Generic.LoadAssembly(AssemblyAlias, sFullPath)
F.Automation.Generic.CreateObject(AssemblyAlias, Namespace.ClassName, "InstanceName")
F.Automation.Generic.CallMethod(INSTANCENAME, MethodName, sParams)
F.Automation.Generic.CallMethodReturnVariable(INSTANCENAME, MethodName, sParams, sResult)
F.Automation.Generic.CallMethodReturnObject(ObjectName, ReturnObject, MethodName, Args)
F.Automation.Generic.DestroyObject("InstanceName")
```

## Step 1 -- Add DLL to File References

In the GAB Code Editor, open the **References** tab and add the DLL under **User Included Files**. The DLL name added here **must match** the assembly alias used in `LoadAssembly`.

Additionally, declare the DLL in the script's **Preflight** block using `Program.External.Include.File`:
```
Program.Sub.Preflight.Start
Program.External.Include.File("MyLibrary.dll",False)
Program.Sub.Preflight.End
```
The second parameter (`False`) means the file is not a GAB library (`.lib`); it is a .NET DLL.

## Step 2 -- Load the Assembly

Build the fully qualified path to the DLL and load it. The DLL is typically deployed alongside the script, so `V.Ambient.ScriptPath` is the standard base path.

```
V.Local.sAssemblyFQP.Declare
F.Intrinsic.String.Build("{0}\AllianceTestClassLibrary.dll", V.Ambient.ScriptPath, V.Local.sAssemblyFQP)
F.Automation.Generic.LoadAssembly(AllianceTestClassLibrary, V.Local.sAssemblyFQP)
```

| Argument | Type | Description |
|----------|------|-------------|
| AssemblyAlias | Unquoted name | Logical name for the assembly (must match the DLL name added to File References) |
| FullPath | String | Fully qualified path to the DLL file |

## Step 3 -- Create an Object Instance

Instantiate a class from the loaded assembly.

```
F.Automation.Generic.CreateObject(ALLIANCETESTCLASSLIBRARY, AllianceHcmIntegration.Alliance, "alliance")
```

| Argument | Type | Description |
|----------|------|-------------|
| AssemblyAlias | Unquoted name | Assembly alias from `LoadAssembly` (case-insensitive) |
| Namespace.ClassName | Unquoted | Fully qualified class name within the assembly |
| InstanceName | String | Quoted handle name for this object instance. Used in subsequent `CallMethod` / `CallMethodReturnVariable` / `DestroyObject` calls (both quoted and unquoted forms work; case-insensitive) |

## Step 4 -- IntelliSense

Once the DLL is added to File References and loaded, GAB IntelliSense displays:
- Available **namespaces** and **classes** when typing the namespace prefix
- Available **methods** inside `CallMethod` / `CallMethodReturnVariable` arguments
- **Method signatures** on hover, including parameter names, types, and return type

## Step 5 -- Call a Void Method (CallMethod)

Use `CallMethod` when the .NET method does not return a value. Arguments are passed as a **single string**. When the .NET method has **multiple parameters**, separate values with `*!*` in method-signature order. When the method takes a **single string parameter**, the string content and any internal delimiter are defined by the DLL itself.

```
' Multi-parameter .NET method -- use *!* delimiter
V.Local.sParams.Declare
V.Local.companyId.Declare(String, "VALUE")
V.Local.userName.Declare(String, "VALUE")
V.Local.password.Declare(String, "VALUE")
F.Intrinsic.String.Build("{0}*!*{1}*!*{2}", V.Local.companyId, V.Local.userName, V.Local.password, V.Local.sParams)
F.Automation.Generic.CallMethod(ALLIANCE, AuthorizeCredentials, V.Local.sParams)

' Single-parameter .NET method -- delimiter is DLL-defined (here the DLL uses | internally)
V.Local.sInput.Declare
V.Local.sInput.Set("apikey|callref|field1:value1|field2:value2")
F.Automation.Generic.CallMethod(MYOBJECT, ProcessData, V.Local.sInput)
```

| Argument | Type | Description |
|----------|------|-------------|
| InstanceName | Unquoted or quoted | Object handle from `CreateObject` (case-insensitive; both `ALLIANCE` and `"alliance"` work) |
| MethodName | Unquoted | Method name on the .NET class |
| Args | String | Parameter string. Use `*!*` to delimit multiple .NET method parameters; for single-parameter methods, the DLL defines the string format |

## Step 6 -- Call a Method with Return Value (CallMethodReturnVariable)

Use `CallMethodReturnVariable` when the .NET method returns a value. Same parameter rules as `CallMethod`, plus a return variable.

```
V.Local.sReturn.Declare
F.Automation.Generic.CallMethodReturnVariable(ALLIANCE, AuthorizeCredentials, V.Local.sParams, V.Local.sReturn)
```

| Argument | Type | Description |
|----------|------|-------------|
| InstanceName | Unquoted or quoted | Object handle from `CreateObject` (case-insensitive) |
| MethodName | Unquoted | Method name on the .NET class |
| Args | String | Parameter string (same delimiter rules as `CallMethod`) |
| Return | Variable | Receives the return value from the .NET method |

## Step 7 -- Destroy the Object

Release the .NET object when finished.

```
F.Automation.Generic.DestroyObject("alliance")
```

## Complete Example

Real-world pattern: loading a custom .NET DLL and calling a method that takes a single delimited string parameter. The DLL defines its own internal delimiter (`|` in this case).

```
Program.Sub.Preflight.Start
Program.External.Include.File("RocketLaneGAB.dll",False)
Program.Sub.Preflight.End

Program.Sub.Main.Start
F.Intrinsic.Control.SetErrorHandler("Main_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sError.Declare(String,"")
V.Local.sRet.Declare(String)
V.Local.sAssemblyFQP.Declare(String)
V.Local.sApiKey.Declare(String,"rl-XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")
V.Local.sCallRef.Declare(String,"GLO010-3420201237-0")
V.Local.sParams.Declare(String)
V.Local.bStat.Declare(String)

' 1. Build path and load assembly
F.Intrinsic.String.Build("{0}\RocketLaneGAB.dll", V.Ambient.ScriptPath, V.Local.sAssemblyFQP)
F.Automation.Generic.LoadAssembly(RocketLaneGAB, V.Local.sAssemblyFQP)

' 2. Create object instance
F.Automation.Generic.CreateObject(RocketLaneGAB, RocketLaneGAB.RocketLaneUpdater, "MyRocketLaneUpdater")

' 3. Build DLL-defined parameter string (| delimited, field:value pairs)
F.Intrinsic.String.Build("{0}|{1}|C-Create:2020-03-04|C-Reference Number:{1}|C-Sit Rep:Testing%20the%20RocketLane%20Dll|", V.Local.sApiKey, V.Local.sCallRef, V.Local.sParams)

' 4. Call method with return value (instance name is unquoted, case-insensitive)
F.Automation.Generic.CallMethodReturnVariable(MYROCKETLANEUPDATER, UpdateTask, V.Local.sParams, V.Local.sRet)

' 5. Check result
F.Intrinsic.String.IsInString(V.Local.sRet,"SUCCESS",True,V.Local.bStat)
F.Intrinsic.Control.If(V.Local.bStat,=,True)
    F.Intrinsic.UI.Msgbox(V.Local.sRet,"SUCCESS: ")
F.Intrinsic.Control.Else
    F.Intrinsic.UI.Msgbox(V.Local.sRet,"ERROR: ")
F.Intrinsic.Control.EndIf

' 6. Clean up
F.Automation.Generic.DestroyObject("MyRocketLaneUpdater")

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("Main_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber,<>,0)
    F.Intrinsic.String.Build("Project: RocketLaneTest.g2u {0}{0}Subroutine: {1}{0}Error Occurred {2} with description {3}", V.Ambient.NewLine, V.Ambient.CurrentSubroutine, V.Ambient.ErrorNumber, V.Ambient.ErrorDescription, V.Local.sError)
    F.Intrinsic.UI.Msgbox(V.Local.sError)
F.Intrinsic.Control.EndIf
Program.Sub.Main.End
```

## SalesForce Automation
```
F.Automation.SalesForce.SetLoginInfo(sUserName, sPassword, sToken)
F.Automation.SalesForce.SetConnectionString                          ' No args: builds from SetLoginInfo + base connection string
F.Automation.SalesForce.SetConnectionString(sConnectionString)       ' Explicit: ignores SetLoginInfo values
F.Automation.SalesForce.ExecuteSQL(sSOQL)
F.Automation.SalesForce.ExecuteSQL(sSOQL, "param0Name", param0Value, ..., "paramNName", paramNValue)
```

**UPDATE/DELETE limitation:** The SalesForce data provider only supports updating or deleting one row at a time. The primary key (`Id`) is always required in the query.

---

# GLOBAL FUNCTIONS

## CallWrapper (Invoke GSS Standard Programs)
```
F.Global.General.CallWrapperSync(iProgramID,sParams)        ' Synchronous
F.Global.General.CallWrapperAsync(iProgramID,sParams)       ' Asynchronous
F.Global.General.CallWrapperSyncBio(iProgramID,sParams)     ' Sync with BI Output

' New-style wrapper
F.Global.CallWrapper.New("Alias","Namespace.ClassName")
F.Global.CallWrapper.SetProperty("Alias","PropertyName",sValue)
F.Global.CallWrapper.Run("Alias")
F.Global.CallWrapper.GetProperty("Alias","PropertyName",sResult)
```

### Common CallWrapper IDs
| ID | Purpose |
|----|---------|
| 1000 | Fix BOM / REBLDALL |
| 1010 | Update Inventory Description to BOM / BM0050 |
| 1500 | Reprice Routers / RE0071CW |
| 1510 | Admin Reprice Routers/Estimates / RE0019 |
| 2000 | Scrap Reason Code Maintenance / JB0082 |
| 2001 | Quality Reject/Disposition / JB0027 |
| 2002 | Shop Floor Control Tasks / JB0028 |
| 2003 | WIP to Finished Goods / JB0052GI |
| 2004 | WIP to FG (with Action/Reverse) / JB0052GI |
| 2005 | Commit Router Material / JB0056GI |
| 2007 | Open / New / View Work Order / JB0010GI |
| 2009 | Copy Work Order / JB0010GI |
| 3000 | Customer Order Notes / AR002CN |
| 3010 | Contract Part Pricing / ORD231 |
| 3050 | Print Customer Statements / AR0140GI |
| 3200 | Purchase Order Receipt / PUR100GI |
| 3500 | Inventory Maintenance / INVMAIN |
| 3550 | Stand-Alone Issue/Receipts / INV220GI |
| 3600 | Engineering Change Control / ENG002 |
| 3601 | Engineering Change Control Signoff / ENG003 |
| 3801 | Update Quote / QTE003GI |
| 4010 | New Shipments / ORD098 |
| 5000 | Edit Flex Schedule / JB0098 |
| 5100 | Add Router Lines to Work Order / JBUTL001 |
| 5101 | Delete All Sequences from Work Order / JBUTL001 |
| 6000 | Flex Schedule Upload / UPLSCHED |
| 6001 | Upload PL/Discounts / UPLPLDSC |
| 6002 | Upload Quote/Quote Lines |
| 6004 | Upload Sales Orders / ORDUPCM3 |
| 6006 | Payroll (Employee) Master Upload / UPLEMPL |
| 6008 | Upload Job Cost Sequence Lines to Router Header / UPLJOBST |
| 6013 | Upload Customer Master / UPLCUST |
| 6016 | PO Receipts Upload / PUR102 |
| 6017 | Job Master Upload / UPLJBMUL |
| 6020 | Router Master Upload |
| 6021 | Router Master Upload (Alternate) |
| 7041 | Transfer/Moved Orders / ORD743 |
| 7070 | Order Entry History Inquiry - by Order Number / ORD193GI |
| 7100 | Update Allocations / INV060 |
| 7101 | Update Allocations (with Action) / INV060 |
| 7200 | Supply and Demand / INV500GI |
| 8101 | Sales Analysis Reports Preprocessor / PSA000P |
| 9200 | Start Job / OLL304W |
| 9201 | Start Job (with Terminal) / OLL304W |
| 100000 | Customer/Prospect Master |
| 100200 | View Open AR / AR0170GI |
| 175100 | Generate Purchase Order from File / PURA64GI |
| 175200 | Open Purchase Order / PUR064GH |
| 200000 | Sales Orders / ORD200 |
| 200700 | Sales Order History by Invoice / QL3060 |
| 200800 | Create WO from Sales Order / ORD880 |
| 200801 | Sales Order to Work Order / ORD880 |
| 200803 | Create WO from Sales Order (Extended) / ORD880 |
| 200900 | Reprint Invoice (Screenless) / QL3060 |
| 251000 | Quote Header Screen / QTE200 |
| 300000 | Inventory Maintenance/View / INVMAIN |
| 300010 | Inventory by Part and Location |
| 201500 | Create Part |
| 300011 | Supply and Demand w/ Switch / INV500GI |
| 300060 | Update Item Master For Issued Parts / LOT155GI |
| 300070 | Update Inventory Usage / INV756 |
| 400000 | Estimating/Standard Routers / RE0010GI |
| 410000 | Exploded BOM/Router File Generator / BOM0048 |
| 450000 | Work Order Query / WOQUERY |
| 450100 | Issue Material to Job From File / WIR100 |
| 450101 | Issue Material to Job From File (Tab) / WIR100/T |
| 450150 | Reverse Issue Material From Job / JB0075GI |
| 500000 | APS Scheduling Information Download / SQLGSLOD |
| 500030 | Schedule Job / JB0011CL |
| 600002 | Activate Hook w/ Widget and Runtime / HOOK02 |
| 900100 | Print Barcode Work Order Extended / BJ020LZ |
| 900200 | Print Work Order Pick List / JB0053 |
| 900300 | Print Flex Schedule / JB0095N |
| 910050 | Print Sales Order / ORD0ACKN |
| 910200 | Print Sales Order Pick List / ORD054 |
| 910201 | Print Shipment Pick List / ORD055 |
| 915000 | Print PO / PUR1LZ |
| 920000 | Print Quote / QTL010 |
| 930000 | Build Payroll Report Table / JB032BGI |

## System Options
```
F.Global.General.ReadOption(iOptionID,3,"","0000",V.Local.sResult)
F.Global.General.ReadOption(iOptionID,3,iDefault,"0001",V.Local.iResult)
F.Global.General.SaveOption(iOptionID,"0000",False,"","","",iValue,"")
F.Global.General.SaveOption(iOptionID,"0000",False,"","","","","",iValue)
F.Global.General.SaveOption(iOptionID,"0000","","","","",iValue,"")    ' 3rd param can be string or boolean
```

## General Utilities
```
F.Global.General.GetCompanyCodes(sResult)                      ' Get all company codes
F.Global.General.GetScriptOrigin(sResult)                      ' How script was launched
F.Global.General.GetMenuPathFromJobstreamID(iJobstreamID,sResult)
F.Global.General.GetServiceWorker(sResult)                     ' Get service worker info
F.Global.General.FireHook(iHookID,"Key1","Value1","Key2","Value2")  ' Trigger a hook
F.Global.General.CreateSoftLock(sType,sKey,iLockID)            ' Create advisory lock
F.Global.General.DestroySoftLock(sType,sKey,iLockID)           ' Release advisory lock
F.Global.General.ResetPassedDataElements                       ' Clear passed data
F.Global.General.SetPassedDataElement("Key",sValue)            ' Set data for CallWrapper
F.Global.General.CallSyncGAS(sScriptPath,sArgs)               ' Call GAS script synchronously
F.Global.General.CallAsyncGAS(sScriptPath,sArgs)               ' Call GAS script asynchronously
F.Global.General.LaunchMenuTask(iMenuID,iTaskID,sResult)       ' Launch a GSS menu task programmatically
```

## Encryption
```
F.Global.Encryption.Encrypt(sPlainText,sEncrypted)
F.Global.Encryption.Decrypt(sEncrypted,sDecrypted)
F.Global.Encryption.Decrypt(baEncryptedBytes,sDecrypted)     ' Decrypt from ByteArray
```

## Security
```
F.Global.Security.CheckUserAccessIPM(iMenuID,iLevel,V.Local.bResult)
F.Global.Security.GetEmpNoFromUser(sUser,V.Local.sResult)
F.Global.Security.GetUserGroups(sUser,sResult)
F.Global.Security.GetUserID(sUser,iResult)
F.Global.Security.IsInGroup(sUser,sGroup,sCompany,bResult)    ' Check if user belongs to a security group
F.Global.Security.GetUserEmail(sUser,sCompany,sResult)        ' Get user's email address
```

## Registry (User Settings Persistence)
```
F.Global.Registry.AddValue(sUser,sCompany,"ProgramName",iRegID,iSeq,False,"Key",False,0,-999.0,1/1/1980,12:00:00 AM,sValue)
F.Global.Registry.ReadValue(sUser,sCompany,"ProgramName",iRegID,iSeq,6,"",sResult)
```

## Document Control
```
F.Global.DocumentControl.GetLinkID(Key,LinkType,ReturnVariable)  ' Key as String, LinkType as Long (see LinkType table), ReturnVariable as Long
F.Global.DocumentControl.CreateReference(Key,Type,ReturnID)  ' Key as String, Type as Long (LinkType ID), ReturnID as Long (creates or returns existing)
F.Global.DocumentControl.AddDocument(LinkID,FileName,Description,Group,[UserName],[FileType],[NoUNC],[NonRev])  ' LinkID as Long; FileName/Description as String; Group as Long; optional: UserName/FileType as String, NoUNC/NonRev as Boolean
F.Global.DocumentControl.DeleteDocument(DocId)  ' Deletes a document; DocId as Long
F.Global.DocumentControl.GetDocumentID(LinkId,File,ReturnVariable)  ' Gets doc ID; LinkId as Long, File as String, ReturnVariable as Long
F.Global.DocumentControl.GetLinkTypeIDs()  ' Returns link type IDs (no params)
F.Global.DocumentControl.CheckUserLinkSecurity(LinkType,User,ReturnVariable)  ' LinkType as Long, User as String, ReturnVariable as Long (>0 = has view permission)
F.Global.DocumentControl.Copy(FromLinkID,ToLinkID,Return)  ' FromLinkID/ToLinkID as Long, Return as Boolean
F.Global.DocumentControl.PrintDocument(FilePath)  ' Prints doc to default printer; FilePath as String
F.Global.DocumentControl.Invoke(DCCKey,DCCKeyType,DCCKeyTypeDescription,PID)  ' Opens DCC viewer; DCCKey as String, DCCKeyType as Long, DCCKeyTypeDescription as String, PID as Long
F.Global.DocumentControl.AddStandAloneDocument(LinkType,File,Description,Group,User,FileType,NonRev,NoUNC,LongReturn)  ' Adds stand-alone doc; see full ref
F.Global.DocumentControl.UpdateStandAloneDocument()  ' Updates a stand-alone document (no params)
```

## Business Intelligence (BI/Reporting)
```
F.Global.BI.GetIDFromName("ReportName.rpt",iReportID)
F.Global.BI.InitializeReport("Report Title",sTemplatePath,iReportID)
F.Global.BI.GetRunID(iRunID)
F.Global.BI.StartLogging(iRunID,iReportID,-1,"",iLogID)
F.Global.BI.StopLogging(iLogID)
F.Global.BI.RunReportPreProcessor(BIRunID,BILogID,ParamNames,ParamVals,Report,Mode,Sync,Debug,Copies,Printer,SaveType,SaveFile,Override,Return)
F.Global.BI.PrintCodesoftLabelFromDataTable(iRunID,iLogID,"dtName",sPrinterName,False)
F.Global.BI.PrintCodesoftLabel(iReportID,sParams,sValues,0,sPrinterName,1)
F.Global.BI.PrintReport(iReportID,sParams,sValues)
F.Global.BI.SaveReport(iReportID,sParams,sValues,sOutputPath)
F.Global.BI.GetIDInfo(iReportID,sResult)
F.Global.BI.SetOverride(iReportID,"OverrideName",sValue)
F.Global.BI.GetReportSequenceList(sResult)
F.Global.BI.GetReportSequenceInfo(iSequenceID,sResult)
F.Global.BI.IsReportSequenceActive(iSequenceID,bResult)
F.Global.BI.ActivateReportSequence(iSequenceID)
F.Global.BI.AddCustomReportID(sName,sPath,iResult)
F.Global.BI.AddGSSReportID(sName,iResult)
F.Global.BI.DeleteReportID(iReportID)
F.Global.BI.AddGSSReportSequence(sName,iResult)
F.Global.BI.AddUserReportSequence(sName,iResult)
F.Global.BI.DeleteReportSequence(iSequenceID)
F.Global.BI.AddReportSequenceEmail(iSequenceID,sEmail)
F.Global.BI.DeleteReportSequenceEmail(iSequenceID,sEmail)
F.Global.BI.GetReportSequenceEmail(iSequenceID,sResult)
F.Global.BI.AddReportSequenceUser(iSequenceID,sUser)
F.Global.BI.DeleteReportSequenceUser(iSequenceID,sUser)
F.Global.BI.GetReportSequenceUsers(iSequenceID,sResult)
F.Global.BI.AddReportSequenceGroup(iSequenceID,sGroup)
F.Global.BI.DeleteReportSequenceGroup(iSequenceID,sGroup)
F.Global.BI.GetReportSequenceGroups(iSequenceID,sResult)
F.Global.BI.SetReportSequenceLogo(iSequenceID,sLogoPath)
F.Global.BI.GetReportSequenceLogo(iSequenceID,sResult)
F.Global.BI.DeleteReportSequenceLogo(iSequenceID)
F.Global.BI.SetReportSequenceNotes(iSequenceID,sNotes)
F.Global.BI.GetReportSequenceNotes(iSequenceID,sResult)
F.Global.BI.SetReportSequencePreProcessor(iSequenceID,sPreProcessor)
F.Global.BI.GetReportSequencePreProcessor(iSequenceID,sResult)
F.Global.BI.GetReportSequencePreProcessorList(sResult)
F.Global.BI.GetReportSequenceOverride(iSequenceID,sResult)
F.Global.BI.IsCorePreProcessor(sPreProcessor,bResult)
```

### RunReportPreProcessor

```
F.Global.BI.RunReportPreProcessor(BIRunID, [BILogID], [ParamNames], [ParamVals], [Report], [Mode], Sync, [Debug], [Copies], [Printer], [SaveType], [SaveFile], [Override], Return)
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `BIRunID` | Long | Yes | Unique Run ID obtained via `F.Global.BI.GetRunID(Return)` |
| `BILogID` | Long | Optional | Log ID from `F.Global.BI.StartLogging`. Pass `-1` for none. |
| `ParamNames` | String | Optional | Crystal Report parameter names, `*!*` delimited. Pass `""` for none. |
| `ParamVals` | String | Optional | Crystal Report parameter values, `*!*` delimited (matches `ParamNames` order). Pass `""` for none. |
| `Report` | String | Optional | Report ID or full path to `.rpt` file. Pass `""` for none. |
| `Mode` | Long | Optional | Output mode. Pass `-1` for none (uses report output when called from GAB, not as preprocessor). |
| `Sync` | Boolean | Yes | `True` for synchronous, `False` for asynchronous. |
| `Debug` | String | Optional | Debug flag. Pass `""` for none. |
| `Copies` | Long | Optional | Number of copies. Pass `-1` for none. |
| `Printer` | String | Optional | Printer name. Pass `""` for none. |
| `SaveType` | Long | Optional | Export format when Mode is Export. Pass `-1` for none. |
| `SaveFile` | String | Optional | Export file path. Pass `""` for none. |
| `Override` | String | Optional | Override string. Pass `""` for none. |
| `Return` | Long | Out | `0` = success (passed to GSSRL for printing). |

**Mode values:**

| Value | Mode |
|-------|------|
| `-1` or `0` | Uses report output (when called from GAB, not as a preprocessor) |
| `2` | Email |
| `4` | Export |
| `8` | Print |
| `16` | View |

**SaveType values:**

| Value | Format |
|-------|--------|
| `-1` | None |
| `0` | PDF |
| `1` | CSV |
| `2` | XLS |

> **Note — Default parameters:** The following Crystal Report parameters are always passed automatically and do not need to be included in `ParamNames`/`ParamVals`: `RUN_ID`, `REPORT_ID`, `REPORT_SEQ`, `COMPANY_NAME`, `LOGO` (FQP to image file from Report Options), `REPORT_DESCRIPTION`, `REPORT_SEQUENCE_DESCRIPTION`.

> **Workflow — Standard BI reporting call sequence:**
> 1. `F.Global.BI.GetRunID(iRunID)` — obtain a unique run ID (one per report call)
> 2. `F.Global.BI.StartLogging(...)` — begin logging. Call this when the user clicks Print (if the script has a screen) or before you begin processing data (if headless).
> 3. Process / prepare report data
> 4. `F.Global.BI.RunReportPreProcessor(...)` — execute the report
> 5. `F.Global.BI.StopLogging(iLogID)` — end logging

**Example — Email, Export, Print, View:**

```
V.Local.iRunID.Declare(Long)
V.Local.iLogID.Declare(Long)

F.Global.BI.GetRunID(V.Local.iRunID)
F.Global.BI.StartLogging(V.Local.iRunID,100014,0,"TEST REPORT",V.Local.iLogID)

' Email
F.Global.BI.RunReportPreProcessor(V.Local.iRunID,V.Local.iLogID,"","","100014",2,False,"",-1,"gsview",-1,"","",V.Local.iRunID)

' Export
F.Global.BI.RunReportPreProcessor(V.Local.iRunID,V.Local.iLogID,"","","100014",4,False,"",-1,"gsview",-1,"","",V.Local.iRunID)

' Print
F.Global.BI.RunReportPreProcessor(V.Local.iRunID,V.Local.iLogID,"","","100014",8,False,"",1,"gsview",-1,"","",V.Local.iRunID)

' View (custom .rpt path, no logging)
F.Global.BI.RunReportPreProcessor(V.Local.iRunID,-1,"","","C:\Global\BUSINT\Custom\BI_TEST_REPORT.rpt",16,False,"",1,"gsview",-1,"","",V.Local.iRunID)

F.Global.BI.StopLogging(V.Local.iLogID)
```

**Example — Custom report with parameters:**

```
V.Local.iBIRunId.Declare(Long)
V.Local.iLogID.Declare(Long)
V.Local.sBIRptID.Declare(String)
V.Local.sParams.Declare(String)
V.Local.sValues.Declare(String)
V.Local.srptLoc.Declare(String)
V.Local.iRet.Declare(Long)

F.Intrinsic.String.Concat(V.Caller.BusintDir,"\Custom\GAB_6691_ACE_VCF.rpt",V.Local.srptLoc)
F.Global.BI.InitializeReport("GAB_6691_ACE_VCF",V.Local.srptLoc,V.Local.sBIRptID)

V.Local.sParams.Set("Packing_No*!*GS_USER")
F.Intrinsic.String.Split(V.Local.sParams,"*!*",V.Local.sParams)
F.Intrinsic.String.Build("{0}*!*{1}",V.Local.sPCK_NO,V.Local.sUserName,V.Local.sValues)
F.Intrinsic.String.Split(V.Local.sValues,"*!*",V.Local.sValues)

F.Global.BI.GetRunID(V.Local.iBIRunId)
F.Global.BI.StartLogging(V.Local.iBIRunId,V.Local.sBIRptID,-1,"",V.Local.iLogID)
F.Global.BI.StopLogging(V.Local.iLogID)
F.Global.BI.RunReportPreProcessor(V.Local.iBIRunId,V.Local.iLogID,V.Local.sParams,V.Local.sValues,V.Local.sBIRptID,16,True,"",1,"",-1,"","",V.Local.iRet)
```

## Dashboard Viewer
```
F.Global.DashboardViewer.Export("objectName",V.Local.sResult)    ' Export dashboard using Data Object config
```
Configure the export via `F.Data.Object` with `V.Enum.DashboardViewerExport*` and `V.Enum.DashboardViewerExportPDF*` enums (see `agents/gab/DATA_MISC.md` > Data Objects).

## Inventory
```
F.Global.Inventory.CreatePart("PartNo","UM","Description","Location","ProductLine","Source","AltDesc1","AltDesc2","Cost","NOMAINT")
F.Global.Inventory.GetGSSPart(sPartNo,sResult)            ' Get GSS-formatted part information
```

## Mobile
```
F.Global.Mobile.SetCustomResult(sCompanyCode,sTransID,sHTMLResult)
F.Global.Mobile.GetCustomPrinter(sTransID,sResult)
F.Global.Mobile.GetPrinterNamefromID(sID,sPrinterName)
```

## Messaging
```
' Email
F.Global.Messaging.QueueMessage(sCompanyCode,iUserID,"",sSubject,sFromEmail,sToEmail,sBody,"","",False,"",,"","","","","",sAttachmentPath,False)
F.Global.Messaging.IsAddressValid(sEmail,bResult)

' Internal Messages
F.Global.Messaging.InternalMessageCreate(iConfigID,dDateTime,iUserID,sTitle,sBody,iMessageID)
F.Global.Messaging.InternalMessageQueueToUser(sRecipient,iMessageID)
```

## XML Processing
```
F.Global.XML.ReadNodeSetValue(sDocument,sNodeSet,sAttribute,sResult)
F.Global.XML.Query(sDocument,sNodeSet,sXPath,bResult)
F.Global.XML.CloseSet(sDocument,sNodeSet)
```

## Presentation / Charts
```
F.Global.Presentation.CreateChart("chartName",sResult)
F.Global.Presentation.CreateChartMember("chartName","Legend","legendName",sResult)
F.Global.Presentation.CreateChartMember("chartName","Title","titleName",sText,sResult)
F.Global.Presentation.CreateChartMember("chartName","Series","seriesName","Line",sData,sResult)
F.Global.Presentation.CreateChartMember("chartName","Series","seriesName","StackedColumn",sData,sResult)
```

## Workstation
```
F.Global.Workstation.GetComponentName(sResult)
F.Global.Workstation.GetComponentPass(sResult)
F.Global.Workstation.GetComponentPriority(iResult)
```

## Internationalization
```
F.Global.International.GetLanguagesByUserID(iUserID,sResult)
```

## CRM
```
F.Global.CRM.Invoke(ParameterString,ProcessIDReturn)  ' Open CRM interface
```

### CRM.Invoke

```
F.Global.CRM.Invoke(ParameterString, ProcessIDReturn)
```

- `ParameterString` (String) -- `*!*` delimited key-value pairs in `KEY::VALUE` format
- `ProcessIDReturn` (Long) -- returns the PID of the launched CRM process

**Parameter String Elements:**

The parameter string is built from `KEY::VALUE` pairs delimited by `*!*`:

| Key | Type | Description |
|-----|------|-------------|
| `MODE` | String (numeric) | CRM launch mode (see table below). Required. |
| `COMPANY-NUMBER` | String | Company number to open in CRM. Optional. |
| `COMPANY-TYPE` | Long | Type of company record. Optional (see table below). |

**Mode values:**

| Value | Mode |
|-------|------|
| `0` | Normal |
| `1` | Edit |
| `5` | Convert Company |
| `6` | No Dollars |
| `9` | View |
| `10` | View Only |

**Company-Type values:**

| Value | Type |
|-------|------|
| `0` | Vendor |
| `15` | Customer |
| `18` | Prospect |
| `19` | Suspect |

**Example — Open CRM for a specific company:**

```
V.Local.sCompanyNumber.Declare(String,"CompanyNumber")
V.Local.iCompanyType.Declare(Long,0)
V.Local.sParameters.Declare(String)
V.Local.iPID.Declare(Long)

F.Intrinsic.String.Build("MODE::0*!*COMPANY-NUMBER::{0}*!*COMPANY-TYPE::{1}",V.Local.sCompanyNumber,V.Local.iCompanyType,V.Local.sParameters)
F.Global.CRM.Invoke(V.Local.sParameters,V.Local.iPID)
```

**Example — Open CRM in Normal mode (no company context):**

```
V.Local.iPID.Declare(Long)
F.Global.CRM.Invoke("MODE::0",V.Local.iPID)
```

## Accounting
```
F.Global.Accounting.GetARItemStatus(Customer, Invoice, ReturnValue)
```
- `Customer` (String) -- customer ID
- `Invoice` (String) -- invoice number
- `ReturnValue` (String) -- output: `Debit*!*Credit*!*Remainder`
  - Debit = sum of AMT_INVOICE for batch codes 10, 13, 15, 17
  - Credit = sum of AMT_INVOICE for batch codes 11, 12, 16
  - Remainder = Debit + Credit
  - Returns `***NORETURN***` if no matching records found (both debit and credit are 0)

## APS (Advanced Planning & Scheduling)
```
F.Global.APS.AddLockedJobSequence(sJob,sSuffix,iSequence,iLengthInDays)
F.Global.APS.JobStarted(sJob,sSuffix,bResult)
F.Global.APS.JobStatus(sJob,sSuffix,iResult)
F.Global.APS.PrintAPS3Report(iReportNumber)
F.Global.APS.PSC(Job[],Suffix[],Sequence[],PSC[])     ' Production Schedule Control (array/UDT)
F.Global.APS.RemoveLockedJobSequence(sJob,sSuffix,iSequence)
F.Global.APS.ScheduleJob(sJob,sSuffix,sDirection,dDate,[sSequence])
```

### AddLockedJobSequence

```
F.Global.APS.AddLockedJobSequence(Job, Suffix, Sequence, LengthInDays)
```

- `Job` (String) -- job number
- `Suffix` (String) -- job suffix
- `Sequence` (Long) -- sequence number
- `LengthInDays` (Long) -- lock duration in days

**Example:**

```
V.Local.sJob.Declare(String)
V.Local.sSuffix.Declare(String)
V.Local.iSequence.Declare(Long)
V.Local.iDays.Declare(Long)
F.Global.APS.AddLockedJobSequence(V.Local.sJob,V.Local.sSuffix,V.Local.iSequence,V.Local.iDays)
```

### JobStarted

```
F.Global.APS.JobStarted(Job, Suffix, ReturnJobStarted)
```

- `Job` (String) -- job number (padded/truncated to 6 characters)
- `Suffix` (String) -- job suffix (padded/truncated to 3 characters)
- `ReturnJobStarted` (Boolean) -- True if the job has started; otherwise False

Checks `JOB_DETAIL` for rows matching the job and suffix.

**Example:**

```
V.Local.bStarted.Declare(Boolean)
F.Global.APS.JobStarted("000155","001",V.Local.bStarted)

' Job with no suffix
F.Global.APS.JobStarted("000155","",V.Local.bStarted)
```

### JobStatus

```
F.Global.APS.JobStatus(Job, Suffix, ReturnJobStatus)
```

- `Job` (String) -- job number (padded/truncated to 6 characters)
- `Suffix` (String) -- job suffix (padded/truncated to 3 characters)
- `ReturnJobStatus` (Long) -- returns `-1` if no record exists; otherwise a bitmask:

| Bit | Value | Meaning |
|-----|-------|---------|
| 0 | `1` | BOM Parent |
| 1 | `2` | BOM Child |
| 2 | `4` | Hold |
| 3 | `8` | Locked |

Queries `APSV3_JBMaster` by JS (Job padded to 6 + Suffix padded to 3).

**Example:**

```
V.Local.iStatus.Declare(Long)
F.Global.APS.JobStatus("500008","000",V.Local.iStatus)

' Check if a job is locked (bit 3)
F.Global.APS.JobStatus("040010","",V.Local.iStatus)
```

### PrintAPS3Report

```
F.Global.APS.PrintAPS3Report(ReportNumber)
```

- `ReportNumber` (Long) -- APS report number to print

**Example:**

```
V.Local.iReportNo.Declare(Long)
F.Global.APS.PrintAPS3Report(V.Local.iReportNo)
```

### PSC (Production Schedule Control)

```
F.Global.APS.PSC(Job, Suffix, Sequence, PSC)
```

All parameters accept arrays (`String[]`) or UDT members. The function evaluates each row against `APSV3_JBLines` using the padded JS (Job + Suffix) and updates the PSC output values.

- `Job` (String[]/UDT) -- job values (padded/truncated to 6 per row)
- `Suffix` (String[]/UDT) -- suffix values (padded/truncated to 3 per row)
- `Sequence` (Long[]/UDT) -- sequence values used in the query (Seq < Sequence)
- `PSC` (Boolean[]/UDT) -- output array/field updated per row: True if no prior rows exist for that job/suffix/sequence or if the prior row has a non-null ComplDate; False if the most recent prior row exists but has a null ComplDate

**Example — UDT-based PSC check:**

```
Variable.UDT.PSCData.Define("Job",String,"Job")
Variable.UDT.PSCData.Define("Sfx",String,"Sfx")
Variable.UDT.PSCData.Define("Seq",String,"Seq")
Variable.UDT.PSCData.Define("PSC",String,"")
Variable.uGlobal.PSCData.Declare("PSCData")

F.Global.APS.PSC(V.Global.PSCData!JOB,V.Global.PSCData!SFX,V.Global.PSCData!SEQ,V.Global.PSCData!PSC)
```

### RemoveLockedJobSequence

```
F.Global.APS.RemoveLockedJobSequence(Job, Suffix, Sequence)
```

- `Job` (String) -- job number
- `Suffix` (String) -- job suffix
- `Sequence` (Long) -- sequence number to unlock

**Example:**

```
V.Local.sJob.Declare(String)
V.Local.sSuffix.Declare(String)
V.Local.iSequence.Declare(Long)
F.Global.APS.RemoveLockedJobSequence(V.Local.sJob,V.Local.sSuffix,V.Local.iSequence)
```

### ScheduleJob

```
F.Global.APS.ScheduleJob(Job, Suffix, Direction, Date, [Sequence])
```

- `Job` (String) -- job number
- `Suffix` (String) -- job suffix
- `Direction` (String) -- `"F"` = Forward scheduling, `"B"` = Backward scheduling
- `Date` (Date) -- if `"F"`, the start date (usually today); if `"B"`, the due date to schedule back from
- `Sequence` (String, optional) -- specific sequence to schedule

> **Note:** APS version 3 or higher must be enabled. A post-2008.03 version of JB0011CL is required.

**Example:**

```
V.Local.sJob.Declare(String,"000123")
V.Local.sSuffix.Declare(String,"001")

' Forward schedule from today
F.Global.APS.ScheduleJob(V.Local.sJob,V.Local.sSuffix,"F",V.Ambient.Now)

' Backward schedule from a due date
F.Global.APS.ScheduleJob(V.Local.sJob,V.Local.sSuffix,"B","12/12/2050")
```

## Scale (Hardware Scales)

> **Note:** All Scale functions require OCTSRS.Net.EXE version 2019.1 or above.

```
F.Automation.Scale.AddUnsupportedScale(sScaleName,iVendorID,iProductID)
F.Automation.Scale.GetScaleInfo(sScaleName,sResult)
F.Automation.Scale.GetSupportedScaleNames(sResult)
F.Automation.Scale.GetUnsupportedScaleNames(sResult)
F.Automation.Scale.GetWeight(sScaleName,fWeight)
F.Automation.Scale.IsConnected(sScaleName,bResult)
```

### AddUnsupportedScale

```
F.Automation.Scale.AddUnsupportedScale(ScaleName, VendorID, ProductID)
```

- `ScaleName` (String) -- descriptive name used to reference the scale in other functions
- `VendorID` (Long) -- hardware Vendor ID (found in Windows Device Manager)
- `ProductID` (Long) -- hardware Product ID (found in Windows Device Manager)

**Example:**

```
F.Automation.Scale.AddUnsupportedScale("uPS60",3768,61440)
```

### GetScaleInfo

```
F.Automation.Scale.GetScaleInfo(ScaleName, ReturnVariable)
```

- `ScaleName` (String) -- name of the scale
- `ReturnVariable` (String) -- returns `ScaleName*!*VendorID*!*ProductID` delimited string

**Example:**

```
V.Local.sScaleInfo.Declare(String)
F.Automation.Scale.GetScaleInfo("PS60",V.Local.sScaleInfo)
```

### GetSupportedScaleNames

```
F.Automation.Scale.GetSupportedScaleNames(ReturnVariable)
```

- `ReturnVariable` (String) -- list of supported scale names

**Example:**

```
V.Local.sScales.Declare(String)
F.Automation.Scale.GetSupportedScaleNames(V.Local.sScales)
```

### GetUnsupportedScaleNames

```
F.Automation.Scale.GetUnsupportedScaleNames(ReturnVariable)
```

- `ReturnVariable` (String) -- list of user-added unsupported scale names

**Example:**

```
V.Local.sScales.Declare(String)
F.Automation.Scale.GetUnsupportedScaleNames(V.Local.sScales)
```

### GetWeight

```
F.Automation.Scale.GetWeight(ScaleName, ReturnVariable)
```

- `ScaleName` (String) -- name of the scale
- `ReturnVariable` (Float) -- current weight reading

**Example:**

```
V.Local.fWeight.Declare(Float)
F.Automation.Scale.GetWeight("PS60",V.Local.fWeight)
```

### IsConnected

```
F.Automation.Scale.IsConnected(ScaleName, ReturnVariable)
```

- `ScaleName` (String) -- name of the scale
- `ReturnVariable` (Boolean) -- True if the scale is connected

**Example:**

```
V.Local.bConnected.Declare(Boolean)
F.Automation.Scale.IsConnected("PS60",V.Local.bConnected)
```

## Outlook Automation
```
F.Automation.MSOutlook.CheckPresence(bResult)
F.Automation.MSOutlook.QueueTask(sSubject,sBody,dDueDate)
F.Automation.MSOutlook.GetTasks(sResult)
F.Automation.MSOutlook.TaskAction(sTaskID,sAction)
```

## IPM (Inter-Process Messaging)
```
F.Intrinsic.IPM.GenericMenuIPM(sMenuID,sParam,sResult)  ' Invokes a GSS menu/config action by numeric ID; all params String
F.Intrinsic.IPM.SendMessage(Message, Handle)  ' Sends IPM message to a process; Message as String, Handle as Long
F.Intrinsic.IPM.RegisterProcess(Meta1, Meta2, Meta3, Meta4, Meta5, ReturnVariable)  ' Registers a process; Meta1-Meta5 as String, ReturnVariable as Long
F.Intrinsic.IPM.GetPRIDs(ReturnVariable)  ' Returns registered process IDs; ReturnVariable as String
F.Intrinsic.IPM.GetPRIDInfo(ProcessId, ReturnVariable)  ' Gets process info by ID; ProcessId as Long, ReturnVariable as String
F.Intrinsic.IPM.UnregisterProcess()  ' Unregisters the current process (no params)
```

### GenericMenuIPM Known Menu IDs
| MenuID | Param Format | Returns | Purpose |
|--------|-------------|---------|---------|
| 11700 | `"OptID*!*0*!*0*!*False"` | Boolean | Read system option (replaces F.Global.General.ReadOption) |
| 11800 | `"OptID*!*0*!*N*!*Default"` | String/Boolean | Read common option (replaces F.Global.General.ReadOptionCommon) |
| 13000 | (empty) | String | Get Service Web username of caller |
| 13100 | (empty) | String | Get Service Web password of caller |
| 13200 | (empty) | Boolean | Get Service Web enabled flag |
| 14300 | component ID (Long) | Boolean | Check component availability |
| 14500 | `"Module*!*MenuItem*!*Seq"` | String | Look up menu item; returns "-1" on failure |
| 14600 | status value | String (`*!*`-delimited) | Get component status description |
| 20351 | `*!*`-delimited params | String | Run report/grid conversion |
| 60020 | company code | String | Activate BI reports; returns "0" on failure |

### SendMessage Patterns
The Handle parameter is typically sourced from `V.Passed.IPMHND` (parent process handle) or `V.Caller.Switches` (passed via launch args).
Messages often use `[~]` as key-value separator and `|~|` between pairs:
```
' Simple completion signal
F.Intrinsic.IPM.SendMessage("COMPLETE",V.Passed.IPMH)

' Structured message with IPM handle forwarding
F.Intrinsic.String.Concat("009993[~]",V.Global.sUser,"|~|STATUS[~]CLOCK IN","|~|IPMHND[~]",V.Ambient.myipmh,V.Ambient.Tab,V.Local.sSendString)
F.Intrinsic.IPM.SendMessage(V.Local.sSendString,V.Passed.IPMHND)
F.Global.General.SignalSp2(V.Caller.Handle)

' Pass transaction stats back to watchdog via Switches handle
F.Intrinsic.String.Build("{0}::{1}::{2}::{3}", V.Global.iTx, V.Global.iSuccess, V.Global.iJ55, V.Global.iO90, V.Local.sMsg)
F.Intrinsic.IPM.SendMessage(V.Local.sMsg, V.Caller.Switches)

' Stop sync signal
F.Intrinsic.IPM.SendMessage("STOPSYNC",V.Global.sender)

' Empty message (acknowledgement/signal)
F.Intrinsic.IPM.SendMessage("",V.Passed.IPMHND)
```

## Task

Additional `F.Intrinsic.Task.*` APIs (process control, locks, shell, GSS launch variants) are documented in `agents/gab/API_PRINTER.md` under `# TASK MANAGEMENT`.

```
F.Global.Task.CallAsyncGas(sScriptPath,"U",2,iResult)
F.Intrinsic.Task.ShellExec(0,"Open",sFilePath,"","",1)
F.Intrinsic.Task.ShellExecSync(iHandle,"open",sExePath,sArgs,"",1)
F.Intrinsic.Task.LaunchGSSSync("ProgramName","-c",sFilePath)
F.Intrinsic.Task.PIDRunning(iPID,bResult)
F.Intrinsic.Task.GetProcessList(sResult)
F.Intrinsic.Task.GetTaskList(sResult)                          ' Get running task list
F.Intrinsic.Task.LaunchAsync(sProgram,sArgs)                   ' Launch async external process
F.Intrinsic.Task.SetEnvironmentVariable(sName,sValue)          ' Set process environment variable
```

## Global Objects
```
F.Global.Object.CreateDB("DB",V.Caller.CompanyCode,V.Ambient.DBServerName,iCon)
F.Global.Object.Create("ObjName","Namespace.ClassName","DB",iCon)
F.Global.Object.Add("ObjName","Property1",value1,"Property2",value2,...)
F.Global.Object.Insert("ObjName",iResult)
F.Global.Object.GetCount("ObjName",iResult)
F.Global.Object.GetValue("ObjName","Property",sResult)
F.Global.Object.Dispose("ObjName")
```

---


# OCTSRS Component Reference (Runtime Implementation)

## Component Reference: AccessComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\AccessComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\AccessComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~86 lines

### Runtime purpose
The Access Component provides Microsoft Access database operations, specifically for checking Access presence and compacting Access database files.

### Implementation notes (OCTSRS)
#### Legacy Behavior
- Uses COM Automation (CreateObject("Access.Application"))
- Caches registry check result for performance

#### Migration Notes
- Simple component with minimal database interaction
- COM interop dependency

### Dependencies
#### External Dependencies
- Microsoft Access (COM Automation)

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `COMPACTDB` | Compact an Access database file |

### Key method signatures & edge cases
#### `CHECKPRESENCE`
**GAB Syntax:** `Function.Global.Access.CheckPresence(Variable.Local.IsInstalled)`

**Purpose:** Checks if Microsoft Access is installed by looking for registry entry.

**Returns:** Boolean - True if Access.Application registry entry exists

#### `COMPACTDB`
**GAB Syntax:** `Subroutine.Global.Access.CompactDB(SourceFile, DestinationFile)`

**Purpose:** Compacts a Microsoft Access database file.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | SourceFile | String | Yes | Source .mdb file path |
| 2 | DestinationFile | String | Yes | Destination .mdb file path |

**Error Codes:**

| Code | Condition |
|------|-----------|
| 200 | Source file not found |
| 202500 | Microsoft Access not installed |

---

## Component Reference: ActianComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\ActianComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\ActianComponent.vb`
- **Feature toggle:** `93c92124-6ce0-4225-b343-b29ab02cd5ca`
- **OCTSRS conversion status:** ADO.NET refactor complete (Approach A — separate `AdoNetActianComponent.vb`)
- **Implementation size:** ~360 lines

### Runtime purpose
The Actian Component provides Actian/Pervasive database administration operations including file rebuilding, archiving, and version information retrieval.

### Implementation notes (OCTSRS)
#### Legacy Behavior
- Uses Shell() for external process execution
- Log file: rbldcli.Log in FilesDir
- Uses System.Threading for process wait

#### Migration Notes
- **ADO.NET (Approach B):** GETFILENAMEFROMTABLENAME, GETTABLENAMEFROMFILENAME, GETCLIENTVERSION, GETSERVERVERSION, and ARCHIVETABLE use ADO.NET when the feature toggle is enabled. Legacy ADODB path remains when toggle is off.
- X$File is queried via parameterized SQL (`AdoNetCompanyConnection`, `AdoNetConnectionExtensions.GetDataTable`/`CreateParameters`).
- Version (GETCLIENTVERSION/GETSERVERVERSION) uses `DbConnection.ServerVersion` when on ADO.NET path.
- File system operations for log management unchanged.

---

### Dependencies
#### External Dependencies
- Pervasive/Actian database engine
- rbldcli.exe utility

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `ARCHIVETABLE` | Archive a database table |
| `CLEARREBUILDLOG` | Clear the rebuild log file |
| `DISPLAYREBUILDLOG` | Open rebuild log in Notepad |
| `GETCLIENTVERSION` | Get Pervasive client version |
| `GETSERVERVERSION` | Get Pervasive server version |
| `GETFILENAMEFROMTABLENAME` | Get file name from table name |
| `GETTABLENAMEFROMFILENAME` | Get table name from file name |
| `REBUILDFILE` | Rebuild a database file |

### Key method signatures & edge cases
#### `REBUILDFILE`
**GAB Syntax:** `Function.Automation.Pervasive.REBUILDFILE(FileName, [Switches], Variable.Local.ElapsedTime)`

**Purpose:** Rebuilds a Pervasive database file using rbldcli utility.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FileName | String | Yes | File to rebuild |
| 2 | Switches | String | No | rbldcli switches (default: -pP) |
| R | ElapsedTime | Integer | Yes | Return - Seconds elapsed |

**Business Rules:**
- If no path specified, uses FilesDir
- Default switches: -pP
- Waits for process to complete

#### `ARCHIVETABLE`
**GAB Syntax:** `Function.Automation.Pervasive.ARCHIVETABLE(TableName, ArchivePath)`

**Purpose:** Archives a database table for backup or historical purposes.

---

## Component Reference: BusinessIntelligenceComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\BusinessIntelligenceComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\BusinessIntelligenceComponent.vb`
- **Feature toggle:** `66c48c64-d75c-4a44-9173-d2ce4f084488` (for GETRUNID method)
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~3,700+ lines (large component)

### Runtime purpose
The Business Intelligence (BI) Component is responsible for managing reports in Global Shop Solutions. It provides functionality to create, configure, activate, print, and manage report definitions, sequences, and their associated metadata (logos, notes, preprocessors, email recipients, security settings).

### Implementation notes (OCTSRS)
#### Legacy Behavior
- Many methods use ADODB Recordset with string concatenation (SQL injection risk)
- Global vs User distinction based on Report_ID range (< 100000 vs >= 100000)
- Sequence range determines Global vs User for sequences (1-9 vs 10+)

#### Connection Type
- Uses `ActianCommonSqlConnection` (Common database, not Company database)
- This is different from most components that use Company connection

#### Known Issues
- SQL injection vulnerabilities in many methods due to string concatenation
- Large component with 40+ methods - consider splitting during refactoring

#### Migration Notes
- Convert all ADODB Recordset operations to ADO.NET DataTable
- Use parameterized queries for all SQL operations
- Maintain Global vs User logic based on Report_ID ranges
- Some methods already partially converted to ADO.NET (AddCustomReportID, AddUserReportSequence)
- Feature toggle already exists for GETRUNID method

#### Output Modes| Mode | Description |
|------|-------------|
| 0 | Print to printer |
| 1 | Save to file |
| 2 | Email |
| 3 | Preview |

#### Error Codes| Code | Condition |
|------|-----------|
| 405 | Wrong argument count |
| 999000 | Invalid method specified |
| 50520 | Not authorized (GSSSignature required) |

### Dependencies
#### Components Called
- `HookAssociationComponent` - For hook execution
- Label printing libraries (Bartender, CodeSoft)

#### Called By
- Report printing screens
- Scheduled report jobs
- Dashboard modules
- Custom GAB programs

#### External Dependencies
- GSS.Administration.BusinessIntelligence.PrintJobs.Labels
- PrintJobs.Labels
- GabLicensingAndEncryption.Project

---

### Key method signatures & edge cases
#### `ADDCUSTOMREPORTID`
**GAB Syntax:** `Function.Global.BusinessIntelligence.AddCustomReportID(CompanyCode, Description, Module, Variable.Local.ReportID)`

**Purpose:** Creates a new custom report ID in the BIR_User table.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | CompanyCode | String | Yes | Company code for the report |
| 2 | Description | String | Yes | Report description |
| 3 | Module | Integer | Yes | Module number |
| R | ReportID | Long | Yes | Return - newly created Report ID |

**Returns:** New Report ID (>= 100000)

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| BIR_User | SELECT | Find highest existing Report_ID for company |
| BIR_User | INSERT | Insert new report definition |

**Business Rules:**
- Custom Report IDs start at 100000
- New ID = MAX(Report_ID) + 1 for the company
- If no existing custom reports, starts at 100000

#### `ADDUSERREPORTSEQUENCE`
**GAB Syntax:** `Function.Global.BusinessIntelligence.AddUserReportSequence(ReportID, CompanyCode, Description, Priority, FilePath, FileName, OutputMode, OutputPath, OutputFile, Copies, Trace, Unattended, Workload, DefaultPrinter, BIReportId, GSReportId, Variable.Local.SequenceID)`

**Purpose:** Creates a new report sequence for a custom report.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | ReportID | Long | Yes | Report ID to add sequence to |
| 2 | CompanyCode | String | Yes | Company code |
| 3 | Description | String | Yes | Sequence description |
| 4 | Priority | Integer | Yes | Print priority |
| 5 | FilePath | String | Yes | Report file path |
| 6 | FileName | String | Yes | Report file name |
| 7 | OutputMode | Integer | Yes | Output mode (0=Print, 1=Save, etc.) |
| 8 | OutputPath | String | Yes | Output file path |
| 9 | OutputFile | String | Yes | Output file name |
| 10 | Copies | Integer | Yes | Number of copies |
| 11 | Trace | Boolean | Yes | Enable trace |
| 12 | Unattended | Boolean | Yes | Run unattended |
| 13 | Workload | Boolean | Yes | Workload flag |
| 14 | DefaultPrinter | String | Yes | Default printer name |
| 15 | BIReportId | Integer | No | BI Report ID reference |
| 16 | GSReportId | Integer | No | GS Report ID reference |
| R | SequenceID | Long | Yes | Return - newly created Sequence ID |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| BIR_User_Seq | SELECT | Find highest sequence for report |
| BIR_User_Seq | INSERT/UPDATE | Create or update sequence |

#### `ACTIVATEREPORTSEQUENCE`
**GAB Syntax:** `Subroutine.Global.BusinessIntelligence.ActivateReportSequence(ReportID, SequenceID, CompanyCode, Activate)`

**Purpose:** Activates or deactivates a report sequence.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | ReportID | Long | Yes | Report ID |
| 2 | SequenceID | Long | Yes | Sequence ID |
| 3 | CompanyCode | String | Yes | Company code |
| 4 | Activate | Boolean | Yes | True=Activate, False=Deactivate |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| BIR_Active_Seq | SELECT | Check if activation record exists |
| BIR_Active_Seq | INSERT/UPDATE | Create or update activation status |

#### `PRINTREPORT`
**GAB Syntax:** `Subroutine.Global.BusinessIntelligence.PrintReport(...)`

**Purpose:** Prints a report using the configured settings.

**Notes:**
- Internally calls `PrintReport(runtimeInformation, False)` 
- `SAVEREPORT` calls `PrintReport(runtimeInformation, True)` to save instead of print

#### `GETRUNID`
**GAB Syntax:** `Function.Global.BusinessIntelligence.GetRunID(Variable.Local.RunID)`

**Purpose:** Gets the current BI run ID for logging purposes.

**Feature Toggle:** `66c48c64-d75c-4a44-9173-d2ce4f084488`
- When enabled: Uses `GetBIRunID(GabProgram)`
- When disabled: Uses `GetBIRunID(RuntimeInformation)`

---

## Component Reference: CaptureComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\CaptureComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\CaptureComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~3,313 lines

### Runtime purpose
The Capture Component provides document scanning and image capture functionality using Dynamsoft TWAIN SDK. It supports scanner control, image manipulation, barcode reading, and PDF creation.

### Implementation notes (OCTSRS)
#### SDK Licensing
- Uses Dynamsoft licensed components
- License keys embedded in constructor
- ImageCore, PDFCreator, TwainManager initialized

#### Interface Implementation
- Implements `IAcquireCallback` for async scanning
- Event-driven image acquisition

#### Legacy Behavior
- Merged from GSCapture + M_Capture
- Removed coupling in AuxInfo

#### Migration Notes
- No database interaction
- Modern SDK usage (Dynamsoft)
- Consider updating license keys periodically

### Dependencies
#### External Dependencies
- Dynamsoft.TWAIN SDK
- Dynamsoft.PDF SDK
- Dynamsoft.Core SDK
- TWAIN-compatible scanner

#### Components Called
- None directly

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `ACQUIREIMAGE` | Acquire image from scanner |
| `CLOSESOURCE` | Close scanner source |
| `DISABLESOURCE` | Disable scanner source |
| `ENABLESOURCE` | Enable scanner source |
| `ENABLESOURCEUI` | Enable scanner UI |
| `FEEDPAGE` | Feed a page |
| `GETSOURCES` | Get available scanners |
| `OPENSOURCE` | Open scanner source |
| `SELECTSOURCE` | Select a scanner |
| `SELECTSOURCEBYINDEX` | Select scanner by index |
| `CAPGET` | Get capability value |
| `CAPGETCURRENT` | Get current capability value |
| `CAPGETDEFAULT` | Get default capability value |
| `CAPGETFRAME` | Get frame capability |
| `CAPIFSUPPORTED` | Check if capability supported |
| `CAPRESET` | Reset capability |
| `CAPSET` | Set capability value |
| `CAPSETFRAME` | Set frame capability |
| `GETCAPITEMS` | Get capability items |
| `GETCAPITEMSSTRING` | Get capability items as string |
| `CROP` | Crop an image |
| `FLIP` | Flip an image |
| `GRAYSCALE` | Convert to grayscale |
| `INVERT` | Invert colors |
| `ISBLANKIMAGE` | Check if image is blank |
| `LOADIMAGE` | Load an image file |
| `MIRROR` | Mirror an image |
| `REMOVEALLIMAGES` | Remove all images |
| `REMOVEIMAGE` | Remove an image |
| `ROTATE` | Rotate an image |
| `SAVEALLASIMAGES` | Save all as images |
| `SAVEALLASPDF` | Save all as PDF |
| `SAVEASIMAGE` | Save as image file |
| `SAVEASPDF` | Save as PDF |
| `GETBARCODEINFO` | Get barcode information |
| `GETBARCODETEXT` | Get barcode text |
| `READBARCODES` | Read barcodes from image |
| `GETIMAGECOREPROPERTY` | Get ImageCore property |
| `GETPDFCREATORPROPERTY` | Get PDFCreator property |
| `GETTWAINMANAGERPROPERTY` | Get TwainManager property |
| *(+6 more)* | See OCTSRS source |

### Key method signatures & edge cases
#### `ACQUIREIMAGE`
**GAB Syntax:** `Subroutine.Global.Capture.AcquireImage()`

**Purpose:** Acquires an image from the selected scanner.

**Business Rules:**
- Scanner must be selected first
- Uses TWAIN protocol
- Supports automatic document feeder (ADF)

#### `READBARCODES`
**GAB Syntax:** `Function.Global.Capture.ReadBarcodes(ImageIndex, Variable.Local.BarcodeCount)`

**Purpose:** Reads barcodes from a scanned image.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | ImageIndex | Integer | Yes | Index of image to scan |
| R | BarcodeCount | Integer | Yes | Return - Number of barcodes found |

#### `SAVEASPDF`
**GAB Syntax:** `Subroutine.Global.Capture.SaveAsPDF(FilePath, ImageIndex)`

**Purpose:** Saves an image as a PDF file.

#### `GETSOURCES`
**GAB Syntax:** `Function.Global.Capture.GetSources(Variable.Local.SourceList)`

**Purpose:** Gets list of available TWAIN scanner sources.

**Returns:** Delimited list of scanner names

---

## Component Reference: CourierComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\CourierComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\CourierComponent.vb`
- **Feature toggle:** `TBD - Check Components_FeatureToggles.xlsx`
- **OCTSRS conversion status:** Partially Converted (AdoNetCourierComponent exists)
- **Implementation size:** ~2,700 lines

### Runtime purpose
The Courier Component provides messaging and notification services for Global Shop Solutions including email, SMS, internal messages, and queue management.

### Implementation notes (OCTSRS)
#### Feature Toggle
- Has ADO.NET version: `AdoNetCourierComponent`
- Uses feature toggle for method routing

#### Message Types
- Internal (within GSS)
- Email (external)
- SMS (mobile)
- Company (broadcast)

#### Queue System
- Messages can be queued for batch processing
- Background processing for reliability
- Retry logic for failed messages

#### Migration Notes
- Uses ADODB Recordset extensively
- Connection type: Company and Common databases
- Complex configuration tables
- ADO.NET version exists for some methods

### Dependencies
#### Components Called
- `GlobalShopComponent` - For GSS integration
- `GlobalShopSecurityComponent` - For user lookups

#### External Dependencies
- Email server (SMTP)
- SMS gateway (if configured)

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `CREATECOMPANYMESSAGE` | Create company-wide message |
| `CREATEINTERNALMESSAGE` | Create internal message |
| `CREATEEMMESSAGE` | Create email message |
| `CREATEEMFMESSAGE` | Create email with file attachment |
| `CREATESMSMESSAGE` | Create SMS message |
| `DELETEMESSAGE` | Delete a message |
| `CONSOLIDATEEMAILS` | Consolidate multiple emails |
| `GETCOMPANYPRIMARYEMAIL` | Get company primary email |
| `INTERNALMESSAGEADDEVENTDYNAMICRECIPIENT` | Add dynamic recipient |
| `INTERNALMESSAGECREATEDYNAMICRECIPIENT` | Create dynamic recipient |
| `INTERNALMESSAGEDELETECONFIGURATION` | Delete configuration |
| `INTERNALMESSAGEDELETECONFIGURATIONCONDITION` | Delete condition |
| `INTERNALMESSAGEDELETECONFIGURATIONRECIPIENT` | Delete recipient |
| `INTERNALMESSAGEDELETEFROMQUEUE` | Delete from queue |
| `INTERNALMESSAGEGETCONFIGURATIONCONDITIONS` | Get conditions |
| `INTERNALMESSAGEGETCONFIGURATIONPRESETSFOREVENT` | Get presets |
| `INTERNALMESSAGEGETCONFIGURATIONRECIPIENTS` | Get recipients |
| `INTERNALMESSAGEGETCONFIGURATIONSFORCOMPANY` | Get company configs |
| `INTERNALMESSAGEGETCONFIGURATIONSFOREVENTNAME` | Get event configs |
| `INTERNALMESSAGEGETCONFIGURATIONSFOREVENTNAMEID` | Get event configs by ID |
| `INTERNALMESSAGEGETEVENTDYNAMICRECIPIENTS` | Get dynamic recipients |
| `INTERNALMESSAGEGETEVENTPARAMETERVALUES` | Get parameter values |
| `INTERNALMESSAGEGETEVENTS` | Get events |
| `QUEUEGETPENDINGMESSAGES` | Get pending messages |
| `QUEUEPROCESSMESSAGE` | Process queued message |

### Key method signatures & edge cases
#### `CREATEINTERNALMESSAGE`
**GAB Syntax:** `Subroutine.Global.Courier.CreateInternalMessage(Recipients, Subject, Body, [Priority])`

**Purpose:** Creates an internal message to specified recipients.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Recipients | String | Yes | Recipient list (delimited) |
| 2 | Subject | String | Yes | Message subject |
| 3 | Body | String | Yes | Message body |
| 4 | Priority | Integer | No | Message priority |

#### `CREATEEMMESSAGE`
**GAB Syntax:** `Subroutine.Global.Courier.CreateEMMessage(To, Subject, Body, [CC], [BCC])`

**Purpose:** Creates and sends an email message.

#### `QUEUEMESSAGE`
**GAB Syntax:** `Subroutine.Global.Courier.QueueMessage(MessageType, MessageData)`

**Purpose:** Queues a message for later processing.

---

## Component Reference: CustomerRelationshipManagementComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\CustomerRelationshipManagementComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\CustomerRelationshipManagementComponent.vb`
- **Feature toggle:** `982c3929-610f-4eea-a1e0-e4f3eb20681e`
- **OCTSRS conversion status:** ADO.NET refactor complete (Approach B)
- **Implementation size:** ~840 lines (legacy) + ADO.NET methods

### Runtime purpose
The Customer Relationship Management (CRM) Component provides CRM functionality including zip code lookups, distance calculations, event tracking, and opportunity management.

### Implementation notes (OCTSRS)
#### Legacy Behavior
- Zip code data stored in ATG_Zip table
- Distance calculations use spherical trigonometry
- Pi value hardcoded: 3.141592653589
- Earth radius: 3958.754 miles

#### Geographic Calculations
- Uses great circle distance formula
- Coordinates in decimal degrees
- Returns 99999 for invalid/missing data

#### Data Requirements
- ATG_Zip table must be populated
- Zip code data typically from USPS or commercial provider

#### Known Issues
- Zip code data may be outdated
- No international postal code support
- Distance calculation assumes spherical Earth

#### Migration Notes
- **ADO.NET (Approach B):** When feature toggle `982c3929-610f-4eea-a1e0-e4f3eb20681e` is enabled, GETCITIESFROMZIP, GETZIPPOSITION, GETZIPDISTANCE, GETZIPSNEARZIP, SAVEOPPORTUNITY, SAVEEVENT, and ISSUPERVISOR use ADO.NET (parameterized queries, AdoNetCompanyConnection / AdoNetCommonConnection). Legacy ADODB path remains when toggle is off.
- GETSTATEFROMABBR and INVOKE have no database calls; unchanged.
- SAVEEVENT AdoNet path currently delegates to legacy SaveEvent (full CRM_Events/CRM_Event_Meta ADO.NET conversion can be done in a follow-up).
- Table existence: `AdoNetConnectionExtensions.HasTable` for ADO.NET path; legacy uses `ActianCompanySqlConnection.HasTable`.
- Unit tests: `Octsrs.UnitTest\Components\CustomerRelationshipManagementComponent\` (GetCitiesFromZip.cs, GetStateFromAbbr.cs).

### Dependencies
#### Components Called
- `GlobalShopComponent` - For GSS integration
- `HookAssociationComponent` - For hook processing

#### Called By
- Customer maintenance screens
- Sales order entry
- Quote management
- Marketing campaigns
- Territory management

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `GETCITIESFROMZIP` | Get list of cities for a zip code |
| `GETSTATEFROMABBR` | Get full state name from abbreviation |
| `GETZIPPOSITION` | Get latitude/longitude for a zip code |
| `GETZIPDISTANCE` | Calculate distance between two zip codes |
| `GETZIPSNEARZIP` | Find zip codes within a radius |
| `SAVEEVENT` | Save a CRM event |
| `SAVEOPPORTUNITY` | Save a sales opportunity |
| `ISSUPERVISOR` | Check if user is a CRM supervisor |

### Key method signatures & edge cases
#### `GETCITIESFROMZIP`
**GAB Syntax:** `Function.Global.Crm.GetCitiesFromZip(ZipCode, Variable.Local.Cities)`

**Purpose:** Returns a list of cities associated with a zip code.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | ZipCode | String | Yes | 5-digit zip code |
| R | Cities | String | Yes | Return - Cities delimited by `*!*` |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| ATG_Zip | SELECT | Zip code lookup table |

**Returns:** Cities delimited by `*!*`, or `***NONE***` if not found

**Example Return:** `Houston*!*Bellaire*!*West University Place`

#### `GETZIPPOSITION`
**GAB Syntax:** `Function.Global.Crm.GetZipPosition(ZipCode, Variable.Local.Latitude, Variable.Local.Longitude)`

**Purpose:** Returns the geographic coordinates for a zip code.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | ZipCode | String | Yes | 5-digit zip code |
| R1 | Latitude | Double | Yes | Return - Latitude coordinate |
| R2 | Longitude | Double | Yes | Return - Longitude coordinate |

**Database Tables:**

| Table | Operation | Description |
|-------|-----------|-------------|
| ATG_Zip | SELECT | Zip code lookup table |

#### `GETZIPDISTANCE`
**GAB Syntax:** `Function.Global.Crm.GetZipDistance(Zip1, Zip2, Variable.Local.Distance)`

**Purpose:** Calculates the distance in miles between two zip codes.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Zip1 | String | Yes | First zip code |
| 2 | Zip2 | String | Yes | Second zip code |
| R | Distance | Double | Yes | Return - Distance in miles |

**Business Rules:**
- Uses great circle distance formula (Haversine)
- Returns 99999 if either zip code is invalid
- Returns 99999 if both zip codes are the same

**Implementation:**
```
Distance = arccos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(long1 - long2)) * 3958.754
```

#### `GETZIPSNEARZIP`
**GAB Syntax:** `Function.Global.Crm.GetZipsNearZip(ZipCode, RadiusMiles, Variable.Local.ZipList)`

**Purpose:** Finds all zip codes within a specified radius of a given zip code.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | ZipCode | String | Yes | Center zip code |
| 2 | RadiusMiles | Double | Yes | Search radius in miles |
| R | ZipList | String | Yes | Return - Zip codes delimited by `*!*` |

#### `GETSTATEFROMABBR`
**GAB Syntax:** `Function.Global.Crm.GetStateFromAbbr(Abbreviation, Variable.Local.StateName)`

**Purpose:** Returns the full state name from a 2-letter abbreviation.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Abbreviation | String | Yes | 2-letter state code (TX, CA, etc.) |
| R | StateName | String | Yes | Return - Full state name |

#### `SAVEEVENT`
**GAB Syntax:** `Subroutine.Global.Crm.SaveEvent(EventType, EventData, ...)`

**Purpose:** Saves a CRM event for tracking customer interactions.

**Business Context:**
- Track sales calls
- Record customer meetings
- Log support interactions
- Document follow-ups

#### `SAVEOPPORTUNITY`
**GAB Syntax:** `Subroutine.Global.Crm.SaveOpportunity(OpportunityData, ...)`

**Purpose:** Creates or updates a sales opportunity in the CRM.

**Business Context:**
- Sales pipeline management
- Quote tracking
- Win/loss analysis
- Revenue forecasting

#### `ISSUPERVISOR`
**GAB Syntax:** `Function.Global.Crm.IsSupervisor(UserID, Variable.Local.IsSupervisor)`

**Purpose:** Checks if a user has CRM supervisor privileges.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | UserID | String | Yes | User to check |
| R | IsSupervisor | Boolean | Yes | Return - True if supervisor |

#### `INVOKE`
**GAB Syntax:** `Function.Global.Crm.Invoke(...)`

**Purpose:** Invokes external CRM operations or integrations.

---

## Component Reference: DevExpressExcelComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\DevExpressExcelComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\DevExpressExcelComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~987 lines

### Runtime purpose
The DevExpress Excel Component provides Excel spreadsheet functionality using the DevExpress Spreadsheet library, without requiring Microsoft Excel installation.

### Implementation notes (OCTSRS)
#### No Excel Required
- Uses DevExpress Spreadsheet library
- Works without Microsoft Excel installed
- CheckPresence always returns true

#### API Compatibility
- Similar API to ExcelComponent
- Easy migration from COM-based Excel
- Same method names where possible

#### Migration Notes
- No database interaction
- Preferred over ExcelComponent for server use
- No COM/Office dependency

### Dependencies
#### External Dependencies
- DevExpress.Spreadsheet library
- DevExpress.XtraPrinting (for PDF export)

---

### Method surface (summary)
Reflection-heavy component with 21 documented methods. Key categories:
- Application Control
- Workbook Operations
- Worksheet Operations
- Cell Operations
- Row Operations
- Bulk Operations

Notable methods not clearly covered in agent docs:
- `CREATEAPPOBJECT` — Create spreadsheet object
- `DELETEALLOBJECTS` — Delete all objects
- `CREATEWORKBOOK` — Create new workbook
- `OPENWORKBOOK` — Open existing workbook
- `SAVEWORKBOOK` — Save workbook
- `CREATEWORKSHEET` — Create new worksheet
- `OPENWORKSHEET` — Open/activate worksheet
- `NAMEWORKSHEET` — Rename worksheet
- `ENUMERATEWORKSHEETS` — List all worksheets
- `GETWORKSHEETCOUNT` — Get worksheet count
- `EXPORTWORKSHEETTOPDF` — Export to PDF
- `READCELL` — Read cell value
- `WRITECELL` — Write cell value
- `FORMATCELL` — Format a cell
- `COPYCELLFORMAT` — Copy cell formatting
- `WRITEFORMULA` — Write formula
- `READROW` — Read entire row
- `ROWCOUNT` — Get row count
- `READSPREADSHEET` — Read entire spreadsheet
- `WRITESPREADSHEET` — Write entire spreadsheet

### Key method signatures & edge cases
#### `CHECKPRESENCE`
**GAB Syntax:** `Function.Global.DxExcel.CheckPresence(Variable.Local.IsPresent)`

**Purpose:** Always returns true since DevExpress doesn't require Excel.

**Note:** Unlike ExcelComponent, no external dependency needed

#### `READCELL`
**GAB Syntax:** `Function.Global.DxExcel.ObjectName.ReadCell(Row, Column, Variable.Local.Value)`

**Purpose:** Reads a value from a specific cell.

#### `WRITECELL`
**GAB Syntax:** `Subroutine.Global.DxExcel.ObjectName.WriteCell(Row, Column, Value)`

**Purpose:** Writes a value to a specific cell.

#### `EXPORTWORKSHEETTOPDF`
**GAB Syntax:** `Subroutine.Global.DxExcel.ObjectName.ExportWorksheetToPDF(OutputPath)`

**Purpose:** Exports the worksheet to PDF format.

---

## Component Reference: EncryptionComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\EncryptionComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\EncryptionComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~288 lines

### Runtime purpose
The Encryption Component provides encryption and decryption services using the GSSERP.SysCommonUtilities.dll library.

### Implementation notes (OCTSRS)
#### Implementation
- Uses reflection to load SysCommonUtilities assembly
- Dynamically invokes encryption methods
- Supports multiple algorithms and encodings

#### Security
- Encryption keys managed by SysCommonUtilities
- Algorithm selection affects security level
- Default algorithm recommended for most uses

#### Migration Notes
- No database interaction
- Depends on external DLL
- Reflection-based implementation

### Dependencies
#### External Dependencies
- GSSERP.SysCommonUtilities.dll
- Uses reflection to invoke encryption methods

---

### Key method signatures & edge cases
#### `ENCRYPT`
**GAB Syntax:** `Function.Global.Encryption.Encrypt(PlainText, [Algorithm], [Encoding], [Length], Variable.Local.EncryptedText)`

**Purpose:** Encrypts plain text using specified algorithm.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | PlainText | String | Yes | Text to encrypt |
| 2 | Algorithm | Integer | No | Encryption algorithm (-1 default) |
| 3 | Encoding | Integer | No | Text encoding |
| 4 | Length | Integer | No | Key length |
| R | EncryptedText | String | Yes | Return - Encrypted result |

**Algorithms:**
- -1: Default algorithm
- Other values defined in SysCommonUtilities

#### `DECRYPT`
**GAB Syntax:** `Function.Global.Encryption.Decrypt(EncryptedText, [Algorithm], [Encoding], [Length], Variable.Local.PlainText)`

**Purpose:** Decrypts encrypted text.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | EncryptedText | String | Yes | Text to decrypt |
| 2 | Algorithm | Integer | No | Encryption algorithm |
| 3 | Encoding | Integer | No | Text encoding |
| 4 | Length | Integer | No | Key length |
| R | PlainText | String | Yes | Return - Decrypted result |

---

## Component Reference: ExcelComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\ExcelComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\ExcelComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~1,074 lines

### Runtime purpose
The Excel Component provides Microsoft Excel integration for creating, reading, and manipulating Excel spreadsheets via COM automation.

### Implementation notes (OCTSRS)
#### COM Automation
- Uses CreateObject("Excel.Application")
- Objects tracked in UserDefinedObjects collection
- Must properly clean up objects to avoid memory leaks

#### Object Management
- Application objects must be terminated
- Workbooks should be saved before closing
- Worksheets tracked by name

#### Migration Notes
- COM interop dependency
- No database interaction
- Consider EPPlus/ClosedXML for non-COM alternatives

### Dependencies
#### External Dependencies
- Microsoft Excel (COM Automation)

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `CREATEAPPOBJECT` | Create Excel application object |
| `DELETEALLOBJECTS` | Delete all Excel objects |
| `CREATEWORKBOOK` | Create new workbook |
| `OPENWORKBOOK` | Open existing workbook |
| `SAVEWORKBOOK` | Save workbook |
| `CREATEWORKSHEET` | Create new worksheet |
| `OPENWORKSHEET` | Open/activate worksheet |
| `NAMEWORKSHEET` | Rename worksheet |
| `ENUMERATEWORKSHEETS` | List all worksheets |
| `GETWORKSHEETCOUNT` | Get worksheet count |
| `EXPORTWORKSHEETTOPDF` | Export worksheet to PDF |
| `READCELL` | Read cell value |
| `WRITECELL` | Write cell value |
| `FORMATCELL` | Format a cell |
| `COPYCELLFORMAT` | Copy cell formatting |
| `WRITEFORMULA` | Write formula to cell |
| `READROW` | Read entire row |
| `ROWCOUNT` | Get row count |
| `READSPREADSHEET` | Read entire spreadsheet |
| `WRITESPREADSHEET` | Write entire spreadsheet |

### Key method signatures & edge cases
#### `CHECKPRESENCE`
**GAB Syntax:** `Function.Global.Excel.CheckPresence(Variable.Local.IsInstalled)`

**Purpose:** Checks if Microsoft Excel is installed.

**Returns:** Boolean - True if Excel.Application registry entry exists

#### `READCELL`
**GAB Syntax:** `Function.Global.Excel.ObjectName.ReadCell(Row, Column, Variable.Local.Value)`

**Purpose:** Reads a value from a specific cell.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Row | Integer | Yes | Row number |
| 2 | Column | Integer | Yes | Column number |
| R | Value | String | Yes | Return - Cell value |

#### `WRITECELL`
**GAB Syntax:** `Subroutine.Global.Excel.ObjectName.WriteCell(Row, Column, Value)`

**Purpose:** Writes a value to a specific cell.

#### `FORMATCELL`
**GAB Syntax:** `Subroutine.Global.Excel.ObjectName.FormatCell(Row, Column, FormatOptions)`

**Purpose:** Applies formatting to a cell.

---

## Component Reference: GlobalShopComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\GlobalShopComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\GlobalShops\GlobalShopComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~2,279 lines

### Runtime purpose
The Global Shop Component provides core Global Shop Solutions integration functionality including call wrappers, hooks, licensing, and general GSS operations.

### Implementation notes (OCTSRS)
#### Call Wrappers
- Core GSS integration mechanism
- Supports sync and async execution
- Biometric versions available

#### Hook System
- Event-driven architecture
- Extensibility point for customization
- Active check before firing

#### Migration Notes
- Uses ADODB extensively
- Connection type: Company and Common
- Complex GSS integration

### Dependencies
#### External Dependencies
- GlobalShop.Encryption
- GSSEO
- GabLicensingAndEncryption

#### Components Called
- `HookAssociationComponent` - For hook operations
- `GlobalShopSecurityComponent` - For security

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `CALLWRAPPERASYNCBIO` | Async with biometric |
| `ISHOOKACTIVE` | Check if hook active |
| `GETMENUPATHFROMPROG` | Get menu from program |
| `GETPASSEDIDFROMHANDLE` | Get passed ID |
| `ISLICENSEDBYMODULENAME` | Check module license |
| `INVOKEWITHLAUNCHFILE` | Invoke with launch file |
| `ISINUPDATE` | Check if in update |
| `GETSERVICEWEBTOKEN` | Get service web token |

### Key method signatures & edge cases
#### `CALLWRAPPERSYNC`
**GAB Syntax:** `Function.Global.Gss.CallWrapperSync(WrapperName, Arguments, Variable.Local.Result)`

**Purpose:** Synchronously calls a GSS call wrapper.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | WrapperName | String | Yes | Call wrapper name |
| 2 | Arguments | String | Yes | Arguments to pass |
| R | Result | String | Yes | Return - Wrapper result |

#### `FIREHOOK`
**GAB Syntax:** `Subroutine.Global.Gss.FireHook(HookName, [Parameters])`

**Purpose:** Fires a GSS hook with optional parameters.

---

## Component Reference: GlobalShopEntityObjectComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\GlobalShopEntityObjectComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\GlobalShops\GlobalShopEntityObjectComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started

### Runtime purpose
The Global Shop Entity Object Component provides entity object management for Global Shop Solutions, handling business entities and their operations.

### Implementation notes (OCTSRS)
#### Migration Notes
- Check source file for detailed methods
- Entity-based operations
- May use ADODB for data access

### Dependencies
#### Components Called
- `GlobalShopComponent` - For GSS integration

---

---

## Component Reference: GlobalShopMobileComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\GlobalShopMobileComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\GlobalShops\GlobalShopMobileComponent.vb`
- **Feature toggle:** `TBD - Check Components_FeatureToggles.xlsx`
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~242 lines

### Runtime purpose
The Global Shop Mobile Component provides mobile-specific functionality for GSMobile applications including custom headers, lines, and printer management.

### Implementation notes (OCTSRS)
#### Mobile Integration
- Designed for GSMobile apps
- Custom header/line/printer support
- UPID-based printer lookup

#### Feature Toggle
- Has feature toggle check
- Also has Pervasive version check

#### Migration Notes
- Uses ADODB Recordset
- Connection type: Common database
- Consider ADO.NET conversion

### Dependencies
#### External Dependencies
- None specific

#### Components Called
- None directly

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `GETCUSTOMHEADER` | Get custom header info |
| `GETCUSTOMLINE` | Get custom line info |

### Key method signatures & edge cases
#### `GETCUSTOMHEADER`
**GAB Syntax:** `Function.Global.GssMobile.GetCustomHeader(HeaderID, Variable.Local.HeaderData)`

**Purpose:** Retrieves custom header information for mobile display.

#### `GETCUSTOMLINE`
**GAB Syntax:** `Function.Global.GssMobile.GetCustomLine(LineID, Variable.Local.LineData)`

**Purpose:** Retrieves custom line information for mobile display.

#### `GETPRINTERNAMEFROMID`
**GAB Syntax:** `Function.Global.GssMobile.GetPrinterNameFromID(UPID, Variable.Local.PrinterName)`

**Purpose:** Gets printer name from user printer ID.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | UPID | String | Yes | User Printer ID |
| R | PrinterName | String | Yes | Return - Printer name |

#### `SETCUSTOMRESULT`
**GAB Syntax:** `Subroutine.Global.GssMobile.SetCustomResult(ResultData)`

**Purpose:** Sets custom result data for mobile response.

---

## Component Reference: GlobalShopUserInterfaceComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\GlobalShopUserInterfaceComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\GlobalShops\GlobalShopUserInterfaceComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started

### Runtime purpose
The Global Shop User Interface Component provides GSS-specific UI functionality and form management.

### Implementation notes (OCTSRS)
#### Migration Notes
- Check source file for detailed methods
- UI-specific functionality
- May require DevExpress controls

### Dependencies
#### Components Called
- `UiComponent` - For base UI operations
- `GlobalShopComponent` - For GSS integration

---

---

## Component Reference: GroupWareComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\GroupWareComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\GroupWares\GroupWareComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started

### Runtime purpose
The GroupWare Component provides calendar and contact management functionality for groupware integration.

### Implementation notes (OCTSRS)
#### Groupware Integration
- Calendar synchronization
- Contact management
- Standard formats support

#### Migration Notes
- Check source file for detailed methods
- May use various groupware APIs

### Dependencies
#### External Dependencies
- Groupware systems (Exchange, etc.)

---

---

## Component Reference: OpenDatabaseConnectivityComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\OpenDatabaseConnectivityComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\OpenDatabaseConnectivityComponent.vb`
- **Feature toggle:** `898b3f8d-b19e-4967-8d4c-218c6aa29243` (see `OdbcConnectionMiscSqlAdoNetFeatureToggleId`; add to `FeatureToggles/Components_FeatureToggles.xlsx` if not present)
- **OCTSRS conversion status:** Misc connection SQL is routed to ADO.NET when the feature toggle is on (see `OdbcConnectionMiscSqlAdoNetFeatureToggleId`).
- **Implementation size:** ~2,874 lines (approximate; see component file)

### Runtime purpose
The ODBC Component provides comprehensive database connectivity and operations including connections, queries, transactions, and recordset management.

### Implementation notes (OCTSRS)
#### Dual Mode Operation
- Checks Pervasive version for ADO.NET vs ADODB
- ADO.NET used for newer Pervasive versions
- ADODB used for legacy compatibility

#### Feature Toggle
- `OPENCONNECTIONPOSTGRESQL` has feature toggle routing

#### Recordset Management
- Recordsets tracked by name
- Must be closed to release resources
- Supports multiple open recordsets

#### Related: GUI form settings (common DB)
`FormSettingsManager` (`GUI/Forms/FormSettingsManager.vb`) loads and saves `USER_FORM_SETTINGS` using **`AdoNetCommonConnection`** and parameterized SQL (no `ADODB.Recordset` in that path). That covers persisted form/accordion-style layout settings tied to user, machine, and script path.

#### Migration Notes
- Heavy ADODB usage in recordset and legacy ODBC paths
- ADO.NET used for misc connection SQL (toggle) and for form settings persistence on common
- Connection type: Company, Common, Custom
- Transaction support across both modes

### Dependencies
#### External Dependencies
- ADODB (legacy)
- System.Data.Odbc
- Pervasive ODBC driver

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `OPENCONNECTION` | Open custom connection |
| `OPENCOMPANYCONNECTION` | Open company database connection |
| `OPENCOMMONCONNECTION` | Open common database connection |
| `OPENCONNECTIONPOSTGRESQL` | Open PostgreSQL connection |
| `CLOSERECORDSETS` | Close all recordsets |
| `BEGINTRANSACTION` | Begin transaction |
| `COMMITTRANSACTION` | Commit transaction |
| `ROLLBACKTRANSACTION` | Rollback transaction |
| `EXECUTEANDRETURN` | Execute and return results |
| `EXECUTESCALAR` | Execute and return single value |
| `BOF` | Check beginning of file |
| `EOF` | Check end of file |
| `MOVENEXT` | Move to next record |
| `MOVEPREVIOUS` | Move to previous record |
| `MOVEFIRST` | Move to first record |
| `MOVELAST` | Move to last record |
| `READFIELD` | Read field value |
| `UPDATEFIELD` | Update field value |
| `ADDNEW` | Add new record |
| `GETSCHEMALIST` | Get schema list |
| `GETSCHEMAFIELDLIST` | Get field list for table |
| `GETSCHEMAFIELDLISTEXT` | Get extended field info |
| `FIELDEXISTS` | Check if field exists |

### Key method signatures & edge cases
#### `OPENCOMPANYCONNECTION`
**GAB Syntax:** `Subroutine.Global.Odbc.Connection.ConnectionName.OpenCompanyConnection()`

**Purpose:** Opens a connection to the company database.

**Business Rules:**
- Uses Pervasive version check for ADO.NET vs ADODB
- Logs connection type for debugging

#### `EXECUTE`
**GAB Syntax:** `Subroutine.Global.Odbc.Connection.ConnectionName.Execute(SQLStatement)`

**Purpose:** Executes a SQL statement.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | SQLStatement | String | Yes | SQL to execute |

#### `READFIELD`
**GAB Syntax:** `Function.Global.Odbc.Recordset.RecordsetName.ReadField(FieldName, Variable.Local.Value)`

**Purpose:** Reads a field value from current record.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FieldName | String | Yes | Field name |
| R | Value | Object | Yes | Return - Field value |

---

## Component Reference: OutlookComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\OutlookComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\OutlookComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started

### Runtime purpose
The Outlook Component provides Microsoft Outlook integration via COM automation.

### Implementation notes (OCTSRS)
#### COM Automation
- Requires Outlook installation
- Uses Outlook object model
- COM interop dependency

#### Migration Notes
- Check source file for detailed methods
- Consider Exchange Web Services for server-side

### Dependencies
#### External Dependencies
- Microsoft Outlook (COM Automation)

---

---

## Component Reference: PdfComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\PdfComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\PdfComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~748 lines

### Runtime purpose
The PDF Component provides PDF manipulation functionality using the iTextSharp library including merging, extracting, form filling, and text operations.

### Implementation notes (OCTSRS)
#### Document Management
- PDFs tracked in PdfDocuments collection
- Must close documents to release resources
- Supports multiple open documents

#### Form Handling
- Supports AcroForm fields
- Can read and write form values
- Field names case-sensitive

#### Migration Notes
- No database interaction
- Uses iTextSharp (consider iText7 upgrade)
- Memory management important for large PDFs

### Dependencies
#### External Dependencies
- iTextSharp library
- System.Drawing.Imaging

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `ISOPEN` | Check if PDF is open |
| `MERGE` | Merge multiple PDFs |
| `EXTRACTPAGES` | Extract pages to new PDF |
| `RESIZE` | Resize PDF pages |
| `ADDTEXT` | Add text to PDF |
| `TEXTSEARCH` | Search for text in PDF |
| `GETPAGECOUNT` | Get number of pages |
| `GETFIELDNAMES` | Get form field names |
| `GETFIELDNAMESANDVALUES` | Get fields with values |
| `SETFORMFIELDS` | Fill form fields |
| `CREATEFROMIMAGE` | Create PDF from image |

### Key method signatures & edge cases
#### `OPEN`
**GAB Syntax:** `Subroutine.Global.Pdf.PdfName.Open(FilePath, [OutputPath])`

**Purpose:** Opens a PDF document for manipulation.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FilePath | String | Yes | Path to PDF file |
| 2 | OutputPath | String | No | Output path for modifications |

#### `MERGE`
**GAB Syntax:** `Subroutine.Global.Pdf.Merge(OutputPath, InputFile1, InputFile2, [InputFile3...])`

**Purpose:** Merges multiple PDF files into one.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | OutputPath | String | Yes | Output file path |
| 2+ | InputFiles | String | Yes | PDF files to merge |

#### `SETFORMFIELDS`
**GAB Syntax:** `Subroutine.Global.Pdf.PdfName.SetFormFields(FieldName1, Value1, [FieldName2, Value2...])`

**Purpose:** Fills form fields in a PDF.

#### `EXTRACTPAGES`
**GAB Syntax:** `Subroutine.Global.Pdf.PdfName.ExtractPages(OutputPath, StartPage, EndPage)`

**Purpose:** Extracts a range of pages to a new PDF.

#### `TEXTSEARCH`
**GAB Syntax:** `Function.Global.Pdf.PdfName.TextSearch(SearchText, Variable.Local.Found)`

**Purpose:** Searches for text in the PDF.

---

## Component Reference: UiComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\UiComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\UiComponent.vb`
- **Feature toggle:** `TBD - Check Components_FeatureToggles.xlsx`
- **OCTSRS conversion status:** Partially Converted (some browser methods have ADO.NET versions)
- **Implementation size:** ~3,784 lines

### Runtime purpose
The UI Component provides user interface functionality including dialogs, browsers, message boxes, input forms, and window management.

### Implementation notes (OCTSRS)
#### Feature Toggle
- Browser methods have feature toggle routing
- ADO.NET versions exist for some browser operations

#### DevExpress
- Uses DevExpress controls for rich UI
- XtraEditors, XtraGrid, XtraBars

#### Window Management
- Handles window positioning
- Parent window relationships
- Modal/modeless dialogs

#### Migration Notes
- Uses ADODB for SQL browser
- ADO.NET versions available
- Heavy UI dependency
- Consider separating UI logic

### Dependencies
#### External Dependencies
- DevExpress UI controls
- System.Windows.Forms
- System.Drawing

#### Components Called
- `GlobalShopComponent` - For GSS integration

---

### Method surface (summary)
Reflection-heavy component with 28 documented methods. Key categories:
- Browser/Grid Operations
- Dialogs
- Message/Input
- Wait/Progress
- Window Management
- Configuration

Notable methods not clearly covered in agent docs:
- `BROWSER` — Show data browser from SQL
- `BROWSERFROMDATATABLE` — Browser from DataTable
- `BROWSERFROMDATAVIEW` — Browser from DataView
- `BROWSERFROMFILE` — Browser from file
- `BROWSERFROMSTRING` — Browser from string
- `COMMONBROWSER` — Common browser
- `MINIBROWSER` — Mini browser
- `SHOWOPENFILEDIALOG` — Open file dialog
- `SHOWSAVEFILEDIALOG` — Save file dialog
- `SHOWCOLORSELECTIONDIALOG` — Color picker
- `SHOWFONTSELECTIONDIALOG` — Font picker
- `FOLDERBROWSER` — Folder selection
- `INPUTBOX` — Show input dialog
- `ALTBOX` — Alternate input box
- `INPUTBOXEXT` — Extended input box
- `SHOWWAITDIALOG` — Show wait dialog
- `HIDEWAITDIALOG` — Hide wait dialog
- `UPDATEWAITDIALOG` — Update wait text
- `SETWINDOWPOSITION` — Set window position
- `SETWINDOWSIZE` — Set window size
- *(+7 more — see OCTSRS source)*

### Key method signatures & edge cases
#### `BROWSER`
**GAB Syntax:** `Function.Global.Ui.Browser(SQL, Title, [Columns], Variable.Local.Selection)`

**Purpose:** Shows a data browser populated from SQL query.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | SQL | String | Yes | SQL query for data |
| 2 | Title | String | Yes | Browser window title |
| 3 | Columns | String | No | Column configuration |
| R | Selection | String | Yes | Return - Selected value(s) |

#### `MSGBOX`
**GAB Syntax:** `Function.Global.Ui.MsgBox(Message, [Buttons], [Title], Variable.Local.Result)`

**Purpose:** Shows a message box dialog.

#### `INPUTBOX`
**GAB Syntax:** `Function.Global.Ui.InputBox(Prompt, [Title], [Default], Variable.Local.Input)`

**Purpose:** Shows an input dialog for user text entry.

#### `SHOWWAITDIALOG`
**GAB Syntax:** `Subroutine.Global.Ui.ShowWaitDialog(Message)`

**Purpose:** Shows a wait/progress dialog.

---

## Component Reference: WordComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\WordComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\WordComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~141 lines

### Runtime purpose
The Word Component provides Microsoft Word integration for document manipulation via COM automation.

### Implementation notes (OCTSRS)
#### COM Automation
- Uses Word.Document registry check
- Caches presence check result
- Requires Word installation

#### Migration Notes
- No database interaction
- COM interop dependency
- Consider Open XML SDK for non-COM alternatives

### Dependencies
#### External Dependencies
- Microsoft Word (COM Automation)

---

### Key method signatures & edge cases
#### `CHECKPRESENCE`
**GAB Syntax:** `Function.Global.Word.CheckPresence(Variable.Local.IsInstalled)`

**Purpose:** Checks if Microsoft Word is installed.

**Returns:** Boolean - True if Word.Document registry entry exists

#### `REPLACE`
**GAB Syntax:** `Subroutine.Global.Word.Replace(FilePath, FindText, ReplaceText)`

**Purpose:** Performs find and replace in a Word document.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FilePath | String | Yes | Path to Word document |
| 2 | FindText | String | Yes | Text to find |
| 3 | ReplaceText | String | Yes | Replacement text |

---

## Component Reference: ZipComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\ZipComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\ZipComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~280 lines

### Runtime purpose
The Zip Component provides file compression and decompression functionality using the nsoftware IPWorks Zip library.

### Implementation notes (OCTSRS)
#### Dual Mode
- Supports standard Zip and ZipPro methods
- IsZipProMethods flag controls mode
- Different feature sets per mode

#### Migration Notes
- No database interaction
- Modern compression library
- Merged from XStandard component

### Dependencies
#### External Dependencies
- nsoftware.IPWorksZip library

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `ZIPCONTENTS` | List archive contents |
| `COMPRESS` | Compress files |
| `EXTRACT` | Extract files |

### Key method signatures & edge cases
#### `COMPRESS`
**GAB Syntax:** `Subroutine.Global.Zip.Compress(ArchivePath, [Files])`

**Purpose:** Compresses files into a ZIP archive.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | ArchivePath | String | Yes | Output ZIP file path |
| 2 | Files | String | No | Files to compress |

#### `EXTRACT`
**GAB Syntax:** `Subroutine.Global.Zip.Extract(ArchivePath, [DestinationPath])`

**Purpose:** Extracts files from a ZIP archive.

#### `ZIPCONTENTS`
**GAB Syntax:** `Function.Global.Zip.ZipContents(ArchivePath, Variable.Local.Contents)`

**Purpose:** Lists the contents of a ZIP archive.

---
