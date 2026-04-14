# FE 단위 테스트 작성 Skill

## 목적
hooks와 데이터 트랜스폼 함수의 로직을 **화이트박스 관점의 단위 테스트**로 검증한다.
E2E·시나리오 기반 블랙박스 테스트는 QA 책임이므로 이 스킬의 범위에서 제외한다.

## 범위

| 포함 (FE 책임) | 제외 (QA 책임) |
|---------------|----------------|
| 데이터 트랜스폼 함수 단위 테스트 | E2E 시나리오 |
| hooks 단위 테스트 (API는 모킹) | 브라우저 기반 시나리오 테스트 |
| 유틸·helper 단위 테스트 | 사용자 여정 기반 통합 검증 |
| ErrorBoundary 동작 단위 테스트 | 회귀 스위트 |

## 트리거
- hooks / 트랜스폼 / 유틸 구현 완료 후
- API 연동 변경 후

## 입력
- 구현된 hooks, 트랜스폼 함수, 유틸
- BE API 명세 (모킹용 응답 스키마, 에러 코드)

## 절차

### 1. 데이터 트랜스폼 단위 테스트 (최우선, 커버리지 ≥ 90%)
```typescript
describe('[transformName]', () => {
  it('transforms API response to View props', () => { ... })
  it('handles null/undefined fields safely', () => { ... })
  it('formats dates correctly', () => { ... })
  it('maps status codes to display values', () => { ... })
  it('returns empty state for empty data', () => { ... })
})
```

### 2. hooks 단위 테스트 (API 모킹, 커버리지 ≥ 80%)
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

### 3. ErrorBoundary 단위 테스트
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
- [ ] 모든 API 에러 코드에 대한 단위 테스트
- [ ] null/undefined 엣지 케이스 테스트
- [ ] ErrorBoundary 단위 테스트 존재
- [ ] 전체 커버리지 ≥ 80%

## 안티패턴
- 트랜스폼 함수 테스트 없이 상위 컴포넌트만 테스트
- happy path만 테스트하고 에러 케이스 미테스트
- API 응답을 `any`로 모킹
- 구현 상세(내부 useState 값 직접 읽기 등)에 의존하는 테스트
- **E2E/시나리오 테스트를 FE가 작성** — QA 영역이므로 금지. 명세 기반 블랙박스 테스트가 필요하면 QA에 요청
