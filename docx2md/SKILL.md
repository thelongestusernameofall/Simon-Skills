---
name: docx2md
description: Convert Word (.docx) files to high-fidelity Markdown. Preserves tables (including vMerge), footnotes, field-code references, bibliography SDT blocks, numbered/bullet lists, images, and YAML frontmatter. Use when asked to convert a Word document to Markdown, extract text from .docx, parse a Word file for further processing, batch-convert documents, or prepare documents for RAG/LLM indexing.
---

# docx2md-cli Skill

High-fidelity Word (.docx) to Markdown converter. Built for documents where structure matters — normative texts, policies, technical specs, government docs, academic papers with citations and footnotes.

**CRITICAL WORKFLOW - Follow these steps in order:**

1. **Verify installation** — Always check `docx2md` is available before use
2. **Install if missing** — Use the platform-appropriate install method below
3. **Choose the right flags** — Match flags to the document type and use case
4. **Validate output** — Check conversion stats and review the result

---

## Installation

### Prerequisites

- Python >= 3.9
- pip or pipx (recommended for CLI tools)

### Method 1: pipx (Recommended for CLI-only use)

Isolated install, no dependency conflicts with other Python projects:

```bash
# macOS / Linux
pipx install docx2md-cli

# With frontmatter support
pipx install "docx2md-cli[frontmatter]"
```

### Method 2: pip (Global install)

```bash
# macOS / Linux
pip install docx2md-cli

# With frontmatter support
pip install "docx2md-cli[frontmatter]"

# If pip requires --user or complains about externally-managed env:
pip install --user docx2md-cli

# If system Python is restricted (PEP 668), use pipx or venv instead:
python3 -m venv ~/.docx2md-env && source ~/.docx2md-env/bin/activate && pip install docx2md-cli
```

### Method 3: pip into a virtual environment (Project-scoped)

```bash
python3 -m venv .venv
source .venv/bin/activate   # Linux/macOS
# .venv\Scripts\activate    # Windows
pip install docx2md-cli
```

### Method 4: uv (Fast alternative)

```bash
# One-off run without installing
uvx docx2md-cli input.docx

# Or install persistently
uv tool install docx2md-cli
```

### Windows-Specific Notes

```powershell
# PowerShell — pip
pip install docx2md-cli

# PowerShell — pipx
pipx install docx2md-cli

# PowerShell — uv
uv tool install docx2md-cli

# If PATH doesn't include pip scripts, add:
# %APPDATA%\Python\Python3X\Scripts  (adjust X for your Python minor version)
```

### Linux-Specific Notes

```bash
# Debian/Ubuntu — if pip is not installed
sudo apt update && sudo apt install -y python3-pip python3-venv
pip install --user docx2md-cli

# Fedora
sudo dnf install -y python3-pip
pip install --user docx2md-cli

# Arch
sudo pacman -S python-pip
pip install --user docx2md-cli
```

### Verify Installation

```bash
docx2md --version    # Should print: docx2md 0.2.0 (or later)
docx2md --help       # Should print full usage info
```

### Troubleshooting Installation

| Problem | Solution |
|---|---|
| `command not found: docx2md` | pip scripts not in PATH. Try `python3 -m docx2md_cli.cli` or add `~/.local/bin` to PATH |
| `externally-managed-environment` error | Use `pipx install docx2md-cli` or create a venv |
| `Permission denied` | Use `pip install --user docx2md-cli` or a venv |
| `lxml` build fails | Install system deps: `sudo apt install libxml2-dev libxslt1-dev` (Debian) or `brew install libxml2 libxslt` (macOS) |
| Python < 3.9 | Upgrade Python or use `uvx docx2md-cli` which manages its own Python |

---

## CLI Reference

### Basic Usage

```bash
# Simplest — outputs to input.md (same name, .md extension)
docx2md input.docx

# Specify output file
docx2md input.docx -o output.md

# Write to stdout (useful for piping)
docx2md input.docx -o -
```

