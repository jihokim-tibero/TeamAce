# API 설계 Skill

## 목적
FE와 QA가 신뢰할 수 있는 명확한 API 계약을 정의한다.

## 트리거
- PM 기능 명세서 완료 후 BE 구현 시작

## 입력
- PM 기능 명세서
- 기존 API 패턴 (있는 경우)

## 절차
1. 기능 명세서에서 필요한 API 엔드포인트 도출
2. RESTful 설계 원칙 적용:
   - 리소스 중심 URL (/api/v1/[resources])
   - 적절한 HTTP 메서드 (GET/POST/PUT/PATCH/DELETE)
   - 일관된 응답 구조
3. 요청/응답 스키마 정의 (camelCase 필드명)
4. 에러 코드 체계 정의
5. TypeScript 인터페이스 작성 (FE 제공용)
6. 인증/인가 방식 명시
7. 실시간 통신 명세 (해당 시: SSE/WebSocket)

## 출력 형식
`~/.claude/agents/be.md`의 API 명세 형식 참조

## 품질 체크리스트
- [ ] 기능 명세서 기능 대비 엔드포인트 매핑 100%
- [ ] 모든 엔드포인트에 에러 코드 정의
- [ ] TypeScript 인터페이스 제공
- [ ] 필드명 camelCase + PM 기능 명세서와 일치
- [ ] 인증 방식 명시

## 안티패턴
- 에러 응답에 에러 코드 없이 메시지만 반환
- 필드명이 PM 기능 명세서와 불일치
- TypeScript 인터페이스 미제공
