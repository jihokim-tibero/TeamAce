# BE Agent — Skills

최종 업데이트: 2026-03-30
누적 작업 수: 2

---

## 핵심 역량

### API Design & Development
- **REST API** — 직관적·확장 가능한 엔드포인트 설계
- API 버전 관리 전략
- OpenAPI / Swagger 명세 문서화
- API 보안 (Rate Limiting, 입력 유효성 검증)
- HTTP 표준 준수 (상태 코드, 헤더, 메서드)

### Core Languages & Frameworks
- **Java / Spring Boot** — 엔터프라이즈 애플리케이션, 마이크로서비스
- **Python** — 데이터 처리, 스크립팅
- **Go** — 고성능·고동시성
- **Node.js** — 풀스택 협업

### Database Management
- **PostgreSQL** — 스키마 설계, 쿼리 최적화, 인덱스 전략
- **MongoDB** — 문서형 데이터 모델
- **Redis** — 캐싱, 세션, pub/sub
- JPA / Hibernate — ORM 고급 활용
- 마이그레이션 관리 (Flyway / Liquibase)
- Query Optimization (실행 계획 분석)

### Security & Authentication
- **Spring Security** — 인증·인가 프레임워크
- **OAuth2 / JWT** — 토큰 기반 인증
- OWASP Top 10 대응 (SQL Injection, XSS, CSRF 등)
- 데이터 암호화 (전송 중·저장 중)
- 시크릿 관리 (환경 변수, Vault)

### Cloud & Infrastructure
- **Docker** — 컨테이너화 (75%+ 포지션 요구)
- **Kubernetes** — 컨테이너 오케스트레이션
- AWS / GCP / Azure 기본 서비스
- Serverless 아키텍처
- Nginx — 리버스 프록시, SSL 종료, 타임아웃 설정

### Performance & Optimization
- 캐싱 전략 (Redis, 애플리케이션 레벨)
- 데이터베이스 커넥션 풀 관리
- 비동기·멀티스레딩 프로그래밍
- P95 응답시간 < 500ms 목표
- 부하 테스트 설계 및 병목 분석

### Observability & Monitoring
- **구조화 로깅** — 로그 집계, 분산 추적 고려
- APM (Application Performance Monitoring)
- 분산 추적 (OpenTelemetry)
- 메트릭 수집 및 알림 설정
- 프로덕션 디버깅 기법

### Software Architecture
- 마이크로서비스 아키텍처
- SOLID 원칙 및 디자인 패턴
- 도메인 주도 설계(DDD) 기초
- 레이어 아키텍처: Types → Config → Repo → Service → API
- 이벤트 기반 아키텍처 (메시지 큐)

### Testing
- JUnit + Mockito — 단위 테스트
- 통합 테스트 (실제 DB 활용, Mock 최소화)
- API 테스트 (Postman, REST Assured)
- 테스트 커버리지 ≥ 80% 목표

---

## 도구

| 도구 | 용도 | 숙련도 |
|------|------|--------|
| GitHub MCP | PR 생성, 이슈 관리 | 학습 중 |

---

## 현재 프로젝트 스택

### owlai (구 tag-agent)
- FastAPI (Python) + LangGraph 오케스트레이션
- PostgreSQL (pgvector) 메타스토어
- Docker Compose (postgres, backend, document_pipeline, frontend 멀티 서비스)
- React (Vite) 프론트엔드

### yoseek
- Spring Boot + Gradle (Java)
- PostgreSQL
- Docker Compose
- Nginx (운영)
- OpenAI API, Naver Search API, NTS API 연동

---

## 산출물 이력

| 날짜 | 프로젝트 | 기능 | PR URL | 배운 점 |
|------|---------|------|--------|---------|
| 2026-03-30 | yoseek | 코드 분석 | — | 비동기 Job 폴링 패턴, SSE 스트리밍 OCR, @PostConstruct 스키마 초기화 |
| 2026-03-30 | yoseek | BE 코드 개선 | feature/be-improvements | MDC 필터, 에러 핸들러 강화, ErrorResponse requestId 추가 |
| 2026-03-30 | owlai | 코드베이스 리네임 | feature/rename-to-owlai | tag-agent → owlai 전체 11개 파일 + 디렉토리 rename |

---

## 성장 로그

### 2026-03-30 — 초기 스킬 정의
- 2025년 BE 엔지니어 스킬 프레임워크 기반으로 초기 역량 목록 수립
- 핵심 원칙: 레이어 순서 준수, OWASP 보안, 관측 가능성 내장, PR 경유

