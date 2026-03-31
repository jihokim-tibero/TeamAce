# Impeccable 심사·폴리시 Skill

## 목적
구현된 View 코드를 Impeccable 커맨드(`/audit` + `/polish`)로 심사하고 품질을 끌어올린다.

## 전제 조건
- Impeccable 스킬이 프로젝트에 설치되어 있어야 함 (`.claude/skills/`)
- 설치 확인: `.claude/skills/` 내 `frontend-design` 스킬 + 레퍼런스 파일 존재

## 트리거
- View 컴포넌트 구현 완료 후 (PR 제출 전 필수)
- 기존 UI 품질 개선 요청

## 입력
- 구현된 View 컴포넌트 코드
- 디자인 토큰 (styles/tokens.css)

## 절차

### Phase 1: Audit (진단) — `/audit` 커맨드 활용

Impeccable의 `/audit` 커맨드를 실행하여 7개 도메인 진단:

| 도메인 | Impeccable 레퍼런스 | TeamAce 추가 검증 |
|--------|-------------------|------------------|
| 타이포그래피 | `typography.md` | Inter 기본값 금지 확인 |
| 색상·대비 | `color-and-contrast.md` | OKLCH 사용 + WCAG AA 확인 |
| 공간 | `spatial-design.md` | 4px grid + tokens.css 변수 사용 확인 |
| 모션 | `motion-design.md` | prefers-reduced-motion 대응 확인 |
| 인터랙션 | `interaction-design.md` | 키보드 완전 지원 확인 |
| 반응형 | `responsive-design.md` | 모바일 퍼스트 확인 |
| UX 라이팅 | `ux-writing.md` | 에러/빈 상태 문구 확인 |

Impeccable `/audit`의 결과에 더해, TeamAce 고유 검증 항목도 확인:
- 5 상태(idle/loading/success/error/empty) 전체 구현 여부
- data-testid 전체 부여 여부
- View 순수성 (API 호출/store import 없음)

### Phase 2: Polish (개선) — `/polish` 커맨드 활용

Audit 결과 기반으로 `/polish` 커맨드를 실행하여 코드 개선:

1. Critical 이슈 즉시 수정
2. Major 이슈 수정
3. Minor 이슈 수정 (시간 허용 시)

필요 시 특화 커맨드 추가 활용:
- 타이포그래피 문제 → `/typeset`
- 색상 문제 → `/colorize`
- 레이아웃 문제 → `/arrange`
- 접근성 문제 → `/harden`
- 모션 문제 → `/animate`

### Phase 3: 안티패턴 최종 체크

- [ ] Inter 폰트 기본값 → 의도적 서체 선택
- [ ] #000 순수 검정 → 컬러 틴트 다크 톤
- [ ] 보라색 그라데이션 기본값 → 브랜드 컬러
- [ ] 카드 안의 카드 → 정보 계층 평탄화
- [ ] 회색 텍스트 on 컬러 배경 → 충분한 대비
- [ ] 장식용 보더 → 공간/색조로 구분
- [ ] 동일 간격 반복 → 리듬감 spacing
- [ ] 기본 그림자 남발 → 의미 있는 elevation

## 출력 형식
```markdown
## Audit 결과 (Impeccable + TeamAce)
| # | 도메인 | 심각도 | 문제 | 해결 | 사용 커맨드 |
|---|--------|-------|------|------|-----------|

## 수정 내역
- [파일]: [변경 내용]

## 안티패턴 체크
✅/❌ 항목별 결과
```

## 품질 체크리스트
- [ ] Impeccable `/audit` 실행 완료
- [ ] 7개 도메인 전체 검증 완료
- [ ] Critical 이슈 0개
- [ ] Major 이슈 0개
- [ ] 안티패턴 8항목 전체 통과
- [ ] WCAG AA 색 대비 전체 통과
- [ ] 5 상태 전체 구현 확인
- [ ] data-testid 전체 부여 확인

## 안티패턴
- Impeccable `/audit` 실행하지 않고 수동 체크만으로 넘어감
- Critical 이슈를 "나중에 수정" 처리
- 접근성 검증 생략
- Impeccable 커맨드 활용 가능한데 수동으로 개선 시도
