# GAB GlobalShop Integration Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with GSS integration, security, entity objects, workflow, shipping, mobile, or registry
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass

> **Version notes:** Some APIs in this file require specific GlobalShop/OCTSRS versions (noted inline, e.g., "Available in OCTSRS 2019.1+"). Check the project's GlobalShop version in `AGENTS.PROJECT.md` > Environment > GlobalShop Version before using version-gated features.
---

**Table of contents**

- **[GENERAL FUNCTIONS (F.Global.General.*)](#general-functions-fglobalgeneral)** -- Options, company, locks, menu, licensing, help, Service Web
  - [System Options](#system-options)
  - [Company Information](#company-information)
  - [Soft Locks](#soft-locks)
  - [Menu & Process](#menu--process)
  - [Licensing](#licensing)
  - [Help](#help)
  - [Service Web](#service-web)
- **[SECURITY (F.Global.Security.*)](#security-fglobalsecurity)** -- Users, groups, permissions
  - [User Access](#user-access)
  - [User Identity](#user-identity)
  - [Groups](#groups)
  - [Misc Security](#misc-security)
- **[ENTITY OBJECTS (F.Global.Object.*)](#entity-objects-fglobalobject)** -- CRUD, load/query, serialization, `V.Object`
  - [Conceptual Overview](#conceptual-overview)
  - [Object Browser](#object-browser)
  - [Create (Lifecycle)](#create-lifecycle)
  - [Load & Query](#load--query)
  - [Read & Write](#read--write)
  - [CRUD](#crud)
  - [Serialization](#serialization)
  - [V.Object Namespace (Variable.Object)](#vobject-namespace-variableobject)
  - [Complete Example -- Entity Object CRUD Operations](#complete-example----entity-object-crud-operations)
  - [Complete Example -- Load Quotes by Date Range](#complete-example----load-quotes-by-date-range)
- **[MOBILE (F.Global.Mobile.*)](#mobile-fglobalmobile)** -- Custom headers, lines, printers, results
- **[REGISTRY (F.Global.Registry.*)](#registry-fglobalregistry)** -- Read/write user preferences and grid layouts
  - [ReadValue](#readvalue----read-a-stored-value-from-the-registry)
  - [AddValue](#addvalue----store-a-value-in-the-registry)
  - [Complete Example -- Grid Layout Persistence](#complete-example----grid-layout-persistence)
- **[TRANSLATION (F.Global.International.*)](#translation-fglobalinternational)** -- Labels and languages
- **[WORKFLOW (F.Global.Workflow.*)](#workflow-fglobalworkflow)** -- Lifecycle, lines, dependencies, documents, metadata
  - [Workflow Lifecycle](#workflow-lifecycle)
  - [Lines (Steps)](#lines-steps)
  - [Dependencies](#dependencies)
  - [Documents & Notes](#documents--notes)
  - [Metadata](#metadata)
- **[SHIPPING (F.Global.ShipIntegration.*)](#shipping-fglobalshipintegration)** -- Carrier session, rates, ship, track, accounts
  - [Session Management](#session-management)
  - [Address & Packages](#address--packages)
  - [Rates & Shipping](#rates--shipping)
  - [Tracking & Voiding](#tracking--voiding)
  - [Validation](#validation)
  - [Account Management](#account-management)
- **[SCANNER / CAPTURE (F.Automation.Capture.*)](#scanner--capture-fautomationcapture)** -- TWAIN acquire, transform, save
  - [Scanner Management](#scanner-management)
  - [Image Acquisition](#image-acquisition)
  - [Image Manipulation](#image-manipulation)
  - [Save & Barcode](#save--barcode)
- **[MAPPER (F.Global.Mapper.*)](#mapper-fglobalmapper)** -- `CallMapper`
- **[GSSUI (F.Global.GSSUI.*)](#gssui-fglobalgssui)** -- Launch programs and payloads
- **[ENCRYPTION (F.Global.Encryption.*)](#encryption-fglobalencryption)** -- Encrypt/decrypt strings
- **[ANTI-PATTERNS](#anti-patterns)** -- Integration dos and don'ts

---

# GENERAL FUNCTIONS (F.Global.General.*)

## System Options
```
F.Global.General.ReadOption(iOptionID,sResult)
F.Global.General.SaveOption(iOptionID,sValue)
F.Global.General.ReadOptionCommon(iOptionID,sResult)
F.Global.General.SaveOptionCommon(iOptionID,sValue)
```

## Company Information
```
F.Global.General.ReadCompanyName(sResult)
F.Global.General.GetCompanyCodes(sResult)
F.Global.General.OverrideCompany(sCompanyCode)
F.Global.General.IsInUpdate(bResult)
```

## Soft Locks
Cooperative record-level locking. All scripts must check before modifying.
```
F.Global.General.CreateSoftLock(sLockID,sResult)
F.Global.General.ReadSoftLock(sLockID,sResult)
F.Global.General.DestroySoftLock(sLockID)
```

> **See also:** `agents/gab/CW_SUPPORT.md` documents `Support.CreateSoftLock` and `Support.ReleaseSoftLock` CallWrappers, which are a separate mechanism for soft locks via the CallWrapper API (program `SYS060`). The two approaches are not interchangeable.

## Menu & Process
```
F.Global.General.RegisterProcess(sProcessInfo)
F.Global.General.UpdateProcess(sProcessInfo)
F.Global.General.LaunchMenuTask(sMenuPath)
F.Global.General.GetMenuPathFromProg(sProgramName,sResult)
```

## Licensing
```
F.Global.General.IsLicensed(iFeatureID,bResult)
F.Global.General.IsLicensedByModuleName(sModuleName,bResult)
```

## Help
```
F.Global.General.LaunchHelpPage(sHelpID)
F.Global.General.LaunchGSSHelpPage(sHelpID)
```

## Service Web
```
F.Global.General.GetServiceWebToken(sResult)
```

---

# SECURITY (F.Global.Security.*)

## User Access
```
F.Global.Security.CheckUserAccess(sUserID,iFunctionID,bResult)
F.Global.Security.CheckUserAccessIPM(sUserID,iFunctionID,bResult)
F.Global.Security.CheckUserFunctionPermission(sUserID,iFunctionID,iPermissionID,bResult)
F.Global.Security.CheckUserFunctionFeatureToggle(sUserID,iFeatureID,bResult)
F.Global.Security.ValidateUser(sUsername,sPassword,bResult)
```

## User Identity
```
F.Global.Security.GetUserId(sUsername,sResult)
F.Global.Security.GetUserEmail(sUserID,sResult)
F.Global.Security.GetUserFromEmail(sEmail,sResult)
F.Global.Security.GetFullName(sUserID,sResult)
F.Global.Security.GetUserNameFromId(sUserID,sResult)
F.Global.Security.GetEmpNoFromUser(sUserID,sResult)
F.Global.Security.GetUserFromEmpNo(sEmpNo,sResult)
```

## Groups
```
F.Global.Security.GetAllUsers(sResult)
F.Global.Security.GetAllUserGroups(sResult)
F.Global.Security.GetUserGroups(sUserID,sResult)
F.Global.Security.IsInGroup(sUserID,iGroupID,bResult)
F.Global.Security.GetGroupMembers(iGroupID,sResult)
F.Global.Security.GetGroupEmails(iGroupID,sResult)
F.Global.Security.GetGroupId(sGroupName,sResult)
F.Global.Security.GetGroupNameFromGroupId(iGroupID,sResult)
```

## Misc Security
```
F.Global.Security.GetDSNCredentials(sDSNName,sResult)
F.Global.Security.GetLoggedInTerminalCount(iResult)
F.Global.Security.GetLoggedInTerminalNumbers(sResult)
F.Global.Security.GetUserPermissionDetail(sUserID,iFunctionID,sResult)
F.Global.Security.GetPayGroupsFromUserId(sUserID,sResult)
```

---

# ENTITY OBJECTS (F.Global.Object.*)

Entity objects provide CRUD operations on GSS business entities.
Available in GSS October 2017.1+.

## Conceptual Overview

Entity objects are a **data layer** that allows GAB programs to interact with the database through typed objects rather than raw SQL. Each object is tied to one or more database tables. Properties on the objects have meaningful names and corrected datatypes. When updating an object that spans multiple tables, all tables are updated with a single call.

### Object Types

| Type | Description | Can Update DB? |
|------|-------------|----------------|
| **Entity Object** | Standard CRUD object (single-instance or collection) | Yes |
| **Lookup Object** | View-only, uses a cache file for fast loading. Has an assigned hook number for GAB override. Loaded via `LoadLookUp`. | No |
| **View Object** | View-only with many properties (typically used in grid views). Similar to Lookup but without a GAB override hook. | No |

**Lookup object caching:** Cache files are created on first load of the day or via the Task Manager Cache File Engine. This ensures fast loading throughout the day. Lookup objects have an assigned hook number that allows GAB scripts to override the lookup behavior wherever that object is used.

### Mode System

Modes determine **which properties are populated** and **which criteria filter the data** when loading an object. Each mode has:
- **Start criteria** -- properties used to filter records (e.g., PartNumber >= value)
- **End criteria** -- *(optional)* upper-bound properties (e.g., PartNumber <= value)
- **Filter criteria** -- *(optional)* post-query filters applied after start/end criteria. **Filters have a performance cost** because they are applied after the initial query returns, removing non-matching rows
- **Top value** -- limits the number of records returned. A value of **0 returns all records**; a non-zero value (e.g., 1000) caps the result set

Mode numbers and their criteria signatures are entity-type-specific. Use the **Object Browser** tool to discover available modes, their properties, and criteria. The order parameters must be passed is specified by the mode definition.

**Performance guidance:** When choosing a mode, prefer one that populates only the properties you need. A mode with significantly more properties than required will incur unnecessary overhead. Be mindful of the Top value -- loading unbounded collections can be expensive.

### Single-Instance vs Collection Objects
GsseoType names follow a **pluralization convention**:
- **Singular** type name (e.g., `Inventory.Part`) = single-instance object
- **Plural** type name (e.g., `Inventory.Parts`) = collection object (holds multiple records)

Collection objects support indexed access via `GetValue` with an `Index` parameter, `GetCount`, `GetMaxValue`, `GetMinValue`, and `ImportFromXMLCollection`. Single-instance objects do not require an index.

**Loading differences:**
- **Collection**: Pass start/end/filter criteria as arguments to `Load` (e.g., `F.Global.Object.Load("oPart",1446,"~~~~~","~~~~~","~~",V.Local.iRet)`)
- **Single-instance**: Set key properties via `SetValue` before calling `Load` with a key-preload mode (e.g., mode 800). See [Load](#load----load-entity-data-by-mode-with-mode-specific-criteria) for details.

**SetValue differences:**
- **Single-instance**: 3-param form -- `SetValue(ObjectName, PropertyName, Value)`. The 4-param form with index `0` also works for single-instance entities (the index is ignored).
- **Collection**: 4-param form with index -- `SetValue(ObjectName, PropertyName, Value, CollectionIndex)`

## Object Browser

The **Object Browser** is a GSS IDE tool for discovering entity object properties, table mappings, and available modes. Access it from within the GAB IDE.

**Key features:**
- **View mode toggle** (upper right): Show/hide table columns, EO properties, or both. "All information" shows how properties map to database table columns.
- **Object/table search** (upper left): Enter an object name or search by table name to locate the entity.
- **Property/column treeviews** (right side): Check properties or columns to filter the mode grid. As you check items, the mode list narrows to only modes that populate those properties.
- **Mode grid** (center): Shows all active modes for the selected object, including criteria type, top value, filter, and which properties are populated.

**Evaluating modes:**
- **Start/end criteria** define the range query (e.g., parts with PartNumber between two values)
- **Filter criteria** are applied post-query and remove non-matching rows from the result -- incurs a performance hit
- **Top column** shows how many records the mode returns (0 = all records)
- Prefer modes that populate only the properties you need; excess properties add overhead

**Requesting a new mode:** If no existing mode meets your needs, right-click the mode grid:
- **Copy** -- duplicate an existing mode and modify the key criteria, top value, or filters
- **Create** -- build a new mode from scratch (select required properties first)
- **Preview** -- use File > Mode Results to test the mode with sample criteria values before submitting
- **Submit** -- use File > Submit to request the mode for implementation

## Create (Lifecycle)

### CreateDB -- establish a named database connection for entity operations
Four overloads. If company and server name are not passed, the current company and server are assumed. If scope is not passed, Global scope is assumed. Returns the connection index of the connection added to the DB object.
```
F.Global.Object.CreateDB(DBObjectName, ConnectionIndex)
F.Global.Object.CreateDB(DBObjectName, Company, ConnectionIndexReturn)
F.Global.Object.CreateDB(DBObjectName, Company, ServerName, ConnectionIndexReturn)
F.Global.Object.CreateDB(DBObjectName, Company, ServerName, GlobalScopeFlag, ConnectionIndexReturn)
```

| Argument | Type | Description |
|----------|------|-------------|
| DBObjectName | String | Logical name for this DB connection (e.g., `"GlobalDB"`) |
| Company | String | Company code (typically `V.Caller.CompanyCode`). Omit to use current company. |
| ServerName | String | Database server name (typically `V.Ambient.DBServerName`). Omit to use current server. |
| GlobalScopeFlag | Boolean | If True, connection is accessible across subroutines. Defaults to True when omitted. |
| ConnectionIndex / ConnectionIndexReturn | Long | Receives the connection handle |

### Create -- instantiate an entity object
Three overloads:
```
F.Global.Object.Create(ObjectName, GsseoType, DbObject, ConnectionIndex)
F.Global.Object.Create(ObjectName, GsseoType, DbObject, ConnectionIndex, GlobalScope)
F.Global.Object.Create(ObjectName, GsseoType, DbObject, ConnectionIndex, GlobalScope, ParentObject)
```

| Argument | Type | Description |
|----------|------|-------------|
| ObjectName | String | Instance name for this entity (e.g., `"oQH"`) |
| GsseoType | String | Entity type in `Module.SubModule.EntityName` format (see Known Types below) |
| DbObject | String | Name of a previously created DB object (from `CreateDB`) |
| ConnectionIndex | Long | Connection handle (same as used in `CreateDB`) |
| GlobalScope | Boolean | *(Optional)* If True, object is accessible across subroutines |
| ParentObject | String | *(Optional)* Instance name of a parent entity for child relationships |

### Known GsseoType Values
GsseoType follows the pattern `Module.SubModule.EntityName`. Singular names are single-instance; plural names are collections.

| GsseoType | Kind | Description |
|-----------|------|-------------|
| `Inventory.Part` | Single-instance | Single part record |
| `Inventory.Parts` | Collection | Part collection |
| `Inventory.Items` | Child entity | Inventory items (child of Part) |
| `Inventory.LookUp.Parts` | Lookup | Part lookup (view-only, cached) |
| `Manufacturing.WorkOrderDetail` | Entity | Work order detail |
| `Manufacturing.Bom.Views.BomExplosions` | View | BOM explosion view |
| `Purchasing.PurchaseOrderLineTransactions` | Entity | PO line transactions |
| `Sales.Quoting.Quote` | Single-instance | Single quote |
| `Sales.Quoting.Quotes` | Collection | Quote collection |
| `Support.ProductLines` | Entity | Product lines |

*(More types to be documented as discovered -- e.g., Accounting.*, Quality.*, Shipping.*, etc.)*

### OverridePath -- override entity object definition path
```
F.Global.Object.OverridePath(FullyQualifiedPath)
```
- `FullyQualifiedPath` (String) -- path to an alternate entity object definition directory

### Dispose
```
F.Global.Object.Dispose(Name)
```
- `Name` (String) -- object instance name to dispose

### CloseConnection
```
F.Global.Object.CloseConnection(ObjectName, ConnectionIndex)
```
- `ObjectName` (String) -- DB object name (e.g., `"DbObject"`)
- `ConnectionIndex` (Long) -- connection index to close

### OpenConnection (OBSOLETE -- use CreateDB instead)
Three overloads, all obsolete:
```
F.Global.Object.OpenConnection(DBObjectName, Return)
F.Global.Object.OpenConnection(DBObjectName, CompanyCode, Return)
F.Global.Object.OpenConnection(DBObjectName, CompanyCode, Server, Return)
```
- `DBObjectName` (String) -- logical DB name
- `CompanyCode` (String) -- company code
- `Server` (String) -- server name
- `Return` (Long) -- connection index

## Load & Query

### Load -- load entity data by mode with mode-specific criteria
Two overloads -- one with explicit DB context, one that uses the connection from `Create`:
```
F.Global.Object.Load(DataObjectName, DBObjectName, DBConnectionIndex, ModeNumber, Arg#..., StatusCodeReturn)
F.Global.Object.Load(DataObjectName, ModeNumber, Arg#..., StatusCodeReturn)
```

| Argument | Type | Description |
|----------|------|-------------|
| DataObjectName | String | Instance name from `Create` |
| DBObjectName | String | *(long form only)* DB object name from `CreateDB` |
| DBConnectionIndex | Long | *(long form only)* Connection handle from `CreateDB` |
| ModeNumber | Long | Load mode -- determines what criteria arguments follow |
| Arg#... | Any | Variable number of mode-specific criteria (0 or more) |
| StatusCodeReturn | Long | Receives status: **0 = success**, non-zero = failure |

**Mode criteria are mode-specific.** Example with mode 40 (key range + date range):
```
F.Global.Object.Load("oQH",40,"0000000","9999999",V.Local.startDate,V.Local.endDate,V.Local.iRet)
```
Here mode 40 takes: low key, high key, start date, end date, then return status.

**Key-preload pattern:** Some modes (e.g., mode 800) expect key fields to be pre-populated on the entity via `SetValue` *before* calling `Load`, rather than passed as positional `Arg#` arguments. In this pattern, `Load` reads the key values directly from the object's properties:
```
F.Global.Object.Create("oPart","Inventory.Part","GlobalDB",V.Global.iCon)

F.Global.Object.SetValue("oPart","PartNumber","0025")
F.Global.Object.SetValue("oPart","PartNumberRevision","")
F.Global.Object.SetValue("oPart","LocationCode","")
F.Global.Object.Load("oPart",800,V.Local.iRet)
```
Here mode 800 takes no inline criteria -- the key fields (`PartNumber`, `PartNumberRevision`, `LocationCode`) are set on the entity first, then `Load` uses them to locate the record.

*(Mode numbers and their criteria signatures are entity-type-specific. Consult GSS documentation for the full mode reference per GsseoType.)*

### GetCount -- get number of records in a loaded object/collection
Two overloads (same signature, different semantics):
```
F.Global.Object.GetCount(ObjectCollectionName, Return)
F.Global.Object.GetCount(ObjectName, Return)
```
- `ObjectCollectionName` / `ObjectName` (String) -- instance name of an object or object collection
- `Return` (Long) -- receives the count

### LoadDatatableFromObject -- convert an entity object into a DataTable
```
F.Global.Object.LoadDatatableFromObject(ObjectName, DatatableName, [GlobalScope])
```
- `ObjectName` (String) -- entity object instance name
- `DatatableName` (String) -- name for the resulting DataTable
- `GlobalScope` (Boolean) -- *(optional)* if True, DataTable is accessible across subroutines

### LoadNewFromCurrent -- create and load a new object using criteria from a current object
Available in OCTSRS 2019.1+
```
F.Global.Object.LoadNewFromCurrent(CurrentObjectName, NewObjectName, NewObjectEOType, NewObjectModeNumber, ModeParameters, FilterCriteriaN...)
```
- `CurrentObjectName` (String) -- instance name of the source (already-loaded) object
- `NewObjectName` (String) -- instance name for the new object to create
- `NewObjectEOType` (String) -- GsseoType for the new object (e.g., `"Manufacturing.WorkOrderDetail"`)
- `NewObjectModeNumber` (Long) -- load mode number for the new object
- `ModeParameters` (String) -- `*!*` delimited mode parameters of the **current** object
- `FilterCriteriaN` (Any) -- *(0 or more)* additional filter criteria for the new object's load

### RefreshLookUp -- refresh a lookup object's cached data
Available in 2020.1+
```
F.Global.Object.RefreshLookUp(ObjectName)
```
- `ObjectName` (String) -- lookup object instance name

### LoadDistinct -- load distinct records by mode with a distinct key
Available in 2020.1+
```
F.Global.Object.LoadDistinct(ObjectName, ModeNumber, DistinctKey, ArgsN..., StatusCodeReturn)
```
- `ObjectName` (String) -- entity object instance name
- `ModeNumber` (Long) -- load mode number
- `DistinctKey` (String) -- `*!*` delimited distinct key (property names to distinct on)
- `ArgsN` (Any) -- *(0 or more)* mode-specific criteria
- `StatusCodeReturn` (Long) -- receives status: **0 = success**, non-zero = failure

### LoadDataTable -- one-step load from entity object directly into a DataTable
Combines CreateDB + Create + Load into a single DataTable-producing call.
```
F.Global.Object.LoadDataTable(DataTableName, ObjectName, GsseoType, ConnectionName, ConnectionIndex, ModeNumber, GlobalScope, ParentObjectName, ChunkSize, ArgN...)
```

| Argument | Type | Description |
|----------|------|-------------|
| DataTableName | String | Name for the resulting DataTable |
| ObjectName | String | Instance name for the underlying entity object |
| GsseoType | String | Entity type (e.g., `"Inventory.Parts"`) |
| ConnectionName | String | DB object name from `CreateDB` |
| ConnectionIndex | Long | Connection handle from `CreateDB` |
| ModeNumber | Long | Load mode number |
| GlobalScope | Boolean | If True, DataTable is accessible across subroutines |
| ParentObjectName | String | Parent object instance name (pass empty if none) |
| ChunkSize | Long | Max records to load. Pass **-1** to load all records. |
| ArgN... | Any | Mode-specific criteria (start, end, filter values) |

Example -- load first 10,000 parts into a DataTable:
```
V.Local.iCon.Declare

F.Global.Object.CreateDB("GlobalDB",V.Caller.CompanyCode,V.Ambient.DBServerName,True,V.Local.iCon)

F.Global.Object.LoadDataTable("dtPart","oPart","Inventory.Parts","GlobalDB",V.Local.iCon,1444,True,,10000,"","z","z","","z","")
```

**Memory note:** `LoadDataTable` creates both an entity object (`ObjectName`) and a DataTable (`DataTableName`), storing the data in memory twice. If only the DataTable is needed, call `F.Global.Object.Dispose(ObjectName)` afterward to free the entity object.

### LoadLookUp -- load a lookup object for cached reference data
Available in OCTSRS 2019.1+
```
F.Global.Object.LoadLookUp(ObjectName, ObjectType)
F.Global.Object.LoadLookUp(ObjectName, ObjectType, Global)
```
- `ObjectName` (String) -- instance name for the lookup object
- `ObjectType` (String) -- GsseoType of the lookup entity (e.g., `"Inventory.LookUp.Parts"`)
- `Global` (Boolean) -- *(optional)* if True, lookup is accessible across subroutines

Once loaded, the lookup object's metadata is available via `V.Object` accessors (`!GetCacheFileName`, `!GetHookNumber`, `!GetKeyList`, etc. -- see [V.Object Namespace](#v-object-namespace-variableobject)). Use `RefreshLookUp` to refresh cached data.

### LoadDictionary -- create a dictionary from an entity object's property data
Available in OCTSRS 2019.1+
```
F.Global.Object.LoadDictionary(DictionaryName, ObjectName, KeyProperty, ValueProperty)
```
- `DictionaryName` (String) -- name for the resulting dictionary
- `ObjectName` (String) -- entity object instance name (must be already loaded)
- `KeyProperty` (String) -- property name to use as dictionary keys
- `ValueProperty` (String) -- property name to use as dictionary values

### LoadChildObject -- load a child entity from a parent object
Two overloads:
```
F.Global.Object.LoadChildObject(ObjectName, ChildName)
F.Global.Object.LoadChildObject(ObjectName, ChildEOType, ModeNumber, ModeParameters)
```
- `ObjectName` (String) -- parent entity object instance name
- `ChildName` (String) -- child entity name (simple overload, inferred from parent)
- `ChildEOType` (String) -- full GsseoType of the child entity (e.g., `"Inventory.Items"`)
- `ModeNumber` (Long) -- load mode number for the child entity
- `ModeParameters` (String) -- `*!*`-delimited key fields that link parent to child

```
F.Global.Object.LoadChildObject("oPart","Inventory.Items",294,"PartNumber*!*PartNumberRevision*!*LocationCode")
```

## Read & Write

### GetValue -- read a property from an entity object
Two overloads:
```
F.Global.Object.GetValue(ObjectName, PropertyName, Return)
F.Global.Object.GetValue(ObjectName, PropertyName, Index, Return)
```
- `ObjectName` (String) -- object instance name
- `PropertyName` (String) -- entity property name
- `Index` (Long) -- *(collection objects only)* zero-based record index within the collection
- `Return` (Any) -- variable to receive the value

Use the 3-param form for single-instance objects. Use the 4-param form with `Index` for collection objects to access a specific record.

### SetValue -- write a property on an entity object
Two overloads (mirrors GetValue):
```
F.Global.Object.SetValue(ObjectName, PropertyName, PropertyValue)
F.Global.Object.SetValue(ObjectName, PropertyName, PropertyValue, CollectionIndex)
```
- `ObjectName` (String) -- object instance name
- `PropertyName` (String) -- entity property name (supports **dotted paths** for nested/related properties)
- `PropertyValue` (Any) -- value to set
- `CollectionIndex` (Long) -- *(collection objects only)* zero-based record index

Use the 3-param form for single-instance objects. Use the 4-param form with `CollectionIndex` for collection objects.

**Dotted property paths:** `PropertyName` can navigate into related entity properties using dot notation. For example, `"Information.ProductLine.ProductLineCode"` navigates from the root entity into its `Information` sub-object, then into `ProductLine`, then sets `ProductLineCode`. Dotted paths work for both Insert and Update operations -- e.g., `"Description.Primary"` navigates into the `Description` sub-object to set the `Primary` property on a loaded record before calling `Update`.

### GetMethod -- obtain a typed method handle from an entity object
```
F.Global.Object.GetMethod(ObjectName, MethodName, [TypeDescriptorN...], ReturnMethodInstanceName)
```
- `ObjectName` (String) -- entity object instance name
- `MethodName` (String) -- the actual method name on the entity (e.g., `"LoadBomExplosions"`)
- `TypeDescriptorN` (String) -- *(0 or more)* type descriptor strings for each method argument, in order. Valid descriptors: `"string"`, `"integer"`, `"double"`, `"boolean"`, `"date"`, etc.
- `ReturnMethodInstanceName` (String) -- receives a handle name used by `InvokeMethod`

GetMethod does **not** call the method. It creates a typed method handle (instance name) that binds the method signature. The type descriptors define the expected argument types.

### InvokeMethod -- execute a method handle with actual values
```
F.Global.Object.InvokeMethod(ObjectName, MethodInstanceName, [ArgN...], [Return])
```
- `ObjectName` (String) -- entity object instance name (same as in `GetMethod`)
- `MethodInstanceName` (String) -- the handle returned by `GetMethod`
- `ArgN` (Any) -- *(0 or more)* actual argument values, matching the type descriptors from `GetMethod`
- `Return` (Any) -- *(optional)* variable to receive the method's return value

### GetMethod + InvokeMethod Pattern
The two-step pattern is: (1) `GetMethod` to bind the method signature with type descriptors, (2) `InvokeMethod` to execute it with actual values.

**Example 1 -- Payroll integration on a Work Order:**
```
V.Local.sStatus.Declare(String)
V.Global.iCon.Declare(Long)
V.Local.sJob.Declare(String,"500040")
V.Local.sSuf.Declare(String,"001")
V.Local.sSeq.Declare(Long,996000)
V.Local.sEmp.Declare(Long,87558)
V.Local.fBurd.Declare(Float,1.25)
V.Local.fFrin.Declare(Float,5.26)

F.Global.Object.CreateDB("GlobalDB",V.Caller.CompanyCode,V.Ambient.DBServerName,True,V.Global.iCon)
F.Global.Object.Create("testCost2Job","Manufacturing.WorkOrderDetail","GlobalDB",V.Global.iCon,True)

'bind method with 6 type descriptors: string, string, integer, integer, double, double
F.Global.Object.GetMethod("testCost2Job","HenryGroupPayrollProcessingWorkOrderDetailIntegration",~"string","string","integer","integer","double","double","testmeth")
'invoke with actual values + return
F.Global.Object.InvokeMethod("testCost2Job","testmeth",V.Local.sJob,V.Local.sSuf,V.Local.sSeq,V.Local.sEmp,V.Local.fBurd,V.Local.fFrin,V.Local.sStatus)
```

**Example 2 -- BOM Explosion loaded into a DataTable:**
```
V.Local.iCon.Declare
F.Global.Object.CreateDB("GlobalDB",V.Local.iCon)
F.Global.Object.Create("bomExplosionCollection","Manufacturing.Bom.Views.BomExplosions","GlobalDB",V.Local.iCon,True)

'bind method: 3 args (String, String, integer)
F.Global.Object.GetMethod("bomExplosionCollection","LoadBomExplosions","String","String","integer","methodInstance")
'invoke with actual values (no return -- method populates the collection in-place)
F.Global.Object.InvokeMethod("bomExplosionCollection","methodInstance","210900-7","",3)
'convert collection to DataTable for grid/reporting use
F.Global.Object.LoadDatatableFromObject("bomExplosionCollection","bomExplosionDT",True)
```

### CallMethod (OBSOLETE)
Two overloads, both obsolete:
```
F.Global.Object.CallMethod(ObjectName, DBObjectName, ConnectionIndex, MethodName, Mode, Return)
F.Global.Object.CallMethod(ObjectName, DBObjectName, ConnectionIndex, MethodName, Mode, Parameter0, Return)
```
- `ObjectName` (String) -- entity instance name
- `DBObjectName` (String) -- DB object name from `CreateDB`
- `ConnectionIndex` (Long) -- connection handle
- `MethodName` (String) -- method to invoke
- `Mode` (Long) -- method mode
- `Parameter0` (Any) -- *(optional)* parameter to pass to the method
- `Return` (Any) -- receives the result

Use `InvokeMethod` / `GetMethod` instead.

### GetMaxValue -- return maximum value of a property across loaded records
Available in OCTSRS 2019.1+
```
F.Global.Object.GetMaxValue(Name, PropertyName, Return)
```
- `Name` (String) -- object instance name
- `PropertyName` (String) -- entity property to evaluate
- `Return` (Any) -- variable to receive the max value

### GetMinValue -- return minimum value of a property across loaded records
Available in OCTSRS 2019.1+
```
F.Global.Object.GetMinValue(ObjectName, PropertyName, ReturnVariable)
```
- `ObjectName` (String) -- object instance name
- `PropertyName` (String) -- entity property to evaluate
- `ReturnVariable` (Any) -- variable to receive the min value

## CRUD

### Insert -- insert a new record into the database
First use `SetValue` to set the key value properties, then invoke `Insert`. Status 0 = success; non-zero = failure.
```
F.Global.Object.Insert(DataObjectName, DBObjectName, DBConnectionIndex, StatusCodeReturn)
F.Global.Object.Insert(DataObjectName, StatusCodeReturn)
```
- `DataObjectName` (String) -- entity object instance name
- `DBObjectName` (String) -- *(long form only)* DB object name from `CreateDB`
- `DBConnectionIndex` (Long) -- *(long form only)* connection handle
- `StatusCodeReturn` (Long) -- receives status: **0 = success**, non-zero = failure

**Insert example -- create a new Part using a single-instance entity:**
```
F.Global.Object.Create("oPart","Inventory.Part","GlobalDB",V.Global.iCon)

F.Global.Object.SetValue("oPart","PartNumber","SarahTesting",0)
F.Global.Object.SetValue("oPart","PartNumberRevision","",0)
F.Global.Object.SetValue("oPart","LocationCode","",0)
F.Global.Object.SetValue("oPart","Information.ProductLine.ProductLineCode","FG",0)
F.Global.Object.SetValue("oPart","Information.UnitOfMeasure.UnitOfMeasureCode","EA",0)
F.Global.Object.Insert("oPart",V.Local.iRet)
```
Note: Uses the **singular** type `Inventory.Part` (single-instance), sets key fields and related properties via dotted paths, then inserts.

### Update -- update an existing record in the database
Two overloads (with and without explicit DB context):
```
F.Global.Object.Update(DataObjectName, DBObjectName, DBConnectionIndex, StatusCodeReturn)
F.Global.Object.Update(DataObjectName, StatusCodeReturn)
```
- `DataObjectName` (String) -- entity object instance name
- `DBObjectName` (String) -- *(long form only)* DB object name from `CreateDB`
- `DBConnectionIndex` (Long) -- *(long form only)* connection handle
- `StatusCodeReturn` (Long) -- receives status: **0 = success**, non-zero = failure

```
F.Global.Object.SetValue("oPart","PartNumber","SarahTest",0)
F.Global.Object.Update("oPart","GlobalDB",V.Global.iCon,V.Local.iRet)
```

**Update example -- key-preload Load then modify and Update:**
```
F.Global.Object.Create("oPart","Inventory.Part","GlobalDB",V.Global.iCon)

'pre-populate key fields, then Load by mode 800 (reads keys from the object)
F.Global.Object.SetValue("oPart","PartNumber","0025")
F.Global.Object.SetValue("oPart","PartNumberRevision","")
F.Global.Object.SetValue("oPart","LocationCode","")
F.Global.Object.Load("oPart",800,V.Local.iRet)

'modify a property using a dotted path, then commit
F.Global.Object.SetValue("oPart","Description.Primary","Test")
F.Global.Object.Update("oPart","GlobalDB",V.Global.iCon,V.Local.iRet)
```
Note: Uses the key-preload Load pattern (see [Load](#load----load-entity-data-by-mode-with-mode-specific-criteria)) and a dotted property path (`Description.Primary`) to modify a related sub-object property before updating.

### Delete -- delete a record from the database
First use `SetValue` to set the key value properties of the object, then invoke `Delete` to delete the record where the key matches. Status 0 = success; non-zero = failure.
```
F.Global.Object.Delete(DataObjectName, DBObjectName, DBConnectionIndex, Status)
F.Global.Object.Delete(DataObjectName, StatusCodeReturn)
```
- `DataObjectName` (String) -- entity object instance name
- `DBObjectName` (String) -- *(long form only)* DB object name from `CreateDB`
- `DBConnectionIndex` (Long) -- *(long form only)* connection handle
- `Status` / `StatusCodeReturn` (Long) -- receives status: **0 = success**, non-zero = failure

### Add -- add a row to a collection object with property values
Available in OCTSRS 2019.1+
```
F.Global.Object.Add(Name, PropertyNameN, PropertyValueN, ...)
```
- `Name` (String) -- collection object instance name
- `PropertyNameN` (String) -- property name (repeatable, in pairs with value)
- `PropertyValueN` (Any) -- property value for the preceding property name

Property name/value pairs are passed as consecutive arguments. You can pass multiple pairs in a single call.

### RemoveAt -- remove a row from a collection object by ordinal
Available in OCTSRS 2020.1+
```
F.Global.Object.RemoveAt(Name, Ordinal)
```
- `Name` (String) -- collection object instance name
- `Ordinal` (Long) -- row index to remove. Pass **-1** to clear the entire collection.

### SetDefaultValue -- set a default value for a property on an entity object
Available in OCTSRS 2019.1+
```
F.Global.Object.SetDefaultValue(ObjectName, PropertyName, DefaultValue)
```
- `ObjectName` (String) -- entity object instance name
- `PropertyName` (String) -- property to set the default for
- `DefaultValue` (Any) -- default value to assign

## Serialization

### ExportToXML
```
F.Global.Object.ExportToXML(DataObjectName, FilePath)
```
- `DataObjectName` (String) -- object instance name to export
- `FilePath` (String) -- target file path

### ImportFromXML (single-instance objects)
```
F.Global.Object.ImportFromXML(DataObjectName, FilePath)
```
- `DataObjectName` (String) -- object instance name
- `FilePath` (String) -- source XML file path

### ImportFromXMLCollection (collection objects)
```
F.Global.Object.ImportFromXMLCollection(DataObjectName, FilePath)
```
- `DataObjectName` (String) -- collection object instance name
- `FilePath` (String) -- source XML file path

Use `ImportFromXML` for singular entity types and `ImportFromXMLCollection` for pluralized (collection) entity types.

### ExportToMessagePackFile
Available in OCTSRS 2019.1+
```
F.Global.Object.ExportToMessagePackFile(FilePath, DatatableName)
```
- `FilePath` (String) -- fully qualified output file path
- `DatatableName` (String) -- name of the DataTable to serialize

**Note:** MessagePack serialization operates on **DataTables**, not entity objects directly.

Example:
```
F.ODBC.Connection!con.OpenCompanyConnection
F.Data.DataTable.CreateFromSQL("dtParts","con","Select top 10 PART,LOCATION,PRODUCT_LINE as PL, DESCRIPTION from V_INVENTORY_MSTR order by PART",True)
F.ODBC.Connection!con.Close

F.Global.Object.ExportToMessagePackFile("C:\Global\TEMP\MsgPck.txt","dtParts")
```

### ImportFromMessagePackFile
Available in OCTSRS 2019.1+
```
F.Global.Object.ImportFromMessagePackFile(FilePath, DatatableName)
```
- `FilePath` (String) -- fully qualified path to the MessagePack file
- `DatatableName` (String) -- name of the DataTable to populate

Example:
```
F.Global.Object.ImportFromMessagePackFile("C:\Global\TEMP\MsgPck.txt","dtParts2")
```

## V.Object Namespace (Variable.Object)

The `V.Object` (or `Variable.Object`) namespace provides read-only access to entity object properties and metadata.

### Standard Accessors

| Accessor | Returns | Description |
|----------|---------|-------------|
| `V.Object.<Name>!IsNothing` | Boolean | True if the object has not been loaded or is disposed |
| `V.Object.<Name>!GetColumns` | String | Comma-delimited list of property/column names on the entity |
| `V.Object.<Name>!GetCount` | Long | Number of records in the collection |
| `V.Object.<Name>(Index).<Property>!FieldVal` | String | Value of a property on a specific row by index |

```
V.Object.oPart!IsNothing
V.Object.oPart!GetColumns
V.Object.oPart!GetCount
V.Object.oParts(0).PartNumber!FieldVal
```

### Lookup Object Accessors

Lookup objects loaded via `F.Global.Object.LoadLookUp` expose additional metadata accessors:

| Accessor | Returns | Description |
|----------|---------|-------------|
| `V.Object.<Name>!GetCacheFileName` | String | File name used for the lookup's local cache |
| `V.Object.<Name>!GetHookNumber` | Long | Hook number associated with the lookup entity |
| `V.Object.<Name>!GetDefaultPropertyIsVisibleList` | String | Delimited list of default visible property flags |
| `V.Object.<Name>!GetKeyList` | String | Delimited list of key property names for the lookup |
| `V.Object.<Name>!GetPropertyList` | String | Delimited list of all property names on the lookup |

```
F.Global.Object.LoadLookUp("PartLookup","Inventory.LookUp.Parts")

V.Object.PartLookup!GetCacheFileName
V.Object.PartLookup!GetHookNumber
V.Object.PartLookup!GetDefaultPropertyIsVisibleList
V.Object.PartLookup!GetKeyList
V.Object.PartLookup!GetPropertyList
```

### Dynamic Object Name (Bracket Notation)

When the object name is stored in a variable (e.g., `V.Args.lookupReturn` from a `SelectionMade` event), use bracket notation `[VariableRef]` in place of the literal name:
```
V.Object.[V.Args.lookupReturn]!GetCount
V.Object.[V.Args.lookupReturn](0).LongPartNumber!FieldVal
```
This resolves the variable at runtime to the actual object name, enabling generic event handlers that work with any lookup result.

## Complete Example -- Entity Object CRUD Operations
```
Program.Sub.Preflight.Start
V.Global.iCon.Declare
F.Global.Object.CreateDB("GlobalDB",V.Caller.CompanyCode,V.Ambient.DBServerName,V.Global.iCon)
Program.Sub.Preflight.End

Program.Sub.Main.Start
F.Intrinsic.UI.UsePixels
V.Local.iRet.Declare(Long)
V.Local.sMaxValue.Declare
V.Local.sMinValue.Declare

'create and load entity object
F.Global.Object.Create("oPart","Inventory.Parts","GlobalDB",V.Global.iCon)
F.Global.Object.Load("oPart",1446,"~~~~~","~~~~~","~~",V.Local.iRet)

'add a new row (Insert commits to DB)
F.Global.Object.Add("oPart","LocationCode","","PartNumber","ZQP999","PartNumberRevision","568")
F.Global.Object.Insert("oPart",V.Local.iRet)

'edit an existing row by index (Update commits to DB)
F.Global.Object.SetValue("oPart","PartNumberRevision","ABC",3)
F.Global.Object.Update("oPart",V.Local.iRet)

'set value on all rows for a column
F.Global.Object.SetDefaultValue("oPart","PartNumberRevision","ABC")

'load entity data into a DataTable in one call
F.Global.Object.LoadDataTable("dtPL","oPL","Support.ProductLines","GlobalDB",V.Global.iCon,6,True,,-1,"","~~~")

'load entity data into a Dictionary
F.Global.Object.LoadDictionary("PartDictionary","oPart","PartNumber","PartNumberRevision")

'create related child entity from current
F.Global.Object.LoadNewFromCurrent("oPart","POLineTransactions","Purchasing.PurchaseOrderLineTransactions",42,"PurchaseOrderNumber","~~","~~~~")

'load child entity with explicit type and key mapping
F.Global.Object.LoadChildObject("oPart","Inventory.Items",294,"PartNumber*!*PartNumberRevision*!*LocationCode")

'aggregate functions
F.Global.Object.GetMaxValue("POLineTransactions","PurchaseOrderNumber",V.Local.sMaxValue)
F.Global.Object.GetMinValue("POLineTransactions","PurchaseOrderNumber",V.Local.sMinValue)

'cleanup
F.Global.Object.Dispose("oPart")
Program.Sub.Main.End
```

## Complete Example -- Load Quotes by Date Range
```
V.Global.iCon.Declare
V.Local.startDate.Declare(Date)
V.Local.endDate.Declare(Date)
V.Local.iRet.Declare(Long)

'establish DB connection
F.Global.Object.CreateDB("GlobalDB",V.Caller.CompanyCode,V.Ambient.DBServerName,V.Global.iCon)

'set date range
F.Intrinsic.Date.DateSerial(2021,10,01,V.Local.startDate)
F.Intrinsic.Date.DateSerial(2022,01,31,V.Local.endDate)

'create entity object -- Sales.Quoting.Quotes
F.Global.Object.Create("oQH",~"Sales.Quoting.Quotes",~"GlobalDB",V.Global.iCon)

'load by mode 40: key range + date range -> return status
F.Global.Object.Load("oQH",40,~"0000000",~"9999999",V.Local.startDate,V.Local.endDate,V.Local.iRet)
```

---

# MOBILE (F.Global.Mobile.*)

```
F.Global.Mobile.GetCustomHeader(sHeaderDef,sResult)
F.Global.Mobile.GetCustomLine(sLineDef,sResult)
F.Global.Mobile.GetCustomPrinter(sCompanyCode,sTransID,sResult)
F.Global.Mobile.SetCustomResult(sCompanyCode,sTransID,sResultData)
F.Global.Mobile.GetPrinterNameFromId(iPrinterID,sResult)
```

---

# REGISTRY (F.Global.Registry.*)

Per-user, per-company preference storage in `GlobalCommon.Gs_Registry`. Most common use case is persisting grid layouts (Serialize/Deserialize) for GAB GridView scripts. Also used for user preferences, last-used values, and script settings.

The registry key is the composite of **(UserID, Company, Program, RegID, Seq)**. When writing your own GAB scripts, ensure these five values form a unique key.

## ReadValue -- read a stored value from the registry

Two overloads:
```
F.Global.Registry.ReadValue(UserID, Company, Program, RegID, Seq, Field, Default, Return)
F.Global.Registry.ReadValue(UserID, Company, Program, RegID, Seq, Field, Default, Option, Order, Return)
```

| Argument | Type | Description |
|----------|------|-------------|
| UserID | Long | User ID (typically `V.Caller.User`) |
| Company | String | Company code (typically `V.Caller.CompanyCode`) |
| Program | String | Program identifier string (e.g., `"GVWC"`) |
| RegID | Long | Registry ID number (e.g., `4228`) |
| Seq | Long | Sequence number (e.g., `1000`) |
| Field | Long | Data type selector (see table below) |
| Default | Any | Default value if no registry entry exists |
| Option | Long | *(10-param form only)* Match option flags (see table below) |
| Order | Long | *(10-param form only)* Search priority order (see table below) |
| Return | Any | Variable to receive the stored value |

### Field (Data Type Selector)

| Value | Type |
|-------|------|
| 0 | Boolean |
| 1 | Long |
| 2 | Float |
| 3 | Date |
| 4 | Time |
| 5 | String |
| 6 | Long Varchar |

### Option (Match Flags) -- combinable via addition

| Value | Meaning |
|-------|---------|
| 0 | ExactMatch -- all key fields must match exactly |
| 1 | AllowEmptyUser -- match even if UserID is empty |
| 2 | AllowEmptyCompany -- match even if Company is empty |
| 4 | AllowEmptyProgram -- match even if Program is empty |

Flags are additive: e.g., `3` = AllowEmptyUser + AllowEmptyCompany.

### Order (Search Priority)

| Value | Priority |
|-------|----------|
| 0 | User -> Company -> Program |
| 1 | User -> Program -> Company |
| 2 | Company -> Program -> User |
| 3 | Company -> User -> Program |
| 4 | Program -> User -> Company |
| 5 | Program -> Company -> User |

## AddValue -- store a value in the registry

```
F.Global.Registry.AddValue(UserID, Company, Program, RegID, Seq, Encrypt, SVal, BVal, IVal, FVal, DVal, TVal, VVal)
```

| Argument | Type | Description | Suggested Default |
|----------|------|-------------|-------------------|
| UserID | Long | User ID (typically `V.Caller.User`) | |
| Company | String | Company code (typically `V.Caller.CompanyCode`) | |
| Program | String | Program identifier string | |
| RegID | Long | Registry ID number | |
| Seq | Long | Sequence number | |
| Encrypt | Boolean | If True, value is stored encrypted | |
| SVal | String | String value to store | `""` (empty) |
| BVal | Boolean | Boolean value to store | `False` |
| IVal | Long | Long value to store | `0` |
| FVal | Float | Float value to store | `-999.0` |
| DVal | Date | Date value to store | `1/1/1980` |
| TVal | Date | Time value to store | `12:00:00 AM` |
| VVal | String | Long varchar value to store | `""` (empty) |

**All 13 parameters are required.** Set the field you want to store and use the suggested defaults for the others. The `Field` parameter in `ReadValue` determines which field is read back.

## Complete Example -- Grid Layout Persistence

**Save layout:**
```
Gui.frmResched.GsGCWC.Serialize("gvWC",V.Local.sSerialize)
F.Global.Registry.AddValue(V.Caller.User,V.Caller.CompanyCode,"GVWC",4228,1000,False,"Serialize",False,0,-999.0,1/1/1980,12:00:00 AM,V.Local.sSerialize)
```

**Restore layout:**
```
F.Global.Registry.ReadValue(V.Caller.User,V.Caller.CompanyCode,"GVWC",4228,1000,6,"",V.Local.sSerialize)
F.Intrinsic.Control.If(V.Local.sSerialize.Trim,<>,"")
    Gui.frmResched.GsGCWC.Deserialize(V.Local.sSerialize)
F.Intrinsic.Control.EndIf
```
Note: `Field=6` (Long Varchar) is used because serialized grid layouts are large strings.

---

# TRANSLATION (F.Global.International.*)

```
F.Global.International.GetLabelTranslation(sLabel,sLanguage,sResult)
F.Global.International.GetLanguagesByUserId(sUserID,sResult)
F.Global.International.GetLanguagesByUserName(sUserName,sResult)
```

---

# WORKFLOW (F.Global.Workflow.*)

## Workflow Lifecycle
```
F.Global.Workflow.Create(sTitle,sResult)
F.Global.Workflow.CreateFromTemplate(iTemplateID,sResult)
F.Global.Workflow.Delete(iWorkflowID)
F.Global.Workflow.Read(iWorkflowID,sResult)
F.Global.Workflow.Save(iWorkflowID)
```

## Lines (Steps)
```
F.Global.Workflow.AddLine(iWorkflowID,sLineData,sResult)
F.Global.Workflow.CompleteLine(iWorkflowID,iLineID)
F.Global.Workflow.ReadLines(iWorkflowID,sResult)
F.Global.Workflow.ReadLineById(iWorkflowID,iLineID,sResult)
F.Global.Workflow.SaveLine(iWorkflowID,iLineID,sLineData)
F.Global.Workflow.DeleteLine(iWorkflowID,iLineID)
F.Global.Workflow.SignOffLine(iWorkflowID,iLineID,sUserID)
F.Global.Workflow.SetLineCompletionPercentage(iWorkflowID,iLineID,iPercentage)
```

## Dependencies
```
F.Global.Workflow.AddLineDependency(iWorkflowID,iLineID,iDependsOnLineID)
F.Global.Workflow.CheckLineDependency(iWorkflowID,iLineID,bResult)
```

## Documents & Notes
```
F.Global.Workflow.AddDocument(iWorkflowID,sDocData,sResult)
F.Global.Workflow.ReadDocument(iWorkflowID,iDocID,sResult)
F.Global.Workflow.DeleteDocument(iWorkflowID,iDocID)
F.Global.Workflow.ReadNote(iWorkflowID,iLineID,sResult)
F.Global.Workflow.SaveNote(iWorkflowID,iLineID,sNoteData)
```

## Metadata
```
F.Global.Workflow.SetMetadata(iWorkflowID,sKey,sValue)
F.Global.Workflow.ReadMetadata(iWorkflowID,sKey,sResult)
F.Global.Workflow.SetPriority(iWorkflowID,iPriority)
F.Global.Workflow.ReadCompletion(iWorkflowID,sResult)
F.Global.Workflow.Export(iWorkflowID,sResult)
F.Global.Workflow.Import(sData,sResult)
```

---

# SHIPPING (F.Global.ShipIntegration.*)

## Session Management
```
F.Global.ShipIntegration.StartSession(sCarrierCode,sResult)
F.Global.ShipIntegration.GetSessionId(sResult)
F.Global.ShipIntegration.ClearSession(sSessionID)
F.Global.ShipIntegration.ClearAllSessions
```

## Address & Packages
```
F.Global.ShipIntegration.SetSessionAddress(sSessionID,sAddressType,sAddressData)
F.Global.ShipIntegration.AddPackage(sSessionID,sPackageData,sResult)
F.Global.ShipIntegration.DeletePackage(sSessionID,sPackageID)
```

## Rates & Shipping
```
F.Global.ShipIntegration.GetRates(sSessionID,sResult)
F.Global.ShipIntegration.QuoteSession(sSessionID,sResult)
F.Global.ShipIntegration.ShipSession(sSessionID,sResult)
F.Global.ShipIntegration.CloseShipments(sSessionID)
```

## Tracking & Voiding
```
F.Global.ShipIntegration.TrackShipment(sTrackingNumber,sResult)
F.Global.ShipIntegration.VoidShipment(sShipmentID)
F.Global.ShipIntegration.VoidPackage(sPackageID)
```

## Validation
```
F.Global.ShipIntegration.ValidateAddress(sAddressData,sResult)
F.Global.ShipIntegration.UPSValidation(sData,sResult)
```

## Account Management
Three overloads distinguished by parameter count.

**Overload 1 (11 params) -- Basic account with doc control:**
```
F.Global.ShipIntegration.SaveAccount(ShipType, Enabled, TestMode, MeterNumber, DevKey, AccountNumber, AccessKey, UserName, Password, DocControl, DocGroup)
```
- `ShipType` as Long
- `Enabled` as Boolean
- `TestMode` as Boolean
- `MeterNumber` as String
- `DevKey` as String
- `AccountNumber` as String
- `AccessKey` as String
- `UserName` as String
- `Password` as String
- `DocControl` as Boolean
- `DocGroup` as Long

**Overload 2 (20 params) -- With address info:**
```
F.Global.ShipIntegration.SaveAccount(ShipType, Enabled, TestMode, MeterNumber, DevKey, AccountNumber, AccessKey, UserName, Password, GssUser, Address1, Address2, City, State, Zip, Country, Phone, Email, ContactName, Company)
```
- First 9 params same as Overload 1
- `GssUser` as String
- `Address1` as String
- `Address2` as String
- `City` as String
- `State` as String
- `Zip` as String
- `Country` as String
- `Phone` as String
- `Email` as String
- `ContactName` as String
- `Company` as String

**Overload 3 (21 params) -- With address + scale:**
```
F.Global.ShipIntegration.SaveAccount(ShipType, Enabled, TestMode, MeterNumber, DevKey, AccountNumber, AccessKey, UserName, Password, GssUser, Address1, Address2, City, State, Zip, Country, Phone, Email, ContactName, Company, Scale)
```
- Same as Overload 2 plus:
- `Scale` as String

---

# SCANNER / CAPTURE (F.Automation.Capture.*)

TWAIN scanner/camera integration.

## Scanner Management
```
F.Automation.Capture.GetSources(sResult)
F.Automation.Capture.SelectSource(sSourceName)
F.Automation.Capture.OpenSource(sSourceName)
F.Automation.Capture.CloseSource
F.Automation.Capture.EnableSource(sOptions)
F.Automation.Capture.DisableSource
F.Automation.Capture.SourceExists(sSourceName,bResult)
```

## Image Acquisition
```
F.Automation.Capture.AcquireImage(sResult)
F.Automation.Capture.FeedPage
F.Automation.Capture.RewindPage
```

## Image Manipulation
```
F.Automation.Capture.Rotate(iDegrees)
F.Automation.Capture.RotateLeft
F.Automation.Capture.RotateRight
F.Automation.Capture.Flip
F.Automation.Capture.Mirror
F.Automation.Capture.Crop(iX,iY,iWidth,iHeight)
F.Automation.Capture.Grayscale
F.Automation.Capture.Invert
F.Automation.Capture.IsBlankImage(bResult)
```

## Save & Barcode
```
F.Automation.Capture.SaveImageInBuffer(sFilePath,sFormat)
F.Automation.Capture.GetBarcodeInfo(sResult)
F.Automation.Capture.GetBarcodeText(sResult)
```

---

# MAPPER (F.Global.Mapper.*)

```
F.Global.Mapper.CallMapper(sMapperName,sParams)
```

---

# GSSUI (F.Global.GSSUI.*)

```
F.Global.GSSUI.Launch(sProgramID,sParams)
F.Global.GSSUI.CreatePayload(sPayloadData,sResult)
```

---

# ENCRYPTION (F.Global.Encryption.*)

```
F.Global.Encryption.Encrypt(sPlainText,sKey,sResult)
F.Global.Encryption.Decrypt(sCipherText,sKey,sResult)
```

Keys must match for encrypt/decrypt. For simpler obfuscation, see `F.Intrinsic.String.WeakEncryption` / `F.Intrinsic.String.WeakDecryption` in `agents/gab/DATA.md` → **Intrinsic.String**.

---

# ANTI-PATTERNS

- Always check security permissions before sensitive operations
- Always dispose entity objects to release database connections
- Release soft locks as soon as the operation completes
- Prefer CallWrapperAsync over CallWrapperSync in UI event handlers (sync blocks UI)
- Never hardcode user IDs or group IDs -- use lookup functions
- Workflow dependencies are enforced -- check before completing lines
- Always clear shipping sessions when done
- Always check scanner source availability with GetSources/SourceExists before acquiring
- Scanner lifecycle: OpenSource -> EnableSource -> AcquireImage -> CloseSource

---

# VALIDATED CORE GSS INTEGRATION PATTERNS (2026-06-03)

> These patterns were verified against live GSS database records, COBOL source (via MCP cobol-codebase), and the OCTSRS runtime during the Employee Notes and Powell Valley SFDC sessions. Each pattern produced records matching standard GSS output.

## Pattern 1: Crew Clock-In via CallWrapper 9200

Clock an employee into a job/operation. Creates a record in `JOBS_IN_PROCESS_G`.

```
V.Local.sParams.Declare(String,"")
F.Intrinsic.String.ConcatCallWrapperArgs(V.Local.sJob,V.Local.sSuffix,V.Local.sSeq,V.Local.sWC,V.Local.sEmpl,V.Local.sParams)
F.Global.General.CallWrapperSync(9200,V.Local.sParams)
```

**Parameters (exactly 5):** JOB, SUFFIX, SEQ, WC, EMPLOYEE. No company/function prefix.

**Verify success:** Check `V.Ambient.CallWrapperReturn` and query `JOBS_IN_PROCESS_G` for the employee record.

## Pattern 2: Employee Comments (EMPL_MT_NOTES)

Write employee comments that flow to `JOB_DTL_NOTES` after Online Update.

**Key fields:**
- `DATE`: Format `YYMMDD` (NOT MMDDYY)
- `KEY_SEQ`: Computed from `MAX(KEY_SEQ) + 1` for the same EMPL+DATE
- `TEXT_COMMENT`: Set to `'Y'` ONLY for crew leader and machine overhead records
- `TEXT_SEQ`: Integer sequence within the comment block
- `TEXT_SHARED`: Space character (not 'N')

```
'-- Compute next KEY_SEQ
V.Local.sSQL.Set("SELECT COALESCE(MAX(KEY_SEQ),0) + 1 FROM EMPL_MT_NOTES WHERE EMPL = '...' AND DATE = '...'")
F.ODBC.Connection!con.ExecuteAndReturn(V.Local.sSQL,V.Local.iNextSeq)

'-- Insert comment record
V.Local.sSQL.Set("INSERT INTO EMPL_MT_NOTES (EMPL,DATE,KEY_SEQ,TEXT_SEQ,TEXT,TEXT_SHARED) VALUES (...)")
F.ODBC.Connection!con.Execute(V.Local.sSQL)
```

## Pattern 3: Auto WIP-to-FG (Lot Generation)

Automatically report finished goods with a generated lot number during clock-out.

**Components:**
1. **XREF_ID**: Unique identifier per crew member record. Read from `OP_HEADER` (ID=401999, SEQ=0000, F_LONG column). Increment and update via SQL (SaveOption cannot reliably write F_LONG for this option).
2. **JOBS_IN_PROC_AUX**: Insert a record with `AUTO_LOT` = next available lot number. Links to JOBS_IN_PROCESS via XREF_ID.
3. **Lot counter**: Stored in `OP_HEADER` (ID=400561, SEQ=0001, TEXT1 column). Read via `ReadOption(DataType=1)`, increment via SQL (15-digit numbers overflow GAB Long), write back via `SaveOption`.

**XREF_ID assignment rules:**
- Crew leader and machine overhead share the same XREF_ID
- Each other crew member gets a unique XREF_ID

**Lot counter increment (offloaded to SQL for overflow safety):**
```
V.Local.sSQL.Set("SELECT CAST(CAST(TEXT1 AS NUMERIC(15,0)) + 1 AS VARCHAR(15)) FROM OP_HEADER WHERE ID = '400561' AND SEQUENCE = '0001'")
F.ODBC.Connection!con.ExecuteAndReturn(V.Local.sSQL,V.Local.sNextLot)
```

## Pattern 4: SQL_MAINT.lib (Custom Table Management)

Revision-tracked DDL for custom tables with automatic schema evolution.

**Structure:**
```
Program.Sub.Preflight.Start
V.Global.iCurrentRevision.Declare(Long,0)
V.Global.iTargetRevision.Declare(Long,3)
Program.Sub.Preflight.End

Program.Sub.Main.Start
'-- Check current revision from a tracking table or option
'-- Apply each revision sequentially:
F.Intrinsic.Control.If(V.Global.iCurrentRevision,<,1)
    F.Intrinsic.Control.CallSub(Rev1_CreateTables)
F.Intrinsic.Control.EndIf
F.Intrinsic.Control.If(V.Global.iCurrentRevision,<,2)
    F.Intrinsic.Control.CallSub(Rev2_AlterColumns)
F.Intrinsic.Control.EndIf
'-- Update revision tracker after success
Program.Sub.Main.End
```

Each revision sub contains idempotent DDL (CREATE TABLE IF NOT EXISTS, ALTER TABLE ADD COLUMN checks).

## Pattern 5: Codesoft Label Printing

Print custom Codesoft labels with data from a DataTable.

```
'-- Initialize report path
F.Global.Printing.InitializeReport(V.Local.sLabelPath)

'-- Print from DataTable (one label per row)
F.Global.Printing.PrintCodesoftLabelFromDataTable("dtLabels",V.Local.sLabelPath,V.Local.iPrinterIndex)
```

Search GitHub org `Global-Shop-Solution-GAB` for `PrintCodesoftLabelFromDataTable` examples with variable mapping and multi-copy patterns.
