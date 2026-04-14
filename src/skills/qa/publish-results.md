# QA 결과 발행 Skill

## 목적
테스트 시나리오를 문서 저장소에, 버그를 Git Issue에, 회귀 결과를 PR 코멘트로 발행한다.
- GitHub 프로젝트 → 테스트 시나리오는 **Notion** (Notion MCP)
- GitLab 프로젝트 → 테스트 시나리오는 **Git Wiki** (`glab api`)

## 트리거
- 테스트 시나리오 작성 완료 후
- 버그 발견 시
- 회귀 테스트 완료 후

## 입력
- 테스트 시나리오 마크다운
- 버그 리포트 (발견 시)
- 회귀 테스트 결과
- 프로젝트 경로 (current directory)

## 절차
1. Git 플랫폼 감지:
   ```bash
   git remote -v
   ```
   - `github.com` → Notion MCP + `gh` CLI
   - `gitlab` → `glab` CLI

### 테스트 시나리오 발행

2a. GitHub → Notion:
   - Notion MCP의 `notion-create-pages` 도구로 테스트 시나리오 페이지 생성
   - 프로젝트명을 제목 prefix로 사용 (예: `[yoseek] 테스트 시나리오`)

2b. GitLab → Git Wiki:
   ```bash
   # Get URL-encoded project path
   PROJ=$(git remote get-url origin | sed -E 's#.+[:/](.+/.+)(\.git)?$#\1#' | sed 's|/|%2F|g')

   glab api "projects/$PROJ/wikis" --method POST \
     -f title="[기능명] 테스트 시나리오" \
     -f content="$(cat test-scenarios.md)" \
     -f format="markdown"
   ```

### 버그 리포트 → Git Issue

3a. GitHub:
   ```bash
   gh issue create --title "버그: [제목]" --label "bug,[심각도]" --body "$(cat bug-report.md)"
   ```

3b. GitLab:
   ```bash
   glab issue create --title "버그: [제목]" --label "bug,[심각도]" --description "$(cat bug-report.md)"
   ```

### 회귀 테스트 결과 → PR/MR 코멘트

4a. GitHub:
   ```bash
   gh pr comment [PR번호] --body "$(cat regression-result.md)"
   ```

4b. GitLab:
   ```bash
   glab mr note [MR번호] --message "$(cat regression-result.md)"
   ```

### 완료 신호

5. 모든 결과물 URL 확보 → 완료 신호:
   ```
   [QA DONE] TC: [N]개 (Critical: N, High: N) | Notion/Wiki: [URL] | 회귀: PASS | 판정: Go/No-Go
   ```

## 출력
- Notion/Wiki URL (테스트 시나리오)
- Issue URL (버그 — 해당 시)
- PR 코멘트 (회귀 결과)
- 완료 신호

## 품질 체크리스트
- [ ] Git 플랫폼에 맞는 도구 사용 (GitHub→Notion MCP / GitLab→glab)
- [ ] 테스트 시나리오 페이지
