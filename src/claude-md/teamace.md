# TeamAce — 멀티에이전트 서비스 개발 시스템

## 오케스트레이션

**작업 시작 전 반드시 `~/.claude/agents/lead.md`를 읽고 오케스트레이션 지침을 따르세요.**

### Agent Team 활용 (필수)

**subagent(Agent tool) 사용 금지** — 반드시 Agent Team을 생성하여 message/broadcast로 소통.
팀원 간 직접 message/broadcast 가능, 공유 작업 목록(Task List)으로 자체 조율.

#### 운영 흐름

1. **팀 생성 + 팀원 스폰**: Lead가 Agent Team 생성, 역할·작업·계약 명시. 병렬 가능한 팀원은 동시 스폰.
2. **작업 목록 조율**: Lead가 작업(Task) 생성·할당, 종속성 설정. 팀원은 완료 후 다음 미차단 작업 claim.
3. **팀원 소통**: message(1:1 핸드오프/피드백), broadcast(전체 공지 — 드물게).
4. **계획 승인**: 고위험 작업 시 팀원에게 Plan Approval 요구.
5. **종료**: 각 팀원 shutdown → Lead가 cleanup 실행.

#### 주의사항

- 팀원은 CLAUDE.md/MCP/skills 자동 로드하지만 Lead 대화 기록은 미상속 → 스폰 프롬프트에 충분한 컨텍스트 포함
- 동일 파일 다중 편집 금지 → PUB↔FE 소유권 분리 준수
- 3-5개 팀원이 최적, 팀원당 5-6개 태스크

### 에이전트 목록

| 에이전트 | 파일 | 역할 |
|---------|------|------|
| PM | `~/.claude/agents/pm.md` | 데이터 드리븐 기획, PRD/기능 명세서 |
| PUB | `~/.claude/agents/pub.md` | Impeccable 기반 퍼블리셔, View 코드 |
| FE | `~/.claude/agents/fe.md` | API 연동/성능/데이터 트랜스폼 |
| BE | `~/.claude/agents/be.md` | API/DB/비즈니스 로직 |
| QA | `~/.claude/agents/qa.md` | 리스크 기반 테스트, 회귀 방지 |

## 경로 체계

```
~/.claude/
├── agents/               ← 에이전트 정의 (lead, pm, pub, fe, be, qa)
└── teamace/
    ├── skills/           ← 에이전트별 워크플로우 스킬
    ├── knowledge/        ← 에이전트별 학습 기록
    ├── contracts/        ← 에이전트 간 핸드오프 계약
    ├── core-principles/  ← 에이전트별 핵심 원칙 (작업 전 읽고 전 과정 준수)
    └── harness/          ← 품질 게이트, 평가 기준, 회귀 정책
```

## PUB↔FE 역할 분리

| PUB 소유 | FE 소유 |
|---------|---------|
| views/, shared/ui/, tokens.css | hooks/, components/, types/, providers/, pages/ |
| View 컴포넌트 (순수 프레젠테이션) | API 클라이언트, 상태 관리, 데이터 트랜스폼, ErrorBoundary |

## 공통 규칙

- **Git 중심**: PR/MR + Issue + Wiki가 단일 진실 공급원. `git remote -v`로 GitHub/GitLab 판별
- **산출물 위치**: GitHub → Notion (Notion MCP) / GitLab → Git Wiki (`glab api`)
- **계약 준수**: `~/.claude/teamace/contracts/` 핸드오프 계약 필수 준수
- **네이밍 규약**: camelCase 사용(snake_case 금지), BE API 응답 스키마 필드명이 기준, 새 필드는 PM이 기능 명세서에 먼저 정의 후 전파, 약어 금지(`businessName` O, `bizNm` X)
- **품질 게이트**: `~/.claude/teamace/harness/quality-gates.md` 단계별 기준 통과 필수
- **핵심 원칙 준수**: 작업 시작 전 `~/.claude/teamace/core-principles/[agent].md`를 읽고 모든 작업 과정에서 준수, 완료 시 재확인
- **하네스 원칙**: 어떤 모델/컨텍스트에서도 동일 품질, 모호한 판단 금지, 회귀 불허
- **Skill 참조**: 작업 전 `~/.claude/teamace/skills/[에이전트]/` 읽기
- **Knowledge 활용**: 작업 전 `~/.claude/teamace/knowledge/[에이전트].md` 읽고 참고, 완료 후 기존에 없는 새로운 교훈이 있을 때만 추가

## Impeccable 디자인 스킬

PUB 에이전트용. 세션 레벨 자동 로드. 미설치 시 `npx skills add pbakaus/impeccable`.
Impeccable 커맨드와 레퍼런스가 없으면 PUB 디자인 품질 게이트를 통과할 수 없다.
