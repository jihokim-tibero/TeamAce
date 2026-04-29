# TeamAce

멀티에이전트 서비스 개발 시스템 — Lead가 PM, PUB, FE, BE, QA 에이전트를 오케스트레이션하여 서비스를 개발하고, 각 프로젝트에 언어별 코드 품질 도구와 CI 게이트를 자동으로 설정합니다.

## 요구 사항

- **git**, **node**, **npm**
- **Claude Code CLI** (`claude`) — 권장
- Python 프로젝트: **python3**, **pip**
- Java 프로젝트: **gradle/maven** (플러그인 통합용)

## 빠른 시작

```bash
# 1. 글로벌 설치
./install.sh

# 2. 프로젝트에서 초기화 (Knowledge + CLAUDE.md + 코드 품질 도구 + CI 잡 자동 설정)
cd /path/to/my-project
teamace init

# 3. Claude Code 실행
claude
```

---

## 핵심 기능

### 1. 멀티에이전트 오케스트레이션
Lead 에이전트가 사용자 요청을 분석하여 PM · PUB · FE · BE · QA 에이전트를 조율합니다. 각 에이전트는 전용 스킬, 핵심 원칙, 품질 하네스를 따릅니다.

### 2. 스택 자동 감지 + 코드 품질 도구 로컬 설치
`teamace init` 실행 시 프로젝트의 언어 스택을 자동 감지하고, 스택에 맞는 린트/포맷/타입 검사 도구를 **로컬에 실제로 설치**합니다.

### 3. 멀티 모듈 / 모노레포 지원
루트에 패키지 파일이 없으면 하위 디렉터리를 최대 3레벨까지 재귀 탐색하여 모듈별로 독립 감지합니다. 하나의 프로젝트에서 FE(Node) + BE(Python/Java)를 동시에 설치할 수 있습니다.

### 4. CI 잡 자동 주입 (GitLab / GitHub)
GitLab은 `.gitlab-ci.yml`에, GitHub은 `.github/workflows/teamace-lint.yml`에 모듈별 lint 잡을 자동으로 만듭니다. 기존 CI 파일이 있으면 마커 블록으로 안전하게 append합니다. **CI lint 잡이 단일 진실 게이트** — pre-commit은 보조입니다.

### 5. Config Guard
핵심 설정(strict, 필수 규칙 등)의 변조와 pre-commit hook 자체의 회귀를 차단합니다.

### 6. 설정 비교 (`teamace status`)
TeamAce 기대 설정과 현재 프로젝트 설정을 전 항목 비교해서 차이점을 표시합니다.

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
| `~/.claude/CLAUDE.md` | TeamAce 글로벌 지침 (기존 내용 보존, TEAMACE 섹션만 삽입) |
| `~/.claude/settings.json` | Agent Team 활성화 + 권한 설정 (기존 설정 보존) |
| `~/.local/bin/teamace` | CLI 실행 파일 |
| Impeccable 스킬 | 프론트엔드 디자인 스킬 (글로벌) |

---

## 프로젝트 초기화 — `teamace init`

프로젝트 디렉터리에서 실행하면 **Knowledge 템플릿 + CLAUDE.md + 코드 품질 도구 + CI 잡**을 로컬에 설치합니다. 멱등성 보장 — 이미 존재하는 설정은 건너뜁니다.

### 스택 감지 기준

| 스택 | 감지 파일 |
|---|---|
| **Node/TS** | `package.json` |
| **Python** | `pyproject.toml` / `requirements.txt` / `setup.py` / `Pipfile` |
| **Java (Maven)** | `pom.xml` |
| **Java (Gradle)** | `build.gradle` / `build.gradle.kts` |

### 스택별 설치 상세

#### Node/TypeScript

| 도구 | 역할 | 설정 파일 |
|---|---|---|
| **ESLint** | 정적 분석 (규칙 기반 린트) | `eslint.config.mjs` |
| **typescript-eslint** | TS 문법 지원 + **타입 정보 활용 lint** | eslint.config.mjs 내 플러그인 |
| **globals** | browser/node 환경 변수 선언 | eslint.config.mjs 내 import |
| **TypeScript (tsc)** | 타입 검사 (strict 모드) | `tsconfig.json` |
| **Husky** | Git hooks 관리 | `.husky/` |
| **commitlint** | Conventional Commits 검증 | `commitlint.config.mjs` |

