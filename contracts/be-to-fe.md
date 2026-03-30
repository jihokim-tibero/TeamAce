# BE → FE 핸드오프 계약

## BE가 FE에게 전달해야 하는 필수 산출물

### 1. API 엔드포인트 목록
- [ ] Method, Path, 목적, 인증 방식
- [ ] 버전 정보 (기본: /api/v1/)

### 2. 요청/응답 스키마
- [ ] Request Body (필드명, 타입, required/optional)
- [ ] Response Body (필드명, 타입, 예시 값)
- [ ] Query Parameters (해당 시)

### 3. 에러 응답 체계
- [ ] HTTP 상태 코드별 에러 조건
- [ ] 에러 코드 (예: `INVALID_INPUT`, `UNAUTHORIZED`)
- [ ] 에러 응답 형식: `{ error: string, code: string, requestId: string }`

### 4. TypeScript 인터페이스
- [ ] API 요청/응답에 대한 TypeScript 타입 정의
- [ ] enum 또는 union type (상태값 등)

```typescript
// 예시 — BE가 제공해야 하는 형태
interface LoginRequest {
  email: string;
  password: string;
}

interface LoginResponse {
  accessToken: string;
  user: {
    id: string;
    name: string;
    role: "admin" | "user";
  };
}

interface ErrorResponse {
  error: string;
  code: string;
  requestId: string;
}
```

### 5. 인증/인가 방식
- [ ] 토큰 전달 방식 (Authorization 헤더, httpOnly 쿠키 등)
- [ ] 토큰 갱신 방법
- [ ] 권한별 접근 가능 엔드포인트

### 6. 실시간 통신 (해당 시)
- [ ] WebSocket/SSE 이벤트 타입 목록
- [ ] 이벤트 페이로드 스키마
- [ ] 이벤트 순서 보장 여부

## 필드 네이밍
- API 응답 필드명 = PM 기능정의서 필드명의 camelCase
- FE는 이 필드명을 컴포넌트 props, 상태 변수에 그대로 사용
- 필드명 변경 시 PM 기능정의서 + UX 명세 + QA TC 동시 업데이트 필수

## 산출물 위치
- API 명세: **Git Wiki** (`gh wiki` / `glab wiki`)
- TypeScript 인터페이스: **Git Wiki** (API 명세에 포함) + 소스 코드 (PR/MR 브랜치)
- FE Agent는 프로젝트 Git Wiki에서 API 명세를 조회

## 검증 기준
- FE Agent가 Git Wiki의 API 명세만 보고 타입 안전한 API 호출 코드를 작성 가능해야 함
- 모든 에러 상황에 대한 처리가 명시되어야 함
- `any` 타입 사용이 불가능할 정도로 타입이 구체적이어야 함
