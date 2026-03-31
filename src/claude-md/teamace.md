# TeamAce — 멀티에이전트 서비스 개발 시스템

## 오케스트레이션

당신은 TeamAce가 설치된 환경에서 동작하는 Claude Code입니다.
**작업 시작 전 반드시 `~/.claude/agents/lead.md`를 읽고 오케스트레이션 지침을 따르세요.**

### Agent Team 활용 (필수)

TeamAce는 Claude Code의 **Agent Team** 실험 기능을 기반으로 동작합니다.
단순 subagent가 아닌 **Agent Team을 생성**하여 팀원 간 직접 소통이 가능한 협업 모델을 사용합니다.

#### Subagent vs Agent Team — 반드시 Agent Team 사용

| | Subagent | Agent Team |
|---|---------|-----------|
| 통신 | 메인 에이전트에게만 결과 보고 | **팀원 간 직접 message/broadcast** |
| 조율 | 메인 에이전트가 모든 작업 관리 | **공유 작업 목록(Task List)으로 자체 조율** |
| 컨텍스트 | 결과가 호출자에게 요약 반환 | 각 팀원이 독립 컨텍스트 윈도우 보유 |

TeamAce에서는 에이전트 간 핸드오프, 계약 검증, 피드백 루프가 필요하므로 **반드시 Agent Team**을 사용해야 합니다.

#### 팀 생성 및 운영 흐름

작업 요청을 받으면 Lead는 다음 순서로 Agent Team을 운영합니다:

**1단계: 팀 생성 + 팀원 스폰**

Lead 에이전트(`~/.claude/agents/lead.md`)를 읽고, Agent Team을 생성하며 필요한 역할의 팀원을 스폰합니다.
각 팀원 스폰 시 구체적인 프롬프트로 역할·작업·계약을 명시합니다.
PUB/BE처럼 병렬 가능한 팀원은 동시에 스폰합니다.

**2단계: 공유 작업 목록으로 조율**

Lead가 작업(Task)을 생성하고 팀원에게 할당합니다.
작업 간 종속성을 설정하면 선행 작업 완료 전까지 후속 작업이 차단됩니다.
팀원이 작업을 마치면 다음 미할당·미차단 작업을 자체 요청(claim)할 수 있습니다.

**3단계: 팀원 간 직접 소통**

- **message**: 특정 팀원 1명에게 메시지 전송 (핸드오프, 피드백, API 조정 등)
- **broadcast**: 전체 팀원에게 동시 전송 (브랜치 전략, 전체 공지 — 비용이 팀 크기에 비례하므로 드물게 사용)

핸드오프 시 산출물 위치, 계약 참조, 컨텍스트를 message에 포함하여 전달합니다.
팀원 메시지는 수신자에게 **자동 전달**되므로 Lead가 폴링할 필요 없습니다.

**4단계: 계획 승인 (Plan Approval)**

고위험 작업에는 팀원에게 **계획 승인을 요구**합니다.
팀원은 읽기 전용 계획 모드에서 작업 계획을 작성 → Lead가 승인/거부 → 승인 시 구현 시작.

**5단계: 종료 및 정리**

각 팀원에게 종료(shutdown) 요청 → 모든 팀원 종료 확인 후 → 팀 정리(cleanup).
**반드시 Lead가 cleanup을 실행**합니다 (팀원이 하면 리소스 불일치 발생).

#### 팀 데이터 저장 위치

- 팀 구성: `~/.claude/teams/{team-name}/config.json`
- 작업 목록: `~/.claude/tasks/{team-name}/`
- 팀원 메일박스: 자동 관리 (수동 편집 금지)

#### Hooks 연동

- **`TeammateIdle`**: 팀원이 유휴 상태가 될 때 실행 — 품질 게이트 미통과 시 피드백 전송하여 계속 작업시킴
- **`TaskCompleted`**: 작업 완료 시 실행 — 계약 미충족 시 완료를 방지하고 피드백 전송

#### 주의사항

- **subagent(Agent tool) 사용 금지** — 반드시 Agent Team으로 팀 생성 후 message/broadcast로 소통
- 팀 리더(Lead)만 팀 생성·cleanup 가능, 팀원은 중첩 팀 생성 불가
- 세션당 한 팀만 운영 가능 — 새 팀 시작 전 현재 팀 cleanup 필수
- 각 팀원은 CLAUDE.md, MCP, skills를 자동 로드하지만 Lead의 대화 기록은 상속하지 않음 — 스폰 프롬프트에 충분한 컨텍스트 포함 필수
- 동일 파일을 여러 팀원이 편집하면 덮어쓰기 발생 — PUB↔FE 소유권 분리 준수

사용 가능한 에이전트:

| 에이전트 | 파일 | 역할 |
|---------|------|------|
| PM | `~/.claude/agents/pm.md` | 데이터 드리븐 기획, PRD/기능 명세서 |
| PUB | `~/.claude/agents/pub.md` | Impeccable 기반 퍼블리셔, View 코드 구현 |
| FE | `~/.claude/agents/fe.md` | 로우레벨 FE, API 연동/성능/데이터 트랜스폼 |
| BE | `~/.claude/agents/be.md` | 백엔드 구현, API/DB/인프라 |
| QA | `~/.claude/agents/qa.md` | 리스크 기반 테스트, 회귀 방지 |

## 경로 체계

TeamAce 파일은 `~/.claude/` 아래에 설치되어 있습니다:

