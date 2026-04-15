---
name: ag-searcher
description: Use this skill when the user wants to search for text, strings, patterns, regex, find files, find directories, or perform any content search/replacement tasks. The Silver Searcher (ag) is faster and more efficient than grep/rg. Use for all text search, file search, content replacement validation, and code search tasks across any file type.
---

# The Silver Searcher (ag) - Universal Search Tool

Use ag (The Silver Searcher) for any search task. It is significantly faster than grep and provides intelligent defaults for searching files, directories, and content.

## Overview

ag is a fast, general-purpose search tool that can replace grep for almost all use cases:
- **Text/String search**: Find any string in files
- **Regex matching**: Full regex pattern support
- **File finding**: Find files by name or content
- **Directory search**: Search within directories
- **Content analysis**: Count, filter, process search results
- **Code search**: Specialized for code (but not limited to)

## Verify Installation

```bash
which ag && ag --version
```

If not installed, install for your platform:

```bash
# macOS
brew install the_silver_searcher

# Ubuntu/Debian
sudo apt install silversearcher-ag

# Fedora
sudo dnf install the_silver_searcher

# Arch Linux
sudo pacman -S the_silver_searcher

# openSUSE
sudo zypper install the_silver_searcher

# Alpine Linux
apk add the_silver_searcher

# Windows (WSL)
sudo apt install silversearcher-ag

# Windows (Scoop)
scoop install ag

# Windows (Chocolatey)
choco install the-silver-searcher
```

## Basic Search

**Search for a pattern in current directory:**

```bash
ag "pattern"
```

**Search in specific path:**

```bash
ag "pattern" /path/to/search
ag "pattern" ./relative/path
```

**Search case-insensitively:**

```bash
ag -i "pattern"
```

**Search case-sensitively:**

```bash
ag -s "pattern"
```

**Search single file:**

```bash
ag "pattern" specific-file.txt
```

## Output Control

**Show only filenames (contains match):**

```bash
ag -l "pattern"
```

**Show only filenames WITHOUT match:**

```bash
ag -L "pattern"
```

**Count matches per file:**

```bash
ag -c "pattern"
```

**Show total count only:**

```bash
ag -c "pattern" | tail -1
```

**Show line numbers:**

```bash
ag -n "pattern"
ag --numbers "pattern"
```

**Show column numbers:**

```bash
ag --column "pattern"
```

**Show only matching part of line:**

```bash
ag -o "pattern"
```

**Print context lines:**

```bash
ag -C 3 "pattern"     # 3 lines before and after
ag -A 5 "pattern"      # 5 lines after match
ag -B 2 "pattern"      # 2 lines before match
```

**Vimgrep format (Vim integration):**

```bash
ag --vimgrep "pattern"
```

**Print filename before matches:**

```bash
ag -H "pattern"
ag --heading "pattern"
```

**Suppress filename (single file):**

```bash
ag -h "pattern"
ag --noheading "pattern"
```

**Color control:**

```bash
ag --color "pattern"       # Force color
ag --no-color "pattern"     # No color (for piping)
```

## Pattern Matching

**Literal search (no regex):**

```bash
ag -Q "literal.string"
ag --literal "literal.string"
```

**Whole word matching:**

```bash
ag -w "pattern"
ag --word-regexp "pattern"
```

**Invert match (exclude lines with pattern):**

```bash
ag -v "pattern"
ag --invert-match "pattern"
```

**Smart case (default - uppercase = case-sensitive):**

```bash
ag -S "pattern"
ag --smart-case "pattern"
```

**Fixed strings (like grep -F):**

```bash
ag -F "pattern"
ag --fixed-strings "pattern"
```

## File Type Restrictions

**Search by file type:**

```bash
ag "pattern" --js           # JavaScript
ag "pattern" --ts           # TypeScript
ag "pattern" --python       # Python
ag "pattern" --go           # Go
ag "pattern" --java         # Java
ag "pattern" --rb           # Ruby
ag "pattern" --php          # PHP
ag "pattern" --c            # C
ag "pattern" --cpp          # C++
ag "pattern" --hs           # Haskell
ag "pattern" --rust         # Rust
ag "pattern" --swift        # Swift
ag "pattern" --kt           # Kotlin
ag "pattern" --scala        # Scala
ag "pattern" --html         # HTML
ag "pattern" --css          # CSS
ag "pattern" --scss         # SCSS
ag "pattern" --xml          # XML
ag "pattern" --json         # JSON
ag "pattern" --yaml         # YAML
ag "pattern" --md           # Markdown
ag "pattern" --txt          # Text files
```

**All text files (excluding binary):**

```bash
ag -t "pattern"
ag --all-text "pattern"
```

**Search all files (includes hidden):**

```bash
ag -a "pattern"
ag --all-types "pattern"
```

Run `ag --list-file-types` for complete list.

## File/Directory Control

**Ignore patterns (global .ignore):**

```bash
ag --ignore "*.log" "pattern"
ag --ignore "*.tmp" "pattern"
ag --ignore "*.cache" "pattern"
```

**Ignore directories:**

```bash
ag --ignore-dir node_modules "pattern"
ag --ignore-dir dist "pattern"
ag --ignore-dir build "pattern"
ag --ignore-dir .git "pattern"
ag --ignore-dir vendor "pattern"
```

**Custom ignore file:**

```bash
ag --path-to-ignore /path/to/.ignore "pattern"
```

**Skip VCS ignore files:**

