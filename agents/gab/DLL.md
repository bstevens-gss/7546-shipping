# GAB+DLL Development Guide
# Creating .NET Class Libraries for GAB Integration
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass

> **When to use this file:** You are creating a C# DLL that GAB scripts will load and call via `F.Automation.Generic.*`, or debugging an existing GAB+DLL integration. For the GAB-side API reference (`LoadAssembly`, `CreateObject`, `CallMethod`, etc.), see [`agents/gab/API_AUTOMATION.md`](API_AUTOMATION.md) (`# EXTERNAL AUTOMATION (.NET)`).

---

## When to Use a GAB+DLL Solution

Use a DLL when GAB alone is insufficient:

| Scenario | Why GAB alone fails |
|----------|-------------------|
| REST/GraphQL APIs with complex auth (OAuth, HMAC, JWT) | GAB's `F.ODBC.Connection` and basic HTTP support lack headers, token refresh, retry logic |
| NuGet package consumption (Newtonsoft.Json, RestSharp, etc.) | GAB cannot reference NuGet packages directly |
| Complex data transformation (JSON/XML parsing, pagination, aggregation) | GAB string functions become unwieldy for deeply nested structures |
| Async/parallel operations | GAB is single-threaded; C# can use `Task.Run` with `.Result` for sync-over-async |
| Reusable business logic shared across multiple g2u scripts | A single DLL method can be called from many scripts without copy-pasting |

If the task is simple (basic SQL, file I/O, UI), use pure GAB -- DLLs add build/deploy overhead.

---

## Project Setup

### Framework Target (CRITICAL)

**Always target .NET Framework 4.6.2.** GAB's runtime loads assemblies via the .NET Framework CLR. SDK-style projects, .NET Core, .NET 5+, and .NET Standard are **not compatible**.

### Solution Structure

```
{ProjectName}/
├── {ProjectName}.sln
├── {ProjectName}/                    # Class Library (OutputType=Library)
│   ├── {ProjectName}.csproj
│   ├── {MainClass}.cs
│   ├── Properties/
│   │   └── AssemblyInfo.cs
│   └── packages.config
└── {ProjectName}.Test/               # Console Test Harness (OutputType=Exe)
    ├── {ProjectName}.Test.csproj
    ├── Program.cs
    ├── Properties/
    │   └── AssemblyInfo.cs
    └── packages.config
```

### NuGet Restore

Use **`packages.config`** (classic restore), NOT `PackageReference`. GAB's runtime expects NuGet DLLs to be resolvable from the output folder, and classic restore with `<HintPath>` makes deployment predictable.

### ProjectGuid

Every `.csproj` must have a **unique** `<ProjectGuid>`. Do not copy GUIDs from another solution -- generate fresh ones.

---

## Class Design Rules (CRITICAL)

These rules are non-negotiable. Violations produce runtime errors that are difficult to diagnose from the GAB side.

### 1. All classes MUST be `public`

GAB uses reflection to instantiate classes via `F.Automation.Generic.CreateObject`. The runtime cannot access `internal`, `private`, or `protected` types.

```csharp
// WRONG -- GAB cannot instantiate this
internal class MyClient { ... }

// CORRECT
public class MyClient { ... }
```

### 2. Avoid private class structures

Do not wrap GAB-facing logic in private nested classes. The public facade class is the API surface GAB interacts with. Helper types that GAB does NOT instantiate can be `private` within the facade class, but the facade class itself and all its methods that GAB calls must be `public`.

```csharp
public class MyClient
{
    // GAB calls this -- MUST be public
    public string DoWork(string args) { ... }

    // Internal helper -- private is fine because GAB never calls it
    private string ParseInput(string raw) { ... }

    // Internal DTO -- private is fine because GAB never instantiates it
    private class ParsedInput
    {
        public string Key { get; set; }
        public string Value { get; set; }
    }
}
```

### 3. Every method GAB calls MUST accept a `string` parameter

GAB's `CallMethod` / `CallMethodReturnVariable` **always passes the Args field as a single `string`**, even when the GAB script passes `""`. The .NET runtime performs overload resolution looking for a method that accepts `(string)`. A parameterless method fails with:

> `Overload resolution failed because no accessible 'MethodName' accepts this number of arguments`

```csharp
// WRONG -- will fail at runtime
public string Ping() { return "PONG"; }

// CORRECT -- accept string even if unused
public string Ping(string args) { return "PONG"; }
```

### 4. All GAB-callable methods MUST return `string`

GAB receives method return values as strings via `CallMethodReturnVariable`. If a method returns `void`, use `CallMethod` instead of `CallMethodReturnVariable`, but the method must still accept a `string` parameter.

