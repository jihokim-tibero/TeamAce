#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# TeamAce Uninstaller
# ─────────────────────────────────────────────

CLAUDE_DIR="$HOME/.claude"
TEAMACE_DIR="$CLAUDE_DIR/teamace"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${YELLOW}TeamAce를 완전히 제거합니다.${NC}"
echo ""
echo "제거 대상:"
echo "  - ~/.claude/agents/{lead,pm,pub,fe,be,qa}.md"
echo "  - ~/.claude/teamace/"
echo "  - ~/.claude/CLAUDE.md 내 TeamAce 섹션"
echo "  - ~/.local/bin/teamace"
echo ""
read -rp "정말 제거하시겠습니까? [y/N] " yn
[[ "$yn" =~ ^[Yy]$ ]] || exit 0

# Remove agent definitions
for agent in lead pm pub fe be qa; do
  rm -f "$CLAUDE_DIR/agents/$agent.md"
done
echo -e "${GREEN}[✓]${NC} 에이전트 정의 제거"

# Remove teamace directory
rm -rf "$TEAMACE_DIR"
echo -e "${GREEN}[✓]${NC} TeamAce 지원 파일 제거"

# Remove CLAUDE.md section
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  sed '/<!-- TEAMACE:START -->/,/<!-- TEAMACE:END -->/d' "$CLAUDE_DIR/CLAUDE.md" > "$CLAUDE_DIR/CLAUDE.md.tmp"
  mv "$CLAUDE_DIR/CLAUDE.md.tmp" "$CLAUDE_DIR/CLAUDE.md"
  if [ ! -s "$CLAUDE_DIR/CLAUDE.md" ]; then
    rm -f "$CLAUDE_DIR/CLAUDE.md"
  fi
  echo -e "${GREEN}[✓]${NC} CLAUDE.md 정리"
fi

# Remove Impeccable global skill
IMPECCABLE_REMOVED=0
if [ -d "$HOME/.agents/skills/frontend-design" ]; then
  rm -rf "$HOME/.agents/skills/frontend-design"
  IMPECCABLE_REMOVED=1
fi
if [ -d "$HOME/.claude/commands/frontend-design" ]; then
  rm -rf "$HOME/.claude/commands/frontend-design"
  IMPECCABLE_REMOVED=1
fi
for f in "$HOME"/.claude/commands/*impeccable*; do
  [ -e "$f" ] && rm -rf "$f" && IMPECCABLE_REMOVED=1
done
if [ "$IMPECCABLE_REMOVED" -eq 1 ]; then
  echo -e "${GREEN}[✓]${NC} Impeccable 글로벌 스킬 제거"
else
  echo -e "${YELLOW}[–]${NC} Impeccable 글로벌 스킬 없음 (건너뜀)"
fi

# Remove Agent Team env from settings.json
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  node -e "
    const fs = require('fs');
    const s = JSON.parse(fs.readFileSync('$CLAUDE_DIR/settings.json', 'utf8'));
    if (s.env) {
      delete s.env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS;
      if (Object.keys(s.env).length === 0) delete s.env;
    }
    fs.writeFileSync('$CLAUDE_DIR/settings.json', JSON.stringify(s, null, 2));
  " 2>/dev/null
  echo -e "${GREEN}[✓]${NC} settings.json 정리"
fi

# Remove CLI
rm -f "$HOME/.local/bin/teamace"
echo -e "${GREEN}[✓]${NC} CLI 제거"

echo ""
echo -e "${GREEN}TeamAce가 완전히 제거되었습니다.${NC}"
echo ""
echo "참고: 각 프로젝트의 CLAUDE.md에서 TeamAce 참조는 수동으로 제거해주세요."
echo "      → 'teamace clean' 을 각 프로젝트에서 실행하면 자동 정리됩니다."
echo ""