**typescript-eslint 프리셋** — 공식 권장 조합 ([typescript-eslint Configs](https://typescript-eslint.io/users/configs/)):
- `strictTypeChecked` — 타입 정보를 활용한 잠재 버그 검출 규칙 (`no-floating-promises`, `no-misused-promises`, `no-unsafe-assignment/call/return/argument`, `await-thenable` 등)
- `stylisticTypeChecked` — 일관된 코딩 스타일 (`prefer-nullish-coalescing`, `prefer-optional-chain`, `consistent-type-definitions` 등)
- `parserOptions.projectService: true` — typescript-eslint v8+ 권장. 모듈별 가까운 `tsconfig.json`을 자동 탐색해 타입 정보를 ESLint에 공급
- `disableTypeChecked` 오버라이드 — `**/*.{js,jsx,mjs,cjs}` 파일에는 type-checked 규칙 비활성 (TS 정보가 없는 파일에서의 오작동 방지)

**ESLint 추가 규칙** (`error` = 필수, `warn` = 권장):
- `no-console: error` — console.log 금지
- `@typescript-eslint/no-explicit-any: error` — any 타입 금지
- `@typescript-eslint/no-unused-vars: error` — 미사용 변수 금지 (`_` 접두사 예외)
- `camelcase: error` — JS/TS 네이밍 규약
- `max-lines: warn(300)` — 파일 길이
- `max-lines-per-function: warn(100)` — 함수 길이

> **포맷은 ESLint가 아닌 Prettier에 위임이 공식 권고** — typescript-eslint 프리셋은 포맷 규칙을 포함하지 않습니다. 필요하면 별도로 Prettier를 도입하세요.

**ESLint 기본 ignores** (빌드 산출물·외부 도구 출력 제외):
`dist/`, `build/`, `node_modules/`, `coverage/`, `.next/`, `out/`, `**/target/` (Rust/Tauri), `**/*.tauri-codegen-assets/`

**ESLint 기본 overrides** (영역별 환경 자동 적용):
- `vite.config.*`, `*.config.{js,ts,mjs,cjs}` — Node globals
- `scripts/**` — Node globals + `no-console: off` (CLI 도구는 console 사용)
- `**/*.{test,spec}.*`, `tests/**`, `**/__tests__/**` — Node + mocha + jest globals
- `**/e2e/**` — Node + mocha + WebdriverIO globals (`browser`, `$`, `$$`, `driver`, `expect`)

**Husky hooks 3개:**
- `pre-commit` — Config Guard + `eslint --max-warnings 0` + `tsc --noEmit` 실행
- `commit-msg` — commitlint
- `pre-push` — main 브랜치 직접 push 차단

#### Python

| 도구 | 역할 | 설정 파일 |
|---|---|---|
| **Ruff** | lint + 포맷 통합 (flake8/isort/black 대체) | `pyproject.toml [tool.ruff]` 또는 `ruff.toml` |
| **mypy** | 정적 타입 검사 (strict 모드) | `pyproject.toml [tool.mypy]` 또는 `mypy.ini` |
| **pre-commit** | Git hooks 프레임워크 | `.pre-commit-config.yaml` (git 루트에 **하나만**) |

**Ruff select 규칙:** `E`(pycodestyle), `F`(pyflakes), `W`(경고), `I`(isort), `N`(PEP 8 네이밍), `UP`(pyupgrade), `B`(bugbear), `A`(builtins), `C4`(comprehensions), `SIM`(simplify)

**mypy 핵심 옵션:** `strict = true`, `warn_return_any = true`, `warn_unused_configs = true`, `ignore_missing_imports = true`

**pre-commit hooks 3개 (루트 단일 config):**
- `ruff` + `ruff-format` — 린트 + 포맷 자동 수정
- `mypy (per-module)` — **프로젝트 venv의 mypy를 각 모듈 디렉터리에서 독립 실행**. `mirrors-mypy`의 격리 venv는 프로젝트 의존성에 접근 불가 + 모노레포 모듈명 충돌 유발하므로 local hook으로 전환
- `config-guard` — mypy strict 설정 변조 차단

**버전 자동 최신화**: 매 init마다 `pre-commit autoupdate` 실행하여 hook rev를 최신 태그로 갱신.

#### Java (Maven/Gradle)

| 도구 | 역할 | 설정 파일 |
|---|---|---|
| **Checkstyle** | 스타일 정적 분석 | `config/checkstyle/checkstyle.xml` |
| **Spotless** | google-java-format 기반 포맷터 | `build.gradle` 또는 `pom.xml` 플러그인 설정 |
| **.githooks/** | 외부 도구 의존 없는 순수 bash 훅 | `.githooks/` + `core.hooksPath` |

**Checkstyle 핵심 모듈 (18개):** ConstantName, LocalVariableName, MemberName, MethodName, PackageName, ParameterName, TypeName, AvoidStarImport, UnusedImports, NeedBraces, LeftCurly, RightCurly, **WhitespaceAround(allowEmpty)**, EmptyBlock, MissingSwitchDefault, FallThrough, UpperEll, FileLength(700), NewlineAtEndOfFile

**Spotless 호환:** `WhitespaceAround`에 `allowEmptyTypes/Constructors/Methods/Lambdas = true` — google-java-format이 빈 블록을 `{}`로 포맷하는 것과의 충돌 방지.

**.githooks 3개:**
- `pre-commit` — Config Guard + `gradlew checkstyleMain` + `gradlew spotlessCheck` (또는 `mvn checkstyle:check`) 실행
- `commit-msg` — Conventional Commits 형식 검증 (bash regex, commitlint 불필요)
- `pre-push` — main 브랜치 직접 push 차단

**빌드 플러그인 버전은 Maven Central API에서 동적 조회** (fallback: 하드코딩 기본값).

### CI 잡 자동 주입 (GitLab / GitHub)

`teamace init`은 git 플랫폼을 감지(`detect_platform`)해 모듈별 lint 잡을 CI에 주입합니다. **모듈 = `find_modules`가 감지한 각 패키지 디렉터리** (Node·Python만, Java는 빌드에 통합되어 제외).

#### GitLab — `.gitlab-ci.yml`

- 파일이 **없으면**: 새로 생성. `stages: [lint]` + 잡 정의.
- 파일이 **있으면**: `# TEAMACE-LINT-START` ... `# TEAMACE-LINT-END` 마커 블록을 끝에 append. `stages`에 `lint`가 없으면 경고만 출력 (덮어쓰지 않음).
- 마커 블록이 이미 있으면 skip (멱등).
- 잡 이름은 `teamace:lint:<modulepath>` — 사용자 기존 잡과 충돌하지 않도록 prefix 부여.

```yaml
teamace:lint:frontend:
  stage: lint
  image: node:20-alpine
  script:
    - cd frontend
    - npm ci --no-audit --no-fund
    - npx eslint . --max-warnings 0
    - if [ -f tsconfig.json ]; then npx tsc --noEmit; fi
  rules:
    - changes: ['frontend/**/*']

teamace:lint:backend:
  stage: lint
  image: python:3.11-slim
  before_script: [pip install --quiet ruff mypy]
  script:
    - cd backend
    - ruff check .
    - ruff format --check .
    - mypy .
  rules:
    - changes: ['backend/**/*']
```

#### GitHub Actions — `.github/workflows/teamace-lint.yml`

- 파일이 **없으면**: 새로 생성. `pull_request` + `push` (main/master) 트리거.
- 파일이 **있으면**: skip (사용자가 직접 관리한다고 간주).
- 잡 이름은 `teamace-lint-<modulepath>`.

#### 멀티 레포 모드

루트에 git 저장소가 없고 하위 디렉터리에 여러 git 레포가 있으면 각 레포의 플랫폼을 개별 감지하여 각각 처리합니다. GitLab 레포와 GitHub 레포가 섞여 있어도 모두 동작합니다.

### 생성되는 공통 파일

| 경로 | 내용 |
|---|---|
| `.claude/teamace/knowledge/{pm,pub,fe,be,qa}.md` | 에이전트별 Knowledge 템플릿 |
| `CLAUDE.md` | 프로젝트 정보 + 네이밍 규약 + 린트 설정 변경 금지 규칙 |
| `.gitlab-ci.yml` | (GitLab) lint 잡 — 새 파일 또는 마커 블록 append |
| `.github/workflows/teamace-lint.yml` | (GitHub) lint 워크플로 — 새 파일만 |

---

## 네이밍 규약

언어별 표준을 존중하되 API 경계에서는 통일된 규칙을 적용합니다.

| 영역 | 규약 | 예시 |
|---|---|---|
| **API JSON 키 (요청/응답 필드)** | `camelCase` | `businessName`, `userId` |
| **클래스명** (모든 언어) | `PascalCase` | `UserService` |
| **상수** (모든 언어) | `UPPER_SNAKE_CASE` | `MAX_RETRY_COUNT` |
| **TS/JS/Java 내부 변수·함수** | `camelCase` | 언어 표준 |
| **Python 내부 변수·함수** | `snake_case` | PEP 8 |
| **DB 컬럼** | `snake_case` | SQL 관례 |

Python 백엔드는 Pydantic `alias_generator`로 `snake_case ↔ camelCase` 변환 — 내부는 snake_case, API 경계에서 camelCase.

---

## 상태 확인 — `teamace status`

글로벌 설치 상태와 프로젝트의 코드 품질 도구 설정을 전 항목 비교하여 표시합니다.

```
코드 품질 도구
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  frontend (node)
    ESLint:      9.39.4
    TypeScript:  strict
    Husky:       설정됨
    commitlint:  설정됨
    ── 설정 비교 ──
      모든 항목 일치
  backend (python)
    Ruff:        0.15.9
    mypy:        1.20.0
    pre-commit:  설정됨 (v0.15.9 v1.20.0)
    ── 설정 비교 ──
      모든 항목 일치
```

차이가 있으면 **항목별로 현재값 vs 기대값**을 색상과 함께 표시합니다:

```
    ── 설정 비교 ──
      tsconfig strict: false (기대: true)
      eslint no-console: off (기대: error)
      checkstyle ignoreFailures: true (기대: 제거 — 위반 시 빌드 실패)
```

> **참고**: `teamace status`는 **설정 존재·값**을 비교합니다. 실제 lint를 실행해 위반 건수를 보려면 각 모듈에서 `npx eslint .` / `ruff check .` / `mypy .`를 직접 실행하세요.

---

## 검증 시점 — Layered

lint/타입 검사는 **여러 시점에 layered**로 돌아 각 단계의 비용·신뢰도를 분담합니다.

| 시점 | 목적 | 비고 |
|------|------|------|
| **에디터/IDE** | 실시간 피드백 | TeamAce 범위 밖 (사용자 IDE 설정) |
| **pre-commit hook** | 로컬에서 깨진 코드 commit 차단 | `--no-verify`로 우회 가능 — 보조 게이트 |
| **CI lint 잡 (push/PR)** | **단일 진실 게이트** — 머지 차단 | 우회 불가. TeamAce가 자동 주입 |
| **빌드 통합** | Java(Gradle/Maven)는 빌드에 lint plugin 통합 | JS/Python은 빌드와 lint 분리가 일반적 |

### 커밋 시점 (pre-commit hook)

| 스택 | 실행 항목 |
|---|---|
| **Node** | Config Guard + `eslint --max-warnings 0` + `tsc --noEmit` |
| **Python** | Config Guard + ruff + ruff-format + mypy (프로젝트 venv, per-module) |
| **Java** | Config Guard + `gradlew checkstyleMain` + `gradlew spotlessCheck` |

### CI 시점 (push/PR)

`.gitlab-ci.yml` 또는 `.github/workflows/teamace-lint.yml`의 `teamace:lint:*` / `teamace-lint-*` 잡이 모듈별로 실행됩니다. 변경된 모듈에 대해서만 돌도록 `rules.changes` / `paths` 필터가 자동 적용됩니다.

### 빌드 시점

| 스택 | 검증 |
|---|---|
| **TypeScript** | `tsc` strict 모드 |
| **Java (Gradle/Maven)** | checkstyle + spotless 플러그인이 빌드에 통합 (`gradle check`, `mvn verify` 시 자동 실행) |

**워닝도 에러로 처리:** ESLint `--max-warnings 0`, Java 빌드 설정에서 `ignoreFailures`/`enforceCheck`/`failOnViolation` 제거.

### Config Guard 검증 항목

| 스택 | 검증 대상 |
|---|---|
| **Node** | tsconfig `strict: true`, ESLint `no-console`/`no-explicit-any` 존재, **`.husky/pre-commit`이 실제로 `npx eslint`/`node_modules/.bin/eslint`를 호출하는지** |
| **Python** | mypy `strict = true` (글로벌 `[tool.mypy]` 섹션, per-module override는 제외) |
| **Java** | `checkstyle.xml` 존재, pre-commit 훅 존재 |

> **회귀 차단**: Node Config Guard는 누군가 pre-commit을 단순화하면서 ESLint 호출 라인을 빼버리는 회귀를 grep으로 잡습니다. ESLint 설정이 존재하는 한 hook이 ESLint를 실제 호출하지 않으면 다음 commit에서 차단됩니다.

---

## 프로젝트 정리 — `teamace clean`

`teamace init`으로 생성된 CLAUDE.md와 Knowledge를 제거합니다. 코드 품질 도구 설정 파일(eslint, husky, checkstyle.xml 등)과 CI 파일(`.gitlab-ci.yml`, `.github/workflows/teamace-lint.yml`)은 **프로젝트의 일부**이므로 제거하지 않습니다.

---

## 제거 — `teamace uninstall`

글로벌 설치된 TeamAce를 완전히 제거합니다. `uninstall.sh`와 동일.

> 각 프로젝트의 CLAUDE.md와 Knowledge는 제거되지 않습니다. 프로젝트별 정리는 `teamace clean`을 사용하세요.

---

## CLI 명령어

| 명령어 | 설명 |
|---|---|
| `teamace init [path]` | 프로젝트 초기화 (Knowledge + CLAUDE.md + 코드 품질 도구 + CI 잡) |
| `teamace clean [path]` | 프로젝트 정리 (Knowledge + CLAUDE.md 제거) |
| `teamace status` | 설치 상태 + 코드 품질 도구 비교 |
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
├── CLAUDE.md                            ← 프로젝트 정보 + 네이밍 규약
├── .claude/teamace/knowledge/           ← 에이전트별 핵심 교훈
├── .pre-commit-config.yaml              ← (Python) git 루트에 단일 config
├── .gitlab-ci.yml                       ← (GitLab) TEAMACE-LINT 마커 블록
├── .github/workflows/teamace-lint.yml   ← (GitHub) TeamAce 자동 워크플로
│
├── frontend/                            ← (예) Node 모듈
│   ├── eslint.config.mjs
│   ├── tsconfig.json
│   ├── commitlint.config.mjs
│   └── .husky/
│
├── backend/                             ← (예) Java Gradle 모듈
│   ├── build.gradle                     ← checkstyle + spotless 플러그인
│   ├── config/checkstyle/checkstyle.xml
│   └── .githooks/
│
└── services/api/                        ← (예) Python 모듈
    ├── pyproject.toml                   ← [tool.ruff], [tool.mypy]
    └── mypy.ini                         ← (대안)
```

---

## 린트 설정 변경 금지 원칙

TeamAce가 설정한 린트 규칙은 에이전트가 **임의로 변경할 수 없습니다**.

- 린트 에러 발생 시 **코드를 규칙에 맞게 수정**한다 (규칙을 끄지 않는다)
- 규칙 조정이 필요하면 사용자 승인 후에만 변경
- `// eslint-disable`, `# type: ignore`, `@SuppressWarnings` 등 인라인 억제도 사유 명시 + 사용자 승인 필수

Config Guard가 pre-commit hook에서 핵심 설정 변조와 hook 자체의 회귀를 차단하며, `teamace status`의 설정 비교에서 차이가 즉시 드러납니다. 우회 가능성을 막는 최종 게이트는 CI lint 잡입니다.

---

## Knowledge 기록 가이드

Knowledge에는 **반복 활용 가능한 핵심 교훈만** 기록합니다.

| 섹션 | 기록 내용 | 예시 |
|---|---|---|
| 재사용 가능한 패턴 | 검증된 기술적 패턴, 설정, 구조 | "SSE 스트림 이벤트에 `event:` 필드 필수 명시" |
| 실수와 회피 방법 | 원인과 재발 방지 조치 | "Notion API block 100개 제한 — 배치 분할 필수" |
| 사용자 선호 | 수정 요청으로 확인된 스타일, 판단 기준 | "컴포넌트 PascalCase, 훅 camelCase" |