---

## Method Signature Contract

### Single-Parameter Convention

The DLL defines its own internal delimiter. The GAB script builds a delimited string and passes it as the single `string args` parameter.

**C# side:**
```csharp
public string GetProducts(string inputString)
{
    string[] parts = inputString.Split('|');
    string apiKey = parts[0].Trim();
    string apiSecret = parts[1].Trim();
    string accountPath = parts[2].Trim();
    // ...
}
```

**GAB side:**
```
F.Intrinsic.String.Build("{0}|{1}|{2}", V.Local.sKey, V.Local.sSecret, V.Local.sAccount, V.Local.sInput)
F.Automation.Generic.CallMethodReturnVariable(MYOBJ, GetProducts, V.Local.sInput, V.Local.sResult)
```

Common delimiters: `|` (pipe), `~` (tilde), `^` (caret). Choose one that won't appear in your data.

### Multi-Parameter Convention

When the C# method has **multiple parameters**, GAB uses `*!*` as the delimiter. The .NET runtime maps the segments to method parameters in order.

**C# side:**
```csharp
public string Update(string companyId, string userName, string password)
{
    // GAB passes: "ACME*!*jdoe*!*secret123"
    // Runtime maps: companyId="ACME", userName="jdoe", password="secret123"
}
```

**GAB side:**
```
F.Intrinsic.String.Build("{0}*!*{1}*!*{2}", V.Local.sCompany, V.Local.sUser, V.Local.sPass, V.Local.sParams)
F.Automation.Generic.CallMethod(MYOBJ, Update, V.Local.sParams)
```

### Return Value Convention

Adopt a consistent prefix convention so GAB can check success/failure:

```csharp
return $"SUCCESS: Connected to {accountPath}";
return $"ERROR: Input must be apiKey|apiSecret|accountPath";
return $"ERROR: {ex.Message}";
```

**GAB side check:**
```
F.Intrinsic.String.Left(V.Local.sResult, 5, V.Local.sCheck)
F.Intrinsic.Control.If(V.Local.sCheck, =, "ERROR")
    F.Intrinsic.UI.Msgbox(V.Local.sResult, "DLL Error")
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf
```

For multi-row returns (e.g., product lists), return newline-separated rows with pipe-delimited fields. Sanitize embedded pipes and newlines in field values.

---

## Build and Deployment

### MSBuild

Use the MSBuild path detection order:
1. `C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\MSBuild.exe`
2. `vswhere.exe` fallback
3. .NET Framework MSBuild fallback

Build command:
```powershell
& "$msbuildPath" /t:Build /p:Configuration=Release "{ProjectName}.sln"
```

### Deployment Checklist

| What | Where | Why |
|------|-------|-----|
| Main DLL (e.g., `FinaleGAB.dll`) | `V.Ambient.ScriptPath` (same folder as the `.g2u`) | GAB builds the path with `V.Ambient.ScriptPath` |
| NuGet dependency DLLs (e.g., `Newtonsoft.Json.dll`) | Same folder as main DLL | .NET assembly resolution looks in the app base directory; NuGet DLLs are NOT in the GAC |
| `.pdb` files | Same folder (optional) | Only needed if debugging with Visual Studio attached |

**Do NOT deploy:** `app.config`, `*.Test.dll`, `packages/` folder, `obj/` folder.

### No `app.config` Support

GAB's runtime does **not** load `.config` files for DLLs. All configuration (API keys, endpoints, credentials) must come from:
- GAB parameters passed to the DLL method
- Database tables (queried by the GAB script, passed as a delimited string)
- Encrypted storage (via `F.Global.Encryption`)

---

## GAB Integration Pattern

### Complete Lifecycle

