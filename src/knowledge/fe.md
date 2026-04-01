# FE Agent — Knowledge

최종 업데이트: 2026-03-30
누적 작업 수: 1

---

## 산출물 이력

| 날짜 | 프로젝트 | 기능 | PR URL | 배운 점 |
|------|---------|------|--------|---------|
| 2026-03-30 | yoseek | FE 코드 품질 개선 | feature/fe-improvements | data-testid 일괄 부여, aria-busy/htmlFor a11y 패턴, union type 강화 |

---

## 핵심 교훈

- **data-testid 전략**: 다중 상태에서 동일 역할 버튼은 같은 testid 사용, context는 부모 aria 속성으로 구분
- **aria-busy 패턴**: disabled 버튼과 로딩 컨테이너에 `aria-busy={boolean}` 추가
- **htmlFor/id 연결**: 시각적으로만 연결된 레이블에 `htmlFor`+`id` 쌍 추가. 래핑 패턴은 이미 OK
- **union type 승격**: `status: string` → 구체적 union type으로 주석 문서화를 타입으로 승격
- **ViewState 유니온 타입**: UI 상태머신 구현 패턴 (9개 상태)
- **Job polling 패턴**: createJob → polling(2s interval) → 최종 상태 전환
- **SSE 스트림 소비**: reasoning/result/error 이벤트 분기 처리