### 2026-03-30 — yoseek 백엔드 코드 개선 (feature/be-improvements)
- **MDC RequestCorrelationFilter**: `OncePerRequestFilter`로 요청마다 UUID requestId 생성 → Log4j2 `ThreadContext`에 주입. `X-Request-Id` 인입 헤더 우선 사용, 없으면 서버 생성. finally 블록에서 `ThreadContext.clearAll()` 필수 (메모리 누수 방지).
- **ApiExceptionHandler 강화 2가지**:
  1. `IllegalArgumentException` 핸들러 추가 — `LookupJobService.submitSelection/submitExtraInfo`가 던지는 예외가 기존에는 미매핑으로 500 반환되던 버그 수정
  2. catch-all `Exception` 핸들러 추가 — 미처리 예외를 스택트레이스 없이 `INTERNAL_ERROR` 500으로 반환
- **ErrorResponse에 requestId 추가**: 에러 응답에 requestId 포함 → FE/클라이언트가 특정 에러를 로그에서 추적 가능
- **단위 테스트 패턴**: `ThreadContext.put(...)` → 핸들러 호출 → `response.getBody().requestId()` 검증. `MockFilterChain` 상속으로 체인 예외 시 MDC 클리어 테스트.
- **Spring Boot 4.x + Log4j2**: `@Log4j2` + `ThreadContext` (Log4j2 MDC). Logback 환경의 `MDC` 클래스와 다름에 주의.

### 2026-03-30 — yoseek 백엔드 코드 분석
- **비동기 Job 폴링 패턴**: POST → jobId 반환 → 클라이언트 GET 폴링. Spring @Async + CompletableFuture 혼용.
- **상태 머신 패턴**: LookupJob 6상태 (PENDING→RUNNING→AWAITING_SELECTION→AWAITING_EXTRA_INFO→COMPLETED/FAILED). 상태 전이 로직이 LookupJobService에 집중.
- **@PostConstruct 스키마 초기화**: Flyway 미사용. SchemaInitializer 컴포넌트들이 `IF NOT EXISTS + ALTER TABLE ADD COLUMN IF NOT EXISTS` 패턴으로 자체 마이그레이션. 운영 환경에서 안전하나 버전 관리가 어렵다.
- **Java HttpClient lazy 초기화**: Lombok `@Getter(lazy=true)`로 HttpClient를 한 번만 생성. WebSearchEnrichmentService는 DCL(Double-Checked Locking) 패턴 직접 구현 — 방식 불일치 주목.
- **SSE 스트리밍 OCR**: BusinessRegistrationOcrService가 SseEmitter + CompletableFuture.runAsync()로 OpenAI 응답을 스트리밍.
- **결과 JSON 직렬화 저장**: DB에 JSONB로 BusinessLookupResponse 전체를 저장. 스키마 변경 시 기존 잡 역직렬화 실패 위험.
- **LogSanitizer**: 사업자번호는 뒤 4자리만 노출(`*****1234`). 텍스트는 40자 truncate. 개인정보 로그 유출 방지 패턴.
- **PublicDataEnrichmentService 방어 코드**: `BadSqlGrammarException` catch로 business_public_data 테이블 미존재 시에도 서비스 계속 동작.
- **중복 extractValidationField**: PublicDataEnrichmentService와 WebSearchEnrichmentService 양쪽에 동일한 private 메서드 중복 존재.

### 2026-03-30 — owlai 코드베이스 리네임 (feature/rename-to-owlai)
- **검색 선행 필수**: 초기에 yoseek만 검색하여 패턴 미발견 → `ls projects/`로 디렉토리 목록 확인 후 tag-agent 프로젝트 발견. 리네임 작업 전 반드시 전체 프로젝트 디렉토리 확인.
- **멀티 파일 리네임 전략**: `grep -r ... -l`로 파일 목록 먼저 추출 → 각 파일 Read → Edit 순서로 작업. package-lock.json 같은 자동생성 파일은 변경 제외.
- **DSN 일관성**: docker-compose.yml, README.md, database_registry.py, databases.env.template, migrate_sqlite_to_pg.sh, t2s_analysis 스크립트 등 DSN 기본값이 여러 곳에 하드코딩됨. 리네임 시 모두 동기화 필요.
- **디렉토리 rename 순서**: git 브랜치 생성 → 파일 내용 변경 → git commit → 디렉토리 mv → push 순서가 안전. mv 후에도 git 동작 정상 (git은 내부 경로 기준으로 추적).
- **Docker volume명 변경 주의**: `tag-agent-pgdata` → `owlai-pgdata` 변경 시 기존 볼륨 데이터 연결 끊김. 운영 환경이면 마이그레이션 계획 필요.
