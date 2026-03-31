#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# TeamAce Installer
# Multi-Agent Service Development System
# ─────────────────────────────────────────────

VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
TEAMACE_DIR="$CLAUDE_DIR/teamace"
AGENTS_DIR="$CLAUDE_DIR/agents"
BIN_DIR="$HOME/.local/bin"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[TeamAce]${NC} $1"; }
ok()    { echo -e "${GREEN}[TeamAce]${NC} $1"; }
warn()  { echo -e "${YELLOW}[TeamAce]${NC} $1"; }
err()   { echo -e "${RED}[TeamAce]${NC} $1" >&2; }

# ─────────────────────────────────────────────
# 0. Pre-flight checks
# ─────────────────────────────────────────────

info "TeamAce v${VERSION} 설치를 시작합니다..."

# Check required tools
for cmd in git node npm; do
  if ! command -v "$cmd" &>/dev/null; then
    err "$cmd 이 설치되어 있지 않습니다. 먼저 설치해주세요."
    exit 1
  fi
done

# Check Claude Code CLI
if ! command -v claude &>/dev/null; then
  warn "Claude Code CLI가 감지되지 않았습니다."
  warn "https://docs.claude.com 에서 설치 후 다시 실행해주세요."
  read -rp "그래도 계속 진행하시겠습니까? [y/N] " yn
  [[ "$yn" =~ ^[Yy]$ ]] || exit 0
fi

# ─────────────────────────────────────────────
# 1. Create directory structure
# ─────────────────────────────────────────────

info "디렉터리 구조 생성 중..."

mkdir -p "$CLAUDE_DIR"
mkdir -p "$AGENTS_DIR"
mkdir -p "$TEAMACE_DIR"/{skills/{pm,pub,fe,be,qa},knowledge,contracts,harness,config}
mkdir -p "$BIN_DIR"

# ─────────────────────────────────────────────
# 2. Install agent definitions → ~/.claude/agents/
# ─────────────────────────────────────────────

info "에이전트 정의 파일 설치 중..."

