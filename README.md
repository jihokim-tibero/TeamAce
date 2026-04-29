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

# 2. 프로젝트에서 초기화
cd /path/to/my-project
teamace init

# 3. Claude Code 실행
claude
```

`teamace init` 한 번이면 Knowledge · CLAUDE.md · 스택별 lint/타입/포맷 도구 · pre-commit hook · CI lint 잡까지 모두 자동 설정됩니다. 멱등성 보장 — 이미 있는 설정은 건너뜁니다.

---

## 핵심 기능

### 1. 멀티에이전트 오케스트레이션
Lead 에이전트가 사용자 요청을 분석하여 PM · PUB · FE · BE · QA 에이전트를 조율합니다.

### 2. 스택 자동 감지 + 코드 품질 도구 로컬 설치
프로젝트의 언어 스택을 자동 감지하고 스택에 맞는 린트/포맷/타입 검사 도구를 **로컬에 실제로 설치**합니다.

### 3. 멀티 모듈 / 모노레포 지원
루트에 패키지 파일이 없으면 하위 디렉터리를 최대 3레벨까지 재귀 탐색하여 모듈별로 독립 감지합니다.

### 4. CI 잡 자동 주입 (GitLab / GitHub)
GitLab은 `.gitlab-ci.yml`에, GitHub은 `.github/workflows/teamace-lint.yml`에 모듈별 lint 잡을 자동 주입합니다. **CI lint 잡이 단일 진실 게이트** — pre-commit은 보조입니다.

### 5. Config Guard
핵심 설정과 hook 자체의 회귀를 pre-commit에서 차단합니다.

### 6. 설정 비교 (`teamace status`)
TeamAce 기대 설정과 현재 프로젝트 설정을 항목별로 비교해서 차이점과 조치 힌트를 표시합니다.

---

## 설치 — `install.sh`

| 경로 | 내용 |
|---|---|
| `~/.claude/agents/` | 에이전트 정의 6개 (lead, pm, pub, fe, be, qa) |
| `~/.claude/teamace/skills/` | 에이전트별 워크플로우 스킬 |
| `~/.claude/teamace/contracts/` | 에이전트 간 핸드오프 계약 |
| `~/.claude/teamace/harness/` | 품질 게이트, 평가 기준, 회귀 정책 |
| `~/.claude/teamace/core-principles/` | 에이전트별 핵심 원칙 |
| `~/.claude/CLAUDE.md` | TeamAce 글로벌 지침 (TEAMACE 섹션만 삽입) |
| `~/.claude/settings.json` | Agent Team 활성화 + 권한 (기존 보존) |
| `~/.local/bin/teamace` | CLI 실행 파일 |
| Impeccable 스킬 | 프론트엔드 디자인 스킬 (글로벌) |

---

## 프로젝트 초기화 — `teamace init`

`teamace init`이 만드는 산출물 개요:

| 산출물 | 설명 |
|---|---|
| `.claude/teamace/knowledge/{pm,pub,fe,be,qa}.md` | 에이전트별 Knowledge 템플릿 |
| `CLAUDE.md` | 프로젝트 정보 + 네이밍 규약 + 린트 변경 금지 규칙 |
| 스택별 lint/타입 도구 | `eslint.config.mjs`, `tsconfig.json`, `pyproject.toml`의 `[tool.ruff]`/`[tool.mypy]`, Java `checkstyle.xml`/빌드 플러그인 등 |
| Husky / .githooks | `pre-commit` (Config Guard + lint 실행), `commit-msg`, `pre-push` |
| `.pre-commit-config.yaml` | (Python 모듈이 있을 때) git 루트에 단일 config |
| `.gitlab-ci.yml` 또는 `.github/workflows/teamace-lint.yml` | 모듈별 lint 잡 |

### 스택 감지 기준

| 스택 | 감지 파일 |
|---|---|
| **Node/TS** | `package.json` |
| **Python** | `pyproject.toml` / `requirements.txt` / `setup.py` / `Pipfile` |
| **Java (Maven)** | `pom.xml` |
| **Java (Gradle)** | `build.gradle` / `build.gradle.kts` |

상세 lint/타입/CI 동작은 아래 [코드 품질 도구](#코드-품질-도구) 섹션 참조.

---

## 코드 품질 도구

### 적용 흐름

`teamace init` 한 번 실행하면 다음이 자동으로 끝납니다:

1. 스택별 lint/타입/포맷 도구 **로컬 설치**
2. **pre-commit hook** 생성 (Config Guard + lint/타입 실행)
3. **CI lint 잡** 자동 주입 (GitLab/GitHub 플랫폼 자동 감지)

자동으로 처리되지 **않는** 케이스는 [사용자가 직접 해야 할 일](#사용자가-직접-해야-할-일)을 참조하세요.

### Node / TypeScript

#### ESLint 핵심 규칙

| 규칙 | 레벨 | 의도 |
|---|---|---|
| `no-console` | error | console.log 금지 |
| `@typescript-eslint/no-explicit-any` | error | any 타입 금지 |
| `@typescript-eslint/no-unused-vars` | error | 미사용 변수 금지 (`_` prefix 예외) |
| `camelcase` | error | JS/TS 네이밍 규약 (`{ properties: "always" }`) |
| `max-lines` | warn | 파일 300줄 |
| `max-lines-per-function` | warn | 함수 100줄 |

#### typescript-eslint 프리셋 ([공식 권장 조합](https://typescript-eslint.io/users/configs/))

- `js.configs.recommended` (코어 ESLint 권장)
- `tseslint.configs.strictTypeChecked` — 타입 정보 활용 잠재 버그 검출 (`no-floating-promises`, `no-misused-promises`, `no-unsafe-*`, `await-thenable`)
- `tseslint.configs.stylisticTypeChecked` — 일관된 코딩 스타일 (`prefer-nullish-coalescing`, `prefer-optional-chain`, `consistent-type-definitions`)
- `parserOptions.projectService: true` (typescript-eslint v8+ 권장) — 모듈별 가까운 `tsconfig.json` 자동 탐색
- `**/*.{js,jsx,mjs,cjs}`에 `disableTypeChecked` 오버라이드 — TS 정보가 없는 파일에서 type-checked 규칙이 오작동하는 걸 방지

> **포맷은 ESLint가 아닌 Prettier에 위임이 공식 권고** — typescript-eslint 프리셋은 포맷 규칙을 포함하지 않습니다. 필요하면 별도로 Prettier를 도입하세요.

#### 자동 ignores (빌드 산출물·외부 도구 출력)

`dist/`, `build/`, `node_modules/`, `coverage/`, `.next/`, `out/`, `**/target/` (Rust/Tauri), `**/*.tauri-codegen-assets/`

#### 자동 overrides (영역별 환경)

| 패턴 | 환경 / 룰 조정 |
|---|---|
| `vite.config.*`, `*.config.{js,ts,mjs,cjs}` | Node globals |
| `scripts/**` | Node globals + `no-console: off` (CLI 도구는 console 사용) |
| `**/*.{test,spec}.*`, `tests/**`, `**/__tests__/**` | Node + mocha + jest globals |
| `**/e2e/**` | Node + mocha + WebdriverIO globals (`browser`, `$`, `$$`, `driver`, `expect`) |

#### TypeScript (tsc)

`tsconfig.json` 기본 옵션: `strict: true`, `esModuleInterop: true`, `skipLibCheck: true`, `forceConsistentCasingInFileNames: true`. `tsc --noEmit`을 pre-commit과 CI에서 실행.

### Python

#### Ruff (`pyproject.toml [tool.ruff]` 또는 `ruff.toml`)

- `line-length = 120`
- `select = ["E", "F", "W", "I", "N", "UP", "B", "A", "C4", "SIM"]`
  - `E`/`W` (pycodestyle), `F` (pyflakes), `I` (isort), `N` (PEP 8 네이밍), `UP` (pyupgrade), `B` (bugbear), `A` (builtins shadowing), `C4` (comprehensions), `SIM` (simplify)
- 포맷: `ruff format` (`quote-style = "double"`) — flake8/isort/black을 Ruff 하나로 통합

#### mypy (`pyproject.toml [tool.mypy]` 또는 `mypy.ini`)

`strict = true`, `warn_return_any = true`, `warn_unused_configs = true`, `ignore_missing_imports = true`, `python_version = "3.11"`

#### pre-commit framework (`.pre-commit-config.yaml`)

git 루트에 **단일 config**. 매 init마다 `pre-commit autoupdate`로 hook rev 자동 갱신.

| Hook | 동작 |
|---|---|
| `ruff` | 린트 + `--fix` 자동 수정 |
| `ruff-format` | 포맷 검증 |
| `mypy (per-module)` | **프로젝트 venv의 mypy를 각 모듈에서 독립 실행** (mirrors-mypy의 격리 venv 회피 + 모노레포 모듈명 충돌 회피) |
| `config-guard` | mypy strict 설정 변조 차단 |

### Java (Maven / Gradle)

#### Checkstyle (`config/checkstyle/checkstyle.xml`, 18 모듈)

ConstantName, LocalVariableName, MemberName, MethodName, PackageName, ParameterName, TypeName, AvoidStarImport, UnusedImports, NeedBraces, LeftCurly, RightCurly, **WhitespaceAround(allowEmpty)**, EmptyBlock, MissingSwitchDefault, FallThrough, UpperEll, FileLength(700), NewlineAtEndOfFile

`WhitespaceAround`에 `allowEmptyTypes/Constructors/Methods/Lambdas = true` — google-java-format이 빈 블록을 `{}`로 포맷하는 것과의 충돌 방지.

#### Spotless

google-java-format 기반. 빌드 플러그인 버전은 Maven Central API에서 동적 조회 (fallback: 하드코딩 기본값).

#### .githooks (외부 도구 의존 없는 순수 bash)

`pre-commit` — Config Guard + `gradlew checkstyleMain` + `gradlew spotlessCheck` (Maven은 `mvn checkstyle:check`)
`commit-msg` — Conventional Commits 형식 검증 (bash regex)
`pre-push` — main 브랜치 직접 push 차단

#### 빌드 통합

빌드 설정에서 `ignoreFailures` / `enforceCheck = false` / `failOnViolation = false`를 자동 제거 — `gradle check` / `mvn verify` 시 위반이 빌드 실패로 이어짐.

### 검증 시점 — Layered

lint/타입 검사는 **여러 시점에 layered**로 돌아 각 단계의 비용·신뢰도를 분담합니다.

| 시점 | 목적 | 우회 가능성 |
|---|---|---|
| **에디터/IDE** | 실시간 피드백 | TeamAce 범위 밖 |
| **pre-commit hook** | 로컬에서 깨진 코드 commit 차단 | `--no-verify` 우회 가능 — 보조 게이트 |
| **CI lint 잡** (push/PR) | **단일 진실 게이트** — 머지 차단 | 우회 불가 |
| **빌드 통합** | Java만 — `gradle check`/`mvn verify`에 plugin 통합 | 우회 불가 |

#### pre-commit 동작

| 스택 | 실행 항목 |
|---|---|
| **Node** | Config Guard + `eslint --max-warnings 0` + `tsc --noEmit` |
| **Python** | Config Guard + `ruff` + `ruff-format` + mypy (프로젝트 venv, per-module) |
| **Java** | Config Guard + `gradlew checkstyleMain` + `gradlew spotlessCheck` |

#### CI lint 잡 (자동 주입)

**GitLab — `.gitlab-ci.yml`**
- 파일이 없으면 새로 생성 (`stages: [lint]` + 모듈별 잡)
- 있으면 `# TEAMACE-LINT-START` … `# TEAMACE-LINT-END` 마커 블록을 끝에 append
- 마커 블록이 이미 있으면 skip (멱등)
- `stages`에 `lint`가 없으면 경고만 출력 (덮어쓰지 않음)
- 잡 이름: `teamace:lint:<modulepath>` — 사용자 잡과 충돌 회피

**GitHub Actions — `.github/workflows/teamace-lint.yml`**
- 파일이 없으면 새로 생성 (`pull_request` + `push` main/master 트리거)
- 있으면 skip (사용자가 직접 관리한다고 간주)
- 잡 이름: `teamace-lint-<modulepath>`

각 잡은 `rules.changes` / `paths` 필터로 변경된 모듈에서만 실행됩니다.

#### 빌드 시점 (Java)

`gradle check` 또는 `mvn verify` 실행 시 checkstyle + spotless 플러그인이 자동 호출. 위반은 빌드 실패.

### Config Guard

pre-commit hook에서 차단하는 변조 항목:

| 스택 | 검증 대상 |
|---|---|
| **Node** | tsconfig `strict: true`, ESLint `no-console`/`no-explicit-any` 규칙 존재, **`.husky/pre-commit`이 실제로 `npx eslint`를 호출하는지** (회귀 차단) |
| **Python** | mypy `strict = true` (글로벌 `[tool.mypy]` 섹션, per-module override는 제외) |
| **Java** | `checkstyle.xml` 존재, pre-commit 훅 존재 |

**회귀 차단**: Node Config Guard는 누군가 pre-commit을 단순화하면서 ESLint 호출 라인을 빼버리는 회귀를 grep으로 잡습니다. ESLint 설정이 존재하는 한 hook이 ESLint를 실제 호출하지 않으면 다음 commit에서 차단됩니다.

### `teamace status`로 확인 가능한 범위

`teamace status`는 **설정 존재·값**을 항목별로 비교하고 차이가 있으면 `→ 조치:` 힌트를 표시합니다.

| 확인 항목 | 다루는 범위 |
|---|---|
| ESLint 규칙 비교 | **flat config를 dynamic import해서 main scope rules만 추출** — `files` 키 있는 overrides 블록은 자동 제외(false positive 회피). 핵심 규칙 6개(`no-console`, `@typescript-eslint/no-explicit-any`, `@typescript-eslint/no-unused-vars`, `camelcase`, `max-lines`, `max-lines-per-function`)의 최종 적용값 비교 |
| ESLint ignores | `dist` 포함 여부 |
| ESLint globals | browser/node 환경 선언 여부 |
| tsconfig 옵션 | `strict`, `esModuleInterop`, `skipLibCheck`, `forceConsistentCasingInFileNames` 외 strict 하위 false 감지 |
| Husky 훅 파일 | `pre-commit`/`commit-msg`/`pre-push` 존재 |
| **Husky pre-commit 본문** | `.husky/pre-commit`이 실제로 `npx eslint`/`node_modules/.bin/eslint`를 호출하는지 grep 검증 (회귀 차단) |
| commitlint 설정 | 파일 존재 |
| Ruff 설정 | **도구 자체 부재 + line-length + select 규칙 + ignore 충돌** |
| mypy 설정 | **도구 자체 부재 + strict 옵션** |
| `.pre-commit-config.yaml` | 존재 + hook rev |
| Java | Checkstyle 모듈 / Spotless / 빌드 옵션(`ignoreFailures` 등) / `.githooks` |
| **CI 게이트** | GitLab `.gitlab-ci.yml`의 `TEAMACE-LINT` 마커 / GitHub `.github/workflows/teamace-lint.yml` 존재 |
| 글로벌 | 버전, 에이전트 수, Knowledge, Impeccable, Agent Team |

ESLint 규칙 검사는 모듈에 `node_modules`가 설치되어 있을 때 정확 모드(dynamic import)로 동작합니다. 미설치 시 grep fallback으로 동작 — overrides 블록을 구분 못 해 false positive가 생길 수 있고, 이 경우 `npm install` 후 `teamace status` 재실행을 안내합니다.

#### `teamace status`가 다루지 **않는** 것

| 미다룸 항목 | 직접 확인 방법 |
|---|---|
| 실제 lint 위반 건수 | `cd <module> && npx eslint .` / `ruff check .` / `mypy .` |
| TS 파일 0개인데 strict tsconfig (데드 컨피그) | 직접 `find . -name '*.ts'` |
| CI 잡 본문 내용 (마커 존재만 확인) | `awk '/# TEAMACE-LINT-START/,/# TEAMACE-LINT-END/' .gitlab-ci.yml` |

### 사용자가 직접 해야 할 일

`teamace init`은 **이미 존재하는 설정을 덮어쓰지 않습니다** (멱등). 즉, 신규 프로젝트는 모두 자동이지만 기존 프로젝트는 일부 수동 조정이 필요할 수 있습니다.

| 상황 | TeamAce 동작 | 사용자 작업 |
|---|---|---|
| `eslint.config.*` 이미 존재 | skip | 최신 템플릿 기준으로 직접 갱신 (ignores·overrides·typescript-eslint 격상 등) |
| `.husky/pre-commit` 이미 존재 | skip | 최신 템플릿으로 직접 교체 (Config Guard·ESLint 호출 회귀 차단) |
| `tsconfig.json`에 strict 누락 | strict만 활성화 시도 | 그 외 옵션 검토 |
| `.gitlab-ci.yml` 있고 `stages.lint` 없음 | lint 잡 append + 경고 | `stages`에 `lint` 직접 추가 |
| `.github/workflows/teamace-lint.yml` 이미 존재 | skip | 최신 템플릿으로 직접 갱신 |
| `pyproject.toml`에 `[tool.ruff]` 있음 | skip | 필요 시 select 규칙 직접 조정 |
| npm 패키지 설치 실패 | 수동 명령 출력 | 출력된 `npm install -D ...` 명령 직접 실행 |
| 모노레포에서 `core.hooksPath`가 pre-commit framework로 설정 | husky가 root commit 시 호출되지 않음 | root `.pre-commit-config.yaml`에 frontend ESLint hook을 local hook으로 추가 |
| ESLint 위반(코드 자체 결함) | 검증만 함 | 코드 수정 (TeamAce는 룰을 끄지 않음) |

`teamace status`를 실행해 `→ 조치: ...` 힌트가 보이는 항목이 있으면 그 안내를 따라가는 게 일반적입니다.

### 설정 변경 금지 원칙

TeamAce가 설정한 린트 규칙은 에이전트가 **임의로 변경할 수 없습니다**.

- 린트 에러 발생 시 **코드를 규칙에 맞게 수정**한다 (규칙을 끄지 않는다)
- 규칙 조정이 필요하면 사용자 승인 후에만 변경
- `// eslint-disable`, `# type: ignore`, `@SuppressWarnings` 등 인라인 억제도 사유 명시 + 사용자 승인 필수

Config Guard가 pre-commit에서 핵심 설정 변조와 hook 자체의 회귀를 차단하며, `teamace status`의 설정 비교에서 차이가 즉시 드러납니다. 우회 가능성을 막는 최종 게이트는 CI lint 잡입니다.

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

차이가 있으면 항목별로 현재값 vs 기대값 + 조치 힌트가 표시됩니다:

```
    ── 설정 비교 ──
      tsconfig strict: false (기대: true)
      → 조치: tsconfig.json의 compilerOptions.strict를 true로
      eslint no-console: off (기대: error)
      → 조치: eslint.config.mjs에서 no-console: off 제거
```

> `teamace status`는 설정 존재·값만 비교합니다. 실제 lint 위반 건수를 보려면 각 모듈에서 `npx eslint .` / `ruff check .` / `mypy .`를 직접 실행하세요.

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

## Knowledge 기록 가이드

Knowledge에는 **반복 활용 가능한 핵심 교훈만** 기록합니다.

| 섹션 | 기록 내용 | 예시 |
|---|---|---|
| 재사용 가능한 패턴 | 검증된 기술적 패턴, 설정, 구조 | "SSE 스트림 이벤트에 `event:` 필드 필수 명시" |
| 실수와 회피 방법 | 원인과 재발 방지 조치 | "Notion API block 100개 제한 — 배치 분할 필수" |
| 사용자 선호 | 수정 요청으로 확인된 스타일, 판단 기준 | "컴포넌트 PascalCase, 훅 camelCase" |
