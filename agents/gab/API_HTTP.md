# GAB HTTP & Communication Reference
# Sub-agent of agents/AGENTS.GAB.md -- read when working with HTTP, REST, JSON, SOAP, SFTP, FTP, IMAP, OAuth, serial, and multipart upload APIs
# Last verified: 2026-04-20 | Product version: unverified | Agent kit audit pass
---

# COMMUNICATION

## HTTP Client
```
F.Communication.HTTP.ResetHeaders
F.Communication.HTTP.SetProperty("Authorization",sAuthHeader)
F.Communication.HTTP.SetProperty("HTTPMethod","GET")           ' GET, POST, PUT
F.Communication.HTTP.SetProperty("ContentType","application/json")
F.Communication.HTTP.SetProperty("Accept","application/json")
F.Communication.HTTP.SetProperty("URL",sURL)
F.Communication.HTTP.SetProperty("LocalFile",sResponseFilePath)
F.Communication.HTTP.SetProperty("PostData",sBody)
F.Communication.HTTP.SetProperty("FollowRedirects",1)
F.Communication.HTTP.Config("SSLEnabledProtocols=4032",sResult)

F.Communication.HTTP.Get(sEndpoint)
F.Communication.HTTP.Post(sEndpoint)
F.Communication.HTTP.Put(sEndpoint)
F.Communication.HTTP.DownloadFile(sURL,sLocalPath)

F.Communication.HTTP.DoEvents()                                ' Process pending events
F.Communication.HTTP.ReadProperty("TransferredData",sResult)   ' Read response body
F.Communication.HTTP.Reset()                                   ' Resets the HTTP component (clears all properties and headers)
```

### HTTP POST with JSON Body (Batch API Pattern)

When calling REST APIs that accept JSON arrays (e.g., Geocodio batch geocoding), use `SetProperty("PostData",...)` with a JSON body and `SetProperty("LocalFile",...)` to capture the response to a file for parsing:

```
F.Communication.HTTP.ResetHeaders
F.Communication.HTTP.SetProperty("ContentType","application/json")
F.Communication.HTTP.SetProperty("PostData",V.Local.sJsonBody)
F.Communication.HTTP.SetProperty("LocalFile",V.Local.sResponseFile)
F.Communication.HTTP.Post("https://api.geocod.io/v1.7/geocode?api_key=YOUR_KEY")
```

**Key pitfalls:**
- GAB's `""` escape in string literals produces literal `""` (two quotes) in the POST body. Use `V.Ambient.DblQuote` in `String.Build` placeholders, or do `F.Intrinsic.String.Replace(sBody,V.Ambient.QuadQuote,V.Ambient.DblQuote,sBody)` to fix doubled quotes before POSTing.
- Always delete stale response files before POST (`F.Intrinsic.File.DeleteFile` with `File.Exists` guard) to avoid parsing old data.
- Parse response with `F.Communication.JSON.ParseFile(sResponseFile)` and XPath navigation. Geocodio uses **1-based** array indexing: `/JSON/results/[1]/response/results/[1]/location/lat`.

See `PATTERNS.md` → Pattern G for the complete WebView2 + HTTP Batch API implementation.

## REST Client
```
F.Communication.REST.SetProperty("HTTPMethod","GET")
F.Communication.REST.SetProperty("OtherHeaders",sHeaders)
F.Communication.REST.SetProperty("LocalFile",sResponseFilePath)
F.Communication.REST.SetProperty("PostData",sBody)

F.Communication.REST.Get(sEndpoint)
F.Communication.REST.Post(sEndpoint)
F.Communication.REST.Delete(sEndpoint)

F.Communication.REST.DoEvents()
F.Communication.REST.ReadProperty("StatusLine",sResult)
F.Communication.REST.ReadProperty("TransferredData",sResult)
F.Communication.REST.Reset
```

## JSON API

| Method | Description |
|--------|-------------|
| `Config(Name, Value)` | Gets or sets a configuration property. Value is by-reference. Get: `Config("HTTPVersion", sResult)` Set: `Config("HTTPVersion=2.0", sResult)` |
| `EndObject` | Writes the closing brace of a JSON object |
| `Flush` | Flushes the writer buffer. No arguments |
| `HasXPath(sXPath, bResult)` | Checks if the specified XPath exists; bResult as Boolean |
| `Input(sInputData)` | Parses a JSON string (alternative to `ParseFile` for in-memory JSON); sInputData as String |
| `ParseFile(sFilePath)` | Parses a JSON file from disk; sFilePath as String |
| `PutProperty(PropertyName, Value, ValueType)` | Inserts a property name/value pair; PropertyName as String, Value as Any, ValueType as String |
| `ReadProperty(PropertyName, sResult)` | Reads a property value at the current XPath; PropertyName as String (`"XText"`, `"XChildren"`, etc.) |
| `Reset` | Resets the JSON parser/writer state. No arguments |
| `SetProperty(PropertyName, Value)` | Sets a parser property (e.g., `"XPath"` to navigate); PropertyName as String, Value as String |
| `StartObject` | Writes the opening brace of a JSON object. No arguments |

