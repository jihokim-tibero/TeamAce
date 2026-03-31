# PUB → FE 핸드오프 계약

## PUB가 FE에게 전달해야 하는 필수 산출물

### 1. View 컴포넌트 코드
- [ ] 모든 화면에 대응하는 View 컴포넌트 (TSX 파일)
- [ ] 각 View의 Props 인터페이스 (명시적 타입, any 금지)
- [ ] 이벤트 핸들러 콜백 시그니처 (onClick, onSubmit 등)
- [ ] View는 순수 프레젠테이션 (API 호출, store import 없음)

### 2. 5 상태 구현 (코드 레벨)
- [ ] idle — 기본 UI, 플레이스홀더, 초기값
- [ ] loading — 스켈레톤/스피너, aria-busy, 비활성 요소
- [ ] success — 결과 표시, 다음 액션 안내
- [ ] error — 에러 메시지, 재시도 CTA, 복구 경로
- [ ] empty — 빈 상태 아이콘, CTA, 안내 문구

### 3. data-testid 테이블
- [ ] 모든 인터랙티브 요소에 data-testid 지정 (코드에 구현됨)
- [ ] 네이밍 규칙: `[컴포넌트]-[역할]` (예: `login-submit-btn`, `search-input`)

### 4. 디자인 토큰 (코드)
- [ ] `styles/tokens.css` — CSS 변수 정의 (OKLCH 색상)
- [ ] 색상 팔레트 (primary, gray, error, success 계열)
- [ ] 타이포그래피 (font-family, 크기별 스타일)
- [ ] 간격 시스템 (spacing scale)
- [ ] 반경 (border-radius scale)

### 5. 공유 UI 컴포넌트
- [ ] `shared/ui/` — Button, Input, Card 등 기본 요소
- [ ] 각 컴포넌트에 data-testid + ARIA 적용

### 6. 접근성 구현 (코드 레벨)
- [ ] 키보드 네비게이션 구현됨
- [ ] ARIA 레이블 코드에 존재
- [ ] WCAG AA 색 대비 (OKLCH 기반 검증)
- [ ] prefers-reduced-motion 대응

### 7. View 명세 문서
- [ ] 화면 목록 + View 파일 매핑
- [ ] Props 인터페이스 요약
- [ ] FE Agent를 위한 연결 가이드 (hooks 바인딩 포인트, 데이터 구조, 콜백 시그니처)

## 디렉터리 구분

| PUB 소유 (FE 수정 금지) | FE 소유 |
|------------------------|---------|
| `features/*/views/` | `features/*/hooks/` |
| `shared/ui/` | `features/*/components/` |
| `styles/tokens.css` | `shared/hooks/`, `shared/monitoring/` |
| | `providers/`, `types/`, `pages/` |

## 필드 네이밍
- Props 인터페이스, data-testid는 PM 기능 명세서의 필드명 기반
- BE API 응답 필드명과 일치해야 함 (~/.claude/teamace/contracts/be-to-fe.md 참조)
- FE는 트랜스폼 함수에서 API 응답을 Props 형태로 변환

## 산출물 위치
- View 코드: **Git `feature/[feature-name]` 통합 브랜치**
- View 명세: GitHub → **Notion** (Notion MCP) / GitLab → **Git Wiki** (`glab api`)
- FE Agent는 브랜치의 View 코드를 직접 읽고, Notion/Wiki에서 View 명세를 조회

## 검증 기준
- FE Agent가 View 코드의 **Props 인터페이스만 보고** hooks + Container를 작성 가능해야 함
- View 컴포넌트를 import하고 Props를 주입하면 **즉시 렌더링** 되어야 함
- "적절히 처리" 같은 모호한 지시 금지 — 모든 상태가 코드로 구현되어 있어야 함
