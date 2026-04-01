# QA Agent — Knowledge

최종 업데이트: 2026-03-30
누적 작업 수: 3

---

## 산출물 이력

| 날짜 | 프로젝트 | 기능 | Notion URL | TC 수 | 배운 점 |
|------|---------|------|-----------|-------|---------|
| 2026-03-30 | yoseek | 사업자 진위확인 전체 플로우 (Sprint 1) | https://www.notion.so/yoseek-QA-33318a01a4e881c686c4c8f393a399dc | 14개 | Notion API 블록 100개 제한 → PATCH 분할 |
| 2026-03-30 | yoseek | 기능 명세서 v1.0 대조 TC 보강 (Sprint 2) | https://www.notion.so/33318a01a4e881c686c4c8f393a399dc | 22개 | 기능 명세서 대조로 갭 TC 추가 |
| 2026-03-30 | tag-agent | TAG-Agent 전체 API 플로우 v1.0 | https://www.notion.so/33318a01a4e881cda475eb43db9363f6 | 37개 | SSE 이벤트 순서 검증 패턴, LangGraph 노드 경로 TC 설계 |

---

## 핵심 교훈

- **Notion API 블록 100개 제한**: children ≤ 100블록, 초과 시 PATCH /blocks/{id}/children으로 분할
- **기능 명세서 대조 TC 갭 분석**: 명세서·기획서 교차 분석으로 미커버 영역 발견
- **SSE 이벤트 검증**: reasoning_step → done 순서 보장 확인, 모드별 이벤트 미발생 검증
- **Deep 모드 왕복 플로우**: plan_user_questions SSE → interaction_id 추출 → POST answer → 스트림 재개
- **admin 격리 테스트**: role=user 토큰으로 /admin/* 접근 시 HTTP 403 검증
- **lookupStatus 상태 전이**: COMPLETED / PUBLIC_DATA_SELECTION_REQUIRED 기반 TC 설계
- **도메인 에러 코드**: `INVALID_PUBLIC_DATA_SELECTION` 등 별도 TC 분리가 효과적
- **모바일 UI TC**: inputmode="numeric", 44px 터치 영역, 키보드 가림 방지를 개별 검증 포인트로 분리
- **p95 성능 기준**: 기획서 KPI와 일치시키기 (API 레벨 500ms ≠ E2E 5초)