### JSON Parsing
```
' Parse from file
F.Communication.JSON.Reset
F.Communication.JSON.ParseFile(sFilePath)
F.Communication.JSON.HasXPath(sXPath,bResult)                  ' Check if path exists
F.Communication.JSON.SetProperty("XPath","/JSON/property")     ' Navigate to node
F.Communication.JSON.ReadProperty("XText",sResult)             ' Read text value at XPath
F.Communication.JSON.ReadProperty("XChildren",iResult)         ' Read child count

' Parse from string
F.Communication.JSON.Reset
F.Communication.JSON.Input(V.Local.sJsonString)
F.Communication.JSON.SetProperty("XPath","/JSON/property")
F.Communication.JSON.ReadProperty("XText",sResult)
```

### JSON Construction
```
F.Communication.JSON.Reset
F.Communication.JSON.StartObject
F.Communication.JSON.PutProperty("propertyName","stringValue","")
F.Communication.JSON.PutProperty("numericProp",123,"")
F.Communication.JSON.PutProperty("nested","","")
F.Communication.JSON.StartObject
F.Communication.JSON.PutProperty("innerProp","innerValue","")
F.Communication.JSON.EndObject
F.Communication.JSON.EndObject
F.Communication.JSON.Flush
```

## REST Configuration Properties
| Property | Description |
|----------|-------------|
| `HTTPMethod` | GET, POST, PUT, DELETE |
| `ContentType` | e.g., application/json |
| `Accept` | Expected response type |
| `OtherHeaders` | Additional headers (Name: Value format) |
| `Authorization` | Auth header value |
| `PostData` | Request body |
| `LocalFile` | File path to save response |
| `StatusLine` | Response status (read-only) |
| `TransferredData` | Response body (read-only) |

## SOAP Web Services
```
F.Communication.SOAP.Reset
F.Communication.SOAP.SetProperty("URL",sWSDLUrl)
F.Communication.SOAP.AddNameSpace("prefix","namespaceURI")
F.Communication.SOAP.AddParam("ParamName",sValue)
F.Communication.SOAP.BuildPacket(sResult)
F.Communication.SOAP.SendRequest(sResult)
F.Communication.SOAP.ReadProperty("ResponseData",sResult)
```

## XML Processing (F.Global.Xml.*)
```
F.Global.Xml.CreateDocument("docName")
F.Global.Xml.LoadDocument("docName",sFilePath)
F.Global.Xml.LoadDocumentFromString("docName",sXML)
F.Global.Xml.SetRoot("docName","rootElement")
F.Global.Xml.AppendNode("docName",sParentXPath,sNodeName,sValue)
F.Global.Xml.ReadNodeValue("docName",sXPath,sResult)
F.Global.Xml.Query("docName",sXPath,sResult)
F.Global.Xml.TraverseNodeSet("docName",sXPath,sResult)
F.Global.Xml.SaveDocument("docName",sFilePath)
F.Global.Xml.DestroyNode("docName")
```

## SFTP
```
F.Communication.SFTP.SetProperty("SSHHost",sHost)
F.Communication.SFTP.SetProperty("SSHPort",22)
F.Communication.SFTP.SetProperty("SSHUser",sUser)
F.Communication.SFTP.SetProperty("SSHPassword",sPass)
F.Communication.SFTP.Logon
F.Communication.SFTP.Upload(sLocalPath,sRemotePath)
F.Communication.SFTP.ListDirectory(sRemotePath,sResult)
F.Communication.SFTP.ReadProperty("LastStatus",sResult)
F.Communication.SFTP.GetProperty(Name, Value)                  ' Gets a property value; see https://cdn.nsoftware.com/help/IFF/cs/SFTP.htm
F.Communication.SFTP.Logoff
```

## FTP / FTPS
```
F.Communication.FTP.Config(sProperty,sResult)
F.Communication.FTP.SetProperty("RemoteHost",sHost)
F.Communication.FTP.SetProperty("RemotePort",21)
F.Communication.FTP.SetProperty("User",sUser)
F.Communication.FTP.SetProperty("Password",sPass)
F.Communication.FTP.Logon
F.Communication.FTP.Upload(sLocalPath,sRemotePath)
F.Communication.FTP.Upload()                                    ' No-arg form; set LocalFile and RemoteFile via SetProperty first
F.Communication.FTP.Download(sRemotePath,sLocalPath)
F.Communication.FTP.ListDirectory(sRemotePath,sResult)
F.Communication.FTP.DeleteFile(sRemotePath)
F.Communication.FTP.ReadProperty(Name, Value)                   ' Gets a property value; see https://cdn.nsoftware.com/help/IPF/cs/FTP.htm
F.Communication.FTP.Logoff
```
FTPS uses the same API: `F.Communication.FTPS.*` with SSL/TLS enabled via Config.

