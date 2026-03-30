# TeamAce — 멀티에이전트 서비스 개발 시스템

## 오케스트레이션

당신은 TeamAce의 메인 세션입니다.
**작업 시작 전 반드시 `agents/lead.md`를 읽고 오케스트레이션 지침을 따르세요.**

사용 가능한 에이전트:

| 에이전트 | 파일 | 역할 |
|---------|------|------|
| PM | `agents/pm.md` | 데이터 드리븐 기획, PRD/기능정의서 |
| UX | `agents/ux.md` | 사용성 중심 UX 설계, Figma 시안 |
| FE | `agents/fe.md` | 프론트엔드 구현, 컴포넌트/테스트 |
| BE | `agents/be.md` | 백엔드 구현, API/DB/인프라 |
| QA | `agents/qa.md` | 리스크 기반 테스트, 회귀 방지 |

## 프로젝트 구조

```
TeamAce/                    ← 루트 (이 CLAUDE.md 위치)
├── agents/                 ← 에이전트 정의 + skills + knowledge
├── contracts/              ← 에이전트 간 핸드오프 계약
├── harness/                ← 품질 게이트, 평가 기준, 회귀 정책
└── projects/               ← 프로젝트별 git repo 디렉터리
    ├── yoseek/             ← git repo (GitHub)
    ├── owlai/              ← git repo (GitLab 등)
    └── [new-project]/      ← 프로젝트 추가 시
```

- `projects/` 아래에 각 프로젝트의 git repo가 위치
- 프로젝트마다 GitHub(`gh`) 또는 GitLab(`glab`)을 사용할 수 있음
- 작업 시 반드시 해당 프로젝트 디렉터리로 이동하여 git 작업 수행

## 공통 규칙

### Git 중심 메타데이터
- **PR/MR + Issue + Wiki**가 단일 진실 공급원
- 산출물은 **Wiki**에 기록하거나 git에 커밋, PR/MR에 링크로 참조
- 에이전트 간 핸드오프는 완료 커밋 + 완료 신호로 수행
- Git 플랫폼 감지: `git remote -v`로 GitHub/GitLab 판별 → `gh` 또는 `glab` 사용

### 산출물 위치 원칙
| 산출물 유형 | 위치 | 도구 |
|------------|------|------|
| 기획서, 기능정의서, UX 명세, API 명세, 테스트 시나리오 | **Git Wiki** | `gh wiki` / `glab wiki` |
| UX 시안, 프로토타입 | **Figma** | Figma MCP |
| 소스 코드, 테스트 코드, 마이그레이션 | **Git repo** | git CLI |
| PR/MR, 코드 리뷰 | **Git PR/MR** | `gh pr` / `glab mr` |
| 버그 리포트, 기능 요청 | **Git Issue** | `gh issue` / `glab issue` |
| 중간 산출물, 비정기 메모, 회의록 | **Notion** | Notion MCP |

### 에이전트 간 계약
- `contracts/` 디렉터리의 핸드오프 계약을 반드시 준수
- 필드명은 계약에 정의된 네이밍 규약을 따름
- 계약 미충족 시 다음 단계 진행 불가

### 품질 게이트
- `harness/quality-gates.md`의 단계별 기준을 통과해야 다음 단계 진행
- 각 에이전트는 완료 전 자체 품질 체크리스트 검증 필수

### 하네스 원칙
- 어떤 모델, 어떤 컨텍스트에서도 동일한 품질의 산출물을 내야 한다
- 모호한 판단은 금지 — 모든 기준은 측정 가능해야 한다
- "되던 건 무조건 되게" — 기존 기능의 회귀를 허용하지 않는다

### Skill 참조
- 각 에이전트는 작업 시작 전 자신의 `skills/` 디렉터리에서 해당 skill을 읽음
- 작업 완료 후 새로 익힌 지식은 `knowledge.md`에 기록

### 외부 도구 사용 원칙
- **Notion** → Notion MCP 도구만 사용 (API 토큰 직접 사용, curl, SDK 설치 금지)
- **Figma** → Figma MCP 도구만 사용
- **GitHub** → `gh` CLI 사용 (PR, Issue, Wiki, Release)
- **GitLab** → `glab` CLI 사용 (MR, Issue, Wiki, Release)
- Git 플랫폼이 불명확하면 `git remote -v`로 먼저 확인