### All Flags

| Flag | Description | Example |
|---|---|---|
| `-o PATH`, `--output PATH` | Write Markdown to PATH. Use `-` for stdout. Default: same name as input with `.md` extension. | `docx2md input.docx -o output.md` |
| `--extract-images DIR` | Extract embedded images to DIR and link them in the Markdown output. | `docx2md input.docx --extract-images images/` |
| `--skip-before-heading` | Skip all content before the first Heading paragraph (cover pages, TOC, version tables). | `docx2md input.docx --skip-before-heading` |
| `--frontmatter FILE` | Prepend custom YAML frontmatter from a YAML file. Requires `docx2md-cli[frontmatter]` extra. | `docx2md input.docx --frontmatter meta.yaml` |
| `--no-frontmatter` | Suppress auto-generated frontmatter from document properties. | `docx2md input.docx --no-frontmatter` |
| `-q`, `--quiet` | Suppress stats output. | `docx2md input.docx -q` |
| `--json-stats` | Print conversion stats as JSON to stderr. Machine-readable for automation. | `docx2md input.docx --json-stats` |
| `-v`, `--version` | Print installed version. | `docx2md --version` |
| `-h`, `--help` | Print help message. | `docx2md --help` |

### Flag Constraints (MUST KNOW)

These combinations will produce errors:

| Combination | Error |
|---|---|
| `--frontmatter FILE` + `--no-frontmatter` | `"--frontmatter and --no-frontmatter are mutually exclusive"` |
| `--json-stats` + `-o -` | `"--json-stats cannot be used with stdout markdown output (-o -)"` — both write to stdout |
| `--frontmatter FILE` without PyYAML | `RuntimeError: "PyYAML is required for --frontmatter or frontmatter_path. Install docx2md-cli[frontmatter] or pyyaml."` |

### Default Output Behavior

- If `-o` is omitted and input is a file → writes to `<input_stem>.md` (same name, `.md` extension)
- If `-o` is omitted and input is `-` (stdin) → defaults to `-` (stdout)

### Streaming / Piping

```bash
# Read from stdin, write to stdout
cat input.docx | docx2md - -o -

# Pipe output to another tool
docx2md input.docx -o - | wc -l

# Capture stats in a variable while writing file
docx2md input.docx --json-stats -o output.md 2>stats.json
```

---

## Common Patterns

### Pattern 1: Simple Conversion

```bash
docx2md document.docx
# Produces: document.md in the same directory
```

### Pattern 2: Conversion with Image Extraction

```bash
docx2md document.docx -o document.md --extract-images images/
# Produces: document.md + images/ directory with extracted images
# Markdown will contain relative image links like: ![Figure 1](images/figure-1.png)
```

### Pattern 3: Skip Cover Pages / TOC

For documents with cover pages, table of contents, or version tables before the real content:

```bash
docx2md policy.docx --skip-before-heading -o policy.md
```

### Pattern 4: Custom Frontmatter

Create a `meta.yaml` file:

```yaml
title: "Company Policy Document"
author: "Legal Team"
date: "2026-01-15"
tags:
  - policy
  - internal
```

Then:

```bash
docx2md policy.docx --frontmatter meta.yaml -o policy.md
```

### Pattern 5: Clean Output for LLM/RAG Processing

No frontmatter, no stats — just the Markdown content:

```bash
docx2md document.docx --no-frontmatter -q -o output.md
```

### Pattern 6: Machine-Readable Stats for Automation

```bash
# Get stats as JSON
docx2md document.docx --json-stats -q -o output.md 2>stats.json

# Example stats.json content:
# {"lines": 342, "bytes": 18420, "headings": 12, "table_rows": 45,
#  "figures": 3, "bold": 28, "footnotes": 8, "refs": 15,
#  "tables_inserted": 4, "tables_total": 4, "underlined": 5,
#  "ordered_list_items": 22, "nested_items": 6}
```

