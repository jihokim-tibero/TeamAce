# 성능 최적화 Skill

## 목적
Core Web Vitals 기준을 충족하는 프론트엔드 성능 최적화를 수행한다.

## 트리거
- 구현 완료 후 성능 검증 단계
- 성능 이슈 리포트 수신
- Core Web Vitals 기준 미달

## 입력
- 구현된 소스 코드
- 성능 측정 결과 (있는 경우)

## 절차

### 1. 측정 (Measure First)
```typescript
// usePerformance.ts — Core Web Vitals 측정
import { onLCP, onCLS, onINP } from 'web-vitals';

export function usePerformanceMonitoring() {
  useEffect(() => {
    onLCP(metric => report('LCP', metric));
    onCLS(metric => report('CLS', metric));
    onINP(metric => report('INP', metric));
    // 목표값: agents/fe.md "성능 엔지니어링" 참조
  }, []);
}
```

### 2. 번들 최적화
- 코드 스플리팅: `React.lazy()` + `Suspense`
- 트리 쉐이킹: 미사용 export 제거
- 동적 임포트: 조건부 로드 (`import()`)
- 번들 분석: `vite-bundle-analyzer` / `webpack-bundle-analyzer`

### 3. 렌더링 최적화
- `React.memo()`: 불필요한 리렌더 방지
- `useMemo()`: 비용 높은 계산 캐싱
- `useCallback()`: 콜백 참조 안정화
- `startTransition()`: 낮은 우선순위 업데이트
- 가상 스크롤: 대량 리스트 (`react-virtual`)

### 4. 네트워크 최적화
- API 응답 캐싱 (TanStack Query staleTime/cacheTime)
- 프리페칭: 다음 화면 데이터 사전 로드
- 요청 디듀플리케이션
- 이미지 최적화 (lazy loading, srcset, WebP/AVIF)

### 5. 리소스 최적화
- 폰트 최적화: `font-display: swap`, 서브셋
- CSS 최적화: 미사용 스타일 제거
- 프리로드/프리커넥트: 크리티컬 리소스

## 출력 형식
```markdown
## 성능 최적화 리포트
| 항목 | Before | After | 목표 | 상태 |
|------|--------|-------|------|------|
| LCP  |        |       | < 2.5s | ✅/❌ |
| CLS  |        |       | < 0.1  | ✅/❌ |
| INP  |        |       | < 200ms | ✅/❌ |
| Bundle Size |  |      |        |      |

## 적용 사항
- [최적화 항목]: [변경 내용]
```

## 품질 체크리스트
- [ ] LCP < 2.5s
- [ ] CLS < 0.1
- [ ] INP < 200ms
- [ ] 코드 스플리팅 적용 (페이지 단위 이상)
- [ ] 불필요한 리렌더 방지 (React DevTools Profiler)
- [ ] 이미지 lazy loading 적용

## 안티패턴
- 측정 없이 최적화 ("감으로" 최적화)
- 모든 컴포넌트에 무차별 React.memo
- useMemo/useCallback을 원시값에 적용
- 프리매추어 최적화 (병목이 아닌 곳 최적화)