## IMAP (Email Retrieval)
```
F.Communication.IMAP.Config(sProperty,sResult)
F.Communication.IMAP.SetProperty("Server",sServer)
F.Communication.IMAP.SetProperty("User",sUser)
F.Communication.IMAP.SetProperty("Password",sPass)
F.Communication.IMAP.Connect
F.Communication.IMAP.SelectFolder("INBOX")
F.Communication.IMAP.GetMessage(iMsgIndex,sResult)
F.Communication.IMAP.GetAttachment(iMsgIndex,iAttachIndex,sLocalPath)
F.Communication.IMAP.Disconnect
```

## OAuth 2.0
```
F.Communication.OAuth.Config(sProperty,sResult)
F.Communication.OAuth.SetProperty("ClientId",sClientId)
F.Communication.OAuth.SetProperty("ClientSecret",sSecret)
F.Communication.OAuth.SetProperty("AuthorizationScope",sScope)
F.Communication.OAuth.SetProperty("ServerAuthURL",sAuthURL)
F.Communication.OAuth.SetProperty("ServerTokenURL",sTokenURL)
F.Communication.OAuth.GetAuthorizationURL(sResult)
F.Communication.OAuth.ExchangeCodeForToken(sAuthCode,sResult)
F.Communication.OAuth.RefreshToken(sRefreshToken,sResult)
```

## Serial Port (F.Communication.Serial.*)
```
F.Communication.Serial.SetCOMPort(sPortName)                          ' Set COM port name
F.Communication.Serial.SetParameters(sParams)                         ' Set Baudrate,DataBits,StopBits,Parity
F.Communication.Serial.SetHandShaking(sHandShake)                     ' Set handshaking protocol
F.Communication.Serial.SetInBufferSize(iSize)                         ' Set input buffer size
F.Communication.Serial.SetOutBufferSize(iSize)                        ' Set output buffer size
F.Communication.Serial.SetDtrEnable(bFlag)                            ' Enable Data Terminal Ready (DTR) signal
F.Communication.Serial.SetRtsEnable(bFlag)                            ' Enable Request to Send (RTS) signal
F.Communication.Serial.SetNullDiscard(bFlag)                          ' Ignore null bytes in transmission
F.Communication.Serial.SetRThreshold(iBytes)                          ' Bytes in input buffer before DataReceived event
F.Communication.Serial.SetSThreshold(iExpression)                     ' Send threshold
F.Communication.Serial.OpenPort(bFlag)                                ' Open (True) or close (False) serial port
F.Communication.Serial.SendOutput(sText)                              ' Write string to serial port
F.Communication.Serial.SendOutputAndReturn(sText,iTimeout,sReturn)    ' Write string and read response
F.Communication.Serial.GetInput(sReturn)                              ' Read all available bytes
F.Communication.Serial.GetInputLen(iLength)                           ' Get length of string in return buffer
F.Communication.Serial.GetReturnBuffer(iTimeout,sReturn)              ' Read all available bytes with timeout
F.Communication.Serial.DataWaiting(iReturn)                           ' Get number of bytes in receive buffer
```

## File Upload (multipart)
```
F.Communication.WebUpload.Reset
F.Communication.WebUpload.SetProperty("URL",sUploadURL)
F.Communication.WebUpload.AddFormVar("fieldName","value")
F.Communication.WebUpload.AddFileVar("fileField",sFilePath,"application/octet-stream")
F.Communication.WebUpload.UploadTo(sResult)
F.Communication.WebUpload.Upload()                              ' Uploads file (use SetProperty to configure URL, LocalFile, RemoteFile first)
F.Communication.WebUpload.ReadProperty("ResponseData",sResult)
```

## Encoding/Decoding

Two encoding APIs exist. Use `Netcode` (preferred, tested):

```
' Netcode (preferred -- parameter order: Format, Text, Value)
F.Communication.Netcode.EncodeToString(V.Enum.DecodeFormats!Base64,sInput,sResult)
F.Communication.Netcode.DecodeToString(V.Enum.DecodeFormats!Base64,sEncoded,sResult)
F.Communication.Netcode.DecodeToFile(sEncodedData,sOutputPath)
```

```
' Misc (alternative -- parameter order: Text, Format, Value)
F.Communication.Misc.EncodeToString(sInput,V.Enum.DecodeFormats!Base64,sResult)
F.Communication.Misc.DecodeToString(sInput,V.Enum.DecodeFormats!Base64,sResult)
```

