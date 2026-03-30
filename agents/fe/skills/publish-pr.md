# PR/MR 생성 Skill

## 목적
구현 완료된 프론트엔드 소스 코드를 Git PR/MR로 제출한다.

## 트리거
- 컴포넌트 구현 + 테스트 작성 완료 후

## 입력
- 구현 완료된 소스 코드 (브랜치)
- UX 명세 Wiki URL
- Figma 시안 URL
- BE API 명세 Wiki URL
- 프로젝트 경로 (`projects/[project]`)

## 절차
1. Git 플랫폼 감지:
   ```bash
   cd projects/[project]
   git remote -v
   ```
   - `github.com` → `gh` CLI
   - `gitlab` → `glab` CLI

2. 빌드 확인:
   ```bash
   npm run build
   ```

3. 커밋 + 푸시:
   ```bash
   git add -A
   git commit -m "feat(fe): [기능명] - [설명]"
   git push -u origin feature/[feature-name]
   ```

4. PR 생성 (GitHub):
   ```bash
   gh pr create --title "feat(fe): [기능명]" --body "$(cat <<'EOF'
   ## 변경 사항
   - [컴포넌트/기능 설명]

   ## 연관 문서
   - UX 명세: [Wiki URL]
   - Figma 시안: [Figma URL]
   - BE API 명세: [Wiki URL]

   ## data-testid 목록
   | ID | 컴포넌트 | 용도 |
   |----|---------|------|

   ## 관측 가능성
   - 에러 바운더리: [적용 위치]
   - 성능 모니터링: [적용 항목]

   ## 체크리스트
   - [ ] 타입 명시 완료 (any 없음)
   - [ ] data-testid 전체 추가
   - [ ] 모든 상태(idle/loading/success/error/empty) 구현
   - [ ] 스냅샷 테스트 + 단위 테스트 작성
   - [ ] 접근성 (키보드, ARIA)
   - [ ] 에러 바운더리 적용
   - [ ] 빌드 성공
   EOF
   )"
   ```

5. MR 생성 (GitLab):
   ```bash
   glab mr create --title "feat(fe): [기능명]" --description "$(cat pr-description.md)"
   ```

6. PR/MR URL 확보 → 완료 신호에 포함

## 출력
- PR/MR URL
- 완료 신호: `[FE DONE] 브랜치: feature/[feature-name] | PR/MR: [URL]`

## 품질 체크리스트
- [ ] 올바른 Git 플랫폼 CLI 사용 (gh / glab)
- [ ] 빌드 성공 확인 후 PR 생성
- [ ] PR 본문에 UX 명세/API 명세 Wiki URL 포함
- [ ] data-testid 목록 포함
- [ ] 커밋 메시지 형식 준수

## 안티패턴
- 빌드 실패 상태로 PR 생성
- PR 본문에 연관 문서 URL 누락
- main 브랜치에 직접 커밋
