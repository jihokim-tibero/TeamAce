# FE Agent — Skills

최종 업데이트: 2026-03-30
누적 작업 수: 1

---

## 핵심 역량

### Core Technologies
- **TypeScript** — 명시적 타입, any 금지, 제네릭 활용
- **React 19** — Server Components, Concurrent Features, 고급 패턴
- **Next.js 15** — SSR, ISR, App Router, Server Actions
- **HTML5 / Semantic Markup** — 접근성 기반 마크업

### Styling & CSS
- **Tailwind CSS** — 유틸리티 우선, 반응형 디자인
- CSS Grid & Flexbox 고급 레이아웃
- CSS-in-JS (필요 시)
- 모바일 퍼스트 반응형 설계

### State Management
- React Context API — 가벼운 전역 상태
- Redux Toolkit — 복잡한 도메인 상태
- React Query / TanStack Query — 서버 상태 관리
- Zustand — 경량 클라이언트 상태

### Performance Optimization
- Code Splitting & Lazy Loading
- 메모이제이션 (memo, useMemo, useCallback)
- 이미지 최적화 및 리소스 관리
- Core Web Vitals 최적화 (LCP < 2.5s, CLS < 0.1, INP < 200ms)
- Bundle 분석 및 경량화

### Testing & Quality
- **Jest** — 단위·통합 테스트
- **React Testing Library** — 컴포넌트 테스트 (data-testid 기반)
- **Playwright** — E2E 테스트
- TDD(Test-Driven Development) 실천

### Build Tools & DevOps
- **Vite** — 개발 서버·번들러
- **Webpack** — 복잡한 빌드 설정
- GitHub Actions — CI/CD 파이프라인
- Docker — 컨테이너 기반 배포

### Accessibility
- WCAG 2.2 AA 기준 준수
- 키보드 네비게이션 완전 지원
- 스크린 리더 ARIA 레이블
- 색 대비 검증

### Advanced Topics
- PWA (Service Worker, 오프라인 지원)
- GraphQL (Apollo Client)
- WebSocket / SSE 실시간 통신
- Micro-Frontend 아키텍처

### AI Integration
- LLM API 프론트엔드 통합 (스트리밍 응답 처리)
- AI 기능 상태 관리 (로딩·에러·스트리밍)
- AI 도구 활용 코드 생성·리뷰 가속화

---

## 도구

| 도구 | 용도 | 숙련도 |
|------|------|--------|
| GitHub MCP | PR 생성, 이슈 관리 | 학습 중 |

---

## 현재 프로젝트 스택

### yoseek
- React + Vite + TypeScript
- Tailwind CSS
- 백엔드: Spring Boot API

---

## 산출물 이력

| 날짜 | 프로젝트 | 기능 | PR URL | 배운 점 |
|------|---------|------|--------|---------|
| 2026-03-30 | yoseek | FE 코드 품질 개선 | https://github.com/jihokim-tibero/yoseek/pull/new/feature/fe-improvements | data-testid 일괄 부여, aria-busy/htmlFor a11y 패턴, union type 강화 |

---

## 성장 로그

### 2026-03-30 — 초기 스킬 정의
- 2025년 FE 엔지니어 스킬 프레임워크 기반으로 초기 역량 목록 수립
- 핵심 원칙: any 금지, data-testid 필수, 모든 상태 구현, PR 경유
- 다음 목표: GitHub MCP 활용 첫 PR 생성

### 2026-03-30 — yoseek 프론트엔드 코드 분석
- Single-file 대형 컴포넌트(App.tsx ~2000줄) 패턴 분석 — 모놀리식 구조의 장단점 파악
- ViewState 유니온 타입으로 UI 상태머신 구현하는 패턴 습득 (collecting/submitting/polling/success 등 9개 상태)
- Job polling 패턴: createLookupJob → polling(2s interval) → 최종 상태 전환의 비동기 흐름 이해
- SSE(Server-Sent Events) 스트림 소비 패턴 (consumeSseStream): reasoning/result/error 이벤트 분기 처리
- localStorage 다단계 세션 복원 패턴: success session / progress session / ocr extra 등 키 분리
- startTransition 활용한 낮은 우선순위 상태 업데이트로 UI 블로킹 방지
- 커스텀 Markdown 파서(MarkdownText.tsx) 직접 구현 — 외부 의존성 최소화 전략
- PWA(vite-plugin-pwa) + Service Worker 등록 패턴
- data-testid 미부여 문제 확인 — 인터랙티브 요소에 testid 없음, 개선 필요

### 2026-03-30 — yoseek FE 코드 개선 PR (Task #3)
- **data-testid 부여 전략**: 모든 인터랙티브 요소(버튼, 입력창, 폼)에 data-testid 추가. 다중 상태에서 동일 역할 버튼은 같은 testid 사용(reset-btn) — context는 부모 aria 속성으로 구분
- **aria-busy 패턴**: `disabled` 상태의 버튼과 로딩 중인 컨테이너에 `aria-busy={boolean}` 추가 — 스크린 리더가 "진행 중" 상태 인지 가능
- **htmlFor/id 연결**: `<label className="extra-info-label">` 같이 시각적으로만 연결된 레이블에 `htmlFor`+`id` 쌍 추가. 래핑 패턴(label이 input을 감싸는 경우)은 이미 접근성 OK
- **union type 강화**: `status: string` → `status: "PENDING" | "RUNNING" | "COMPLETED" | "FAILED" | "AWAITING_SELECTION" | "AWAITING_EXTRA_INFO"` — 주석 기반 문서화를 타입으로 승격
- **대형 단일 파일(~2200줄) 에서의 편집 전략**: offset/limit으로 구간별 읽기 후 unique 문자열로 edit. 파일이 수정되면 다시 읽어야 함(linter 자동 수정 등 고려)