```bash
ag --skip-vcs-ignores "pattern"
```

**Search hidden files:**

```bash
ag --hidden "pattern"
```

**Unrestricted (ignore all ignore files):**

```bash
ag -u "pattern"
ag --unrestricted "pattern"
```

**Limit directory depth:**

```bash
ag --depth 3 "pattern"
```

**Follow symlinks:**

```bash
ag -f "pattern"
ag --follow "pattern"
```

**One device (don't follow symlinks to other devices):**

```bash
ag --one-device "pattern"
```

## File Finding

**Find files by name:**

```bash
ag -g "filename"
ag -g "*.js"
ag -g "package.json"
```

**Find files by regex in content:**

```bash
ag -G "\.tsx$" "pattern"
ag --file-search-regex "\.js$" "pattern"
```

## Binary and Compression

**Search binary files:**

```bash
ag --search-binary "pattern"
```

**Search compressed files (gzip):**

```bash
ag -z "pattern"
ag --search-zip "pattern"
```

## Performance Options

**Maximum matches per file:**

```bash
ag -m 100 "pattern"
ag --max-count 100 "pattern"
```

**Print search statistics:**

```bash
ag --stats "pattern"
```

**Stats only (total count):**

```bash
ag --stats-only "pattern"
```

**Debug mode:**

```bash
ag -D "pattern"
ag --debug "pattern"
```

## Common Usage Patterns

### Text/String Search

**Find any string:**

```bash
ag "hello world"
```

**Find in current directory:**

```bash
ag "pattern" .
```

**Find recursively:**

```bash
ag "pattern" ~/
```

### File Finding

**Find all files with extension:**

```bash
ag -g "\.js$"
ag -g "\.ts$"
ag -g "\.py$"
```

**Find config files:**

```bash
ag -g "config"
ag -g "*.json"
```

### Content Analysis

**Count all occurrences:**

```bash
ag -c "pattern"
```

**Count per file, sorted:**

```bash
ag -c "pattern" | sort -n
```

**Find files with most matches:**

```bash
ag -c "pattern" | sort -n -t: -k2
```

### Filter and Process

**Find but exclude some results:**

```bash
ag "pattern" | grep -v "exclude"
```

**Get unique matches:**

```bash
ag -o "pattern" | sort -u
```

**Get only first match per file:**

```bash
ag -l "pattern" | head -20
```

### Multi-Pattern Search

**OR: Files with any pattern:**

```bash
ag -l "pattern1" ; ag -l "pattern2"
```

**AND: Files with both patterns:**

```bash
ag -l "pattern1" | xargs ag -l "pattern2"
```

**NOT: Files with pattern1 but not pattern2:**

```bash
comm -23 <(ag -l "pattern1" | sort) <(ag -l "pattern2" | sort)
```

### Development Tasks

**Find TODO/FIXME:**

```bash
ag -n "TODO"
ag -n "FIXME"
ag -n "XXX"
```

**Find function definitions:**

```bash
ag -n "def " --python
ag -n "function " --js
ag -n "func " --go
```

**Find imports:**

```bash
ag -n "^import " --python
ag -n "^const " --js
```

**Find console.log/print:**

```bash
ag -n "console.log" --js
ag -n "print(" --python
```

**Find error handling:**

```bash
ag -n "catch" --js
ag -n "except" --python
```

### Search Replace (Validation)

**Find all occurrences before replace:**

```bash
ag -n "old_pattern"
```

**Validate replacement pattern:**

```bash
ag -n "new_pattern"
```

## Integration

### Shell/Pipes

**Pipe to head:**

```bash
ag "pattern" | head -20
```

**Pipe to tail:**

```bash
ag "pattern" | tail -20
```

**Count results:**

```bash
ag "pattern" | wc -l
```

### xargs

**Edit files found:**

```bash
ag -l "pattern" | xargs sed -i 's/old/new/g'
```

**Copy files found:**

```bash
ag -l "pattern" | xargs cp -t /destination/
```

**Open in editor:**

```bash
ag -l "pattern" | xargs $EDITOR
```

### Vim

**Search in current file:**

```bash
:!ag "pattern" %
```

**Quickfix from ag:**

```bash
:grep "pattern" %   # Native Vim
```

### VS Code

Use output in terminal panel.

### Git

**Search in tracked files:**

```bash
git grep "pattern"
```

**Compare with ag (faster):**

```bash
ag "pattern" $(git rev-parse --show-toplevel)
```

## Tips

1. **Faster than grep** - Use ag by default for any search
2. **Intelligent defaults** - Respects .gitignore automatically
3. **Smart case** - Case-insensitive unless pattern has uppercase
4. **Color output** - Use `--no-color` when piping
5. **Stats** - Use `--stats` to see performance metrics

## Troubleshooting

**No results in expected location:**
- Check if directory is in .gitignore
- Try `--skip-vcs-ignores` or `-u`

**Pattern not found:**
- Try `-i` for case-insensitive
- Try `-Q` for literal match

**Too many results:**
- Use `-C` for context
- Use `--depth` to limit depth

**ag not found:**
- Install per platform instructions above

## ag vs Other Tools

| Scenario | Recommended Tool |
|----------|------------------|
| General search (default) | `ag` |
| AST-aware code analysis | `ast-grep` |
| Very large files | `rg` |
| Portable scripts | `grep` |
| Windows native | `rg` (ripgrep) |

ag is the best choice for most search tasks due to speed and intelligent defaults.
