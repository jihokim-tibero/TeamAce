# API 명세 Wiki 발행 Skill

## 목적
API 명세를 프로젝트의 Git Wiki에 발행하고, PR/MR을 생성한다.

## 트리거
- API 명세 작성 완료 후
- 소스 코드 구현 완료 후

## 입력
- 완성된 API 명세 마크다운
- 소스 코드 (브랜치)
- 프로젝트 경로 (`projects/[project]`)

## 절차
1. Git 플랫폼 감지:
   ```bash
   cd projects/[project]
   git remote -v
   ```
   - `github.com` → `gh` CLI
   - `gitlab` → `glab` CLI

2. API 명세 Wiki 발행 (GitHub):
   ```bash
   gh wiki create "[기능명]-API명세" --message "Add API spec for [기능명]" < api-spec.md
   ```

3. API 명세 Wiki 발행 (GitLab):
   ```bash
   glab wiki create "[기능명]-API명세" --title "[기능명] API 명세" --content "$(cat api-spec.md)"
   ```

4. 소스 코드 PR/MR 생성 (GitHub):
   ```bash
   git add -A && git commit -m "feat(be): [기능명] - [설명]"
   git push -u origin feature/[feature-name]-be
   gh pr create --title "feat(be): [기능명]" --body "$(cat pr-description.md)"
   ```

5. 소스 코드 MR 생성 (GitLab):
   ```bash
   git add -A && git commit -m "feat(be): [기능명] - [설명]"
   git push -u origin feature/[feature-name]-be
   glab mr create --title "feat(be): [기능명]" --description "$(cat pr-description.md)"
   ```

6. Wiki URL + PR/MR URL 확보 → 완료 신호에 포함

## 출력
- Wiki URL (API 명세)
- PR/MR URL (소스 코드)
- 완료 신호: `[BE DONE] 브랜치: feature/[feature-name]-be | PR/MR: [URL] | API 명세: [Wiki URL]`

## 품질 체크리스트
- [ ] 올바른 Git 플랫폼 CLI 사용 (gh / glab)
- [ ] API 명세에 TypeScript 인터페이스 포함
- [ ] Wiki 페이지 정상 생성 확인
- [ ] PR/MR 정상 생성 확인
- [ ] 커밋 메시지 형식 준수

## 안티패턴
- API 명세를 Wiki에 올리지 않고 PR 본문에만 작성
- Wiki URL 없이 완료 선언
- GitHub 레포에 `glab mr create` 사용 (또는 그 반대)
