# QA Agent — Skills

최종 업데이트: 2026-03-30
누적 작업 수: 3

---

## 핵심 역량

### Test Strategy & Planning
- 리스크 기반 테스트 우선순위 설정
- 테스트 레벨 정의 (단위/통합/E2E/성능/접근성)
- 수락 기준(Acceptance Criteria) 검증 설계
- Agile 환경 테스트 계획 (스프린트 내 완료)
- Given-When-Then 형식 테스트 케이스 작성

### Test Automation
- **Playwright** — E2E 자동화 (data-testid 기반)
- **Cypress** — 컴포넌트·E2E 테스트
- **Jest / React Testing Library** — FE 단위·통합 테스트
- **JUnit + Mockito** — BE 단위 테스트
- **Selenium** — 브라우저 호환성 테스트
- 자동화 대상 선정 기준 (ROI 기반)

### API Testing
- Postman — API 기능·회귀 테스트
- REST Assured — BE 통합 테스트
- 계약 테스트 (Contract Testing) — FE/BE 인터페이스 검증
- AI 기반 자동 테스트 케이스 생성 (2025 트렌드)
- Mock 서버 활용 격리 테스트

### Performance Testing
- 부하 테스트 (JMeter, k6)
- P95 응답시간 목표 검증 (< 500ms)
- 병목 지점 식별 및 리포트
- 스트레스 테스트 및 복구 시간 측정

### Security Testing
- OWASP Top 10 기반 보안 점검
- 입력 유효성 검증 테스트 (SQL Injection, XSS)
- 인증·인가 경계 테스트
- API 보안 취약점 점검

### Accessibility Testing
- WCAG 2.2 AA 기준 자동화 검사
- 키보드 네비게이션 완전 검증
- 스크린 리더 호환성 테스트
- 색 대비 자동 검사

### CI/CD Integration
- GitHub Actions — 테스트 자동화 파이프라인
- PR 머지 전 품질 게이트 통과 필수
- 테스트 결과 자동 리포트
- 플레이키(Flaky) 테스트 탐지·해결

### AI-Assisted Testing (2025)
- AI 기반 테스트 케이스 자동 생성
- Self-Healing 테스트 스위트
- AI 시스템 품질 검증 (LLM 출력 신뢰도)
- 지능형 버그 식별 패턴

### Bug Reporting
- 재현 가능한 버그 리포트 작성
- 심각도 분류 (Critical/Major/Minor)
- GitHub Issue 기반 추적
- 근본 원인 분석 (RCA)

---

## 도구

| 도구 | 용도 | 숙련도 |
|------|------|--------|
| GitHub MCP | 버그 이슈 등록, PR 검토 | 학습 중 |
| Notion MCP | 테스트 시나리오 관리 | 학습 중 |
| Notion REST API (curl) | settings.local.json 권한 기반 직접 호출 | 경험 있음 |

---

## 산출물 이력

| 날짜 | 프로젝트 | 기능 | Notion URL | TC 수 | 발견 버그 | 배운 점 |
|------|---------|------|-----------|-------|---------|---------|
| 2026-03-30 | yoseek | 사업자 진위확인 전체 플로우 (Sprint 1) | https://www.notion.so/yoseek-QA-33318a01a4e881c686c4c8f393a399dc | 14개 (Critical 4, High 9, Medium 1) | — | Notion API 블록 100개 제한 → 페이지 생성 후 PATCH로 추가 블록 분할 업로드 |
| 2026-03-30 | yoseek | 기능 명세서 v1.0 대조 TC 보강 (Sprint 2 — Notion 보강 완료) | https://www.notion.so/33318a01a4e881c686c4c8f393a399dc | 22개 (Critical 6, High 14, Medium 2) | — | 기능 명세서 대조로 F-003~F-008 갭 8개 TC 추가, API 스펙 불일치 주석 삽입 |
| 2026-03-30 | tag-agent | TAG-Agent 전체 API 플로우 v1.0 | https://www.notion.so/33318a01a4e881cda475eb43db9363f6 | 37개 (Critical 10, High 19, Medium 8) | — | SSE 이벤트 순서 검증 패턴, LangGraph 노드 경로 TC 설계, Deep 모드 왕복 플로우 TC 분리 |

---

## 성장 로그

### 2026-03-30 — 초기 스킬 정의
- 2025년 QA 엔지니어 스킬 프레임워크 기반으로 초기 역량 목록 수립
- 핵심 원칙: Given-When-Then 형식, data-testid 기반 자동화, 재현 가능한 버그 리포트
- 다음 목표: Notion MCP·GitHub MCP 활용 첫 테스트 시나리오 작성

### 2026-03-30 — yoseek QA 테스트 시나리오 작성 (Sprint 2 — Notion 업로드 완료)

