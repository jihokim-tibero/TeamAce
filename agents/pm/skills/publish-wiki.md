# Git Wiki 발행 Skill

## 목적
기획서(PRD)와 기능정의서를 프로젝트의 Git Wiki에 발행한다.

## 트리거
- 기획서 또는 기능정의서 작성 완료 후

## 입력
- 완성된 기획서 (PRD) 마크다운
- 완성된 기능정의서 마크다운
- 프로젝트 경로 (`projects/[project]`)

## 절차
1. Git 플랫폼 감지:
   ```bash
   cd projects/[project]
   git remote -v
   ```
   - `github.com` → `gh` CLI 사용
   - `gitlab` → `glab` CLI 사용

2. Wiki 페이지 생성 (GitHub):
   ```bash
   # 기획서
   gh wiki create "[기능명]-PRD" --message "Add PRD for [기능명]" < prd.md

   # 기능정의서
   gh wiki create "[기능명]-기능정의서" --message "Add spec for [기능명]" < spec.md
   ```

3. Wiki 페이지 생성 (GitLab):
   ```bash
   # 기획서
   glab wiki create "[기능명]-PRD" --title "[기능명] 기획서" --content "$(cat prd.md)"

   # 기능정의서
   glab wiki create "[기능명]-기능정의서" --title "[기능명] 기능정의서" --content "$(cat spec.md)"
   ```

4. Wiki URL 확보 → 완료 신호에 포함

5. Wiki 업데이트 (수정 시):
   ```bash
   # GitHub
   gh wiki edit "[기능명]-PRD" < prd-updated.md

   # GitLab
   glab wiki edit "[기능명]-PRD" --content "$(cat prd-updated.md)"
   ```

## 출력
- Wiki URL (기획서)
- Wiki URL (기능정의서)
- 완료 신호: `[PM DONE] 기획서: [Wiki URL] | 기능정의서: [Wiki URL]`

## 품질 체크리스트
- [ ] 올바른 Git 플랫폼 CLI 사용 (gh / glab)
- [ ] Wiki 페이지 정상 생성 확인
- [ ] Wiki URL을 완료 신호에 포함
- [ ] 마크다운 렌더링 정상 확인

## 안티패턴
- GitHub 레포에 `glab` 사용 (또는 그 반대)
- Wiki URL 없이 완료 선언
- 로컬 파일만 작성하고 Wiki 발행 누락
