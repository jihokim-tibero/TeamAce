# View PR 생성 Skill

## 목적
구현 완료된 View 컴포넌트 + 디자인 시스템 코드를 Git PR/MR로 제출하고 View 명세를 발행한다.

## 트리거
- View 구현 + audit-polish 완료 후

## 입력
- 구현 완료된 View 코드 (브랜치)
- View 명세 마크다운
- 프로젝트 경로 (current directory)

## 절차
1. Git 플랫폼 감지:
   ```bash
   git remote -v
   ```
   - `github.com` → `gh` CLI
   - `gitlab` → `glab` CLI

2. 빌드 확인:
   ```bash
   npm run build
   ```

3. View 명세 발행:
   - GitHub → Notion MCP (`notion-create-pages`)
   - GitLab → `glab api` (GitLab Wiki REST API)

4. 커밋 + 푸시:
   ```bash
   git add -A
   git commit -m "feat(pub): [기능명] - View 컴포넌트 구현"
   git push -u origin feature/[feature-name]
   ```

5. PR 생성:
   ```bash
   gh pr create --title "feat(pub): [기능명] — View 구현" --body "$(cat <<'EOF'
   ## 변경 사항
   - [View 컴포넌트/화면 설명]

   ## 디자인 결정
   - [Impeccable 원칙 기반 주요 디자인 판단과 근거]

   ## 연관 문서
   - View 명세: [Notion/Wiki URL]
   - 기획서: [URL]

   ## data-testid 목록
   | ID | 컴포넌트 | 용도 |
   |----|---------|------|

   ## Impeccable 체크리스트
   - [ ] 안티패턴 전체 검증 통과
   - [ ] OKLCH 색상 체계 사용
   - [ ] 타이포그래피 스케일 일관
   - [ ] spacing rhythm 준수
   - [ ] 접근성 (키보드, ARIA, 색 대비)

   ## 체크리스트
   - [ ] 타입 명시 완료 (any 없음)
   - [ ] data-testid 전체 추가
   - [ ] 모든 상태(idle/loading/success/error/empty) 구현
   - [ ] 스냅샷 테스트 작성
   - [ ] View에 비즈니스 로직 없음
   - [ ] 빌드 성공
   EOF
   )"
   ```

6. MR 생성 (GitLab):
   ```bash
   glab mr create --title "feat(pub): [기능명] — View 구현" --description "$(cat pr-description.md)"
   ```

7. PR/MR URL + Notion/Wiki URL 확보 → 완료 신호

## 출력
- PR/MR URL
- View 명세 Notion/Wiki URL
- 완료 신호: `[PUB DONE] 브랜치: feature/[feature-name] | PR/MR: [URL] | View 명세: [Notion/Wiki URL]`

## 품질 체크리스트
- [ ] 올바른 Git 플랫폼 CLI 사용 (gh / glab)
- [ ] 빌드 성공 확인 후 PR 생성
- [ ] View 명세 발행 완료 (Notion/Wiki)
- [ ] PR 본문에 data-testid 목록 포함
- [ ] PR 본문에 Impeccable 체크리스트 포함
- [ ] 커밋 메시지 형식 준수: `feat(pub): ...`

## 안티패턴
- 빌드 실패 상태에서 PR 생성
- audit-polish 미실행 상태에서 PR 생성
- View 명세 미발행 상태에서 PR 생성
- data-testid 목록 누락
