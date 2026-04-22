#!/bin/bash
#
# Simon-Skills Installer
# One-click installation for Claude Code skills
#
# Supported platforms: macOS, Linux (Ubuntu/Debian, Fedora, Arch, openSUSE, Alpine), Windows (WSL, Scoop, Chocolatey)
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default settings
SKILLS_DIR="${HOME}/.claude/skills"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case "$ID" in
                    ubuntu|debian)
                        OS="debian"
                        ;;
                    fedora)
                        OS="fedora"
                        ;;
                    arch)
                        OS="arch"
                        ;;
                    opensuse|sles)
                        OS="opensuse"
                        ;;
                    alpine)
                        OS="alpine"
                        ;;
                    *)
                        OS="linux"
                        ;;
                esac
            else
                OS="linux"
            fi
            ;;
        Darwin*)
            OS="macos"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            OS="windows"
            ;;
        *)
            OS="unknown"
            ;;
    esac
}

# Detect package manager
detect_pkg_manager() {
    case "$OS" in
        macos)
            if command -v brew &> /dev/null; then
                PKG_MANAGER="brew"
            else
                PKG_MANAGER="none"
            fi
            ;;
        debian)
            if command -v apt-get &> /dev/null; then
                PKG_MANAGER="apt"
            elif command -v dnf &> /dev/null; then
                PKG_MANAGER="dnf"
            fi
            ;;
        fedora)
            if command -v dnf &> /dev/null; then
                PKG_MANAGER="dnf"
            elif command -v yum &> /dev/null; then
                PKG_MANAGER="yum"
            fi
            ;;
        arch)
            PKG_MANAGER="pacman"
            ;;
        opensuse)
            PKG_MANAGER="zypper"
            ;;
        alpine)
            PKG_MANAGER="apk"
            ;;
        windows)
            if command -v scoop &> /dev/null; then
                PKG_MANAGER="scoop"
            elif command -v choco &> /dev/null; then
                PKG_MANAGER="choco"
            fi
            ;;
        *)
            PKG_MANAGER="none"
            ;;
    esac
}

# Install ag (The Silver Searcher)
install_ag() {
    echo -e "${BLUE}Installing The Silver Searcher (ag)...${NC}"
    
    case "$OS" in
        macos)
            if ! command -v ag &> /dev/null; then
                case "$PKG_MANAGER" in
                    brew)
                        brew install the_silver_searcher
                        ;;
                    *)
                        echo -e "${RED}Homebrew not found. Please install Homebrew first:${NC}"
                        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                        exit 1
                        ;;
                esac
            fi
            ;;
        debian)
            if ! command -v ag &> /dev/null; then
                sudo apt update
                sudo apt install -y silversearcher-ag
            fi
            ;;
        fedora)
            if ! command -v ag &> /dev/null; then
                sudo dnf install -y the_silver_searcher
            fi
            ;;
        arch)
            if ! command -v ag &> /dev/null; then
                sudo pacman -S --noconfirm the_silver_searcher
            fi
            ;;
        opensuse)
            if ! command -v ag &> /dev/null; then
                sudo zypper install -y the_silver_searcher
            fi
            ;;
        alpine)
            if ! command -v ag &> /dev/null; then
                apk add --no-cache the_silver_searcher
            fi
            ;;
        windows)
            if ! command -v ag &> /dev/null; then
                if [ "$PKG_MANAGER" = "scoop" ]; then
                    scoop install ag
                elif [ "$PKG_MANAGER" = "choco" ]; then
                    choco install the-silver-searcher -y
                else
                    echo -e "${RED}Please install ag via Scoop or Chocolatey:${NC}"
                    echo "  Scoop: scoop install ag"
                    echo "  Chocolatey: choco install the-silver-searcher"
                    exit 1
                fi
            fi
            ;;
    esac
    
    echo -e "${GREEN}✓ ag installed${NC}"
}

