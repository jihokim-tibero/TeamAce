# BE 단위 테스트 Skill

## 목적
BE가 구현한 서비스·도메인·검증·에러 경로의 정확성을 단위 수준에서 보장한다. E2E(QA 소관)와 명확히 역할이 분리된다.

## 트리거
- 신규 엔드포인트/서비스 구현 시
- 버그 수정 시(재현 테스트 먼저 추가 — TDD 스타일)
- 리팩터 시(기존 테스트로 회귀 감지)

## 입력
- 구현된 소스(Controller/Service/Domain/Repository/Validator)
- PM 기능 명세서의 수락 기준(특히 에러 분기)
- API spec의 에러 코드 목록

## 역할 분리 (중요)
| 층위 | 관점 | 책임 | 담당 |
|------|------|------|------|
| **단위 테스트** | 화이트박스 | service/domain/validation/error-branch. 외부 의존은 fake/stub으로 격리 | **BE** |
| E2E / 계약 테스트 | 블랙박스 | 브라우저·HTTP API 레벨 시나리오. 리포지토리+DB·외부 의존까지 포함한 실제 계약 검증 | QA |

BE는 **화이트박스 단위 테스트에만 집중**한다. 실제 DB를 띄우거나 외부 의존을 조합해 검증하는 "통합 테스트"는 **이 스킬의 범위 밖**이며, 계약 레벨 검증은 QA의 E2E가 커버한다(FE와 동일한 원칙). BE는 "내부 로직이 명세대로 동작한다"만 증명한다.

## 절차

### 1. 대상 식별
다음을 반드시 커버:
- **Service 메서드**: happy path + 각 분기
- **Domain 로직**: 불변식(invariant), 상태 전이
- **Validator**: 허용/거부 경계값
- **Error branch**: 모든 명시된 에러 코드가 실제로 발생하는 경로

### 2. 테스트 구조 (AAA)
```python
def test_oauth_callback_rejects_expired_state():
    # Arrange
    state = make_state(expires_at=past())
    # Act
    with pytest.raises(InvalidStateError) as exc:
        service.exchange_code(code="x", state=state.value)
    # Assert
    assert exc.value.code == "AUTH_STATE_EXPIRED"
```

### 3. 테스트 네이밍
`test_[대상]_[조건]_[기대]` — 실패 시 원인 즉시 파악 가능해야 한다.

### 4. 외부 의존 격리
- DB: 리포지토리 인터페이스를 fake/stub으로 치환. **실제 DB 연결 금지** — 실제 DB 레벨 시나리오는 QA E2E에서 API를 통해 검증된다.
- HTTP/외부 API: `httpx.MockTransport` 등으로 격리.
- 시계·랜덤: 주입 가능하게(Clock, RNG 인터페이스).

### 5. 경계값·에러 커버리지
모든 API spec의 에러 코드는 최소 1개 테스트로 증명되어야 한다. 에러 코드 목록 ↔ 테스트 이름 매핑 표를 PR 본문에 첨부.

### 6. 실행 게이트
- CI: `pytest -q --maxfail=1`
- 커버리지 기준: 서비스·도메인 레이어 **≥ 80%** (core-principles/be.md와 일치)
- 단위 테스트 실행 시간: 전체 < 30초 (느려지면 외부 의존 격리가 깨졌는지 점검 — 해당 케이스는 QA E2E로 이관)

## 출력
- `tests/unit/[domain]/test_*.py`
- PR 본문에 커버리지 요약 + 에러코드↔테스트 매핑 표

## 품질 체크리스트
- [ ] happy path + 모든 에러 분기 커버
- [ ] API spec의 모든 에러 코드가 테스트로 증명
- [ ] 외부 의존 격리(DB/HTTP/시계)
- [ ] 테스트명 `test_[대상]_[조건]_[기대]`
- [ ] 서비스·도메인 커버리지 ≥ 80%
- [ ] 단위 테스트 총 실행 시간 < 30s
- [ ] E2E 시나리오를 BE가 침범하지 않음 (QA 소관 유지)

## 안티패턴
- 서비스 테스트에서 실제 DB·외부 API를 띄움 → 단위 테스트 범위 위반. 해당 시나리오는 QA E2E 소관
- happy path만 쓰고 에러 분기 누락
- 랜덤/시간에 의존해 간헐적 실패 유발(flaky)
- E2E 성격의 테스트(브라우저·전체 요청/응답)를 BE가 단위 테스트로 분류
- 커버리지 숫자 맞추기 위한 assert 없는 테스트
