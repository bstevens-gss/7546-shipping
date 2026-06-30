# GAB File I/O & Automation Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with files, Excel, PDF, ZIP, BDF, or images
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

> **Critical pitfalls for I/O operations:** See `agents/gab/PITFALLS.md` for:
> - **`String2File` / `File2String` argument order** -- path is always the FIRST argument, content is SECOND. Reversing them is a common mistake.
> - **ODBC connection name reuse** across nested calls when writing file-driven workflows.

# FILE I/O

```
F.Intrinsic.File.Exists(sPath,bResult)
F.Intrinsic.File.DirExists(sPath,bResult)
F.Intrinsic.File.CreateDir(sPath)
F.Intrinsic.File.String2File(sPath,sContent)               ' Write
F.Intrinsic.File.File2String(sPath,sContent)               ' Read
F.Intrinsic.File.CopyFile(sSource,sDest)
F.Intrinsic.File.MoveFile(sSource,sDest,bResult)                ' Move/rename a file
F.Intrinsic.File.DeleteFile(sPath)
F.Intrinsic.File.DeleteDir(sPath,bRecursive)                   ' True to remove subdirs & files
F.Intrinsic.File.IsFileLocked(sPath,bResult)
F.Intrinsic.File.GetFileList(sPattern,sResult)               ' Wildcard file listing (e.g., "C:\path\*.csv")
F.Intrinsic.File.GetFileNameFromFQN(sFQPath,sFileName)       ' Extract filename from full path
F.Intrinsic.File.GetExtensionComponent(sFileName,sExtension) ' Extract file extension
F.Intrinsic.File.PathExists(sPath,bResult)                   ' Check if directory path exists
F.Intrinsic.File.MakeFilenameFriendly(sInput,sResult)        ' Sanitize filename
F.Intrinsic.File.CopyOpenFile(sSource,sDest)                 ' Copy even if file is in use
F.Intrinsic.File.FileToStringArray(sPath,sDelimiter,sArray)  ' Read file into string array split by delimiter

' Handle-based file writing (for line-by-line output)
F.Intrinsic.File.GetHandle(iHandle)                          ' Get available file handle
F.Intrinsic.File.OpenForWrite(sPath,iHandle)                 ' Open file for writing
F.Intrinsic.File.WriteLine(iHandle,sLine)                    ' Write a line
F.Intrinsic.File.CloseFile(iHandle)                          ' Close file handle
```

## Handle-Based File Reading
```
F.Intrinsic.File.GetHandle(iHandle)
F.Intrinsic.File.OpenForRead(sPath,iHandle)
F.Intrinsic.File.ReadFile(iHandle,sResult)               ' Read entire file contents
F.Intrinsic.File.ReadLine(iHandle,sResult)                ' Read next line
F.Intrinsic.File.EOF(iHandle,bResult)
F.Intrinsic.File.CloseFile(iHandle)

' Read file line-by-line pattern:
F.Intrinsic.File.GetHandle(V.Local.iHandle)
F.Intrinsic.File.OpenForRead(V.Local.sPath,V.Local.iHandle)
V.Local.bEOF.Declare(Boolean, False)
F.Intrinsic.Control.DoUntil(V.Local.bEOF,=,True)
    F.Intrinsic.File.ReadLine(V.Local.iHandle,V.Local.sLine)
    F.Intrinsic.File.EOF(V.Local.iHandle,V.Local.bEOF)
F.Intrinsic.Control.Loop
F.Intrinsic.File.CloseFile(V.Local.iHandle)
```

## Append & Prepend
```
F.Intrinsic.File.Append2File(sPath,sContent)              ' Append text to file
F.Intrinsic.File.Append2FileNewLine(sPath,sContent)       ' Append with newline
F.Intrinsic.File.PrependToFile(sPath,sContent)             ' Prepend text to file start
F.Intrinsic.File.PrependToFileNewLine(sPath,sContent)      ' Prepend with newline
F.Intrinsic.File.OpenForAppend(sPath,iHandle)              ' Open for append (handle-based)
```

## File Merge
```
F.Intrinsic.File.MergeHtmlFiles(sHeader,sFooter,sExportToGrid,sReturnFilePath)  ' Appends data from all files into return file
```

## Directory Operations
```
F.Intrinsic.File.CopyDirectory(sSource,sTarget,bOverwrite,bResult)
F.Intrinsic.File.MoveDirectory(sSource,sTarget,bResult)
F.Intrinsic.File.ChangeDirectory(sPath)
```