### Pattern 7: Batch Conversion (Multiple Files)

```bash
# Bash — convert all .docx files in a directory
for f in *.docx; do
  docx2md "$f" -q --no-frontmatter
done

# Bash — with image extraction per document
for f in *.docx; do
  name="${f%.docx}"
  docx2md "$f" -o "${name}.md" --extract-images "${name}-images" -q
done

# PowerShell
Get-ChildItem *.docx | ForEach-Object { docx2md $_.Name -q --no-frontmatter }
```

### Pattern 8: CI/CD Integration

```yaml
# GitHub Actions example
- name: Convert DOCX to Markdown
  run: |
    pip install docx2md-cli
    for f in docs/*.docx; do
      docx2md "$f" -q --no-frontmatter
    done
```

```bash
# Pre-commit hook (add to .git/hooks/pre-commit)
# Auto-convert tracked .docx files before commit
git diff --cached --name-only | grep '\.docx$' | while read f; do
  docx2md "$f" -q --no-frontmatter
  git add "${f%.docx}.md"
done
```

---

## Python API

For programmatic use within Python scripts or agents:

```python
from docx2md_cli import convert

# Basic conversion
result = convert("input.docx", output_path="output.md")

# Full-featured
result = convert(
    "input.docx",              # str path, bytes, or BinaryIO
    output_path="output.md",   # str | None — None means auto-derive from input
    images_dir="images",       # str | None — directory for extracted images
    skip_before_heading=True,  # skip cover pages / TOC
    frontmatter_path=None,     # str | None — path to custom YAML frontmatter file
    frontmatter_dict=None,     # dict | None — frontmatter fields as dict
    no_frontmatter=False,      # disable all frontmatter
    print_stats=True,          # print human-readable stats
    json_stats=False,          # emit stats as JSON
    stats_stream=None,         # TextIO | None — custom stream for stats
)

# Access results
lines = result.lines          # list[str] — Markdown lines
stats = result.stats          # dict — conversion counters
json_str = result.as_json()   # str — JSON string of stats

# result is list-like for backward compatibility
first_three = result[:3]
total_lines = len(result)
```

### Stats Dict Keys

| Key | Description |
|---|---|
| `lines` | Total lines of Markdown output |
| `bytes` | Total bytes of Markdown output |
| `headings` | Number of headings found |
| `table_rows` | Total table rows processed |
| `figures` | Number of figures/images |
| `bold` | Number of bold text segments |
| `footnotes` | Number of footnotes |
| `refs` | Number of field-code references |
| `tables_inserted` | Tables inserted into output |
| `tables_total` | Total tables detected |
| `underlined` | Underlined text segments |
| `ordered_list_items` | Ordered list items |
| `nested_items` | Nested list items |

### Frontmatter Priority Chain (Highest to Lowest)

1. `no_frontmatter=True` → no frontmatter at all (complete suppression)
2. `frontmatter_dict={}` → suppresses frontmatter (empty dict = no output)
3. `frontmatter_dict={"key": "val"}` → uses provided dict (overrides everything below)
4. `frontmatter_path="meta.yaml"` → loads YAML file
5. **Auto-generated** from `doc.core_properties` (title, author, date, updated, source)

Auto-generated frontmatter only appears if `title` or `author` is present in document properties.

Special YAML value handling:
- List values render as YAML list (`key:\n  - item`)
- String values containing `:#{}[]|>&*!` are auto-quoted

### Image Extraction Details

When using `--extract-images DIR`:

- Images are extracted from `word/media/` inside the docx ZIP archive
- **Caption-derived renaming**: If a caption paragraph follows the image, the image is renamed:
  - With matching caption (e.g., "Figure 3. System Architecture"): `fig03-system-architecture.png`
  - Without matching caption: `fig-<slugified-caption-text>.png`
- The slug function normalizes Unicode, strips special chars, limits to 60 chars
- Image paths in Markdown are **relative** to the output file's directory
- When output is stdout (`-o -`), image paths use the basename of the images directory
- The directory is created automatically if it doesn't exist