```
Program.Sub.Preflight.Start
Program.External.Include.File("MyLibrary.dll",False)
Program.Sub.Preflight.End

Program.Sub.Main.Start
F.Intrinsic.Control.SetErrorHandler("Main_Err")
F.Intrinsic.Control.ClearErrors

V.Local.sDllPath.Declare(String)
V.Local.sInput.Declare(String)
V.Local.sResult.Declare(String)
V.Local.sCheck.Declare(String)

' 1. Build path and load assembly
F.Intrinsic.String.Build("{0}\MyLibrary.dll", V.Ambient.ScriptPath, V.Local.sDllPath)
F.Automation.Generic.LoadAssembly(MYLIBRARY, V.Local.sDllPath)

' 2. Create object instance
F.Automation.Generic.CreateObject(MYLIBRARY, MyNamespace.MyClient, "oClient")

' 3. Build parameter string and call method
F.Intrinsic.String.Build("{0}|{1}|{2}", V.Local.sKey, V.Local.sSecret, V.Local.sPath, V.Local.sInput)
F.Automation.Generic.CallMethodReturnVariable(oClient, MyMethod, V.Local.sInput, V.Local.sResult)

' 4. Destroy object
F.Automation.Generic.DestroyObject("oClient")

' 5. Check result
F.Intrinsic.String.Left(V.Local.sResult, 5, V.Local.sCheck)
F.Intrinsic.Control.If(V.Local.sCheck, =, "ERROR")
    F.Intrinsic.UI.Msgbox(V.Local.sResult, "Error")
    F.Intrinsic.Control.ExitSub
F.Intrinsic.Control.EndIf

' 6. Use result...

F.Intrinsic.Control.ExitSub

F.Intrinsic.Control.Label("Main_Err")
F.Intrinsic.Control.If(V.Ambient.ErrorNumber, <>, 0)
    F.Intrinsic.String.Build("Error {0}: {1}", V.Ambient.ErrorNumber, V.Ambient.ErrorDescription, V.Local.sResult)
    F.Intrinsic.UI.Msgbox(V.Local.sResult, "Error")
F.Intrinsic.Control.EndIf
Program.Sub.Main.End
```

### Key Points

- The `Program.External.Include.File` DLL name must match the assembly alias used in `LoadAssembly`
- `CreateObject` takes the **fully qualified class name** (`Namespace.ClassName`)
- Instance names are **case-insensitive** (`oClient` and `OCLIENT` are interchangeable)
- Always `DestroyObject` to release COM/interop resources
- For detailed API docs on each `F.Automation.Generic.*` function, see [`agents/gab/API_AUTOMATION.md`](API_AUTOMATION.md) (`# EXTERNAL AUTOMATION (.NET)`)

---

## Testing Pattern

### Console Test Harness

Add a second project in the same solution with `OutputType=Exe`. It references the class library project directly.

```csharp
public class Program
{
    public static void Main(string[] args)
    {
        var client = new MyClient();

        // Test with same string format GAB would pass
        string input = "apiKey|apiSecret|accountPath";
        string result = client.TestConnection(input);
        Console.WriteLine(result.StartsWith("SUCCESS") ? "PASS" : $"FAIL: {result}");

        // Test error handling
        result = client.TestConnection("bad|bad|bad");
        Console.WriteLine(result.StartsWith("ERROR") ? "PASS" : $"FAIL: {result}");
    }
}
```

### Testing Principles

- Call the **same public methods** with the **same string format** GAB would use
- Verify both `SUCCESS:` and `ERROR:` paths
- Use constants or environment variables for credentials in tests -- never hardcode production secrets
- Run the test console before deploying the DLL alongside the `.g2u`

---

## Common Gotchas

| Problem | Cause | Fix |
|---------|-------|-----|
| `Overload resolution failed because no accessible 'MethodName' accepts this number of arguments` | Method has no `string` parameter | Add `string args` parameter (even if unused) |
| `Could not load file or assembly 'Newtonsoft.Json'` | NuGet DLL not deployed alongside main DLL | Copy `Newtonsoft.Json.dll` (and all other dependency DLLs) to the same folder |
| Method returns nothing / empty | Method returns `void` but called with `CallMethodReturnVariable` | Change method to return `string`, or use `CallMethod` for void methods |
| `Type 'MyClass' is not defined` | Class is `internal` or `private` | Make the class `public` |
| Deadlock on async calls | `Task.Run(...).Result` can deadlock with `SynchronizationContext` | Use `Task.Run(() => asyncMethod()).Result` -- works in most GAB contexts but can deadlock in some UI-thread scenarios. Prefer synchronous HTTP when possible. |
| `app.config` settings ignored | GAB runtime doesn't load DLL config files | Pass configuration via GAB parameters or DB tables |
| Duplicate `ProjectGuid` causes build issues | Copied `.csproj` from another solution | Generate a fresh GUID: `[guid]::NewGuid()` in PowerShell |

---

## Skeleton Templates

### Class Library `.csproj`

