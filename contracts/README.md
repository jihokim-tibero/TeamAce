# 에이전트 간 계약 (Contracts)

## 목적

에이전트 A의 산출물이 에이전트 B의 입력 요구사항을 **반드시** 만족하도록 보장한다.
계약을 통해 필드명 불일치, 누락된 상태 정의 등의 통합 버그를 구조적으로 방지한다.

## 계약 파일 목록

| 파일 | 방향 | 핵심 검증 항목 |
|------|------|--------------|
| `pm-to-ux.md` | PM → UX | 화면/흐름/상태 요구, 사용자 시나리오 |
| `pm-to-be.md` | PM → BE | 비즈니스 로직, 데이터 요구, 성능 기준 |
| `ux-to-fe.md` | UX → FE | 5 상태 정의, data-testid, 디자인 토큰 |
| `be-to-fe.md` | BE → FE | API 엔드포인트, 스키마, 에러 코드, TypeScript 인터페이스 |
| `all-to-qa.md` | 전체 → QA | 수락 기준, data-testid, API 명세, 시나리오 |
| `qa-to-all.md` | QA → 전체 | 버그 리포트, 회귀 결과, 품질 게이트 판정 |

## 네이밍 규약

모든 에이전트가 공유하는 필드 네이밍 기준:

- **camelCase** 사용 (snake_case 금지)
- BE API 응답 스키마의 필드명이 기준 — PM/UX/FE/QA 모두 이 이름을 사용
- 새로운 필드 도입 시 PM이 기능정의서에 먼저 정의, 이후 전파
- 약어 사용 금지 (예: `businessName` O, `bizNm` X)

## 산출물 위치

문서 산출물의 저장소는 프로젝트의 Git 플랫폼에 따라 결정:
- **GitHub 프로젝트** → **Notion** (Notion MCP)
- **GitLab 프로젝트** → **Git Wiki** (`glab wiki`)

| 산출물 | GitHub 프로젝트 | GitLab 프로젝트 | 도구 |
|--------|----------------|----------------|------|
| 기획서/기능정의서 | Notion | Git Wiki | Notion MCP / `glab wiki` |
| UX 명세 | Notion | Git Wiki | Notion MCP / `glab wiki` |
| Figma 시안 | Figma | Figma | Figma MCP |
| API 명세 | Notion | Git Wiki | Notion MCP / `glab wiki` |
| 소스 코드 | Git branch + PR | Git branch + MR | `gh pr` / `glab mr` |
| 테스트 시나리오 | Notion | Git Wiki | Notion MCP / `glab wiki` |
| 버그 리포트 | GitHub Issue | GitLab Issue | `gh issue` / `glab issue` |
| 중간 산출물/메모 | Notion | Notion | Notion MCP |

각 계약에서 "위치"를 참조할 때 위 테이블 기준을 따른다.

## 계약 위반 시

1. 리드 에이전트가 위반 사항을 구체적으로 지적
2. 해당 에이전트에 보완 요청 (위반 항목 + 기대값 명시)
3. 보완 완료 후 재검증
4. 계약 충족 전까지 다음 Phase 진행 불가
