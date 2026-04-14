# 전체 → QA 핸드오프 계약

## 각 에이전트가 QA에게 전달해야 하는 필수 산출물

### PM → QA
- [ ] 수락 기준 (Acceptance Criteria) — 측정 가능한 형태
- [ ] 사용자 시나리오 (주요 흐름 + 예외 흐름)
- [ ] 목표 성능 지표 (응답 시간, 에러율 등)
- [ ] 기능 우선순위 (Critical/High/Medium/Low)

### PUB → QA
- [ ] data-testid 테이블 (코드에 구현됨 — 자동화 테스트용)
- [ ] 컴포넌트 상태 정의 (5 상태 — 코드에 구현됨, 각 상태의 트리거와 기대 표시)
- [ ] 접근성 구현 내역 (키보드, 스크린 리더, 색 대비)
- [ ] 사용자 여정 플로우 (단계별 화면 전환)
- [ ] View 명세 문서 URL

### FE → QA
- [ ] PUB View와 연결된 Container 컴포넌트 목록
- [ ] API 연동 목록 (엔드포인트 ↔ hooks 매핑)
- [ ] **화이트박스 단위 테스트 커버리지 리포트** (트랜스폼·hooks)
- [ ] 에러 핸들링 시나리오 목록 (API 에러 코드별 대응)
- [ ] 빌드 성공 확인 (컴파일 에러 없음)
- [ ] 개발 서버 기동 방법 (`npm run dev` 등)

### BE → QA
- [ ] API 엔드포인트 목록 + 요청/응답 스키마
- [ ] 에러 코드 목록 + 발생 조건
- [ ] **화이트박스 단위 테스트 커버리지 리포트** (service·domain·검증)
- [ ] DB 마이그레이션 적용 확인
- [ ] 개발 서버 기동 방법 + 시드 데이터 (E2E 테스트용)

## 테스트 책임 분담 (필독)

| 계층 | 주체 | 관점 | 범위 | 근거 |
|------|------|------|------|------|
| 단위 테스트 | **FE / BE** | 화이트박스 (내부 구조 앎) | 트랜스폼·hooks·service·domain·검증·에러 분기 | 소스 코드 |
| E2E / 시나리오 / 회귀 | **QA** | 블랙박스 (외부 관점) | 사용자 여정, API 계약, 회귀 스위트 | **명세만** (PM·PUB·BE 명세). 소스 내부 참조 금지 |

- QA는 테스트 설계 시 소스 코드 내부를 보지 않는다. 변경 영향 분석 목적의 `git diff`(파일·범위 식별)만 예외.
- 명세 ↔ 실제 동작 불일치가 발견되면 QA는 **임의로 TC를 현재 동작에 맞추지 않고**, PM·담당 개발(PUB/FE/BE)에게 버그 리포트 또는 명세 정정 요청을 발행한다. 합의 전까지 해당 TC는 **Blocked** 상태로 둔다.

## 산출물 위치
- 기획서/기능 명세서 (PM): GitHub → **Notion** / GitLab → **Git Wiki**
- View 명세 (PUB): GitHub → **Notion** / GitLab → **Git Wiki**
- API 명세 (BE): GitHub → **Notion** / GitLab → **Git Wiki**
- 소스 코드 + 테스트 (PUB/FE/BE): **Git `feature/[feature-name]` 통합 브랜치**
- QA Agent는 Notion 또는 Git Wiki에서 기획서·View 명세·API 명세를 조회

## 검증 기준
- QA Agent가 Notion/Wiki의 산출물만으로 테스트 시나리오를 작성 가능해야 함
- data-testid 목록이 PUB View 코드 ↔ FE Container 간 일치해야 함
- API 스키마가 BE 명세 ↔ FE hooks 간 일치해야 함
