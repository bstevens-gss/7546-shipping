# Crystal Reports SDK - Portable Release Folder

This folder contains the SAP Crystal Reports .NET SDK DLLs and supporting files needed to compile Crystal Report programs. It travels with the agent kit so that any machine with the Crystal runtime installed can compile against these references.

## SDK Version

| Property | Value |
|----------|-------|
| Crystal Reports Version | 13.0.4000.0 |
| PublicKeyToken | `692fbea5521e1304` |
| Target Framework | .NET Framework 4.0+ (compiled with `/platform:x86`) |

## Contents

| File | Purpose |
|------|---------|
| `CrystalDecisions.CrystalReports.Engine.dll` | Engine API (load, modify, export, print reports) |
| `CrystalDecisions.Shared.dll` | Shared types, enums, exceptions |
| `CrystalDecisions.ReportAppServer.ClientDoc.dll` | RAS InProc client document (ISCDReportClientDocument) |
| `CrystalDecisions.ReportAppServer.Controllers.dll` | RAS controllers (ReportDef, Database, DataDef, etc.) |
| `CrystalDecisions.ReportAppServer.DataDefModel.dll` | RAS data definition model (fields, formulas, parameters, groups) |
| `CrystalDecisions.ReportAppServer.ReportDefModel.dll` | RAS report definition model (sections, objects, formatting) |
| `CrystalDecisions.ReportAppServer.CommonObjectModel.dll` | RAS common object model base types |
| `CrystalDecisions.ReportAppServer.CommLayer.dll` | RAS communication layer |
| `CrystalDecisions.ReportAppServer.ObjectFactory.dll` | RAS object factory |
| `log4net.dll` | SAP-signed log4net (v1.2.10.0, required runtime dependency) |
| `RptToXml.exe` | Report-to-XML inspection tool |
| `App.config` | Template config file (copy to `<YourExe>.exe.config` next to compiled exe) |

## Provenance

- Crystal DLLs extracted from: `C:\Windows\Microsoft.NET\assembly\GAC_MSIL\CrystalDecisions.*\v4.0_13.0.4000.0__692fbea5521e1304\`
- log4net.dll extracted from: `C:\Windows\assembly\GAC_32\log4net\1.2.10.0__692fbea5521e1304\`
- RptToXml.exe copied from a prior Crystal project Release folder
- Extracted on: 2026-05-22

## Usage

All compile commands in the Crystal agent documentation reference these files as `Release\...` relative paths. The working directory for compilation should be `agents/crystal/`.

Example:
```
C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe /platform:x86 /target:exe ^
  /reference:"Release\CrystalDecisions.CrystalReports.Engine.dll" ^
  /reference:"Release\CrystalDecisions.Shared.dll" ^
  /out:MyProgram.exe MyProgram.cs
```
