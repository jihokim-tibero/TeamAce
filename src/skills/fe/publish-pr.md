# FE PR 생성 Skill

## 목적
구현 완료된 FE 소스 코드(hooks, 트랜스폼, Container, 테스트)를 Git PR/MR로 제출한다.

## 트리거
- API 연동 + 테스트 작성 완료 후

## 입력
- 구현 완료된 소스 코드 (브랜치)
- PUB View 명세 URL
- BE API 명세 URL
- PUB PR URL
- 프로젝트 경로 (current directory)

## 절차
1. Git 플랫폼 감지:
   ```bash
   git remote -v
   ```

2. 빌드 확인:
   ```bash
   npm run build
   ```

3. 테스트 실행:
   ```bash
   npm run test -- --coverage
   ```

4. 커밋 + 푸시:
   ```bash
   git add -A
   git commit -m "feat(fe): [기능명] - API 연동 + 상태 관리"
   git push -u origin feature/[feature-name]
   ```

5. PR 생성 (GitHub):
   ```bash
   gh pr create --title "feat(fe): [기능명] — API 연동" --body "$(cat <<'EOF'
   ## 변경 사항
   - [hooks/API/상태관리 설명]

   ## 연관 문서
   - PUB View 명세: [Notion/Wiki URL]
   - BE API 명세: [URL]
   - PUB PR: [URL]

   ## API 연동
   | 엔드포인트 | 훅 | 데이터 변환 |
   |-----------|-----|-----------|

   ## 성능
   - 코드 스플리팅: [적용 위치]
   - 메모이제이션: [적용 항목]

   ## 관측 가능성
   - 에러 바운더리: [적용 위치]
   - 성능 모니터링: [적용 항목]

   ## 체크리스트
   - [ ] 타입 명시 완료 (any 없음)
   - [ ] API 에러 핸들링 완전
   - [ ] 데이터 트랜스폼 순수 함수
   - [ ] 화이트박스 단위 테스트 작성 (트랜스폼·hooks, 커버리지 ≥ 80%)
   - [ ] 에러 바운더리 적용
   - [ ] Core Web Vitals 기준 준수
   - [ ] 빌드 성공
   - [ ] View 컴포넌트 미수정
   EOF
   )"
   ```

6. MR 생성 (GitLab):
   ```bash
   glab mr create --title "feat(fe): [기능명] — API 연동" --description "$(cat pr-description.md)"
   ```

7. PR/MR URL 확보 → 완료 신호

## 출력
- PR/MR URL
- 완료 신호: `[FE DONE] 브랜치: feature/[feature-name] | PR/MR: [URL]`

## 품질 체크리스트
- [ ] 올바른 Git 플랫폼 CLI 사용 (gh / glab)
- [ ] 빌드 성공 확인 후 PR 생성
- [ ] 테스트 전체 통과 + 커버리지 ≥ 80%
- [ ] PR 본문에 API 연동 목록 포함
- [ ] PR 본문에 PUB PR 링크 포함
- [ ] 커밋 메시지 형식 준수: `feat(fe): ...`

## 안티패턴
- 빌드 실패 상태에서 PR 생성
- 테스트 미통과 상태에서 PR 생성
- PUB View 코드를 수정한 채 PR 생성
- API 에러 핸들링 없이 PR 생성