### Python API — Advanced Examples

```python
from docx2md_cli import convert
import json

# Convert and inspect stats programmatically
result = convert("report.docx", output_path="report.md", print_stats=False)
if result.stats["footnotes"] > 0:
    print(f"Document has {result.stats['footnotes']} footnotes")
if result.stats["table_rows"] > 100:
    print("Warning: large table detected, review formatting")

# Convert from bytes (e.g., downloaded file)
with open("downloaded.docx", "rb") as f:
    content = f.read()
result = convert(content, output_path="output.md")

# Custom frontmatter as dict (overrides auto-generated)
result = convert(
    "input.docx",
    output_path="output.md",
    frontmatter_dict={"source": "internal-wiki", "version": 2},
)

# Suppress frontmatter entirely via empty dict
result = convert("input.docx", output_path="output.md", frontmatter_dict={})

# Pipe to stdout from Python
result = convert("input.docx", output_path="-", no_frontmatter=True, print_stats=False)
```

---

## What It Preserves (That Others Don't)

| Feature | docx2md-cli | Pandoc | MarkItDown | mammoth |
|---|---|---|---|---|
| Bold / Italic / Underline | Yes | Yes | No | Yes |
| Footnotes (inline position) | Yes | Yes | No | Yes |
| Field codes (`[N]` refs) | Yes | Partial | No | No |
| Bibliography (SDT) | Yes | No | No | No |
| Vertical merge (vMerge) | Yes | No | No | No |
| Split table detection | Yes | No | No | No |
| Numbered list distinction | Yes | Yes | No | No |
| Nested list levels | Yes | Yes | No | No |
| Image extraction + rename | Yes | Yes | No | No |
| YAML frontmatter | Yes | No | No | No |

---

## Supported Languages (Caption Matching)

Caption matching currently recognizes:

- Spanish: `Figura`, `Tabla`
- English: `Figure`, `Table`
- French: `Tableau`
- German: `Abbildung`, `Tabelle`
- Portuguese: `Tabela`
- Italian: `Tabella`

Word heading detection follows the standard `Heading N` style names.

---

## Decision Guide: When to Use This Skill

### Use docx2md-cli when:

- Converting normative documents, policies, or technical specs from Word to Markdown
- Preparing Word documents for RAG indexing or LLM retrieval
- Parsing complex Word documents with footnotes, field codes, bibliography, nested tables
- Extracting structured content where Pandoc/MarkItDown/mammoth lose fidelity
- Batch-converting multiple .docx files in CI/CD pipelines
- Need machine-readable stats about the conversion
- Need YAML frontmatter from document properties

### Do NOT use docx2md-cli when:

- Simple plain-text extraction only → use `markitdown` or `python-docx` directly
- PDF conversion → use `nano-pdf`, `pdftotext`, or `marker`
- Editing Word files → use `python-docx`
- HTML output → use `mammoth`
- Converting to formats other than Markdown → use `pandoc`

---

## Agent-Friendly Usage

When operating as an AI agent, prefer these patterns for reliable, parseable output:

```bash
# Quiet conversion with stats capture
docx2md input.docx -q --json-stats -o output.md 2>stats.json

# Stdout for inline processing
docx2md input.docx -o - --no-frontmatter -q

# Verify conversion quality via stats
docx2md input.docx --json-stats 2>&1 | python3 -c "
import sys, json
stats = json.loads(sys.stdin.read().split('\n')[-1] if '\n' in sys.stdin.read() else sys.stdin.read())
if stats.get('footnotes', 0) > 0 or stats.get('tables_total', 0) > 0:
    print('Complex document — review output carefully')
else:
    print('Simple document — conversion likely clean')
"
```

```python
# Python API for agent workflows
from docx2md_cli import convert

result = convert("input.docx", print_stats=False, no_frontmatter=True)
stats = result.stats
payload = result.as_json()

# Quality check
if stats["table_rows"] > 0 and stats["tables_inserted"] < stats["tables_total"]:
    print("WARNING: Some tables may not have rendered correctly")
```

