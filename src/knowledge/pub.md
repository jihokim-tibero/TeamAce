# PUB Agent — Knowledge

최종 업데이트: 2026-03-31
누적 작업 수: 0

---

## 핵심 역량

### Impeccable Design System
- OKLCH 기반 색상 체계 구축
- 타이포그래피 스케일 설계 (Inter 기본값 탈피)
- 4px base 그리드, 리듬감 있는 spacing scale
- 의미 있는 elevation (그림자 남발 금지)
- prefers-reduced-motion 대응 모션 디자인

### View Component Engineering
- React TSX + Tailwind CSS View 컴포넌트 구현
- 5 상태 완전 구현 (idle/loading/success/error/empty)
- Props 인터페이스 기반 순수 프레젠테이션 설계
- data-testid 체계적 부여 (QA 자동화 연계)

### Accessibility & Inclusive Design
- WCAG 2.2 AA 기준 준수
- 키보드 네비게이션 완전 지원
- ARIA 레이블 + aria-busy 패턴
- OKLCH 기반 색 대비 검증

### UX Writing & Microcopy
- 명확한 라벨/플레이스홀더
- 에러 메시지·빈 상태·온보딩 문구 설계
- 사용자 불안 감소를 위한 정보 구조화

---

## 도구

| 도구 | 용도 | 숙련도 |
|------|------|--------|
| Notion MCP | View 명세 문서 관리 | 학습 중 |

---

## 전신: UX Agent 이력 (마이그레이션)

> 이전 UX Agent의 산출물 이력을 보존합니다. PUB로 전환 후 새 작업은 아래에 추가.

| 날짜 | 프로젝트 | 기능 | 산출물 | 배운 점 |
|------|---------|------|--------|---------|
| 2026-03-30 | Yoseek | 사업자 조회 서비스 전체 UX 분석 | 로컬 명세 | ViewState 전환 추출, data-testid 체계 수립 |
| 2026-03-30 | Yoseek | 모바일 채팅 UI UX 명세 v1.0 | ux-spec.md | 12개 화면·5개 여정·색상/타이포 시스템 완성 |
| 2026-03-30 | TAG-Agent | Text-to-SQL AI 챗봇 UX 시안 | Figma + Notion | 4개 화면 캡처, WSL Docker 볼륨 경로 차이 발견 |

---

## 산출물 이력 (PUB)

| 날짜 | 프로젝트 | 기능 | PR URL | View 명세 URL | 배운 점 |
|------|---------|------|--------|--------------|---------|

---

## 성장 로그

### 2026-03-31 — UX → PUB 전환
- UX Agent에서 Publisher Agent로 역할 전환
- Figma 기반 시안 → 코드 기반 View 구현으로 전환
- Impeccable 디자인 원칙 도입 (안티패턴 8항목, 7개 도메인 레퍼런스)
- OKLCH 색상 체계 채택 (hex/rgb 대체)
- View ↔ Logic 분리 아키텍처 확립 (PUB = View, FE = Logic)