> **Note:** `Netcode` and `Misc` have **different parameter orders** for Encode/Decode. `Netcode` takes `(Format, Text, Result)` while `Misc` takes `(Text, Format, Result)`. Mixing them up causes silent failures or wrong output.

---

## HTTP vs REST Component Selection Guide

| Scenario | Use | Why |
|----------|-----|-----|
| Simple GET/POST to REST API | `F.Communication.REST.*` | Handles SSL, encoding, simpler property chain |
| Batch API POST with JSON body | `F.Communication.HTTP.*` | Full control over headers, body, response file |
| File download | `F.Communication.HTTP.DownloadFile` | Direct file save |
| SOAP web service | `F.Communication.SOAP.*` | Native WSDL/envelope support |
| Need SSL on HTTP component | `F.Communication.HTTP.Config("SSLEnabledProtocols=4032",sResult)` | Enables TLS 1.2 |

**Critical HTTP component rules (see also `PITFALLS.md`):**
- Use `ResetHeaders` between calls, NOT `Reset` (Reset kills internal state)
- Always set `LocalFile` property for POST/GET to capture response
- Apply `MakeURLFriendly` only to query parameter **values**, not full URLs
- JSON `ReadProperty("XText",...)` returns strings with surrounding `"` -- strip before comparing

---


# OCTSRS Component Reference (Runtime Implementation)

## Component Reference: AzureComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\AzureComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\AzureComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~102 lines

### Runtime purpose
The Azure Component provides Azure SQL Database connection management for cloud database operations.

### Implementation notes (OCTSRS)
#### Connection Management
- Connections stored in `DatabaseConfiguration.Connections` collection
- Connection names are case-insensitive (converted to uppercase)
- Uses `AzureSqlConnection` wrapper class

#### Security
- Encryption enabled by default
- TrustServerCertificate = False for security
- Credentials passed as parameters (consider secure storage)

#### Migration Notes
- Already uses ADO.NET (SqlConnection)
- No ADODB usage in this component
- Modern connection string with Azure-specific settings

### Dependencies
#### External Dependencies
- System.Data.SqlClient
- Azure SQL Database service

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `OPENCONNECTION` | Open an Azure SQL connection |
| `CLOSECONNECTION` | Close an Azure SQL connection |

### Key method signatures & edge cases
#### `OPENCONNECTION`
**GAB Syntax:** `Subroutine.Global.Azure.ConnectionName.OpenConnection(ServerName, DatabaseName, User, Password, [CommandTimeout])`

**Purpose:** Opens a connection to an Azure SQL database.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | ServerName | String | Yes | Azure SQL server name (e.g., server.database.windows.net) |
| 2 | DatabaseName | String | Yes | Database name |
| 3 | User | String | Yes | SQL user ID |
| 4 | Password | String | Yes | SQL password |
| 5 | CommandTimeout | String | No | Connection timeout |

**Connection String Format:**
```
Server=tcp:{ServerName};Initial Catalog={DatabaseName};Persist Security Info=True;User ID={User};Password={Password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout={Timeout}
```

**Error Codes:**

| Code | Condition |
|------|-----------|
| 20013 | Connection name already exists |
| 20014 | Cannot open connection |

#### `CLOSECONNECTION`
**GAB Syntax:** `Subroutine.Global.Azure.ConnectionName.CloseConnection()`

**Purpose:** Closes an existing Azure SQL connection.

**Error Codes:**

| Code | Condition |
|------|-----------|
| 20012 | Error closing connection |

---

## Component Reference: CalDavComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\CalDavComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\CalDavComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~196 lines

### Runtime purpose
The CalDav Component provides CalDAV (Calendar Distributed Authoring and Versioning) protocol support for calendar synchronization and management.

### Implementation notes (OCTSRS)
#### Legacy Behavior
- Uses nsoftware IPWorks CalDav class
- Event-driven architecture with handlers
- Lazy initialization of CalDav object

#### Protocol Support
- CalDAV (RFC 4791)
- iCalendar (RFC 5545)
- WebDAV extensions

#### Migration Notes
- No database interaction
- Uses modern IPWorks library
- Event handlers for async operations

### Dependencies
#### External Dependencies
- nsoftware.IPWorks library
- CalDAV server (Google Calendar, iCloud, etc.)

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `INTERRUPT` | Interrupt current operation |
| `CREATECALENDAR` | Create a new calendar |
| `GETCALENDAREVENT` | Get a calendar event |
| `PUTCALENDAREVENT` | Create/update calendar event |
| `DELETECALENDAREVENT` | Delete a calendar event |
| `COPYCALENDAREVENT` | Copy a calendar event |
| `MOVECALENDAREVENT` | Move a calendar event |
| `GETCALENDAROPTIONS` | Get calendar options |
| `GETCALENDARREPORT` | Get calendar report |
| `GETFREEBUSYREPORT` | Get free/busy information |
| `LOCKCALENDAR` | Lock a calendar |
| `UNLOCKCALENDAR` | Unlock a calendar |
| `IMPORTICS` | Import iCalendar data |
| `EXPORTICS` | Export to iCalendar format |
| `ADDCOOKIE` | Add a cookie |
| `ADDCUSTOMPROPERTY` | Add custom property |

