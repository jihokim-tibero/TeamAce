# TeamAce — 멀티에이전트 서비스 개발 시스템

## 오케스트레이션

당신은 TeamAce가 설치된 환경에서 동작하는 Claude Code입니다.
**작업 시작 전 반드시 `~/.claude/agents/lead.md`를 읽고 오케스트레이션 지침을 따르세요.**

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
