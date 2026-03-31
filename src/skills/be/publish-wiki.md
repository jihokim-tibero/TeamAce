# API 명세 발행 Skill

## 목적
API 명세를 프로젝트의 문서 저장소에 발행하고, PR/MR을 생성한다.
- GitHub 프로젝트 → **Notion** (Notion MCP)
- GitLab 프로젝트 → **Git Wiki** (`glab api`)

## 트리거
- API 명세 작성 완료 후
- 소스 코드 구현 완료 후

## 입력
- 완성된 API 명세 마크다운
- 소스 코드 (브랜치)
- 프로젝트 경로 (current directory)

## 절차
1. Git 플랫폼 감지:
   ```bash
   git remote -v
   ```
   - `github.com` → Notion MCP + `gh` CLI
   - `gitlab` → `glab` CLI

2. API 명세 발행 (GitHub → Notion):
   - Notion MCP의 `notion-create-pages` 도구로 API 명세 페이지 생성
   - 프로젝트명을 제목 prefix로 사용 (예: `[yoseek] API 명세`)

3. API 명세 발행 (GitLab → Git Wiki):
   ```bash
   # Get URL-encoded project path
   PROJ=$(git remote get-url origin | sed -E 's#.+[:/](.+/.+)(\.git)?$#\1#' | sed 's|/|%2F|g')

   glab api "projects/$PROJ/wikis" --method POST \
     -f title="[기능명] API 명세" \
     -f content="$(cat api-spec.md)" \
     -f format="markdown"
   ```

4. 소스 코드 PR 생성 (GitHub):
   ```bash
   git add -A && git commit -m "feat(be): [기능명] - [설명]"
   git push -u origin feature/[feature-name]
   gh pr create --title "feat(be): [기능명]" --body "$(cat pr-description.md)"
   ```

5. 소스 코드 MR 생성 (GitLab):
   ```bash
   git add -A && git commit -m "feat(be): [기능명] - [설명]"
   git push -u origin feature/[feature-name]
   glab mr create --title "feat(be): [기능명]" --description "$(cat pr-description.md)"
   ```

6. Notion/Wiki URL + PR/MR URL 확보 → 완료 신호에 포함

## 출력
- Notion/Wiki URL (API 명세)
- PR/MR URL (소스 코드)
- 완료 신호: `[BE DONE] 브랜치: feature/[feature-name] | PR/MR: [URL] | API 명세: [Notion/Wiki URL]`

## 품질 체크리스트
- [ ] Git 플랫폼에 맞는 도구 사용 (GitHub→Notion MCP / GitLab→glab)
- [ ] API 명세에 TypeScript 인터페이스 포함
- [ ] 페