# Install docx2md-cli (Word to Markdown converter)
install_docx2md() {
    echo -e "${BLUE}Installing docx2md-cli (Word to Markdown converter)...${NC}"
    
    # Already installed?
    if command -v docx2md &> /dev/null; then
        echo -e "${GREEN}✓ docx2md already installed ($(docx2md --version 2>/dev/null || echo 'unknown version'))${NC}"
        return 0
    fi
    
    # Ensure Python 3.9+ is available
    local python_cmd=""
    if command -v python3 &> /dev/null; then
        python_cmd="python3"
    elif command -v python &> /dev/null; then
        python_cmd="python"
    else
        echo -e "${YELLOW}Python not found. Installing Python...${NC}"
        case "$OS" in
            macos)
                case "$PKG_MANAGER" in
                    brew) brew install python3 ;;
                    *) echo -e "${RED}Please install Python 3.9+ first${NC}"; return 1 ;;
                esac
                python_cmd="python3"
                ;;
            debian)
                sudo apt update
                sudo apt install -y python3 python3-pip python3-venv
                python_cmd="python3"
                ;;
            fedora)
                sudo dnf install -y python3 python3-pip
                python_cmd="python3"
                ;;
            arch)
                sudo pacman -S --noconfirm python python-pip
                python_cmd="python3"
                ;;
            opensuse)
                sudo zypper install -y python3 python3-pip
                python_cmd="python3"
                ;;
            alpine)
                apk add --no-cache python3 py3-pip
                python_cmd="python3"
                ;;
            windows)
                echo -e "${YELLOW}Please install Python 3.9+ from https://www.python.org/downloads/${NC}"
                return 1
                ;;
        esac
    fi
    
    # Check Python version >= 3.9
    local py_version=$($python_cmd -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null || echo "0.0")
    local py_major=$(echo "$py_version" | cut -d. -f1)
    local py_minor=$(echo "$py_version" | cut -d. -f2)
    if [ "$py_major" -lt 3 ] || { [ "$py_major" -eq 3 ] && [ "$py_minor" -lt 9 ]; }; then
        echo -e "${YELLOW}Python $py_version found, but docx2md-cli requires Python >= 3.9${NC}"
        echo -e "${YELLOW}Attempting install anyway...${NC}"
    fi
    
    # Install lxml system dependencies (required for docx2md-cli)
    case "$OS" in
        debian)
            sudo apt install -y libxml2-dev libxslt1-dev 2>/dev/null || true
            ;;
        fedora)
            sudo dnf install -y libxml2-devel libxslt-devel 2>/dev/null || true
            ;;
        arch)
            sudo pacman -S --noconfirm libxml2 libxslt 2>/dev/null || true
            ;;
        opensuse)
            sudo zypper install -y libxml2-devel libxslt-devel 2>/dev/null || true
            ;;
        alpine)
            apk add --no-cache libxml2-dev libxslt-dev 2>/dev/null || true
            ;;
    esac
    
    # Try install methods in order: pipx > pip --user > pip > venv fallback
    if command -v pipx &> /dev/null; then
        echo -e "${BLUE}Installing via pipx (isolated)...${NC}"
        pipx install "docx2md-cli[frontmatter]" 2>/dev/null || pipx install docx2md-cli
    elif $python_cmd -m pip install --user "docx2md-cli[frontmatter]" 2>/dev/null; then
        echo -e "${BLUE}Installed via pip --user${NC}"
    elif $python_cmd -m pip install "docx2md-cli[frontmatter]" 2>/dev/null; then
        echo -e "${BLUE}Installed via pip${NC}"
    else
        # Fallback: venv
        echo -e "${YELLOW}System pip unavailable. Creating isolated venv...${NC}"
        local venv_dir="${HOME}/.docx2md-env"
        $python_cmd -m venv "$venv_dir"
        source "$venv_dir/bin/activate"
        pip install "docx2md-cli[frontmatter]"
        # Create wrapper script in ~/.local/bin
        mkdir -p "${HOME}/.local/bin"
        cat > "${HOME}/.local/bin/docx2md" << 'WRAPPER'
