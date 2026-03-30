# QA 결과 발행 Skill

## 목적
테스트 시나리오를 Git Wiki에, 버그를 Git Issue에, 회귀 결과를 PR 코멘트로 발행한다.

## 트리거
- 테스트 시나리오 작성 완료 후
- 버그 발견 시
- 회귀 테스트 완료 후

## 입력
- 테스트 시나리오 마크다운
- 버그 리포트 (발견 시)
- 회귀 테스트 결과
- 프로젝트 경로 (`projects/[project]`)

## 절차
1. Git 플랫폼 감지:
   ```bash
   cd projects/[project]
   git remote -v
   ```
   - `github.com` → `gh` CLI
   - `gitlab` → `glab` CLI

### 테스트 시나리오 → Git Wiki

2a. GitHub:
   ```bash
   gh wiki create "[기능명]-테스트시나리오" --message "Add test scenarios for [기능명]" < test-scenarios.md
   ```

2b. GitLab:
   ```bash
   glab wiki create "[기능명]-테스트시나리오" --title "[기능명] 테스트 시나리오" --content "$(cat test-scenarios.md)"
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
   [QA DONE] TC: [N]개 (Critical: N, High: N) | Wiki: [URL] | 회귀: PASS | 스냅샷: PASS | 판정: Go/No-Go
   ```

## 출력
- Wiki URL (테스트 시나리오)
- Issue URL (버그 — 해당 시)
- PR 코멘트 (회귀 결과)
- 완료 신호

## 품질 체크리스트
- [ ] 올바른 Git 플랫폼 CLI 사용 (gh / glab)
- [ ] 테스트 시나리오 Wiki 페이지 정상 생성
- [ ] 버그 Issue에 심각도 라벨 지정
- [ ] 버그 Issue에 재현 단계 (Given-When-Then) 포함
- [ ] 회귀 결과가 PR/MR 코멘트로 등록

## 안티패턴
- 버그를 Wiki에 작성 (Issue가 아닌 곳에)
- Issue에 재현 단계 없이 "동작 안 함"만 작성
- 회귀 결과를 보고하지 않고 완료 선언