---

## Troubleshooting

| Problem | Cause | Solution |
|---|---|---|
| `command not found: docx2md` | Not installed or not in PATH | Install via `pipx install docx2md-cli` or check PATH includes `~/.local/bin` |
| `ModuleNotFoundError: No module named 'yaml'` | Frontmatter extra not installed | Run `pip install "docx2md-cli[frontmatter]"` |
| `"--frontmatter and --no-frontmatter are mutually exclusive"` | Both flags used together | Use only one: `--frontmatter FILE` OR `--no-frontmatter` |
| `"--json-stats cannot be used with stdout markdown output"` | Both `--json-stats` and `-o -` used | Write to file with `-o output.md` when using `--json-stats` |
| Images not extracted | `--extract-images` not specified | Add `--extract-images DIR` flag |
| Cover page / TOC in output | Pre-heading content included | Add `--skip-before-heading` flag |
| Frontmatter appears unwanted | Auto-generated from doc properties | Add `--no-frontmatter` flag |
| Tables look broken in output | Complex vMerge or split tables | Review manually; file issue at https://github.com/gonzalopezgil/docx2md-cli/issues |
| `lxml` import error | Missing system dependency | Install `libxml2-dev libxslt1-dev` (Debian) or `libxml2 libxslt` (macOS/Homebrew) |
| Large file slow/hangs | Very large .docx with many images | Use `--extract-images` to offload; consider splitting document first |
| Encoding issues in output | Non-UTF8 characters | Ensure locale supports UTF-8: `export LANG=en_US.UTF-8` |
| Custom heading styles not detected | Heading detection uses `Heading N` style names only | Rename styles in Word to use standard `Heading 1`, `Heading 2`, etc. |
| Underline renders as `<u>` HTML tags | CommonMark has no underline syntax | This is expected; post-process if pure Markdown is required |

---

## Known Limitations

1. **No Homebrew/Docker distribution** — PyPI only. Use `pip`, `pipx`, or `uv`.
2. **No recursive directory conversion** — Must script batch conversion manually (see Pattern 7).
3. **No config file support** — All options are CLI flags or Python API params.
4. **Heading detection relies on Word style names** — Only matches `Heading N` styles; custom-named heading styles are not detected.
5. **TOC detection is style-name-based** — Paragraphs with `table of` or `toc` in style name are skipped, but TOC fields are not detected.
6. **Underline renders as HTML `<u>` tags** — Not pure Markdown (CommonMark has no underline syntax).
7. **Caption matching is regex-based** — May miss non-standard caption formats.
8. **No progress indicator** — Large documents convert silently.
9. **`--json-stats` + `-o -` is mutually exclusive** — Both would write to stdout; use `-o output.md` instead.

---

## Quick Reference Card

```
# Install
pipx install docx2md-cli                          # recommended
pip install docx2md-cli                            # alternative
pip install "docx2md-cli[frontmatter]"             # with frontmatter support
uvx docx2md-cli input.docx                         # one-off, no install

# Convert
docx2md input.docx                                 # → input.md
docx2md input.docx -o output.md                    # → output.md
docx2md input.docx -o -                            # → stdout

# With features
docx2md input.docx --extract-images img/           # extract images
docx2md input.docx --skip-before-heading           # skip cover/TOC
docx2md input.docx --frontmatter meta.yaml         # custom frontmatter
docx2md input.docx --no-frontmatter                # no frontmatter

# Automation
docx2md input.docx -q -o output.md                 # quiet mode
docx2md input.docx --json-stats -o output.md       # stats as JSON
cat input.docx | docx2md - -o -                    # pipe through

# Batch
for f in *.docx; do docx2md "$f" -q; done          # all files in dir

# Verify
docx2md --version                                  # check version
docx2md --help                                     # full help
```
