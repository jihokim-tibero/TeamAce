# 테스트 시나리오 작성 Skill

## 목적
리스크 기반으로 우선순위가 부여된 테스트 시나리오를 작성한다.

## 트리거
- PM 기획서 + PUB View 명세 + FE/BE 코드가 준비된 후

## 입력
- PM 기획서 (수락 기준)
- PM 기능 명세서 (기능 목록, 상세 명세)
- PUB View 명세 (data-testid, 상태 정의, 사용자 여정)
- BE API 명세 (엔드포인트, 에러 코드)
- FE/BE 코드 변경 diff

## 절차
1. 수락 기준에서 Given-When-Then TC 도출
2. 리스크 분석:
   - Critical: 사용자 핵심 가치 경로, 결제/인증, 데이터 손실 가능성
   - High: 주요 기능의 예외 흐름, 에러 처리
   - Medium: 부가 기능, UI/UX 세부사항
   - Low: 엣지 케이스, 미약한 영향
3. 각 TC에 리스크 근거 명시 ("왜 이 우선순위인가")
4. data-testid 기반 자동화 가능 여부 판단
5. 검증 유형 분류 (기능/UI/성능/접근성/보안/회귀)

## 출력 형식
```markdown
## TC-[번호]: [시나리오명]
**Given**: [초기 상태]
**When**: [액션] (data-testid: `[id]`)
**Then**: [기대 결과]

**우선순위**: Critical / High / Medium / Low
**리스크 근거**: [비즈니스 이유]
**자동화 가능**: Yes / No
**검증 유형**: 기능 / UI / 성능 / 접근성 / 보안 / 회귀
```

## 품질 체크리스트
- [ ] 수락 기준 대비 TC 매핑률 100%
- [ ] 모든 TC에 리스크 근거 존재
- [ ] Critical TC가 핵심 가치 경로를 커버
- [ ] data-testid 기반 자동화 가능 TC ≥ 90%
- [ ] 에러/예외 흐름 TC 존재

## 안티패턴
- 리스크 근거 없이 "중요해 보여서" Critical 배정
- happy path만 테스트하고 에러 케이스 무시
- data-testid 미활용 (CSS selector 기반 TC)
