# TeamAce

멀티에이전트 서비스 개발 시스템 — Lead가 PM, PUB, FE, BE, QA 에이전트를 오케스트레이션하여 서비스를 개발합니다.

## 요구 사항

- **git**, **node**, **npm**
- **Claude Code CLI** (`claude`) — 권장

## 빠른 시작

```bash
# 1. 글로벌 설치
./install.sh

# 2. 프로젝트에서 초기화
cd /path/to/my-project
teamace init

# 3. Claude Code 실행
claude
```

---

## 설치 — `install.sh`

글로벌 환경에 에이전트, 스킬, 계약, 하네스 등 TeamAce 공통 구성요소를 설치합니다.

| 경로 | 내용 |
|---|---|
| `~/.claude/agents/` | 에이전트 정의 6개 (lead, pm, pub, fe, be, qa) |
| `~/.claude/teamace/skills/` | 에이전트별 워크플로우 스킬 |
| `~/.claude/teamace/contracts/` | 에이전트 간 핸드오프 계약 |
| `~/.claude/teamace/harness/` | 품질 게이트, 평가 기준, 회귀 정책 |
| `~/.claude/teamace/core-principles/` | 에이전트별 핵심 원칙 |
| `~/.claude/CLAUDE.md` | TeamAce 글로벌 지침 (기존 내용 보존) |
| `~/.claude/settings.json` | Agent Team 활성화 + 권한 설정 (기존 설정 보존) |
| `~/.local/bin/teamace` | CLI 실행 파일 |
| Impeccable 스킬 | 프론트엔드 디자인 스킬 (글로벌) |

---

## 프로젝트 초기화 — `teamace init`

프로젝트 디렉터리에서 실행하면 **Knowledge 템플릿 + CLAUDE.md + 코드 품질 도구**를 로컬에 설치합니다.

### 스택 자동 감지

프로젝트 파일을 기반으로 스택을 감지하고, 스택에 맞는 도구를 설치합니다.

| 감지 기준 | 스택 | 설치되는 도구 |
|---|---|---|
| `package.json` | Node/TS | ESLint + TypeScript strict + Husky hooks + commitlint |
| `pyproject.toml` / `requirements.txt` / `setup.py` | Python | Ruff + mypy strict + pre-commit hooks + commitlint |
| `pom.xml` | Java (Maven) | Checkstyle + .githooks (commit-msg, pre-push) |
| `build.gradle` / `build.gradle.kts` | Java (Gradle) | Checkstyle + .githooks (commit-msg, pre-push) |

### 스택별 설치 상세

**Node/TS**
- `eslint.config.mjs` — no-console, no-explicit-any, camelcase, max-lines 등 핵심 규칙
- `tsconfig.json` — `strict: true` 활성화 (기존 파일 수정)
- `.husky/commit-msg` — commitlint 연동
- `.husky/pre-push` — main 브랜치 직접 push 차단
- `commitlint.config.mjs` — Conventional Commits 규칙
- npm 패키지 자동 설치: eslint, typescript-eslint, husky, @commitlint/cli

**Python**
- `pyproject.toml` 또는 `ruff.toml` — Ruff lint + format 설정
- `pyproject.toml` 또는 `mypy.ini` — mypy strict 모드
- `.pre-commit-config.yaml` — ruff, mypy, commitlint 훅
- `commitlint.config.mjs` — Conventional Commits 규칙
- pip 패키지 자동 설치: ruff, mypy, pre-commit

**Java**
- `config/checkstyle/checkstyle.xml` — 네이밍, import, 브레이스 등 기본 규칙
- `.githooks/commit-msg` — Conventional Commits 형식 검증
- `.githooks/pre-push` — main 브랜치 직접 push 차단
- `git core.hooksPath` 자동 설정
- Maven/Gradle 빌드 플러그인 추가 안내 출력

### 멱등성

모든 항목은 이미 존재하면 건너뜁니다. `teamace init`을 여러 번 실행해도 안전합니다.

### 멀티 모듈 / 모노레포

루트에 패키지 파일이 없으면 하위 디렉터리를 최대 3레벨까지 재귀 탐색하여 모듈별로 스택을 독립 감지합니다. 하나의 프로젝트에서 FE(Node)와 BE(Python/Java)를 동시에 설치할 수 있습니다.

