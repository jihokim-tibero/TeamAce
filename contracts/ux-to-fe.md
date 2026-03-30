# UX → FE 핸드오프 계약

## UX가 FE에게 전달해야 하는 필수 산출물

### 1. 화면 목록
- [ ] 화면ID, 화면명, Figma 프레임 URL
- [ ] 화면 간 전환 흐름 (어떤 액션으로 어떤 화면으로 이동)

### 2. 컴포넌트 상태 정의 (5 상태 필수)
- [ ] idle — 초기/대기 상태
- [ ] loading — 로딩 중
- [ ] success — 성공
- [ ] error — 에러 (에러 메시지 + 재시도 방법 명시)
- [ ] empty — 데이터 없음 (빈 상태 UI 명시)

### 3. data-testid 테이블
- [ ] 모든 인터랙티브 요소에 data-testid 지정
- [ ] 네이밍 규칙: `[컴포넌트]-[역할]` (예: `login-submit-btn`, `search-input`)

### 4. 디자인 토큰
- [ ] 색상 팔레트 (primary, gray, error, success 계열)
- [ ] 타이포그래피 (font-family, 크기별 스타일)
- [ ] 간격 시스템 (spacing scale)
- [ ] 반경 (border-radius scale)

### 5. 인터랙션 명세
- [ ] 스크롤 전략 (상태별 scrollIntoView 대상)
- [ ] 포커스 관리 (모달, 폼 전환 시)
- [ ] 트랜지션/애니메이션 (있는 경우)

### 6. 접근성 기준
- [ ] 키보드 네비게이션 요구사항
- [ ] ARIA 레이블 목록
- [ ] WCAG AA 색 대비 기준

### 7. FE 구현 노트
- [ ] 특별한 구현 주의사항 (상태 관리 전략, localStorage 사용 등)

## 필드 네이밍
- 컴포넌트 props, data-testid는 PM 기능정의서의 필드명 기반
- BE API 응답 필드명과 일치해야 함 (contracts/be-to-fe.md 참조)

## 산출물 위치
- UX 명세: GitHub → **Notion** (Notion MCP) / GitLab → **Git Wiki** (`glab wiki`)
- Figma 시안: **Figma** (Figma MCP, URL을 UX 명세에 포함)
- FE Agent는 Notion 또는 Git Wiki에서 UX 명세를, Figma에서 시안을 조회

## 검증 기준
- FE Agent가 Notion/Wiki의 UX 명세 + Figma 시안만 보고 **추측 없이** 구현 시작 가능해야 함
- "적절히 처리" 같은 모호한 지시 금지
- 누락된 상태가 있으면 FE는 작업을 거부하고 UX에 보완 요청
