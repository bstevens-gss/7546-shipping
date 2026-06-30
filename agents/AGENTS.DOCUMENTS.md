---
AGENT_TITLE: Document Extraction Protocol
AGENT_DESCRIPTION: Procedure for fully extracting text and embedded images from PDF, DOCX, and Word documents so no stakeholder context is lost.
AGENT_USAGE: Load whenever a PDF, DOCX, or Word file is referenced (RFQs, change requests, specs, bug reports with screenshots).
---

# Document Extraction Protocol

> **When to use this file:** Any time a PDF, DOCX, or Word file is referenced -- RFQs, change requests, supplemental specs, bug reports with screenshots, stakeholder attachments, or any document with embedded images.

Cursor's Read tool extracts text from PDFs but **loses embedded images**. DOCX support is limited. Stakeholder documents frequently contain annotated screenshots, workflow diagrams, UI mockups, and marked-up images that carry critical context. This protocol ensures nothing is lost.

---

## Protocol

When you encounter a reference to a `.pdf` or `.docx` file:

### 1. Check for existing extraction

Look for `{filename}_extracted/content.md` next to the source file. If it exists and is **newer** than the source, skip to step 3.

### 2. Run extraction

```
python "{project_root}/tools/extract-document.py" "{file_path}"
```

The script outputs:
```
{filename}_extracted/
  content.md       -- Markdown text with ![image](images/...) references
  images/          -- Extracted PNG/JPG files
  manifest.json    -- Image metadata (page, position, dimensions)
```

If `pymupdf4llm` or `python-docx` is not installed, install first:
```
pip install -r "{project_root}/tools/requirements.txt"
```

### 3. Read extracted content

1. **Read `content.md`** for the full text with image placeholders
2. **Read each image** in the `images/` directory using the Read tool (supports JPEG, PNG, GIF, WEBP)
3. **Cross-reference** `![image](images/...)` placeholders in content.md with the actual images you read

### 4. Describe visual content

When reading images, describe what you see:
- Screenshots: identify UI elements, labels, data shown, annotations
- Diagrams: describe flow, components, relationships
- Tables rendered as images: extract the data into text
- Annotations/markup: note highlighted areas, arrows, handwritten notes

Relate every image back to the surrounding text context from content.md.

---

## Supported Formats

| Format | Engine | Images | Tables | OCR |
|--------|--------|--------|--------|-----|
| `.pdf` | pymupdf4llm | Extracted to PNG | Layout-aware | Auto-detected |
| `.docx` | zipfile + python-docx | From word/media/ | Parsed to Markdown | N/A |
| `.doc` | Not supported | -- | -- | Save as .docx first |

---

## Lifecycle

- Extracted folders (`*_extracted/`) should live alongside the source documents
- Track all stakeholder documents in `AGENTS.PROJECT.md` under Supplemental Documents
- Re-run extraction with `--force` if the source document is updated
