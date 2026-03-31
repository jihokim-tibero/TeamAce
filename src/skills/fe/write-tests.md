# FE 테스트 작성 Skill

## 목적
hooks, 데이터 트랜스폼, Container 컴포넌트의 비즈니스 로직을 검증하는 테스트를 작성한다.

## 트리거
- hooks/Container 구현 완료 후
- API 연동 변경 후

## 입력
- 구현된 hooks, 트랜스폼 함수, Container 코드
- BE API 명세 (요청/응답 스키마, 에러 코드)
- PUB View 명세 (Props 인터페이스)

## 절차

### 1. 데이터 트랜스폼 단위 테스트 (최우선)
```typescript
describe('[transformName]', () => {
  it('transforms API response to View props', () => { ... })
  it('handles null/undefined fields safely', () => { ... })
  it('formats dates correctly', () => { ... })
  it('maps status codes to display values', () => { ... })
  it('returns empty state for empty data', () => { ... })
})
```

### 2. hooks 테스트
```typescript
describe('use[Feature]', () => {
  it('returns loading state initially', () => { ... })
  it('returns success state with transformed data', () => { ... })
  it('returns error state on API failure', () => { ... })
  it('returns empty state when no data', () => { ... })
  it('retries on transient errors', () => { ... })
  it('caches response correctly', () => { ... })
})
```

### 3. Container 통합 테스트
```typescript
describe('[Name]Container', () => {
  it('passes correct props to View', () => { ... })
  it('handles loading state', () => { ... })
  it('handles error state with retry', () => { ... })
  it('handles empty state', () => { ... })
})
```

### 4. 에러 바운더리 테스트
```typescript
describe('ErrorBoundary', () => {
  it('catches render errors', () => { ... })
  it('shows fallback UI', () => { ... })
  it('logs error to monitoring', () => { ... })
  it('supports retry action', () => { ... })
})
```

## 품질 체크리스트
- [ ] 트랜스폼 함수 커버리지 ≥ 90%
- [ ] hooks 커버리지 ≥ 80%
- [ ] 모든 API 에러 코드에 대한 테스트
- [ ] null/undefined 엣지 케이스 테스트
- [ ] 에러 바운더리 테스트 존재
- [ ] 전체 커버리지 ≥ 80%

## 안티패턴
- 트랜스폼 함수 테스트 없이 Container만 테스트
- happy path만 테스트하고 에러 케이스 미테스트
- API 응답을 any로 모킹
- 구현 상세(내부 상태)에 의존하는 테스트
