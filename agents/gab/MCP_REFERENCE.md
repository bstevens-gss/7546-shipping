# MCP Intelligence Reference for GAB Development
# Full reference for MCP-connected verification and research tools
# Load this file when debugging, investigating ERP behavior, or when MCP tiebreaker is needed
---

MCP Intelligence (`user-mcp-intelligence`) is a single gateway to 11 downstream servers providing authoritative GAB reference data. When connected, it is the **preferred source of truth** for API validation, COBOL business logic, and documentation. When disconnected, fall back to local tools.

## Usage: All downstream tools via one call

```
CallMcpTool(
  server: "user-mcp-intelligence",
  toolName: "call_proxy_tool",
  arguments: { "server": "<downstream>", "tool_name": "<tool>", "arguments": "<json-string>" }
)
```

**CRITICAL**: The `arguments` field inside `call_proxy_tool` is a **JSON string**, not a nested object. Always stringify.

## Key Downstream Servers for GAB Development

### 1. gab-commands (5,421 definitions -- authoritative GAB API reference)

| Tool | Purpose |
|------|---------|
| `validate_gab_command` | Pass `commandName` + optional `arguments` object, returns `isValid` + errors/warnings |
| `search_gab_commands` | Find commands by keyword or natural language description |
| `get_gab_command_details` | Full overloads, argument types, HelpJuice article IDs |
| `generate_gab_syntax` | Generate properly-formatted GAB code line from args |

**ODBC validation gotcha**: Instance-based commands require the **wildcard form**:
- CORRECT: `Function.ODBC.Connection!*con.Execute`
- WRONG: `Function.ODBC.Connection!con.Execute` (literal instance name fails lookup)

### 2. cobol-codebase (Core ERP business logic -- COBOL programs)

| Tool | Purpose |
|------|---------|
| `get_program_summary` | One-call overview of any COBOL program (START HERE) |
| `search_cobol_code` | Regex search across all COBOL source files |
| `read_cobol_file` | Read specific source with line numbers |
| `get_call_graph` | Program-to-program CALL relationships |
| `analyze_business_logic` | Extract paragraphs with verb profiles and purposes |

### 3. book-of-armaments (HelpJuice knowledge base)

| Tool | Purpose |
|------|---------|
| `search` | Semantic search across HelpJuice articles + tribal knowledge |
| `get_article` | Full article by ID (e.g., CallWrapper Modes = article 1345287) |

### 4. log-parser (OCTSRS/GSSEO log analysis)

| Tool | Purpose |
|------|---------|
| `upload_log` + `get_errors` | Upload trace files, extract ERROR/WARN records |
| `correlate_logs` | Merge multiple logs into unified timeline |

## Fallback Hierarchy (when MCP is NOT connected)

| Need | MCP Intelligence route | Local Fallback |
|------|----------------------|----------------|
| Validate GAB command | `gab-commands` → `validate_gab_command` | `Validate-GabApi.ps1` (1,683 methods, skips ODBC) |
| Command details/overloads | `gab-commands` → `get_gab_command_details` | `agents/gab/*.md` reference files |
| Core ERP logic (COBOL) | `cobol-codebase` → `search_cobol_code` | No local fallback |
| CallWrapper docs | `book-of-armaments` → `search` | `agents/gab/CALLWRAPPERS.md` + `CW_*.md` |
| Log analysis | `log-parser` → `upload_log` + `get_errors` | Manual read of `%TEMP%\GSS\*.debug` |

## OCTSRS Source (GAB Runtime Engine) -- NOT on any MCP

OCTSRS is the VB.NET/C# runtime engine that executes GAB scripts. It is **not available via MCP Intelligence or any downstream server**.

- `gab-commands` MCP has the **extracted definitions** (5,421 commands) -- validates whether a command EXISTS
- Deep runtime implementation details (HOW something works internally) require a local OCTSRS clone -- not all devs have this
- Document local OCTSRS paths in `AGENTS.PROJECT.md` only (workspace-specific, not shared)

## When to Use MCP vs Local

- **Writing new code**: Use `gab-commands` → `validate_gab_command` to verify function calls if not found in local docs
- **Investigating ERP behavior**: Use `cobol-codebase` → `get_program_summary` to understand what core programs do
- **Looking up CallWrapper parameters**: Use `book-of-armaments` → `search` for mode numbers, parameter orders
- **Debugging runtime failures**: Use `log-parser` → `upload_log` to analyze OCTSRS trace files
- **VS Code shows a squiggly**: Do NOT assume the command is invalid. Check `gab-commands` → `validate_gab_command` first
