# 컴포넌트 구현 Skill

## 목적
UX 명세를 기반으로 타입 안전하고 접근성을 갖춘 React 컴포넌트를 구현한다.

## 트리거
- UX 명세 + BE API 명세가 준비된 후 FE 구현 요청

## 입력
- UX 명세 (화면목록, 상태정의, data-testid, 디자인토큰)
- BE API 명세 (엔드포인트, TypeScript 인터페이스)

## 절차
1. UX 명세에서 구현할 컴포넌트 목록 확인
2. BE TypeScript 인터페이스를 types/ 에 배치
3. 컴포넌트 스캐폴딩:
   - Props 인터페이스 정의 (any 금지)
   - 5 상태 분기 (idle/loading/success/error/empty)
   - data-testid 부여
   - ARIA 레이블 추가
4. 커스텀 훅 추출 (비즈니스 로직 분리)
5. 에러 바운더리 래핑
6. 스타일링 (디자인 토큰 기반)
7. 스냅샷 테스트 + 단위 테스트 작성

## 출력 형식
```
features/[domain]/
├── components/[ComponentName].tsx
├── hooks/use[Feature].ts
└── __tests__/
    ├── [ComponentName].test.tsx
    └── [ComponentName].snap.tsx
```

## 품질 체크리스트
- [ ] any 타입 0개
- [ ] UX 명세의 5 상태 전체 구현
- [ ] data-testid 전체 부여 (UX 테이블 대조)
- [ ] ARIA 레이블 추가
- [ ] 에러 바운더리 적용
- [ ] 파일당 300줄 이하
- [ ] 레이어 순서 준수 (pages → features → shared)

## 안티패턴
- `as any` 캐스팅으로 타입 에러 회피
- loading 상태만 구현하고 error/empty 미구현
- data-testid 없이 className 기반 테스트
- 단일 파일에 모든 로직 집중 (300줄 초과)