#!/bin/bash
source "$HOME/.docx2md-env/bin/activate"
exec docx2md "$@"
WRAPPER
        chmod +x "${HOME}/.local/bin/docx2md"
        deactivate
        echo -e "${YELLOW}Installed via venv. Ensure ~/.local/bin is in your PATH.${NC}"
    fi
    
    # Verify
    if command -v docx2md &> /dev/null; then
        echo -e "${GREEN}✓ docx2md installed ($(docx2md --version 2>/dev/null || echo 'ok'))${NC}"
    else
        echo -e "${YELLOW}docx2md installed but not in PATH. Try: source ~/.bashrc or restart your shell${NC}"
    fi
}

# Get list of skills from repo
get_skills() {
    find "$REPO_DIR" -maxdepth 1 -type d ! -name '.' ! -name '.git' ! -name '.*' | while read -r dir; do
        if [ -f "$dir/SKILL.md" ]; then
            basename "$dir"
        fi
    done
}

# Install a single skill
install_skill() {
    local skill_name="$1"
    local skill_src="$REPO_DIR/$skill_name"
    local skill_dest="$SKILLS_DIR/$skill_name"
    
    if [ ! -d "$skill_src" ]; then
        echo -e "${RED}Skill '$skill_name' not found in repository${NC}"
        return 1
    fi
    
    if [ ! -f "$skill_src/SKILL.md" ]; then
        echo -e "${RED}Skill '$skill_name' is missing SKILL.md${NC}"
        return 1
    fi
    
    # Create skills directory if not exists
    mkdir -p "$SKILLS_DIR"
    
    # Remove existing skill if exists
    if [ -d "$skill_dest" ]; then
        echo -e "${YELLOW}Removing existing skill: $skill_name${NC}"
        rm -rf "$skill_dest"
    fi
    
    # Copy skill
    cp -r "$skill_src" "$skill_dest"
    echo -e "${GREEN}✓ Installed: $skill_name${NC}"
}

# Install all skills
install_all_skills() {
    echo -e "${BLUE}Installing skills to: $SKILLS_DIR${NC}"
    echo ""
    
    local skills=$(get_skills)
    
    if [ -z "$skills" ]; then
        echo -e "${YELLOW}No skills found in repository${NC}"
        return
    fi
    
    for skill in $skills; do
        install_skill "$skill"
    done
    
    echo ""
    echo -e "${GREEN}All skills installed successfully!${NC}"
}

# List installed skills
list_installed() {
    echo -e "${BLUE}Installed skills:${NC}"
    if [ -d "$SKILLS_DIR" ]; then
        for skill in "$SKILLS_DIR"/*; do
            if [ -d "$skill" ] && [ -f "$skill/SKILL.md" ]; then
                local name=$(basename "$skill")
                echo "  - $name"
            fi
        done
    else
        echo "  (none)"
    fi
}

# Show usage
usage() {
    echo "Simon-Skills Installer"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  install          Install all skills + dependencies (default)"
    echo "  install-ag       Install The Silver Searcher only"
    echo "  install-docx2md  Install docx2md-cli only"
    echo "  list             List installed skills"
    echo "  help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0               # Install all skills + dependencies"
    echo "  $0 install-ag    # Install ag tool"
    echo "  $0 install-docx2md  # Install docx2md-cli tool"
    echo "  $0 list          # List installed skills"
}

# Main
main() {
    detect_os
    detect_pkg_manager
    
    case "${1:-install}" in
        install)
            install_ag
            install_docx2md
            install_all_skills
            ;;
        install-ag)
            install_ag
            ;;
        install-docx2md)
            install_docx2md
            ;;
        list)
            list_installed
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            echo -e "${RED}Unknown command: $1${NC}"
            usage
            exit 1
            ;;
    esac
}

main "$@"