for agent_file in "$SCRIPT_DIR"/src/agents/*.md; do
  cp "$agent_file" "$AGENTS_DIR/"
done
ok "  → ~/.claude/agents/ 에 에이전트 6개 설치 완료"

# ─────────────────────────────────────────────
# 3. Install TeamAce supporting files
# ─────────────────────────────────────────────

info "TeamAce 지원 파일 설치 중..."

# Skills (per-agent)
for agent in pm pub fe be qa; do
  if [ -d "$SCRIPT_DIR/src/skills/$agent" ]; then
    cp "$SCRIPT_DIR"/src/skills/"$agent"/*.md "$TEAMACE_DIR/skills/$agent/" 2>/dev/null || true
  fi
done
ok "  → skills 설치 완료"

# Knowledge
cp "$SCRIPT_DIR"/src/knowledge/*.md "$TEAMACE_DIR/knowledge/" 2>/dev/null || true
ok "  → knowledge 설치 완료"

# Contracts
cp "$SCRIPT_DIR"/src/contracts/*.md "$TEAMACE_DIR/contracts/"
ok "  → contracts 설치 완료"

# Harness
cp "$SCRIPT_DIR"/src/harness/*.md "$TEAMACE_DIR/harness/"
ok "  → harness 설치 완료"

# Version marker
echo "$VERSION" > "$TEAMACE_DIR/version"

# ─────────────────────────────────────────────
# 4. Update ~/.claude/CLAUDE.md
# ─────────────────────────────────────────────

info "글로벌 CLAUDE.md 설정 중..."

MARKER_START="<!-- TEAMACE:START -->"
MARKER_END="<!-- TEAMACE:END -->"

# Remove existing TeamAce section if present
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  # Create temp file without TeamAce section
  sed "/$MARKER_START/,/$MARKER_END/d" "$CLAUDE_DIR/CLAUDE.md" > "$CLAUDE_DIR/CLAUDE.md.tmp"
  mv "$CLAUDE_DIR/CLAUDE.md.tmp" "$CLAUDE_DIR/CLAUDE.md"
fi

# Append TeamAce section
{
  echo ""
  echo "$MARKER_START"
  cat "$SCRIPT_DIR/src/claude-md/teamace.md"
  echo ""
  echo "$MARKER_END"
} >> "$CLAUDE_DIR/CLAUDE.md"

ok "  → ~/.claude/CLAUDE.md 에 TeamAce 지침 추가 완료"

# ─────────────────────────────────────────────
# 5. Merge MCP settings into ~/.claude/settings.json
# ─────────────────────────────────────────────

info "MCP 설정 병합 중..."

if [ -f "$SCRIPT_DIR/src/config/settings.json" ]; then
  if [ -f "$CLAUDE_DIR/settings.json" ]; then
    # Merge: TeamAce settings into existing settings
    # Using node for reliable JSON merge
    node -e "
      const fs = require('fs');
      const existing = JSON.parse(fs.readFileSync('$CLAUDE_DIR/settings.json', 'utf8'));
      const teamace = JSON.parse(fs.readFileSync('$SCRIPT_DIR/src/config/settings.json', 'utf8'));

      // Deep merge permissions
      if (teamace.permissions) {
        existing.permissions = existing.permissions || {};
        for (const [key, val] of Object.entries(teamace.permissions)) {
          existing.permissions[key] = [...new Set([
            ...(existing.permissions[key] || []),
            ...val
          ])];
        }
      }

      // Deep merge env (Agent Team 실험 기능 등)
      if (teamace.env) {
        existing.env = { ...existing.env, ...teamace.env };
      }

      // Deep merge mcpServers
      if (teamace.mcpServers) {
        existing.mcpServers = { ...existing.mcpServers, ...teamace.mcpServers };
      }

      fs.writeFileSync('$CLAUDE_DIR/settings.json', JSON.stringify(existing, null, 2));
    "
    ok "  → 기존 settings.json에 TeamAce 설정 병합 완료"
  else
    cp "$SCRIPT_DIR/src/config/settings.json" "$CLAUDE_DIR/settings.json"
    ok "  → ~/.claude/settings.json 새로 생성 완료"
  fi
fi

# ─────────────────────────────────────────────
# 6. Install teamace CLI
# ─────────────────────────────────────────────

info "teamace CLI 설치 중..."

cp "$SCRIPT_DIR/bin/teamace" "$BIN_DIR/teamace"
chmod +x "$BIN_DIR/teamace"

# Ensure BIN_DIR is in PATH
SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
  SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
  if ! grep -q "$BIN_DIR" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# TeamAce CLI" >> "$SHELL_RC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    warn "  → PATH에 $BIN_DIR 추가됨. 새 터미널을 열거나 'source $SHELL_RC' 실행 필요"
  fi
fi

ok "  → teamace CLI 설치 완료"

# ─────────────────────────────────────────────
# 7. Summary
# ─────────────────────────────────────────────

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN} TeamAce v${VERSION} 설치 완료!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  설치 위치:"
echo "    에이전트 정의  → ~/.claude/agents/"
echo "    지원 파일      → ~/.claude/teamace/"
echo "    글로벌 지침    → ~/.claude/CLAUDE.md"
echo "    CLI           → ~/.local/bin/teamace"
echo ""
echo "  다음 단계:"
echo "    1. 프로젝트 디렉터리에서 'teamace init' 실행"
echo "    2. Claude Code 시작 → TeamAce 자동 인식"
echo ""
echo "  사용법:"
echo "    teamace init      — 현재 프로젝트에 Impeccable + 기본 설정 초기화"
echo "    teamace status    — 설치 상태 확인"
echo "    teamace update    — TeamAce 업데이트"
echo "    teamace uninstall — TeamAce 제거"
echo ""