### Key method signatures & edge cases
#### `GETCALENDAREVENT`
**GAB Syntax:** `Subroutine.Global.CalDav.GetCalendarEvent(EventURL)`

**Purpose:** Retrieves a calendar event from the CalDAV server.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | EventURL | String | Yes | URL of the calendar event |

#### `PUTCALENDAREVENT`
**GAB Syntax:** `Subroutine.Global.CalDav.PutCalendarEvent(EventURL)`

**Purpose:** Creates or updates a calendar event on the CalDAV server.

#### `EXPORTICS`
**GAB Syntax:** `Function.Global.CalDav.ExportICS(Variable.Local.ICSData)`

**Purpose:** Exports current event data to iCalendar format.

**Returns:** String - iCalendar formatted data

#### `IMPORTICS`
**GAB Syntax:** `Subroutine.Global.CalDav.ImportICS(ICSData)`

**Purpose:** Imports iCalendar data into the component.

---

## Component Reference: FtpComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\FtpComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\FtpComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~186 lines

### Runtime purpose
The FTP Component provides FTP (File Transfer Protocol) client functionality for file transfers using the nsoftware IPWorks library.

### Implementation notes (OCTSRS)
#### SSL/TLS Support
- Supports FTPS (FTP over SSL)
- SSLStartMode configurable
- IsSecure property controls SSL usage

#### Event-Driven
- Uses event handlers for async operations
- Progress tracking via OnTransfer
- Error handling via OnError

#### Migration Notes
- No database interaction
- Modern IPWorks library
- Event-based architecture

### Dependencies
#### External Dependencies
- nsoftware.IPWorks library

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `ABORT` | Abort current operation |
| `INTERRUPT` | Interrupt transfer |
| `STOREUNIQUE` | Upload with unique name |
| `LISTDIRECTORYLONG` | List with details |
| `MAKEDIRECTORY` | Create directory |
| `REMOVEDIRECTORY` | Remove directory |
| `RENAMEFILE` | Rename remote file |
| `COMMAND` | Send FTP command |

### Key method signatures & edge cases
#### `LOGON`
**GAB Syntax:** `Subroutine.Global.Ftp.Logon()`

**Purpose:** Connects to the FTP server using configured credentials.

**Prerequisites:** Set Server, User, Password properties first

#### `DOWNLOAD`
**GAB Syntax:** `Subroutine.Global.Ftp.Download()`

**Purpose:** Downloads a file from the FTP server.

**Prerequisites:** Set RemoteFile and LocalFile properties first

#### `UPLOAD`
**GAB Syntax:** `Subroutine.Global.Ftp.Upload()`

**Purpose:** Uploads a file to the FTP server.

**Prerequisites:** Set LocalFile and RemoteFile properties first

#### `SETPROPERTY`
**GAB Syntax:** `Subroutine.Global.Ftp.SetProperty(PropertyName, Value)`

**Purpose:** Sets an FTP component property.

**Common Properties:**
- `Server` - FTP server address
- `User` - Username
- `Password` - Password
- `RemoteFile` - Remote file path
- `LocalFile` - Local file path
- `RemotePath` - Remote directory

---

## Component Reference: HttpComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\HttpComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\HttpComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~236 lines

### Runtime purpose
The HTTP Component provides HTTP client functionality for web requests using the nsoftware IPWorks library.

### Implementation notes (OCTSRS)
#### HTTPS Support
- Supports HTTP and HTTPS
- IsSecure property controls SSL
- Certificate management for client certs

#### Response Handling
- Response in TransferredData property
- Headers accessible via events
- Status code for error checking

#### Migration Notes
- No database interaction
- Modern IPWorks library
- Consider HttpClient for newer implementations

### Dependencies
#### External Dependencies
- nsoftware.IPWorks library
- System.Net namespace

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `ADDCOOKIE` | Add a cookie |
| `ADDCERTIFICATE` | Add SSL certificate |
| `INTERRUPT` | Interrupt request |

### Key method signatures & edge cases
#### `GET`
**GAB Syntax:** `Subroutine.Global.Http.Get(URL)`

**Purpose:** Performs an HTTP GET request.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | URL | String | Yes | URL to request |

#### `POST`
**GAB Syntax:** `Subroutine.Global.Http.Post(URL, PostData)`