```
my-project/              ← 루트 (패키지 파일 없음)
├── frontend/            ← Node 감지 → ESLint + Husky + commitlint
├── backend/             ← Python 감지 → Ruff + mypy + pre-commit
└── packages/
    └── shared/          ← Node 감지 → ESLint + commitlint
```

멀티 레포(하위 디렉터리에 `.git`)인 경우에도 각 서브레포별로 동일하게 동작합니다.

### 생성되는 파일 (공통)

| 경로 | 내용 |
|---|---|
| `.claude/teamace/knowledge/{pm,pub,fe,be,qa}.md` | 에이전트별 Knowledge 템플릿 |
| `CLAUDE.md` | 프로젝트 정보 + 프로젝트별 규칙 템플릿 |

---

## 상태 확인 — `teamace status`

글로벌 설치 상태와 현재 프로젝트의 코드 품질 도구 설정 현황을 표시합니다.

```
코드 품질 도구
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  스택: node
    ESLint:      설정됨
    TypeScript:  strict
    Husky:       설정됨
    commitlint:  설정됨
```

---

## 프로젝트 정리 — `teamace clean`

`teamace init`으로 생성된 CLAUDE.md와 Knowledge를 제거합니다. 각 단계마다 확인 프롬프트가 표시됩니다. 코드 품질 도구 설정 파일(eslint, husky 등)은 프로젝트의 일부이므로 제거하지 않습니다.

---

## 제거 — `teamace uninstall`

글로벌 설치된 TeamAce를 완전히 제거합니다. `uninstall.sh`와 동일합니다.

> 각 프로젝트의 CLAUDE.md와 Knowledge는 제거되지 않습니다. 프로젝트별 정리는 `teamace clean`을 사용하세요.

---

## CLI 명령어

| 명령어 | 설명 |
|---|---|
| `teamace init [path]` | 프로젝트 초기화 (Knowledge + CLAUDE.md + 코드 품질 도구) |
| `teamace clean [path]` | 프로젝트 정리 (Knowledge + CLAUDE.md 제거) |
| `teamace status` | 설치 상태 + 코드 품질 도구 현황 |
| `teamace update` | 업데이트 안내 |
| `teamace uninstall` | 글로벌 제거 |
| `teamace version` | 버전 출력 |
| `teamace help` | 도움말 |

---

## 디렉터리 구조

```
~/.claude/                               ← 글로벌 (모든 프로젝트 공통)
├── agents/                              ← 에이전트 정의
├── teamace/
│   ├── skills/{pm,pub,fe,be,qa}/        ← 스킬
│   ├── contracts/                       ← 에이전트 간 계약
│   ├── harness/                         ← 품질 하네스
│   ├── core-principles/                 ← 핵심 원칙
│   └── version
├── CLAUDE.md                            ← 글로벌 지침
└── settings.json                        ← Agent Team + 권한

<프로젝트>/                               ← 프로젝트 로컬
├── CLAUDE.md                            ← 프로젝트 정보
├── .claude/teamace/
│   └── knowledge/{pm,pub,fe,be,qa}.md   ← 에이전트별 핵심 교훈
├── eslint.config.mjs                    ← (Node) ESLint
├── commitlint.config.mjs               ← 커밋 메시지 규칙
├── .husky/                              ← (Node) Git hooks
├── .pre-commit-config.yaml              ← (Python) pre-commit hooks
├── ruff.toml                            ← (Python) Ruff lint/format
├── config/checkstyle/checkstyle.xml     ← (Java) Checkstyle
└── .githooks/                           ← (Java) Git hooks
```

---

## Knowledge 기록 가이드

Knowledge에는 **반복 활용 가능한 핵심 교훈만** 기록합니다.

| 섹션 | 기록 내용 | 예시 |
|---|---|---|
| 재사용 가능한 패턴 | 검증된 기술적 패턴, 설정, 구조 | "SSE 스트림 이벤트에 `event:` 필드 필수 명시" |
| 실수와 회피 방법 | 원인과 재발 방지 조치 | "Notion API block 100개 제한 — 배치 분할 필수" |
| 사용자 선호 | 수정 요청으로 확인된 스타일, 판단 기준 | "컴포넌트 PascalCase, 훅 camelCase" |
