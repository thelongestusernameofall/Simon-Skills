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
    echo "  install          Install all skills (default)"
    echo "  install-ag       Install The Silver Searcher only"
    echo "  list             List installed skills"
    echo "  help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0               # Install all skills"
    echo "  $0 install-ag    # Install ag tool"
    echo "  $0 list          # List installed skills"
}

# Main
main() {
    detect_os
    detect_pkg_manager
    
    case "${1:-install}" in
        install)
            install_ag
            install_all_skills
            ;;
        install-ag)
            install_ag
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
