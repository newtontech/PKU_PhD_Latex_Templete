#!/usr/bin/env bash
#
# One-click installer for PKU PhD LaTeX dual-agent skills.
# Supports both local (project-only) and global (cross-project) installation.
#
# Usage:
#   ./scripts/install-skills.sh         # Local mode: symlinks under .codex/skills/ and .claude/skills/
#   ./scripts/install-skills.sh --global # Global mode: installs into ~/.codex/skills/ and ~/.claude/skills/
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SKILLS_DIR="${PROJECT_ROOT}/skills"

GLOBAL_MODE=false
if [[ "${1:-}" == "--global" ]]; then
    GLOBAL_MODE=true
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
log_ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "Linux";;
        Darwin*)    echo "macOS";;
        CYGWIN*|MINGW*|MSYS*) echo "Windows";;
        *)          echo "Unknown";;
    esac
}

OS="$(detect_os)"
log_info "Detected OS: ${OS}"

# Determine target directories
if [[ "$GLOBAL_MODE" == true ]]; then
    CODEX_SKILLS_DIR="${CODEX_HOME:-${HOME}/.codex}/skills"
    CLAUDE_SKILLS_DIR="${CLAUDE_HOME:-${HOME}/.claude}/skills"
    log_info "Running in GLOBAL mode. Skills will be installed to:"
    log_info "  Codex:  ${CODEX_SKILLS_DIR}"
    log_info "  Claude: ${CLAUDE_SKILLS_DIR}"
else
    CODEX_SKILLS_DIR="${PROJECT_ROOT}/.codex/skills"
    CLAUDE_SKILLS_DIR="${PROJECT_ROOT}/.claude/skills"
    log_info "Running in LOCAL mode. Skills will be linked under:"
    log_info "  .codex/skills/"
    log_info "  .claude/skills/"
fi

# Create target directories if missing
mkdir -p "${CODEX_SKILLS_DIR}" "${CLAUDE_SKILLS_DIR}"

# Determine if we can use symlinks
CAN_SYMLINK=true
if [[ "$OS" == "Windows" ]]; then
    CAN_SYMLINK=false
fi

install_skill() {
    local skill_name="$1"
    local src_dir="${SKILLS_DIR}/${skill_name}"
    local codex_dest="${CODEX_SKILLS_DIR}/${skill_name}"
    local claude_dest="${CLAUDE_SKILLS_DIR}/${skill_name}"

    if [[ ! -d "$src_dir" ]]; then
        log_warn "Skill directory not found, skipping: ${skill_name}"
        return
    fi

    # Codex
    if [[ -e "$codex_dest" || -L "$codex_dest" ]]; then
        if [[ "$GLOBAL_MODE" == true ]]; then
            log_warn "Already exists (Codex), skipping: ${skill_name}"
        else
            log_ok "Already linked (Codex): ${skill_name}"
        fi
    else
        if [[ "$CAN_SYMLINK" == true ]]; then
            if [[ "$GLOBAL_MODE" == true ]]; then
                ln -s "$src_dir" "$codex_dest"
            else
                ln -sf "../../skills/${skill_name}" "$codex_dest"
            fi
        else
            cp -r "$src_dir" "$codex_dest"
        fi
        log_ok "Installed (Codex): ${skill_name}"
    fi

    # Claude
    if [[ -e "$claude_dest" || -L "$claude_dest" ]]; then
        if [[ "$GLOBAL_MODE" == true ]]; then
            log_warn "Already exists (Claude), skipping: ${skill_name}"
        else
            log_ok "Already linked (Claude): ${skill_name}"
        fi
    else
        if [[ "$CAN_SYMLINK" == true ]]; then
            if [[ "$GLOBAL_MODE" == true ]]; then
                ln -s "$src_dir" "$claude_dest"
            else
                ln -sf "../../skills/${skill_name}" "$claude_dest"
            fi
        else
            cp -r "$src_dir" "$claude_dest"
        fi
        log_ok "Installed (Claude): ${skill_name}"
    fi
}

# Collect all skill directories
SKILL_NAMES=()
for dir in "${SKILLS_DIR}"/*/; do
    if [[ -f "${dir}/SKILL.md" ]]; then
        basename "$dir"
    fi
done | sort > /tmp/pku_skills_list.txt

mapfile -t SKILL_NAMES < /tmp/pku_skills_list.txt

TOTAL="${#SKILL_NAMES[@]}"
log_info "Found ${TOTAL} skills to install."

for skill in "${SKILL_NAMES[@]}"; do
    install_skill "$skill"
done

echo ""
log_ok "Installation complete!"

if [[ "$GLOBAL_MODE" == true ]]; then
    log_info "Skills are now available globally."
    log_info "Restart your Codex / Claude Code sessions to discover the new skills."
else
    log_info "Skills are linked locally. They will be auto-discovered when you run"
    log_info "  codex  or  claude  inside this project directory."
    log_info ""
    log_info "To install globally (all projects), run:"
    log_info "  ./scripts/install-skills.sh --global"
fi
