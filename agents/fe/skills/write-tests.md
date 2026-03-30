# FE 테스트 작성 Skill

## 목적
컴포넌트의 모든 상태와 인터랙션을 커버하는 테스트를 작성한다.

## 트리거
- 컴포넌트 구현 완료 후
- 기존 컴포넌트 변경 후

## 입력
- 구현된 컴포넌트 코드
- UX 명세 (상태 정의, data-testid)

## 절차
1. 스냅샷 테스트: 각 상태(idle/loading/success/error/empty)의 렌더링 스냅샷
2. 단위 테스트: data-testid 기반 인터랙션 테스트
3. 상태 전환 테스트: 사용자 액션에 따른 상태 변경 확인
4. 에러 바운더리 테스트: 에러 발생 시 폴백 UI 확인
5. 접근성 테스트: 키보드 네비게이션, ARIA 레이블

## 출력 형식
```typescript
describe('[ComponentName]', () => {
  describe('Snapshots', () => {
    it('renders idle state', () => { ... })
    it('renders loading state', () => { ... })
    it('renders success state', () => { ... })
    it('renders error state', () => { ... })
    it('renders empty state', () => { ... })
  })
  describe('Interactions', () => {
    it('[data-testid] triggers [action]', () => { ... })
  })
  describe('Accessibility', () => {
    it('supports keyboard navigation', () => { ... })
  })
})
```

## 품질 체크리스트
- [ ] 5 상태 스냅샷 테스트 존재
- [ ] 모든 data-testid 요소에 대한 인터랙션 테스트
- [ ] 에러 바운더리 테스트 존재
- [ ] 커버리지 ≥ 80%

## 안티패턴
- 스냅샷 테스트 없이 단위 테스트만 작성
- data-testid 대신 className으로 요소 선택
- happy path만 테스트하고 error/empty 미테스트
