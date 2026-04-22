# Simon-Skills

Claude Code skills for enhanced productivity.

## Quick Start

### Clone & Install

```bash
# Clone repository
git clone https://github.com/thelongestusernameofall/Simon-Skills.git Simon-Skills

# Enter directory
cd Simon-Skills

# Run installer
./install.sh

# Verify installation
./install.sh list
```

### Install ag (Optional)

The `ag-silversearcher` skill requires The Silver Searcher (ag):

```bash
# Install ag only
./install.sh install-ag
```

### Install docx2md-cli (Optional)

The `docx2md` skill requires [docx2md-cli](https://github.com/gonzalopezgil/docx2md-cli) (Python >= 3.9):

```bash
# Install docx2md-cli only
./install.sh install-docx2md
```

### Available Commands

| Command | Description |
|---------|-------------|
| `./install.sh` | Install all skills + dependencies |
| `./install.sh install-ag` | Install ag only |
| `./install.sh install-docx2md` | Install docx2md-cli only |
| `./install.sh list` | List installed skills |
| `./install.sh help` | Show help |

## Skills

### ag-silversearcher

The Silver Searcher (ag) documentation for fast code/content search.

**Usage:** Use ag instead of grep for any search task.

```bash
# Search for pattern
ag "pattern"

# Find files by name
ag -g "*.js"

# Count matches
ag -c "pattern"
```

### docx2md

High-fidelity Word (.docx) to Markdown converter. Preserves tables (vMerge), footnotes, field-code references, bibliography, numbered/bullet lists, images, and YAML frontmatter — where Pandoc and others fall short.

**Usage:** Convert Word documents to Markdown with full structure preservation.

```bash
# Basic conversion
docx2md input.docx

# With image extraction
docx2md input.docx -o output.md --extract-images images/

# Skip cover pages / TOC
docx2md input.docx --skip-before-heading

# Clean output for LLM/RAG processing
docx2md input.docx --no-frontmatter -q -o output.md

# Machine-readable stats
docx2md input.docx --json-stats -o output.md

# Batch convert
for f in *.docx; do docx2md "$f" -q; done
```

**Key features vs alternatives:**

| Feature | docx2md-cli | Pandoc | MarkItDown | mammoth |
|---------|:-----------:|:------:|:----------:|:-------:|
| Field codes / citations | ✅ | Partial | ❌ | ❌ |
| Bibliography (SDT) | ✅ | ❌ | ❌ | ❌ |
| Vertical merge (vMerge) | ✅ | ❌ | ❌ | ❌ |
| Inline footnotes | ✅ | ✅ | ❌ | ✅ |
| YAML frontmatter | ✅ | ❌ | ❌ | ❌ |

## Requirements

- [The Silver Searcher (ag)](https://github.com/ggreer/the_silver_searcher) - for ag-silversearcher skill
- [docx2md-cli](https://github.com/gonzalopezgil/docx2md-cli) (Python >= 3.9) - for docx2md skill

Install on your platform:

**ag (The Silver Searcher):**

- **macOS:** `brew install the_silver_searcher`
- **Ubuntu/Debian:** `sudo apt install silversearcher-ag`
- **Fedora:** `sudo dnf install the_silver_searcher`
- **Arch:** `sudo pacman -S the_silver_searcher`
- **Windows:** `scoop install ag` or `choco install the-silver-searcher`

**docx2md-cli:**

- **All platforms:** `pipx install docx2md-cli` (recommended) or `pip install docx2md-cli`
- **One-off (no install):** `uvx docx2md-cli input.docx`
- **With frontmatter support:** `pipx install "docx2md-cli[frontmatter]"`

## License

MIT
