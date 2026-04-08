# View 컴포넌트 구현 Skill

## 목적
PM 기획서를 기반으로 Impeccable 디자인 원칙을 적용한 View 컴포넌트(React TSX + Tailwind CSS)를 구현한다. 코드가 곧 시안이다.

## 전제 조건
- Impeccable 스킬이 글로벌 설치되어 있어야 함 (`~/.agents/skills/frontend-design/` 또는 `~/.claude/commands/frontend-design/`)
- `frontend-design` 스킬이 디자인 판단의 기초가 됨
- 7개 레퍼런스 파일이 각 도메인의 세부 기준 제공

## 트리거
- PM 기획서/기능 명세서 완료 후 View 구현 요청
- 새 화면/페이지 추가 요청

## 입력
- PM 기획서 (PRD) + 기능 명세서
- 디자인 토큰 (`styles/tokens.css`) — 없으면 design-system 스킬로 먼저 생성
- 기존 공유 UI (`shared/ui/`) — 없으면 함께 생성

## 절차
1. 기획서의 사용자 시나리오에서 화면 목록 도출
2. 화면별 컴포넌트 트리 설계
3. **Impeccable 디자인 방향 결정**:
   - `.claude/skills/` 내 `frontend-design` 스킬 읽기
   - 프로젝트 톤에 맞는 시각적 컨셉 결정
   - 필요 시 `/critique` 커맨드로 디자인 방향 검증
   - 안티패턴 사전 체크 (Inter 기본값, 순수 검정, 카드 in 카드 등)
4. Props 인터페이스 정의 (`any` 금지, 모든 props에 타입)
5. 5 상태 분기 구현 (agents/pub.md "5 상태 완전 구현" 참조)
6. data-testid 부여: `[컴포넌트]-[역할]` 형식
7. ARIA 레이블 + 키보드 네비게이션 구현
8. Tailwind + CSS 변수(tokens) 기반 스타일링
9. **Impeccable 검증**: `/audit` → `/polish` 순서로 실행
10. 스냅샷 테스트 (5 상태별)

## 출력 형식
```
features/[domain]/views/
├── [ViewName].tsx          ← View 컴포넌트
├── [ViewName].stories.tsx  ← 상태별 스토리 (선택)
└── __tests__/
    └── [ViewName].snap.tsx ← 스냅샷 테스트
```

## 핵심 원칙: View는 순수 프레젠테이션
- API 호출 금지 — fetch/axios/tanstack-query 사용하지 않음
- 전역 상태 직접 접근 금지 — Redux store, Context를 import하지 않음
- Props + 콜백으로만 외부와 통신
- FE Agent가 hooks로 데이터를 주입하면 바로 동작

## 품질 체크리스트
- [ ] Impeccable `frontend-design` 스킬 읽기 완료
- [ ] any 타입 0개
- [ ] 5 상태 전체 구현 (idle/loading/success/error/empty)
- [ ] data-testid 전체 부여
- [ ] ARIA 레이블 추가
- [ ] View에 비즈니스 로직 없음 (API 호출, store import 없음)
- [ ] 파일당 300줄 이하
- [ ] Impeccable 안티패턴 전체 준수
- [ ] OKLCH 색상 체계 사용 (tokens.css 참조)
- [ ] `/audit` + `/polish` 실행 완료

## 안티패턴
- Impeccable `frontend-design` 스킬을 읽지 않고 바로 구현 시작
- View 안에서 useEffect로 API 호출
- loading 상태만 구현하고 error/empty 누락
- data-testid 없이 className 기반 테스트 의존
- core-principles/pub.md P2의 8대 안티패턴 위반
- Impeccable 커맨드 활용 가능한데 수동 검증만 수행
