# Simon-Skills

Claude Code skills for enhanced productivity.

## Quick Start

### Clone & Install

```bash
# Clone repository
git clone git@github.com:thelongestusernameofall/Simon-Skills.git Simon-Skills

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

### Available Commands

| Command | Description |
|---------|-------------|
| `./install.sh` | Install all skills + ag |
| `./install.sh install-ag` | Install ag only |
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

## Requirements

- [The Silver Searcher (ag)](https://github.com/ggreer/the_silver_searcher) - for ag-silversearcher skill

Install on your platform:

- **macOS:** `brew install the_silver_searcher`
- **Ubuntu/Debian:** `sudo apt install silversearcher-ag`
- **Fedora:** `sudo dnf install the_silver_searcher`
- **Arch:** `sudo pacman -S the_silver_searcher`
- **Windows:** `scoop install ag` or `choco install the-silver-searcher`

## License

MIT