```xml
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="15.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <Import Project="$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props"
          Condition="Exists('$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props')" />
  <PropertyGroup>
    <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
    <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
    <ProjectGuid>{INSERT-FRESH-GUID-HERE}</ProjectGuid>
    <OutputType>Library</OutputType>
    <RootNamespace>MyNamespace</RootNamespace>
    <AssemblyName>MyLibrary</AssemblyName>
    <TargetFrameworkVersion>v4.6.2</TargetFrameworkVersion>
    <FileAlignment>512</FileAlignment>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
    <DebugSymbols>true</DebugSymbols>
    <DebugType>full</DebugType>
    <Optimize>false</Optimize>
    <OutputPath>bin\Debug\</OutputPath>
    <DefineConstants>DEBUG;TRACE</DefineConstants>
    <ErrorReport>prompt</ErrorReport>
    <WarningLevel>4</WarningLevel>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
    <DebugType>pdbonly</DebugType>
    <Optimize>true</Optimize>
    <OutputPath>bin\Release\</OutputPath>
    <DefineConstants>TRACE</DefineConstants>
    <ErrorReport>prompt</ErrorReport>
    <WarningLevel>4</WarningLevel>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="System" />
    <Reference Include="System.Core" />
    <Reference Include="System.Net.Http" />
    <!-- Add NuGet references with HintPath here -->
  </ItemGroup>
  <ItemGroup>
    <Compile Include="MyClient.cs" />
    <Compile Include="Properties\AssemblyInfo.cs" />
  </ItemGroup>
  <ItemGroup>
    <None Include="packages.config" />
  </ItemGroup>
  <Import Project="$(MSBuildToolsPath)\Microsoft.CSharp.targets" />
</Project>
```

### Facade Class `.cs`

```csharp
using System;
using System.Text;

namespace MyNamespace
{
    public class MyClient
    {
        public string Ping(string args)
        {
            return "SUCCESS: PONG";
        }

        public string DoWork(string inputString)
        {
            try
            {
                var parsed = ParseInput(inputString);
                if (parsed == null)
                    return "ERROR: Input must be field1|field2|field3";

                // Business logic here...

                return "SUCCESS: Done";
            }
            catch (Exception ex)
            {
                return $"ERROR: {ex.Message}";
            }
        }

        private ParsedInput ParseInput(string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                return null;

            string[] parts = input.Split('|');
            if (parts.Length < 3)
                return null;

            return new ParsedInput
            {
                Field1 = parts[0].Trim(),
                Field2 = parts[1].Trim(),
                Field3 = parts[2].Trim()
            };
        }

        private class ParsedInput
        {
            public string Field1 { get; set; }
            public string Field2 { get; set; }
            public string Field3 { get; set; }
        }
    }
}
```

### Test Harness `.csproj`

```xml
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="15.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <Import Project="$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props"
          Condition="Exists('$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props')" />
  <PropertyGroup>
    <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
    <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
    <ProjectGuid>{INSERT-DIFFERENT-FRESH-GUID-HERE}</ProjectGuid>
    <OutputType>Exe</OutputType>
    <RootNamespace>MyNamespace.Test</RootNamespace>
    <AssemblyName>MyLibrary.Test</AssemblyName>
    <TargetFrameworkVersion>v4.6.2</TargetFrameworkVersion>
    <FileAlignment>512</FileAlignment>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
    <DebugSymbols>true</DebugSymbols>
    <DebugType>full</DebugType>
    <Optimize>false</Optimize>
    <OutputPath>bin\Debug\</OutputPath>
    <DefineConstants>DEBUG;TRACE</DefineConstants>
    <ErrorReport>prompt</ErrorReport>
    <WarningLevel>4</WarningLevel>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
    <DebugType>pdbonly</DebugType>
    <Optimize>true</Optimize>
    <OutputPath>bin\Release\</OutputPath>
    <DefineConstants>TRACE</DefineConstants>
    <ErrorReport>prompt</ErrorReport>
    <WarningLevel>4</WarningLevel>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="System" />
    <Reference Include="System.Core" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="Program.cs" />
    <Compile Include="Properties\AssemblyInfo.cs" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\MyLibrary\MyLibrary.csproj">
      <Project>{MATCH-LIBRARY-PROJECT-GUID}</Project>
      <Name>MyLibrary</Name>
    </ProjectReference>
  </ItemGroup>
  <Import Project="$(MSBuildToolsPath)\Microsoft.CSharp.targets" />
</Project>
```

---

## Version Compatibility Matrix

| Component | Required Version | Notes |
|-----------|-----------------|-------|
| .NET Framework | **4.6.2** | GAB runtime CLR compatibility -- do NOT use .NET Core/5+/Standard |
| Newtonsoft.Json | 13.0.x (`net45` TFM) | Most common NuGet dependency; `net45` target is compatible with 4.6.2 |
| MSBuild | 16.11.6 (VS 2019 Build Tools) | See user Cursor rules for path detection order |
| Visual Studio | 2019 or later | Solution format v12 / ToolsVersion 15.0 |
| C# language | 7.3 (default for .NET 4.6.2) | Do not use C# 8+ features (nullable reference types, ranges, etc.) unless you override `<LangVersion>` |
