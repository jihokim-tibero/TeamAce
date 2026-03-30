# UX Agent — Knowledge

최종 업데이트: 2026-03-30
누적 작업 수: 4

---

## 핵심 역량

### Research & Discovery
- 사용자 인터뷰 설계 및 진행
- 사용성 테스트 (고충실도 프로토타입 기반)
- Card Sorting & Information Architecture 설계
- 설문·정량 분석으로 패턴 발견
- 지속적 사용자 피드백 수집 체계 구축

### Design Systems & Consistency
- 디자인 시스템 컴포넌트 라이브러리 구축·관리
- Figma 컴포넌트 아키텍처 (Atomic Design)
- 토큰(색상·타이포·간격) 체계 정의
- 재사용 가능한 패턴 문서화

### Prototyping & Interaction Design
- **Figma** — 와이어프레임, 고충실도 시안, 프로토타입
- 모든 컴포넌트 상태 정의 (idle/loading/success/error/empty)
- 마이크로 인터랙션 및 트랜지션 설계
- 사용자 여정 플로우 다이어그램

### Accessibility & Inclusive Design
- **WCAG 2.2 AA** 기준 준수
- 색 대비, 키보드 네비게이션, 스크린 리더 지원
- 포용적 설계 원칙 적용
- data-testid 기반 QA 협업 설계

### UX Writing & Microcopy
- 명확하고 공감적인 인터페이스 문구 작성
- 에러 메시지·빈 상태·온보딩 문구 설계
- 사용자 불안 감소를 위한 정보 구조화

### AI-Assisted Design
- Figma AI 플러그인 활용 (와이어프레임 생성·일관성 검사)
- AI 기반 접근성 자동 검사
- AI 도구로 시안 변형·검증 속도 향상
- AI 편향·윤리 고려한 UX 설계

### Systems Thinking & Strategy
- 제품 전략과 UX 정렬
- 트레이드오프 분석 및 의사결정 근거 문서화
- 데이터 기반 디자인 의사결정
- 비즈니스 지표(전환율·이탈률)와 UX 연결

---

## 도구

| 도구 | 용도 | 숙련도 |
|------|------|--------|
| Figma MCP | 시안 생성·수정·프로토타입 | 학습 중 |
| Notion MCP | UX 명세 문서 관리 | 학습 중 |

---

## 산출물 이력

| 날짜 | 프로젝트 | 기능 | Figma URL | Notion URL | 배운 점 |
|------|---------|------|-----------|-----------|---------|
| 2026-03-30 | Yoseek | 사업자 조회 서비스 전체 UX 분석 | MCP 미연결 (로컬 명세 작성) | MCP 미연결 (로컬 명세 작성) | React SPA 코드 역독으로 ViewState 전환 완전 추출, data-testid 체계 수립 |
| 2026-03-30 | Yoseek | 모바일 채팅 UI 전체 UX 명세 v1.0 | MCP 미연결 → projects/yoseek/ux/ux-spec.md | MCP 미연결 (로컬 작성) | 12개 화면·5개 사용자 여정·색상/타이포 시스템·접근성 기준·FE구현노트·QA체크리스트 완성 |
| 2026-03-30 | Yoseek | Figma 파일 생성 및 디자인 토큰·시안 초기 구축 | https://www.figma.com/design/o97Toh955RRzNZOosQvRrd | — | Figma MCP 연결 성공, 디자인 토큰 15색·간격·반경 변수 생성, generate_figma_design으로 실제 앱 캡처 완료 |
| 2026-03-30 | TAG-Agent | Text-to-SQL AI 챗봇 전체 UX 시안 | https://www.figma.com/design/FmheJEoTxhWsQUbkuhoKNU | https://www.notion.so/33318a01a4e8812296f6cbf84b0d66d3 | 4개 화면 캡처(로그인·스키마·문서·관리자), WSL Docker 볼륨 경로 차이 발견, 인라인 스크립트 injection 방식 확립 |

---

## 성장 로그

### 2026-03-30 — 초기 스킬 정의
- 2025년 UX 디자이너 스킬 프레임워크 기반으로 초기 역량 목록 수립
- 핵심 원칙: 모든 상태 명시, WCAG AA 준수, FE 구현 청사진 역할
- 다음 목표: Figma MCP 활용 첫 시안 작성

### 2026-03-30 — TAG-Agent Figma 시안 작성 (네 번째 실제 작업)

**수행 작업**
- TAG-Agent UX 시안 Figma 파일 생성 (key: FmheJEoTxhWsQUbkuhoKNU)
- `generate_figma_design` + 브라우저 캡처로 4개 화면 시안 추가:
  - S-000 로그인 (node-id=1-2)
  - S-002 스키마 브라우저 (node-id=4-2)
  - S-003 문서 관리 (node-id=5-2)
  - S-004 관리자 에이전트 설정 (node-id=2-2)
- Notion에 UX 명세 v1.0 작성 (화면목록·컴포넌트상태·사용자여정·접근성·엣지케이스·FE구현노트·QA체크리스트)

**습득 패턴**
- **WSL Docker 볼륨 경로 차이**: `team-ace/projects/` vs `/home/kjh/project/` — Docker mount source 확인 필수 (`docker inspect --format '{{range .Mounts}}...'`)
- **Vite async script 제거 문제**: `<script src="..." async>` → Vite dev 모드가 제거. 인라인 `createElement` 방식으로 우회
- **PowerShell URL 전달**: `Start-Process 'URL'` (단일 인용부호)가 가장 안정적. `&` 포함 URL도 정상 전달
- **capture pending 반복 시**: 새 브라우저 탭 열기 재시도로 해결 (same captureId 재사용 가능)
- **앱 베이스 경로 확인**: `vite.config.js`의 `base:` 값 확인 → `/ai/` prefix 필수