## File Metadata
```
F.Intrinsic.File.GetFileSize(sPath,iResult)
F.Intrinsic.File.GetFileDateTime(sPath,dResult)
F.Intrinsic.File.GetFileDateTimeExtended(sPath,sType,bUseLocal,dResult)    ' sType: "Created", "LastAccess", "LastModified"
F.Intrinsic.File.SetFileDateTimeExtended(sPath,sType,bUseLocal)            ' Sets creation, last access, or last modified date/time
F.Intrinsic.File.GetFileAttributes(sPath,iResult)
F.Intrinsic.File.SetFileAttributes(sPath,iAttrValue)
F.Intrinsic.File.CalculateMD5(sPath,sResult)              ' MD5 hash of file contents
F.Intrinsic.File.DisplaySizeString(iLength,bShortSuffix,sResult)  ' Human-readable file size
F.Intrinsic.File.GetFreeDiskCapacity(sPath,fResult)
F.Intrinsic.File.GetTotalDiskCapacity(sPath,fResult)
F.Intrinsic.File.GetScriptVersion(sPath,sResult)        ' Read script version from a GAS file
F.Intrinsic.File.SetScriptVersion(sVersion)              ' Set script version in a GAS file
```

## File Properties (PE Version Info)
```
F.Intrinsic.File.ReadPropCompanyName(sPath,sResult)
F.Intrinsic.File.ReadPropDescription(sPath,sResult)
F.Intrinsic.File.ReadPropInternalName(sPath,sResult)
F.Intrinsic.File.ReadPropLegalCopyright(sPath,sResult)
F.Intrinsic.File.ReadPropOriginalFileName(sPath,sResult)
F.Intrinsic.File.ReadPropProductName(sPath,sResult)
F.Intrinsic.File.ReadPropProductVersion(sPath,sResult)
F.Intrinsic.File.ReadPropVersion(sPath,sResult)
```

## Path Utilities
```
F.Intrinsic.File.GetPathFromFQN(sFQN,sResult)            ' Extract directory from full path
F.Intrinsic.File.GetShortPath(sFQN,sResult)               ' 8.3 format path
F.Intrinsic.File.GetUNCName(sPath,sResult)                ' Map drive letter to UNC path
F.Intrinsic.File.IsUNC(sPath,bResult)                     ' Check if UNC path
F.Intrinsic.File.IsFilenameValid(sFileName,bResult)       ' Validate filename characters
```

## Binary File Operations
```
F.Intrinsic.File.OpenForBinary(sPath,iHandle)
F.Intrinsic.File.BinaryGet(iHandle,iPosition,iLength,sResult)
F.Intrinsic.File.BinaryPut(iHandle,sData)
F.Intrinsic.File.GetLOF(iHandle,iResult)                  ' Length of file in bytes
F.Intrinsic.File.Reset                                      ' Close ALL open files in all subs
```

## Version Comparison
```
F.Intrinsic.File.IsTargetDateTimeNewer(sPath,dCompare,bResult)
F.Intrinsic.File.IsTargetSizeLarger(sPath,iCompareSize,bResult)
F.Intrinsic.File.IsTargetVersionHigher(sPath,sVersion,bResult)
F.Intrinsic.File.GetScriptVersion(sGASFile,sResult)
F.Intrinsic.File.SetScriptVersion(sVersion)                    ' Sets the script version label; companion to GetScriptVersion
```

---

# EXCEL AUTOMATION

## Quick Read/Write (no Excel instance required)
```
F.Automation.MSExcel.ReadSpreadsheet(sFilePath,sContent)
F.Automation.MSExcel.WriteSpreadsheet(sFilePath,sContent)
```
Excel content format: Sheets separated by `&^&`, rows by `$!$`, cells by `*!*`.

## COM-Based Excel Automation (requires Excel installed)
```
F.Automation.MSExcel.CheckPresence(bResult)                 ' Check if Excel is installed
F.Automation.MSExcel.CreateAppObject                        ' Create Excel application instance
F.Automation.MSExcel.OpenWorkBook(sFilePath)                ' Open workbook
F.Automation.MSExcel.EnumerateWorksheets(sResult)           ' List all sheet names
F.Automation.MSExcel.OpenWorksheet(sSheetName)              ' Select active sheet
F.Automation.MSExcel.RowCount(iResult)                      ' Row count of active sheet
F.Automation.MSExcel.ReadCell(iRow,iCol,sResult)            ' Read individual cell
F.Automation.MSExcel.ReadRow(iRow,sResult)                  ' Read entire row
F.Automation.MSExcel.DestroyAllObjects                      ' Clean up COM objects
```

## Excel COM Write Operations
```
F.Automation.MSExcel.CreateWorkbook                         ' Create new empty workbook
F.Automation.MSExcel.CreateWorksheet(sSheetName)            ' Add new sheet
F.Automation.MSExcel.WriteCell(iRow,iCol,sValue)            ' Write to cell
F.Automation.MSExcel.WriteFormula(iRow,iCol,sFormula)       ' Write formula to cell
F.Automation.MSExcel.FormatCell(iRow,iCol,sProperty,sValue) ' Format cell
F.Automation.MSExcel.SaveWorkbook(sFilePath)                ' Save workbook
F.Automation.MSExcel.ExportWorksheetToPDF(sSheetName,sPDFPath)  ' Export sheet as PDF
F.Automation.MSExcel.DeleteAllObjects                       ' Cleanup (use in Finally block)
```