**Purpose:** Performs an HTTP POST request.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | URL | String | Yes | URL to post to |
| 2 | PostData | String | Yes | Data to post |

#### `ADDCERTIFICATE`
**GAB Syntax:** `Subroutine.Global.Http.AddCertificate(PropertyName, [StoreType], [Store], [StorePassword], [Subject])`

**Purpose:** Adds an SSL certificate for HTTPS requests.

#### `SETPROPERTY`
**GAB Syntax:** `Subroutine.Global.Http.SetProperty(PropertyName, Value)`

**Purpose:** Sets an HTTP component property.

**Common Properties:**
- `URL` - Request URL
- `ContentType` - Content-Type header
- `Accept` - Accept header
- `Authorization` - Authorization header
- `TransferredData` - Response data
- `StatusCode` - Response status code

---

## Component Reference: IMapComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\IMapComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\IMapComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started

### Runtime purpose
The IMAP Component provides IMAP email client functionality for email retrieval and management.

### Implementation notes (OCTSRS)
#### IMAP Protocol
- Standard IMAP4 support
- Folder management
- Message retrieval

#### Migration Notes
- Check source file for detailed methods
- Email protocol handling

### Dependencies
#### External Dependencies
- nsoftware IPWorks (likely)

---

---

## Component Reference: JsonComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\JsonComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\JsonComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~164 lines

### Runtime purpose
The JSON Component provides JSON parsing and building functionality using the nsoftware IPWorks library.

### Implementation notes (OCTSRS)
#### Two Libraries
- Uses IPWorks Json for parsing
- Newtonsoft.Json also available

#### Event-Driven Parsing
- Events fired during parse
- Can process large JSON streams

#### Migration Notes
- No database interaction
- Modern JSON handling
- Consider System.Text.Json for newer code

### Dependencies
#### External Dependencies
- nsoftware.IPWorks library
- Newtonsoft.Json

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `STARTARRAY` | Start JSON array |
| `ENDARRAY` | End JSON array |
| `PUTVALUE` | Add a value |
| `PUTNAME` | Add a name/key |

### Key method signatures & edge cases
#### `PARSE`
**GAB Syntax:** `Subroutine.Global.Json.Parse(JsonString)`

**Purpose:** Parses a JSON string.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | JsonString | String | Yes | JSON to parse |

#### `PUTVALUE`
**GAB Syntax:** `Subroutine.Global.Json.PutValue(Value, [ValueType])`

**Purpose:** Adds a value to the JSON being built.

---

## Component Reference: MimeComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\MimeComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\MimeComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started

### Runtime purpose
The MIME Component provides MIME (Multipurpose Internet Mail Extensions) handling for email and file attachments.

### Implementation notes (OCTSRS)
#### MIME Support
- Attachment encoding
- Content type handling
- Multi-part message support

#### Migration Notes
- Check source file for detailed methods
- Email-related functionality

### Dependencies
#### External Dependencies
- MIME handling libraries

---

---

## Component Reference: NetworkComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\NetworkComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\NetworkComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~115 lines

### Runtime purpose
The Network Component provides network-related operations including DNS lookups, user authentication, and network time retrieval.

### Implementation notes (OCTSRS)
#### Active Directory
- Uses PrincipalContext for AD authentication
- Requires domain connectivity
- Credentials validated against domain controller

#### DNS Operations
- Uses System.Net.Dns class
- Supports IPv4 and IPv6
- May require network access

#### Migration Notes
- No database interaction
- Uses .NET networking classes
- Consider timeout handling

### Dependencies
#### External Dependencies
- System.Net namespace
- System.DirectoryServices.AccountManagement

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `AUTHENTICATEUSER` | Authenticate against Active Directory |
| `GETHOSTNAMEFROMIP` | Get hostname from IP address |
| `GETIPFROMHOSTNAME` | Get IP address from hostname |
| `GETTHREADUSER` | Get current thread user |
| `GETTIME` | Get network time |
| `PING` | Ping a host |

### Key method signatures & edge cases
#### `AUTHENTICATEUSER`
**GAB Syntax:** `Function.Global.Network.AuthenticateUser(Username, Password, Domain, Variable.Local.IsValid)`

**Purpose:** Validates user credentials against Active Directory.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Username | String | Yes | Username to validate |
| 2 | Password | String | Yes | Password |
| 3 | Domain | String | Yes | AD domain name |
| R | IsValid | Boolean | Yes | Return - True if valid |

#### `GETHOSTNAMEFROMIP`
**GAB Syntax:** `Function.Global.Network.GetHostnameFromIP(IPAddress, Variable.Local.Hostname)`

**Purpose:** Performs reverse DNS lookup.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | IPAddress | String | Yes | IP address to lookup |
| R | Hostname | String | Yes | Return - Hostname |

