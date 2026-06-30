---
name: generate-quote-docx
description: >-
  Generate professional DOCX (Word) quotes/specs for GAB development projects using
  a structured JSON content file and a Python generator script. Use when quoting a
  project, generating a spec, creating a ServiceWeb quote, or when the user says
  "quote this" for an RFQ document.
---

# DOCX Quote Generator

Generate styled Word documents matching the GSS ServiceWeb 3-section quote format.

## Dependencies

- `python-docx` >= 1.2.0
- `Pillow` >= 12.0.0 (for architecture diagrams)

## Usage

1. Build a JSON content file following the schema below
2. Run the generator:

```bash
python "{skill_dir}/scripts/generate_quote_docx.py" <content.json> "<output.docx>"
```

Or copy the script into your project's `scripts/` folder first for portability.

## JSON Content Schema

```json
{
  "meta": {
    "customer_name": "Company Name",
    "customer_abbreviation": "ABBREV",
    "project_title": "Project Title",
    "quote_rev": "QUOTE-REV",
    "expiration_date": "Month DD, YYYY",
    "contact": "Contact Name",
    "call_reference": "CALL-REF",
    "classification": "Type A Block-Hour | Type B T&M | Type C Quick Fix | Type D Support",
    "is_modification": false
  },
  "section1_description": {
    "executive_summary": ["paragraph1", "paragraph2"],
    "assumptions": ["assumption1", "assumption2"],
    "prerequisites": ["prereq1"]
  },
  "section2_specifications": {
    "scope_items": [
      {"number": 1, "title": "Feature", "description": "desc", "sub_items": ["detail"]}
    ],
    "deliverables": [
      {"id": "D-01", "deliverable": "Name", "type": "GAB", "description": "desc"}
    ],
    "test_cases": [
      {
        "id": "TC-01", "title": "Title", "reference": "optional",
        "objective": "What is verified",
        "steps": ["step1", "step2"],
        "expected_results": ["result1"]
      }
    ]
  },
  "section3_technical": {
    "content_blocks": [
      {"type": "heading", "level": 3, "text": "Section Title"},
      {"type": "sub_heading", "number": "3.1", "title": "Sub", "paragraphs": [], "bullets": []},
      {"type": "table", "columns": ["Col1"], "rows": [["val"]]},
      {"type": "code_block", "title": "File", "lines": [{"text": "code"}, {"comment": "# note"}]},
      {"type": "callout", "style": "info|warning|success", "title": "Title", "content": "Body"}
    ],
    "architecture": {
      "title": "Architecture Overview",
      "subtitle": "optional",
      "boxes": [
        {"name": "System", "subtitle": "Type", "details": "Extra", "color": "purple|dark|amber|green", "row": 0}
      ],
      "connections": [
        {"direction": "READ", "protocol": "ODBC"}
      ]
    },
    "integration_points": [
      {"module": "Module", "direction": "READ|WRITE|READ / WRITE", "description": "desc"}
    ],
    "screenshots": [
      {"caption": "Title", "path": "relative/path.png", "description": "desc", "interactions": ["bullet"]}
    ]
  },
  "quote_details": {
    "line_items": [
      {"sequence": 1, "type": "GAB", "hours": 80, "rate": 225.00, "total": 18000.00, "description": "desc"},
      {"type": "Buffer", "hours": 15, "rate": 225.00, "total": 3375.00, "description": "15% contingency", "is_buffer": true}
    ],
    "total_hours": 95,
    "total_amount": 21375.00
  }
}
```

## Inline Markdown

JSON string values support: `**bold**`, `*italic*`, `` `code` ``
