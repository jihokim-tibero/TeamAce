# API 명세 발행·동기화 Skill

## 목적
BE가 설계·구현하는 API 명세를 **개발 진행 중** 문서 저장소에 지속 동기화하고, 최종적으로 MR을 생성한다. 단일 진실 공급원은 Git Wiki(GitLab) / Notion(GitHub). 로컬 Markdown은 드래프트일 뿐 최종본이 아니다.

- GitHub 프로젝트 → **Notion** (Notion MCP)
- GitLab 프로젝트 → **Git Wiki** (`glab api`)

## 트리거
- API 설계 초안 확정 직후(동기화 시작)
- 요청/응답 스키마·에러 코드 변경 시(즉시 반영)
- 구현 중 스펙 변동 발생 시(변경 즉시, PR 병합 대기 금지)
- 소스 코드 구현 완료 시(MR 생성)

## 입력
- 작성 중/완성된 API 명세 Markdown (엔드포인트·요청/응답·에러·TS 인터페이스 포함)
- 소스 브랜치 `feature/[name]`
- 프로젝트 경로(current directory)

## 절차

### 1. 플랫폼 감지
```bash
git remote -v
```
- `github.com` → Notion MCP + `gh`
- `gitlab`(self-hosted 포함) → `glab`

### 2. Wiki 페이지 초기 생성 (GitLab)
API 설계 초안이 나오면 **즉시** 빈 Wiki 페이지를 만들어 후속 에이전트(FE/QA)가 참조할 앵커를 확보한다.
```bash
PROJ=$(git remote get-url origin | sed -E 's#.+[:/](.+/.+)(\.git)?$#\1#' | sed 's|/|%2F|g')
glab api "projects/$PROJ/wikis" --method POST \
  -f title="Features/[기능명]/api-spec" \
  -f content="$(cat api-spec.md)" \
  -f format="markdown"
```

Notion(GitHub)의 경우 `mcp__plugin_Notion_notion__create-pages` 로 동일 구조 페이지 생성. 제목 prefix는 `[프로젝트]`.

### 3. 변경 시 동기화 (핵심)
스펙이 변할 때마다 **덮어쓰기 PUT**으로 즉시 반영. "구현 끝나고 한 번에 업로드" 금지.
```bash
glab api "projects/$PROJ/wikis/Features%2F[기능명]%2Fapi-spec" --method PUT \
  -f content="$(cat api-spec.md)" \
  -f format="markdown"
```
변경 사항 요약을 BE knowledge에 append할 필요는 없다. Wiki 히스토리가 단일 소스.

### 4. FE 핸드오프 메시지
Wiki URL + 변경 요약을 1~2줄로 FE에 전달:
```
[BE→FE] API spec 갱신: <Wiki URL>
변경: POST /auth/callback response 200→JSON {redirectTo}
```

### 5. 소스 코드 MR (최종 단계)
```bash
git add -A && git commit -m "feat(be): [기능명] - [설명]"
git push -u origin feature/[name]
glab mr create --title "feat(be): [기능명]" --description "$(cat mr-description.md)"
```
GitHub은 `gh pr create` 치환.

### 6. 완료 신호
```
[BE DONE] 브랜치: feature/[name] | MR: [URL] | API spec: [Wiki URL]
```

## 출력
- Wiki/Notion 페이지 URL (항상 최신)
- MR/PR URL
- FE·QA에 전달된 핸드오프 메시지

## 품질 체크리스트
- [ ] 설계 초안 시점에 Wiki 페이지 생성 완료
- [ ] 스펙 변동 시 즉시 Wiki PUT 반영 (로컬만 수정하고 끝내지 않음)
- [ ] 응답 필드 camelCase, PM 기능명세서와 일치
- [ ] TS 인터페이스 포함
- [ ] 에러 코드·인증 방식 명시
- [ ] FE에 변경 요약 핸드오프 메시지 전송

## 안티패턴
- MR 생성 시점까지 Wiki 업로드를 미룸 → FE/QA가 오래된 로컬 문서로 작업
- 로컬 `api-spec.md`만 수정하고 Wiki 반영 누락
- 필드명·에러 코드가 PM 기능명세서와 불일치
- Wiki URL을 핸드오프 메시지에 포함하지 않음