#### `GETIPFROMHOSTNAME`
**GAB Syntax:** `Function.Global.Network.GetIPFromHostname(Hostname, Variable.Local.IPAddress)`

**Purpose:** Performs DNS lookup.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | Hostname | String | Yes | Hostname to lookup |
| R | IPAddress | String | Yes | Return - IP address |

#### `GETTHREADUSER`
**GAB Syntax:** `Function.Global.Network.GetThreadUser(Variable.Local.Username)`

**Purpose:** Gets the current thread's identity name.

#### `PING`
**GAB Syntax:** `Function.Global.Network.Ping(Host, Variable.Local.Success)`

**Purpose:** Pings a network host.

---

## Component Reference: OauthComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\OauthComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\OauthComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started

### Runtime purpose
The OAuth Component provides OAuth authentication functionality for secure API access.

### Implementation notes (OCTSRS)
#### OAuth Support
- OAuth 1.0 and 2.0 support
- Token refresh handling
- Secure credential management

#### Migration Notes
- Check source file for detailed methods
- Modern authentication patterns

### Dependencies
#### External Dependencies
- OAuth libraries

---

---

## Component Reference: RestComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\RestComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\RestComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~265 lines

### Runtime purpose
The REST Component provides RESTful API client functionality using the nsoftware IPWorks library with built-in XML/JSON parsing.

### Implementation notes (OCTSRS)
#### Built-in Parsing
- Automatic XML/JSON response parsing
- XPath queries for XML responses
- Integrated with response handling

#### Event-Driven
- Comprehensive event handlers
- Progress tracking
- Error handling

#### Migration Notes
- No database interaction
- Modern REST client
- Consider HttpClient for newer implementations

### Dependencies
#### External Dependencies
- nsoftware.IPWorks library

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `ADDCOOKIE` | Add a cookie |
| `ATTR` | Get attribute value |
| `TRYXPATH` | Try XPath query |
| `XATTR` | Get XML attribute |
| `INTERRUPT` | Interrupt request |

### Key method signatures & edge cases
#### `GET`
**GAB Syntax:** `Subroutine.Global.Rest.Get(URL)`

**Purpose:** Performs an HTTP GET request.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | URL | String | Yes | URL to request |

#### `POST`
**GAB Syntax:** `Subroutine.Global.Rest.Post(URL, PostData)`

**Purpose:** Performs an HTTP POST request.

#### `HASXPATH`
**GAB Syntax:** `Function.Global.Rest.HasXPath(XPath, Variable.Local.Exists)`

**Purpose:** Checks if an XPath expression exists in the response.

#### `XTEXT`
**GAB Syntax:** `Function.Global.Rest.XText(XPath, Variable.Local.Value)`

**Purpose:** Gets text content at an XPath location.

---

## Component Reference: SFtpComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\SFtpComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\SFtpComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~231 lines

### Runtime purpose
The SFTP Component provides secure file transfer functionality using SSH File Transfer Protocol via the nsoftware IPWorks SSH library.

### Implementation notes (OCTSRS)
#### SSH Security
- Uses SSH protocol for encryption
- Key-based or password authentication
- Server authentication handling

#### Event-Driven
- Progress tracking via events
- Error handling via OnError
- Transfer status updates

#### Migration Notes
- No database interaction
- Modern secure transfer library
- Consider SSH key management

### Dependencies
#### External Dependencies
- nsoftware.IPWorksSSH library

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `MAKEDIRECTORY` | Create directory |
| `REMOVEDIRECTORY` | Remove directory |
| `RENAMEFILE` | Rename remote file |
| `INTERRUPT` | Interrupt transfer |

### Key method signatures & edge cases
#### `DOWNLOAD`
**GAB Syntax:** `Subroutine.Global.SFtp.Download()`

**Purpose:** Downloads a file from the SFTP server.

**Prerequisites:** Set SSHHost, SSHUser, SSHPassword, RemoteFile, LocalFile properties

#### `UPLOAD`
**GAB Syntax:** `Subroutine.Global.SFtp.Upload()`

**Purpose:** Uploads a file to the SFTP server.

#### `SETPROPERTY`
**GAB Syntax:** `Subroutine.Global.SFtp.SetProperty(PropertyName, Value)`

**Purpose:** Sets an SFTP component property.

**Common Properties:**
- `SSHHost` - SFTP server address
- `SSHUser` - Username
- `SSHPassword` - Password
- `RemoteFile` - Remote file path
- `LocalFile` - Local file path
- `RemotePath` - Remote directory

---

## Component Reference: SoapComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\SoapComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\SoapComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~206 lines

### Runtime purpose
The SOAP Component provides SOAP web service client functionality using the nsoftware IPWorks library.

