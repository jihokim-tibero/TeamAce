# DB 스키마 설계 Skill

## 목적
PM 기능 명세서의 데이터 요구를 바탕으로 DB 스키마와 마이그레이션을 설계한다. 회귀 없이 스키마를 진화시키는 2-phase 절차를 따른다.

## 트리거
- 새 기능 구현 시 신규 테이블/컬럼 필요
- 기존 스키마 변경(컬럼 추가/수정/삭제, 인덱스·제약 조정)

## 입력
- PM 기능 명세서(필드·제약·도메인)
- 기존 스키마(`schema.sql`, `migrations/`)
- 쿼리 패턴(조회·필터·정렬) 예상치

## 절차

### 1. 테이블 설계
- 도메인 단위로 테이블 분리(정규화 3NF 기본, 조회 성능 필요 시 의도적으로 비정규화)
- 컬럼 명명: `snake_case` (DB 관례)
- PK: `id BIGSERIAL` 또는 도메인 자연키(ULID/UUID v7 권장)
- 타임스탬프: `created_at`, `updated_at TIMESTAMPTZ NOT NULL DEFAULT now()`
- 삭제 전략: hard vs soft 결정 → soft면 `deleted_at TIMESTAMPTZ NULL`

### 2. 제약·인덱스
- NOT NULL / UNIQUE / CHECK 제약 명시
- 외래키는 `ON DELETE` 정책 명시(CASCADE/SET NULL/RESTRICT)
- 인덱스는 실제 쿼리 패턴 기준으로 최소 필요만 — 복합 인덱스 컬럼 순서는 선택도(selectivity)·쿼리 조건 순 고려

### 3. 마이그레이션 파일 규칙
파일명: `migrations/[YYYYMMDDHHMMSS]_[kebab_description].sql`
예: `migrations/20260414120000_add_oauth_clients.sql`

- 단일 파일 = 단일 의도(기능 단위). 리팩터와 기능 추가 혼합 금지
- `BEGIN; ... COMMIT;`로 트랜잭션 래핑
- 되돌림 가능한 변경만 → `down.sql` 동반(`migrations/20260414120000_add_oauth_clients.down.sql`)

### 4. 2-Phase 변경 (호환성 필수)
FE/BE가 동시 배포되지 않는 환경에서 필수. 단일 마이그레이션으로 컬럼을 깨지 않게 변경.

**컬럼 추가/이름 변경**
1. Phase A: 새 컬럼 추가(NULL 허용) → 애플리케이션이 양쪽 쓰기 → 백필 → 구버전 컬럼은 읽기 유지
2. Phase B: 구 컬럼 DROP, 새 컬럼 NOT NULL (후속 릴리스)

**타입 변경**
1. Phase A: 신규 컬럼(`_v2`) 추가, 애플리케이션이 양쪽 유지
2. Phase B: 구 컬럼 DROP, 신규 컬럼을 원래 이름으로 RENAME

**테이블 삭제**
1. Phase A: 쓰기 중단, 읽기만 유지
2. Phase B: 드랍(최소 1 릴리스 후)

### 5. 출력 형식 (Wiki 섹션)
```markdown
## DB 스키마

### 테이블: oauth_clients
| 컬럼 | 타입 | 제약 | 설명 |
|------|------|------|------|
| id | BIGSERIAL | PK | |
| client_id | TEXT | UNIQUE NOT NULL | 외부 공개 식별자 |
| ... | | | |

### 인덱스
- `idx_oauth_clients_client_id` (UNIQUE)

### 마이그레이션
- `migrations/20260414120000_add_oauth_clients.sql` (+down)
```

## 품질 체크리스트
- [ ] 컬럼명 `snake_case`
- [ ] 모든 NOT NULL·FK·기본값 명시
- [ ] 인덱스는 실제 쿼리 기준(불필요한 인덱스 없음)
- [ ] 마이그레이션 파일 타임스탬프·단일 의도·트랜잭션
- [ ] 호환성 필요 시 2-Phase로 분할
- [ ] down 마이그레이션 동반 (rollback 경로 존재)
- [ ] Wiki API spec과 함께 스키마 섹션 최신화

## 안티패턴
- 컬럼 DROP + 추가를 단일 마이그레이션에서 동시 실행(배포 중 장애)
- 기존 컬럼을 NOT NULL로 바로 전환(백필 누락)
- 마이그레이션 없이 DDL을 수동 실행(환경 간 드리프트)
- 쿼리 패턴 확인 없이 방어적 인덱스 남발
- 마이그레이션 파일 하나에 기능 추가 + 리팩터 + 시드 데이터를 섞음
