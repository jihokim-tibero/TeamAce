# UX 명세 Wiki 발행 Skill

## 목적
UX 명세 문서를 프로젝트의 Git Wiki에 발행한다. Figma 시안 URL을 포함한다.

## 트리거
- UX 명세 작성 완료 후

## 입력
- 완성된 UX 명세 마크다운
- Figma 시안 URL
- 프로젝트 경로 (`projects/[project]`)

## 절차
1. Git 플랫폼 감지:
   ```bash
   cd projects/[project]
   git remote -v
   ```
   - `github.com` → `gh` CLI
   - `gitlab` → `glab` CLI

2. UX 명세에 Figma URL 포함 확인:
   ```markdown
   # [기능명] UX 명세
   **Figma 시안**: [Figma URL]  ← 필수
   ```

3. Wiki 페이지 생성 (GitHub):
   ```bash
   gh wiki create "[기능명]-UX명세" --message "Add UX spec for [기능명]" < ux-spec.md
   ```

4. Wiki 페이지 생성 (GitLab):
   ```bash
   glab wiki create "[기능명]-UX명세" --title "[기능명] UX 명세" --content "$(cat ux-spec.md)"
   ```

5. Wiki URL 확보 → 완료 신호에 포함

## 출력
- Wiki URL (UX 명세)
- Figma URL (시안)
- 완료 신호: `[UX DONE] Figma: [URL] | UX 명세: [Wiki URL]`

## 품질 체크리스트
- [ ] 올바른 Git 플랫폼 CLI 사용 (gh / glab)
- [ ] Figma URL이 UX 명세에 포함
- [ ] Wiki 페이지 정상 생성 확인
- [ ] data-testid 테이블이 UX 명세에 포함
- [ ] 5 상태 정의가 UX 명세에 포함

## 안티패턴
- Figma URL 없이 UX 명세만 발행
- Wiki 발행 없이 로컬 파일로 완료 선언