### Implementation notes (OCTSRS)
#### Legacy Configuration
- Sets MethodNamespacePrefix to empty string
- Assumes RPC-style services by default
- Compatible with legacy SOAP services

#### Response Parsing
- Built-in XML response parsing
- XPath query support
- Value extraction methods

#### Migration Notes
- No database interaction
- Consider REST for newer services
- SOAP still used in enterprise integrations

### Dependencies
#### External Dependencies
- nsoftware.IPWorks library

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `EVALPACKET` | Evaluate response packet |
| `ATTR` | Get attribute |
| `XATTR` | Get XML attribute |

### Key method signatures & edge cases
#### `SENDREQUEST`
**GAB Syntax:** `Subroutine.Global.Soap.SendRequest()`

**Purpose:** Sends the SOAP request to the configured endpoint.

**Prerequisites:** Set URL, Method, and parameters

#### `ADDPARAM`
**GAB Syntax:** `Subroutine.Global.Soap.AddParam(Name, Value)`

**Purpose:** Adds a parameter to the SOAP request.

#### `SETPROPERTY`
**GAB Syntax:** `Subroutine.Global.Soap.SetProperty(PropertyName, Value)`

**Purpose:** Sets a SOAP component property.

**Common Properties:**
- `URL` - Service endpoint URL
- `Method` - SOAP method name
- `MethodURI` - Method namespace URI
- `ActionURI` - SOAP action URI

---

## Component Reference: XmlComponent

> **Provenance:** `OCTSRS\octsrs-silas-clone\ComponentDocumentation\XmlComponent.md`

- **Runtime source:** `octsrs.solution\Core\Octsrs.Runtime\Components\XmlComponent.vb`
- **Feature toggle:** N/A
- **OCTSRS conversion status:** Not Started
- **Implementation size:** ~1,621 lines

### Runtime purpose
The XML Component provides XML document manipulation functionality including creation, loading, querying, and modification of XML documents.

### Implementation notes (OCTSRS)
#### XPath Support
- Full XPath query support
- Node set iteration
- Attribute access

#### Document Management
- Multiple documents can be open
- Documents tracked by name
- Must close documents to release resources

#### Node Sets
- Query results returned as node sets
- Iteration support (Next, Back)
- Position management

#### Migration Notes
- No database interaction
- Uses .NET System.Xml
- Consider LINQ to XML for newer code

### Dependencies
#### External Dependencies
- System.Xml namespace

---

### Methods (not in agent docs)
| Method | Purpose |
|--------|---------|
| `CLOSEDOCUMENT` | Close XML document |
| `CREATEELEMENTNODE` | Create element node |
| `CREATEATTRIBUTENODE` | Create attribute node |
| `APPENDNODETOROOT` | Append to root |
| `APPENDNODEINSET` | Append in node set |
| `APPENDTEXTNODE` | Append text node |
| `DESTROYATTRIBUTENODE` | Delete attribute |
| `DELETECHILDINSET` | Delete child in set |
| `NEXT` | Move to next node |
| `BACK` | Move to previous node |
| `CLOSESET` | Close node set |
| `SETNODESETPOSITION` | Set position in set |
| `READNODESETBOUND` | Get set bounds |
| `READNODESETVALUE` | Read value from set |
| `SETNODESETVALUE` | Set value in set |
| `READNODESETATTRIBUTE` | Read attribute from set |
| `READNODEATTRIBUTE` | Read node attribute |
| `SETATTRIBUTETONODE` | Set node attribute |
| `SETATTRIBUTETOROOT` | Set root attribute |

### Key method signatures & edge cases
#### `LOADDOCUMENT`
**GAB Syntax:** `Subroutine.Global.Xml.DocumentName.LoadDocument(FilePath)`

**Purpose:** Loads an XML document from a file.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | FilePath | String | Yes | Path to XML file |

#### `QUERY`
**GAB Syntax:** `Function.Global.Xml.DocumentName.Query(XPath, Variable.Local.NodeSet)`

**Purpose:** Executes an XPath query and returns a node set.

**Parameters:**

| # | Name | Type | Required | Description |
|---|------|------|----------|-------------|
| 1 | XPath | String | Yes | XPath expression |
| R | NodeSet | Object | Yes | Return - Node set |

#### `READNODEVALUE`
**GAB Syntax:** `Function.Global.Xml.DocumentName.ReadNodeValue(NodePath, Variable.Local.Value)`

**Purpose:** Reads the value of a node at the specified path.

#### `CREATEELEMENTNODE`
**GAB Syntax:** `Subroutine.Global.Xml.DocumentName.CreateElementNode(NodeName)`

**Purpose:** Creates a new element node.

#### `SAVEDOCUMENT`
**GAB Syntax:** `Subroutine.Global.Xml.DocumentName.SaveDocument(FilePath)`

**Purpose:** Saves the XML document to a file.

---
