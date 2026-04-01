# BE Agent — Knowledge

최종 업데이트: 2026-03-30
누적 작업 수: 2

---

## 산출물 이력

| 날짜 | 프로젝트 | 기능 | PR URL | 배운 점 |
|------|---------|------|--------|---------|
| 2026-03-30 | yoseek | BE 코드 개선 | feature/be-improvements | MDC 필터, 에러 핸들러 강화, ErrorResponse requestId 추가 |
| 2026-03-30 | owlai | 코드베이스 리네임 | feature/rename-to-owlai | 11개 파일 + 디렉토리 rename |

---

## 핵심 교훈

- **MDC RequestCorrelationFilter**: `OncePerRequestFilter`로 UUID requestId 생성 → `ThreadContext` 주입. `X-Request-Id` 인입 헤더 우선 사용. finally에서 `ThreadContext.clearAll()` 필수
- **ApiExceptionHandler**: `IllegalArgumentException` 핸들러 추가로 미매핑 500 버그 수정. catch-all `Exception` 핸들러로 미처리 예외 안전 처리
- **ErrorResponse requestId**: 에러 응답에 requestId 포함 → FE가 로그 추적 가능
- **Spring Boot 4.x + Log4j2**: `@Log4j2` + `ThreadContext` (Logback `MDC`와 다름)
- **@PostConstruct 스키마 초기화**: Flyway 미사용 시 `IF NOT EXISTS + ALTER TABLE ADD COLUMN IF NOT EXISTS` 패턴. 안전하나 버전 관리 어려움
- **Docker volume명 변경**: 기존 볼륨 데이터 연결 끊김 주의. 운영 환경이면 마이그레이션 계획 필요
