# 문서 산출물 발행 Skill

## 목적
기획서(PRD)와 기능 명세서를 프로젝트의 문서 저장소에 발행한다.
- GitHub 프로젝트 → **Notion** (Notion MCP)
- GitLab 프로젝트 → **Git Wiki** (`glab api`)

## 트리거
- 기획서 또는 기능 명세서 작성 완료 후

## 입력
- 완성된 기획서 (PRD) 마크다운
- 완성된 기능 명세서 마크다운
- 프로젝트 경로 (current directory)

## 절차
1. Git 플랫폼 감지:
   ```bash
   cd .
   git remote -v
   ```
   - `github.com` → Notion MCP 사용
   - `gitlab` → `glab` CLI 사용

2. 문서 발행 (GitHub → Notion):
   - Notion MCP의 `notion-create-pages` 도구로 기획서 페이지 생성
   - Notion MCP의 `notion-create-pages` 도구로 기능 명세서 페이지 생성
   - 프로젝트명을 제목 prefix로 사용 (예: `[yoseek] 기획서`)

3. 문서 발행 (GitLab → Git Wiki):
   ```bash
   # Get URL-encoded project path
   PROJ=$(git remote get-url origin | sed -E 's#.+[:/](.+/.+)(\.git)?$#\1#' | sed 's|/|%2F|g')

   # 기획서
   glab api "projects/$PROJ/wikis" --method POST \
     -f title="[기능명] 기획서" \
     -f content="$(cat prd.md)" \
     -f format="markdown"

   # 기능 명세서
   glab api "projects/$PROJ/wikis" --method POST \
     -f title="[기능명] 기능 명세서" \
     -f content="$(cat spec.md)" \
     -f format="markdown"
   ```

4. Notion/Wiki URL 확보 → 완료 신호에 포함

5. 문서 업데이트 (수정 시):
   - GitHub: Notion MCP의 `notion-update-page` 도구 사용
   - GitLab:
     ```bash
     # Get URL-encoded project path
     PROJ=$(git remote get-url origin | sed -E 's#.+[:/](.+/.+)(\.git)?$#\1#' | sed 's|/|%2F|g')

     glab api "projects/$PROJ/wikis/prd-page-slug" --method PUT \
       -f content="$(cat prd-updated.md)"
     ```

## 출력
- Notion/Wiki URL (기획서)
- Notion/Wiki URL (기능 명세서)
- 완료 신호: `[PM DONE] 기획서: [Notion/Wiki URL] | 기능 명세서: [Notion/Wiki URL]`

## 품질 체크리스트
- [ ] Git 플랫폼에 맞는 도구 사용 (GitHub→Notion MCP / GitLab→glab)
- [ ] 페이지 정