```
~/.claude/
├── agents/               ← 에이전트 정의 (lead, pm, pub, fe, be, qa)
└── teamace/
    ├── skills/           ← 에이전트별 워크플로우 스킬
    │   ├── pm/
    │   ├── pub/
    │   ├── fe/
    │   ├── be/
    │   └── qa/
    ├── knowledge/        ← 에이전트별 학습 기록
    ├── contracts/        ← 에이전트 간 핸드오프 계약
    └── harness/          ← 품질 게이트, 평가 기준, 회귀 정책
```

현재 작업 중인 프로젝트의 소스 코드는 현재 디렉터리(`.`)에 위치합니다.

## 전제 조건 (프로젝트별 셋업)

각 프로젝트에서 `teamace init`을 실행하면 다음이 설정됩니다:

### Impeccable 디자인 스킬
```bash
teamace init    # 또는 직접: npx skills add pbakaus/impeccable
```

설치 후 프로젝트의 `.claude/skills/`에 다음이 배치됨:
- `frontend-design` — 기초 디자인 스킬 (1개)
- 20개 커맨드: `/audit`, `/polish`, `/critique`, `/adapt`, `/animate`, `/arrange`, `/bolder`, `/clarify`, `/colorize`, `/delight`, `/distill`, `/extract`, `/harden`, `/normalize`, `/onboard`, `/optimize`, `/overdrive`, `/quieter`, `/typeset`, `/teach-impeccable`
- 7개 레퍼런스: `typography.md`, `color-and-contrast.md`, `spatial-design.md`, `motion-design.md`, `interaction-design.md`, `responsive-design.md`, `ux-writing.md`

Claude Code가 `.claude/skills/`를 세션 레벨에서 자동 로드하므로, PUB 에이전트가 Impeccable 커맨드와 레퍼런스를 별도 import 없이 사용할 수 있다.

> **Impeccable이 없으면 PUB 에이전트의 디자인 품질 게이트를 통과할 수 없다.**

## PUB↔FE 역할 분리

PUB와 FE는 프론트엔드를 **View(프레젠테이션)**와 **Logic(비즈니스)**으로 분리한다:

| 영역 | PUB (퍼블리셔) | FE (로우레벨) |
|------|--------------|--------------|
| View 컴포넌트 (TSX + 스타일) | ✓ 소유 | 수정 금지 |
| 디자인 토큰 (tokens.css) | ✓ 소유 | 참조만 |
| 공유 UI (shared/ui/) | ✓ 소유 | 사용만 |
| Custom Hooks / API 클라이언트 | | ✓ 소유 |
| 상태 관리 / 데이터 트랜스폼 | | ✓ 소유 |
| 에러 바운더리 / 모니터링 | | ✓ 소유 |
| 성능 최적화 | | ✓ 소유 |
| 타입 정의 (types/) | | ✓ 소유 |

## 공통 규칙

### Git 중심 메타데이터
- **PR/MR + Issue + Wiki**가 단일 진실 공급원
- 산출물은 **Wiki**에 기록하거나 git에 커밋, PR/MR에 링크로 참조
- 에이전트 간 핸드오프는 완료 커밋 + 완료 신호로 수행
- Git 플랫폼 감지: `git remote -v`로 GitHub/GitLab 판별 → `gh` 또는 `glab` 사용

### 산출물 위치 원칙

문서 산출물의 저장소는 프로젝트의 Git 플랫폼에 따라 결정:
- **GitHub 프로젝트** → **Notion** (Notion MCP)
- **GitLab 프로젝트** → **Git Wiki** (`glab api`)

| 산출물 유형 | GitHub 프로젝트 | GitLab 프로젝트 | 도구 |
|------------|----------------|----------------|------|
| 기획서, 기능 명세서, View 명세, API 명세, 테스트 시나리오 | **Notion** | **Git Wiki** | Notion MCP / `glab api` |
| View 코드, hooks, API 연동, 테스트 코드 | **Git repo** | **Git repo** | git CLI |
| PR/MR, 코드 리뷰 | **GitHub PR** | **GitLab MR** | `gh pr` / `glab mr` |
| 버그 리포트, 기능 요청 | **GitHub Issue** | **GitLab Issue** | `gh issue` / `glab issue` |
| 중간 산출물, 비정기 메모, 회의록 | **Notion** | **Notion** | Notion MCP |

### 에이전트 간 계약
- `~/.claude/teamace/contracts/` 디렉터리의 핸드오프 계약을 반드시 준수
- 필드명은 계약에 정의된 네이밍 규약을 따름
- 계약 미충족 시 다음 단계 진행 불가

### 품질 게이트
- `~/.claude/teamace/harness/quality-gates.md`의 단계별 기준을 통과해야 다음 단계 진행
- 각 에이전트는 완료 전 자체 품질 체크리스트 검증 필수

### 하네스 원칙
- 어떤 모델, 어떤 컨텍스트에서도 동일한 품질의 산출물을 내야 한다
- 모호한 판단은 금지 — 모든 기준은 측정 가능해야 한다
- "되던 건 무조건 되게" — 기존 기능의 회귀를 허용하지 않는다

### Skill 참조
- 각 에이전트는 작업 시작 전 `~/.claude/teamace/skills/[에이전트]/`에서 해당 skill을 읽음
- 작업 완료 후 새로 익힌 지식을 `~/.claude/teamace/knowledge/[에이전트].md`에 기록