Note the full COM lifecycle:
1. `CheckPresence` -> 2. `CreateAppObject` -> 3. `CreateWorkbook` or `OpenWorkBook` -> 4. Read/Write operations -> 5. `SaveWorkbook` -> 6. `DestroyAllObjects` (ALWAYS, even on error)

---

# IMAGE OPERATIONS

```
F.Image.File.Load("imageAlias",sFilePath)                    ' Load image from file
F.Image.File.ToByteArray(sFilePath,V.Local.baResult)          ' Convert image to ByteArray (for DataTable storage)
F.Image.File.Save("imageAlias",sFilePath)                    ' Save image to file
F.Image.Transform.RotateFlip(sInputPath,sMode,sOutputPath)   ' Modes: Rotate90, Rotate180, Rotate270, FlipX, FlipY
```

Used with DataTables that have `BYTEARRAY` columns for image data (e.g., TileView, CardView controls).

---

# PDF AUTOMATION

```
' Open/Close
F.Automation.PDF.Open("alias",sFilePath)
F.Automation.PDF.Close("alias")

' Read operations
F.Automation.PDF.GetPageCount("alias",iResult)
F.Automation.PDF.GetFieldNames("alias",sResult)
F.Automation.PDF.GetFieldNamesAndValues("alias",sResult)
F.Automation.PDF.TextSearch("alias",sSearchText,sResult)

' Manipulation
F.Automation.PDF.SetFormFields("alias",sOutputPath,sFieldNames,sFieldValues,bFlatten)
F.Automation.PDF.ExtractPages("alias",sOutputPath,iStartPage,iEndPage)
F.Automation.PDF.Merge(sInputPath,sOutputPath)
F.Automation.PDF.AddText("alias",sText,iPage,iX,iY)
```

---

# WORD AUTOMATION

```
F.Automation.MSWord.CheckPresence(bResult)
F.Automation.MSWord.Replace(sFilePath,sFindText,sReplaceText)
```
Limited to find/replace operations. For complex Word automation, use external tools.

---

# ZIP / COMPRESSION

## Simple Zip
```
F.Automation.Zip.Zip(sSourcePath,sZipPath)
F.Automation.Zip.UnZip(sZipPath,sDestPath)
```

## Advanced ZIPPro
```
F.Automation.ZIPPro.SetProperty("PropertyName",value)
F.Automation.ZIPPro.IncludeFiles(sPattern)           ' e.g., "*.csv"
F.Automation.ZIPPro.Compress(sSourceDir,sZipPath)
F.Automation.ZIPPro.ExtractAll(sZipPath,sDestDir)
F.Automation.ZIPPro.Scan(sZipPath,sResult)           ' List contents
```

---

# BDF (Binary Data Files)

BDFs are binary record files used by GSS for auxiliary data storage (e.g., AUX001, AUX002, AUX003).

```
F.Intrinsic.BDF.Load("bdfName","bdfName")                     ' Load BDF file
F.Intrinsic.BDF.Load("bdfName","bdfName",True)                ' Load with write access
F.Intrinsic.BDF.ReadRowCount("bdfName",iResult)
F.Intrinsic.BDF.ReadRow("bdfName",iRowIndex,sResult)          ' Returns pipe-delimited (|~|) row
F.Intrinsic.BDF.ReadColumnTitle("bdfName",sResult)             ' Column headers
F.Intrinsic.BDF.ReadColumnCount("bdfName",iResult)             ' Number of columns
F.Intrinsic.BDF.ReadColumnDataType("bdfName",sResult)          ' Column data types
F.Intrinsic.BDF.ReadKey("bdfName",sResult)                     ' Key of a BDF object
F.Intrinsic.BDF.ReadTitle("bdfName",sResult)                   ' Title of a BDF object
F.Intrinsic.BDF.WriteRow("bdfName",sRowData)                  ' Write row (pipe-delimited)
F.Intrinsic.BDF.AddColumn("bdfName",sColName,sColType,[bEditable],[iColWidth])  ' Add column to BDF
F.Intrinsic.BDF.SetColumnTitle("bdfName",iColIndex,sTitle)     ' Set column title
F.Intrinsic.BDF.SetData("bdfName",iColIndex,iRowIndex,sValue)  ' Set a specific cell value
F.Intrinsic.BDF.SetProperty("bdfName",iColIndex,sReplace,sValue)  ' Set cell/column property
F.Intrinsic.BDF.TextMatrix("bdfName",iCol,iRow,sResult)        ' Read a single cell value
F.Intrinsic.BDF.SeekRow("bdfName",iCol,iStartRow,sSearchText,iResult)  ' Search a column for a value
F.Intrinsic.BDF.ReplaceAndSave("bdfName",sFind,sReplace)       ' Find/replace and save
F.Intrinsic.BDF.Clone("bdfName","cloneName")                  ' Clone BDF structure
F.Intrinsic.BDF.Save("bdfName")                               ' Save changes
```