**한계 및 개선점**
- use_figma Starter Plan 한도로 페이지 구조화 불가 → generate_figma_design으로 대체
- 인증 필요 페이지(채팅 메인 로그인 후 상태)는 로그인 없이 캡처 불가 → 테스트 계정 사전 확보 필요
- 채팅 메인 + ReasoningPanel 펼침 상태는 캡처 미완료 (수동 캡처 필요)

### 2026-03-30 — Yoseek Figma 파일 생성 및 시안 초기 구축 (세 번째 실제 작업)

**수행 작업**
- Figma MCP 첫 연결 성공 (`whoami` → Sysmaster UX Team)
- Figma 파일 신규 생성: "Yoseek — 사업자 조회 서비스" (key: o97Toh955RRzNZOosQvRrd)
- 3개 페이지 구조 설정: 🎨 Design Tokens / 📱 Screens / 🔄 User Flows
- 디자인 토큰 변수 27개 생성: 색상 15개(primary/gray/error/success), 간격 6개, 반경 6개
- Docker로 Vite 개발 서버 구동 (node:22-alpine, 포트 5786)
- generate_figma_design으로 실제 앱 초기 화면(S-001) 캡처 → Figma 파일에 추가
- UX 명세 v1.1 업데이트: Figma URL 기록

**습득 패턴**
- Figma `create_new_file` API: `fileName`, `planKey`, `editorType` 필수 파라미터
- Inter 폰트 스타일명: "Semi Bold" (SemiBold 아님) — 폰트 사용 전 `listAvailableFontsAsync()` 확인 필수
- use_figma Starter Plan 호출 한도 존재 → 복잡한 화면은 `generate_figma_design`(캡처 방식)이 더 효율적
- WSL 환경에서 브라우저 열기: `powershell.exe -Command "Start-Process '<url>'"` 사용 (xdg-open/cmd.exe 불안정)
- `generate_figma_design` 캡처 URL: hash 형식 `#figmacapture=...&figmadelay=...` 사용

**한계 및 개선점**
- use_figma Starter Plan 호출 수 제한으로 화면 빌드 중단 → Pro Plan 또는 generate_figma_design 활용 권장
- 추가 상태 캡처(error/success) 미완료 — 브라우저 localStorage 주입 방식 확인 필요
- Figma 파일의 📱 Screens 페이지에 앱 초기 화면 1개 캡처 완료; 나머지 7개 화면은 수동 캡처 가능(브라우저 캡처 툴바 활용)

### 2026-03-30 — Yoseek UX 명세 v1.0 완성 (두 번째 실제 작업)

**수행 작업**
- 12개 화면(S-001~S-012) 전체 레이아웃 ASCII 와이어프레임 + 컴포넌트 상태 매트릭스 작성
- 5개 사용자 여정(수동입력/OCR/동명매장/유효성오류/세션복원) 플로우 정의
- 색상 팔레트(8색) + 타이포그래피 + 간격 시스템 완전 문서화
- 스크롤 전략 테이블(viewState × advisorBrief.status 조합별)
- WCAG AA 접근성 기준 명세 (role="log", role="alert", aria-busy 등)
- FE 구현 노트 8항 (localStorage 키 패턴, ViewState 분기법, 조건부 포커스 로직)
- QA 체크리스트 20항 작성

**습득 패턴**
- 채팅형 SPA의 ViewState+InputMode 이중 상태 관리를 화면 ID 체계로 매핑하는 방법
- 스크롤 전략을 상태별로 표로 정리해 FE가 추측 없이 구현 가능하게 명세하는 기법
- localStorage 세션 키 패턴을 명세에 포함시켜 FE·QA 양쪽이 참조 가능하게 구조화

**한계 및 개선점**
- Figma MCP 미연결 → ASCII 와이어프레임으로 대체, MCP 연결 후 실제 프레임 변환 필요
- Notion MCP 미연결 → 로컬 파일로 대체, MCP 연결 후 업로드 필요
- 다음 작업 시: MCP 연결 상태 먼저 확인하는 루틴 추가 (이전과 동일한 한계 반복)

### 2026-03-30 — Yoseek UX 분석 및 명세 작성 (첫 번째 실제 작업)

**수행 작업**
- App.tsx (2406줄) 전체 역독으로 ViewState 9종 완전 추출
- 채팅형 SPA 특유의 상태 머신 구조 파악 (ViewState + InputMode 조합)
- 컴포넌트별 상태 × 트리거 × data-testid 매트릭스 작성
- 17개 화면, 5개 핵심 컴포넌트 상태 정의
- UX 개선 제안 8건 (High 3 / Medium 3 / Low 2) 도출

**습득 패턴**
- React SPA 코드 → UX 명세 역추출: ViewState union type이 화면 상태의 단일 진실 공급원
- 채팅형 UI의 스크롤 UX: 상태별로 다른 scrollIntoView 전략 (bottomRef vs contentStartRef)
- localStorage 세션 복원 패턴: progress session / success session 분리 이유 이해
- OCR + 수동입력 병렬 경로의 converging point 파악

**한계 및 개선점**
- Figma MCP 미연결로 실제 시안 생성 불가 → MCP 연결 후 로컬 명세를 Figma 프레임으로 변환 필요
- Notion MCP 미연결로 온라인 문서화 불가 → 동일하게 MCP 연결 후 처리
- 다음 작업 시: MCP 연결 상태 먼저 확인하는 루틴 추가
