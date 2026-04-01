# PM Agent — Knowledge Base

최종 업데이트: 2026-03-30
누적 작업 수: 4

---

## 산출물 이력

| 날짜 | 프로젝트 | 기능 | Notion 링크 | 배운 점 |
|------|---------|------|------------|---------|
| 2026-03-30 | yoseek | 서비스 기획서 + 기능 명세서 | https://www.notion.so/yoseek-33318a01a4e881f29c58e8e62b81e2a7 | Notion MCP 미연결 시 REST API 직접 활용 |
| 2026-03-30 | yoseek | Notion 산출물 검토·보강·정리 | https://www.notion.so/33318a01a4e881f29c58e8e62b81e2a7 | QA 문서와 기능 명세서 간 필드명 불일치 발견 → v1.1 보강 |
| 2026-03-30 | tag-agent | 서비스 기획서 + 기능 명세서 | https://www.notion.so/33318a01a4e88162bb65d3f1816d2eac (기획서), https://www.notion.so/33318a01a4e8814c9ac4e1b15dc6aa8b (기능 명세서) | SSE 스트림 이벤트 계약 기반 수락기준 작성 |
| 2026-03-30 | OwlAI | Notion 구조 재정비 + 기획서 + 기능 명세서 | https://www.notion.so/33318a01a4e88131a6e9fe745aec6c7b (기획서), https://www.notion.so/33318a01a4e881f0b8a2e29a37cf0189 (기능 명세서) | 요구사항정의서 8개 REQ → 16개 기능 분해 |

---

## 핵심 교훈

- **Notion API parent 타입**: page_id로 명시. table 블록은 children 내 table_row로 구성
- **Notion content 길이 제한**: 긴 문서는 빈 페이지 생성 후 replace_content로 분할 작성
- **SSE 이벤트 계약**: AI 에이전트 서비스 기획 시 SSE 이벤트 타입이 FE/QA 수락기준의 핵심
- **RICE 우선순위**: Reach × Impact × Confidence ÷ Effort로 기능 우선순위 산정
