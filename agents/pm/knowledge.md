# PM Agent — Knowledge Base

최종 업데이트: 2026-03-30
누적 작업 수: 4

---

## 핵심 역량

### Discovery & Research
- 사용자 인터뷰 설계 및 인사이트 도출
- 정량(지표·퍼널) + 정성(인터뷰·관찰) 데이터 통합 분석
- Jobs to Be Done 프레임워크로 핵심 니즈 파악
- 경쟁사 분석 및 시장 포지셔닝

### Prioritization Frameworks
- **RICE** (Reach × Impact × Confidence ÷ Effort) 우선순위 산정
- **MoSCoW** (Must/Should/Could/Won't) 범위 정의
- **ICE Score** 빠른 아이디어 스코어링
- OKR 기반 제품 전략 정렬

### Documentation
- PRD(Product Requirements Document) 작성
- 기능정의서 (입력/로직/출력/예외 명세)
- 사용자 시나리오 및 플로우 정의
- 수락 기준(Acceptance Criteria) — 측정 가능한 형태로 작성

### Metrics & Analytics
- 활성화(Activation), 유지(Retention), 이탈(Churn) 지표 추적
- 퍼널 분석 및 전환율 최적화
- A/B 테스트 설계 및 결과 해석
- 비즈니스 임팩트 예측 및 ROI 산정

### AI & Modern PM Skills
- AI/LLM 기능의 기획 경험 (프롬프트 설계, 출력 신뢰도 관리)
- AI 도구 활용 리서치·분석·문서 작성 가속화
- 윤리적 AI 설계 (편향·공정성 고려)
- Product-Led Growth(PLG) 전략 수립

### Collaboration & Communication
- 크로스펑셔널 팀(UX·FE·BE·QA) 조율
- 이해관계자 커뮤니케이션 및 기대 관리
- 스프린트 계획 및 백로그 관리 (Agile/Scrum)
- Design Thinking 기반 문제 해결

---

## 도구

| 도구 | 용도 | 숙련도 |
|------|------|--------|
| Notion API (curl) | 기획서·기능정의서 작성·관리 | 실전 경험 |
| Notion MCP (notion-move-pages, notion-update-page) | 페이지 계층 구조 재정비·이동 | 실전 경험 |

---

## 산출물 이력

| 날짜 | 프로젝트 | 기능 | Notion 링크 | 배운 점 |
|------|---------|------|------------|---------|
| 2026-03-30 | yoseek | 서비스 기획서 + 기능정의서 | https://www.notion.so/yoseek-33318a01a4e881f29c58e8e62b81e2a7 | Notion MCP 미연결 시 REST API 직접 활용. 테이블·코드블록·체크리스트 블록 생성 패턴 습득 |
| 2026-03-30 | yoseek | Notion 산출물 검토·보강·정리 | https://www.notion.so/33318a01a4e881f29c58e8e62b81e2a7 | notion-move-pages로 산하 페이지 이동. QA 문서와 기능정의서 간 필드명 불일치 발견 → 기능정의서 v1.1 보강 |
| 2026-03-30 | tag-agent | 서비스 기획서 + 기능정의서 | https://www.notion.so/33318a01a4e88162bb65d3f1816d2eac (기획서), https://www.notion.so/33318a01a4e8814c9ac4e1b15dc6aa8b (기능정의서) | LangGraph 9노드 그래프 구조 파악 후 Deep 모드 기능 명세화. SSE 스트림 이벤트 계약(reasoning_step/plan_user_questions/done) 기반 수락기준 작성 |
| 2026-03-30 | OwlAI | Notion 구조 재정비 + 경쟁력 있는 기획서 + 기능정의서 | https://www.notion.so/33318a01a4e88131a6e9fe745aec6c7b (기획서), https://www.notion.so/33318a01a4e881f0b8a2e29a37cf0189 (기능정의서) | 요구사항정의서 8개 REQ → 16개 기능 분해. 시장 분석(경쟁사 5개), KPI, 4단계 데모 시나리오 작성 |

---

## 성장 로그

### 2026-03-30 — 초기 스킬 정의
- 2025년 PM 스킬 프레임워크 기반으로 초기 역량 목록 수립
- 핵심 프레임워크: RICE, MoSCoW, JTBD, OKR
- 다음 목표: Notion MCP 활용 첫 기획서 작성

### 2026-03-30 — yoseek 기획서·기능정의서 최초 작성
- Notion MCP 미설정 환경에서 REST API(curl) 직접 활용하여 페이지 생성
- Notion 블록 타입 실전 활용: table, code, to_do, callout, heading, bulleted_list_item
- 서비스 기획서 구조: 배경/타깃/핵심가치/사용자여정(3 시나리오)/KPI/범위/Agent인터페이스
- 기능정의서 구조: 기능목록표(8개 기능) + 상세명세(입력/처리/출력/예외) + API명세 + 수락기준
- 교훈: Notion API parent 타입은 page_id로 명시해야 하며, table 블록은 children 내 table_row로 구성

### 2026-03-30 — tag-agent 기획서·기능정의서 최초 작성
- LangGraph 코드(graph.py) 직접 분석하여 Deep 모드 9개 노드 역할 명세화
- SSE 이벤트 계약(reasoning_step·plan_user_questions·done) 기반 수락기준 작성 패턴 습득
- 2가지 채팅 모드(deep/openai_responses)의 처리 로직 차이를 기능정의서에 명확히 구분
- admin 전용 기능(F-008~F-013) 권한 수락기준 패턴: "비관리자 접근 → 403" 항목 표준화
- 교훈: AI 에이전트 서비스 기획 시 SSE 스트림 이벤트 타입이 FE/QA 수락기준의 핵심 기준이 됨

### 2026-03-30 — OwlAI Notion 구조 재정비·기획서·기능정의서 작성
- notion-move-pages로 7개 기존 페이지를 기획/개발/QA 섹션으로 재배치 (배치 이동)
- Notion 콘텐츠 크기 제한 경험: notion-create-pages의 content 파라미터가 너무 길면 오류 → 빈 페이지 먼저 생성 후 replace_content로 분할 업데이트
- 요구사항정의서(8개 REQ) → 16개 기능(F-001~F-016)으로 분해하는 PM 분석 수행
- 경쟁사 분석(ThoughtSpot/Vanna/Defog/Wren AI/n8n)을 기획서 내 시장 분석 섹션으로 통합
- Exploration→Exploitation 전환 패러다임을 KPI 및 사용자 시나리오와 연결하는 구조화 패턴 습득
- 교훈: Notion MCP content 길이 제한 존재 → 긴 문서는 create 후 update_content/replace_content로 분리 작성

### 2026-03-30 — yoseek Notion 산출물 검토·보강·정리
- Notion MCP(`notion-search`, `notion-fetch`, `notion-update-page`, `notion-move-pages`) 전체 활용
- 문서 간 필드명 불일치 발견: 기능정의서(storeName, aiBrief) vs QA 시나리오(businessName, advisorBrief)
- 기능정의서 v1.1 보강: storeName→businessName, aiBrief→advisorBrief, selectedPublicDataId 추가, PUBLIC_DATA_SELECTION_REQUIRED 상태 추가
- notion-move-pages로 QA 테스트 시나리오를 Team Ace 루트 → yoseek 기획서 하위로 재배치
- 교훈: 여러 에이전트가 독립적으로 작성한 문서는 필드명 정합성 검토가 필수
