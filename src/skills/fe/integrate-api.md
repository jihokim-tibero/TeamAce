# API 연동 Skill

## 목적
BE API 명세를 기반으로 타입 안전한 API 클라이언트와 커스텀 훅을 구현한다. PUB의 View 컴포넌트에 데이터를 주입하는 연결 계층을 만든다.

## 트리거
- PUB View 코드 + BE API 명세가 준비된 후
- 새 API 엔드포인트 연동 요청

## 입력
- PUB View 명세 (Props 인터페이스, 상태 정의)
- BE API 명세 (엔드포인트, TypeScript 인터페이스, 에러 코드)

## 절차
1. BE TypeScript 인터페이스를 `types/` 에 배치/검증
2. API 클라이언트 함수 구현:
   - fetch/axios 래핑
   - 인증 헤더 자동 삽입
   - 에러 응답 파싱 + 구조화
   - 재시도 로직 (지수 백오프)
   - 요청/응답 인터셉터
3. 커스텀 훅 구현 (`use[Feature]`):
   - TanStack Query / SWR 래핑 또는 직접 상태 관리
   - loading/error/success/empty 상태 관리
   - 캐시 전략 (stale-while-revalidate, invalidation)
   - 옵티미스틱 업데이트 (적절한 경우)
4. 데이터 트랜스폼 함수:
   - API 응답 → View Props 변환 (순수 함수)
   - 날짜 포매팅, 금액 포매팅, 상태 매핑
   - null/undefined 안전 처리
5. Container 컴포넌트:
   - PUB View를 import
   - hooks에서 데이터 추출
   - 트랜스폼 후 Props 주입

## 출력 형식
```
features/[domain]/
├── hooks/
│   ├── use[Feature].ts          ← API 호출 + 상태 관리
│   └── use[Feature]Transform.ts ← 데이터 변환 (순수 함수)
├── components/
│   └── [Name]Container.tsx      ← View + hooks 연결
└── __tests__/
    ├── use[Feature].test.ts
    └── use[Feature]Transform.test.ts
```

## 비동기 패턴

### 폴링 패턴 (Job 기반 비동기 처리)
비동기 작업이 즉시 완료되지 않는 경우 Job 생성 → 주기적 폴링 → 최종 상태 전환 패턴을 적용한다.
- createJob → poll (2초 간격 등) → 완료/실패 상태 전환
- 최대 폴링 횟수 설정으로 무한 대기 방지
- 폴링 중 사용자에게 진행 상태 피드백

### SSE 스트림 소비 패턴
Server-Sent Events를 소비할 때 이벤트 타입별 분기 처리를 적용한다.
- `event:` 필드 기반으로 분기 (예: reasoning, result, error)
- 각 이벤트 타입별 로컬 상태 업데이트
- 연결 끊김 시 재연결 로직 + 사용자 알림

### View 상태 머신
느슨한 문자열 대신 유니온 타입으로 View 상태를 정의하고 모든 가능한 상태를 exhaustive하게 처리한다.
- `type ViewState = IdleState | LoadingState | SuccessState | ErrorState | EmptyState`
- switch/match에서 누락 상태가 컴파일 타임에 잡히도록 구성

## 품질 체크리스트
- [ ] any 타입 0개
- [ ] 모든 API 엔드포인트에 에러 핸들링
- [ ] 재시도 로직 구현
- [ ] 데이터 트랜스폼 순수 함수 (side-effect 없음)
- [ ] 트랜스폼 함수 단위 테스트 커버리지 ≥ 90%
- [ ] null/undefined 안전 처리
- [ ] View 컴포넌트 미수정

## 안티패턴
- 컴포넌트에서 직접 fetch (hooks를 거치지 않음)
- 트랜스폼 로직을 View 컴포넌트에 삽입
- API 에러를 무시하고 빈 데이터 반환
- any 타입으로 API 응답 캐스팅
- PUB의 View 파일을 직접 수정
