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
- [ ] 단위 테스트 + 통합 테스트 커버리지 리포트
- [ ] 에러 핸들링 시나리오 목록 (API 에러 코드별 대응)
- [ ] 빌드 성공 확인 (컴파일 에러 없음)
- [ ] 개발 서버 기동 방법 (`npm run dev` 등)

### BE → QA
- [ ] API 엔드포인트 목록 + 요청/응답 스키마
- [ ] 에러 코드 목록 + 발생 조건
- [ ] 단위/통합 테스트 커버리지 리포트
- [ ] DB 마이그레이션 적용 확인
- [ ] 개발 서버 기동 방법 + 시드 데이터 (E2E 테스트용)

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