**작업 내용**
- yoseek 사업자 진위확인 서비스 전체 플로우 분석
- `POST /api/v1/business-lookups` API 기반 15개 TC 설계
  - 정상 케이스 2개 (TC-001 단건 매칭, TC-002 중복 선택 플로우)
  - 경계 케이스 3개 (TC-004 폐업사업자, TC-005 없는 번호, TC-014 주소 불일치)
  - 오류 케이스 5개 (TC-003 진위확인 실패, TC-006~009 입력 오류, TC-010 외부 API 장애)
  - UI/UX 케이스 3개 (TC-011 모바일, TC-012 로딩 상태, TC-013 에러 메시지)
  - 성능 케이스 1개 (TC-015 동시 다중 요청)

**새로 익힌 패턴**
- `lookupStatus` 상태 전이 기반 테스트 설계: COMPLETED / PUBLIC_DATA_SELECTION_REQUIRED
- 외부 API 장애 시나리오는 Mock 서버 필수 — fallback 정책 명확화 전제
- `INVALID_PUBLIC_DATA_SELECTION` 등 도메인 에러 코드 별도 TC 분리가 효과적
- 모바일 UI TC: inputmode="numeric", 44px 터치 영역, 키보드 가림 방지를 개별 검증 포인트로 분리
- AI 브리프(`advisorBrief`) 검증: 존재 여부 + 비어있지 않음 + 폐업 시 처리 방식까지 케이스화

**환경 이슈 및 해결 방법**
- Notion API 블록 100개 제한: 페이지 생성 시 children ≤ 100블록 / 초과 시 PATCH /blocks/{id}/children으로 분할 업로드
- settings.local.json의 기존 curl 허용 패턴 활용 (별도 권한 추가 불필요)

**완료 항목**
- Notion 페이지 업로드 완료: https://www.notion.so/yoseek-QA-33318a01a4e881c686c4c8f393a399dc
- 14개 TC 전체 작성 (Critical 4, High 9, Medium 1), 자동화 가능률 100%

**다음 세션 과제**
- data-testid 실제 코드베이스 대조 검증 (yoseek FE 브랜치)

### 2026-03-30 — yoseek QA TC 보강 (기능 명세서 v1.0 대조)

**작업 내용**
- Notion에서 기존 QA 페이지(14개 TC) + 기능 명세서 + 서비스 기획서 교차 분석
- F-003~F-008 미커버 영역 발견, TC-015~022 8개 신규 작성
- API 스펙 불일치(businessName→storeName, lookupStatus→verification.status) 경고 주석 삽입
- 페이지 제목 "[최종]" 마킹, 품질 게이트 요약 갱신

**새로 익힌 패턴**
- 기능 명세서·기획서 대조를 통한 TC 갭 분석 프로세스
- Graceful Degradation TC는 Mock 서버 필수 + 부분 결과 각 필드별 개별 검증 필요
- p95 성능 기준은 기획서 KPI와 일치시켜야 함 (API 레벨 500ms ≠ E2E 5초)
- notion-update-page update_content 명령으로 기존 페이지 섹션 교체 가능

**완료 항목**
- Notion 페이지 보강 완료: https://www.notion.so/33318a01a4e881c686c4c8f393a399dc
- 총 22개 TC (Critical 6, High 14, Medium 2), 자동화 가능률 100%

**다음 세션 과제**
- BE 개발자와 API 스펙 동기화 (storeName/verification.status 확인)
- FE 브랜치의 data-testid 실제 구현 여부 대조 검증

### 2026-03-30 — tag-agent QA 테스트 시나리오 작성 (v1.0)

**작업 내용**
- TAG-Agent Text-to-SQL 챗봇 전체 API 37개 TC 설계
  - 인증 5개 (JWT 발급, 만료, 비인증 접근, 중복 가입)
  - openai_responses 채팅 7개 (SSE 스트림, 이벤트 순서, 취소, 경계 케이스)
  - deep 모드 채팅 6개 (추론 스트림, plan_user_questions, 사용자 응답 왕복, 취소)
  - 스키마 브라우저 4개, 문서 RAG 4개, 관리자 5개, 대화 공유 3개, 성능 3개

**새로 익힌 패턴**
- SSE 이벤트 타입별 검증: reasoning_step → done 순서 보장, openai_responses에서 plan_user_questions 미발생
- LangGraph 9노드 경로 TC: discover_tools → plan → dispatch_actions → assess → draft_answer → synthesize 흐름 검증
- Deep 모드 왕복 플로우: plan_user_questions SSE 수신 → interaction_id 추출 → POST /deep-interactions/answer → 스트림 재개
- admin role 격리 테스트: role=user 토큰으로 /admin/* 접근 시 HTTP 403 검증
- 대화 공유 비인증 조회: JWT 없이 GET /shared/{token} 접근 가능한 공개 엔드포인트 TC

**완료 항목**
- Notion 페이지 업로드 완료: https://www.notion.so/33318a01a4e881cda475eb43db9363f6
- 37개 TC (Critical 10, High 19, Medium 8), 자동화 가능률 100%
