# TeamAce

멀티에이전트 서비스 개발 시스템 — Lead가 PM · PUB · BE · FE · QA 에이전트를 오케스트레이션하여 서비스를 개발합니다.

## 요구 사항

- **git**, **node**, **npm** — 사전 설치 필수
- **Claude Code CLI** (`claude`) — 권장. 없어도 설치는 진행되지만 경고가 표시됩니다.

---

## 글로벌 vs 프로젝트 로컬

TeamAce는 파일을 **글로벌**과 **프로젝트 로컬** 두 곳에 나누어 관리합니다.

| 구분 | 위치 | 내용 | 특성 |
|------|------|------|------|
| 글로벌 | `~/.claude/` | 에이전트 정의, 스킬, 계약, 하네스, 핵심 원칙, Impeccable | 모든 프로젝트에 공통으로 적용되는 범용 규칙과 절차 |
| 프로젝트 로컬 | `<프로젝트>/.claude/teamace/` | knowledge (핵심 교훈) | 프로젝트별로 축적되는 반복 활용 가능한 교훈 |
| 프로젝트 로컬 | `<프로젝트>/CLAUDE.md` | 프로젝트 정보, 프로젝트별 규칙 | 글로벌 지침과 중복하지 않는 로컬 오버라이드용 템플릿 |

---

## 설치 — `install.sh`

```bash
./install.sh
```

글로벌 환경(`$HOME`)에 TeamAce를 설치합니다. 이미 설치된 파일이 있으면 덮어쓰거나 병합합니다.

### 생성/변경되는 파일

| 경로 | 내용 |
|---|---|
| `~/.claude/agents/` | 에이전트 정의 6개 — `lead.md` `pm.md` `pub.md` `fe.md` `be.md` `qa.md` |
| `~/.claude/teamace/skills/{pm,pub,fe,be,qa}/` | 에이전트별 스킬 (`.md`) |
| `~/.claude/teamace/contracts/` | 에이전트 간 계약 (`pm-to-be.md` `be-to-fe.md` 등 6개) |
| `~/.claude/teamace/harness/` | 품질 하네스 (`eval-criteria.md` `quality-gates.md` `regression-policy.md`) |
| `~/.claude/teamace/core-principles/` | 에이전트별 핵심 원칙 (`pm.md` `pub.md` `fe.md` `be.md` `qa.md`) |
| `~/.claude/teamace/config/` | (예약 디렉터리) |
| `~/.claude/teamace/version` | 설치 버전 (`1.0.0`) |
| Impeccable 글로벌 스킬 | `~/.agents/skills/frontend-design/` 또는 `~/.claude/commands/frontend-design/` |
| `~/.claude/CLAUDE.md` | `<!-- TEAMACE:START -->` ~ `<!-- TEAMACE:END -->` 섹션 추가 (기존 내용 보존) |
| `~/.claude/settings.json` | `permissions`, `env` (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`), `mcpServers` 병합 (기존 설정 보존) |
| `~/.local/bin/teamace` | CLI 실행 파일 |
| `~/.zshrc` 또는 `~/.bashrc` | PATH에 `~/.local/bin`이 없을 경우 `export PATH` 라인 추가 |

---

## 프로젝트 초기화 — `teamace init`

```bash
cd /path/to/my-project
teamace init
```

현재 프로젝트 디렉터리에 TeamAce를 연결합니다. 글로벌 설치(`install.sh`)가 선행되어야 합니다.

### 수행 동작

1. **프로젝트 구조 감지** — 단일 레포(`.git` 존재) / 멀티 레포(하위 디렉터리에 `.git`) / 레포 없음을 자동 판별하고, Git 플랫폼(GitHub, GitLab, Bitbucket)을 감지합니다.
2. **Impeccable 글로벌 설치 확인** — 글로벌 또는 프로젝트 레벨에 Impeccable이 있는지 확인합니다. 없으면 `install.sh` 재실행 안내를 출력합니다.
3. **Agent Team 실험 기능 확인** — `settings.json`의 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` 활성화 여부를 확인합니다.
4. **프로젝트 Knowledge 생성** — `.claude/teamace/knowledge/` 디렉터리에 에이전트별 knowledge 템플릿(`pm.md` `pub.md` `fe.md` `be.md` `qa.md`)을 생성합니다. 각 파일은 "재사용 가능한 패턴", "실수와 회피 방법", "사용자 선호" 세 섹션으로 구성됩니다. 이미 존재하는 파일은 건너뜁니다.
5. **프로젝트 CLAUDE.md 생성** — 이미 존재하면 건너뜁니다. 없으면 프로젝트 정보와 프로젝트별 규칙을 위한 간소한 템플릿을 생성합니다. 글로벌 지침(`~/.claude/CLAUDE.md`)과 중복되는 내용은 포함하지 않습니다.

### 생성되는 파일

| 경로 | 내용 |
|---|---|
| `<프로젝트>/.claude/teamace/knowledge/{pm,pub,fe,be,qa}.md` | 에이전트별 knowledge 템플릿. 작업을 거치며 재사용 가능한 패턴, 실수 회피 방법, 사용자 선호가 축적됩니다. |
| `<프로젝트>/CLAUDE.md` | 프로젝트명, 기술 스택, 프로젝트별 규칙 섹션 (멀티 레포일 경우 레포 목록 포함) |

---

## 프로젝트 정리 — `teamace clean`

```bash
cd /path/to/my-project
teamace clean
```

`teamace init`으로 생성된 프로젝트 레벨 파일을 정리합니다. 글로벌 설치에는 영향을 주지 않습니다. 각 단계마다 확인 프롬프트가 표시됩니다.

### 수행 동작

1. **CLAUDE.md 제거** — 삭제 여부를 묻습니다.
2. **프로젝트 Knowledge 제거** — `.claude/teamace/` 전체를 삭제합니다. 축적된 학습 기록이 함께 삭제되므로 경고가 표시됩니다.
3. **레거시 Impeccable 프로젝트 스킬 제거** — 과거 버전에서 프로젝트 레벨에 설치된 Impeccable이 있으면 제거 여부를 묻습니다 (현재 버전은 글로벌 설치).
4. **빈 `.claude/` 제거** — 위 과정 후 디렉터리가 비어 있으면 자동 삭제합니다.

### 제거되는 파일

| 경로 | 조건 |
|---|---|
| `<프로젝트>/CLAUDE.md` | 사용자 확인 시 |
| `<프로젝트>/.claude/teamace/` | 사용자 확인 시 (knowledge 포함) |
| `<프로젝트>/.claude/skills/` | 레거시 Impeccable이 있고, 사용자 확인 시 |
| `<프로젝트>/.claude/` | 위 과정 후 비어 있으면 자동 |

---

## 제거 — `uninstall.sh` / `teamace uninstall`

```bash
./uninstall.sh
# 또는
teamace uninstall
```

두 명령은 동일한 동작을 수행합니다. 글로벌 설치된 TeamAce를 완전히 제거합니다.

### 제거되는 파일

| 경로 | 내용 |
|---|---|
| `~/.claude/agents/{lead,pm,pub,fe,be,qa}.md` | 에이전트 정의 |
| `~/.claude/teamace/` | 전체 삭제 (skills, contracts, harness, core-principles, config, version) |
| `~/.claude/CLAUDE.md` | `<!-- TEAMACE:START -->` ~ `<!-- TEAMACE:END -->` 섹션 제거. 나머지 내용이 없으면 파일 삭제 |
| `~/.claude/settings.json` | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` 환경변수 제거 (다른 설정은 보존) |
| Impeccable 글로벌 스킬 | `~/.agents/skills/frontend-design/`, `~/.claude/commands/frontend-design/` 등 |
| `~/.local/bin/teamace` | CLI 실행 파일 |

> **참고**: 각 프로젝트의 `CLAUDE.md`와 `.claude/teamace/knowledge/`는 제거되지 않습니다. 프로젝트별 정리가 필요하면 해당 프로젝트에서 `teamace clean`을 실행하세요.

---

## CLI 명령어 요약

| 명령어 | 설명 |
|---|---|
| `teamace init [path]` | 프로젝트에 TeamAce 초기화 (knowledge 템플릿 + CLAUDE.md 생성) |
| `teamace clean [path]` | 프로젝트의 init 결과 정리 (knowledge + CLAUDE.md 제거) |
| `teamace status` | 글로벌 설치 상태 + 현재 프로젝트 상태 확인 |
| `teamace update` | 업데이트 안내 (git pull → install.sh 재실행) |
| `teamace uninstall` | 글로벌 제거 (`uninstall.sh`와 동일) |
| `teamace version` | 설치된 버전 출력 |
| `teamace help` | 도움말 |

---

## 디렉터리 구조

```
~/.claude/                              ← 글로벌 (범용)
├── agents/                             ← 에이전트 정의 (lead, pm, pub, fe, be, qa)
├── teamace/
│   ├── skills/{pm,pub,fe,be,qa}/       ← 에이전트별 스킬
│   ├── contracts/                      ← 에이전트 간 계약
│   ├── harness/                        ← 품질 하네스
│   ├── core-principles/                ← 핵심 원칙
│   ├── config/                         ← (예약)
│   └── version                         ← 설치 버전
├── CLAUDE.md                           ← TeamAce 글로벌 지침
└── settings.json                       ← Agent Team 실험 기능 + 권한 설정

~/.local/bin/
└── teamace                             ← CLI

<프로젝트>/                              ← 프로젝트 로컬 (프로젝트별 고유)
├── CLAUDE.md                           ← 프로젝트 정보 + 프로젝트별 규칙
└── .claude/teamace/
    └── knowledge/{pm,pub,fe,be,qa}.md  ← 에이전트별 핵심 교훈 (프로젝트 축적)
```

---

## Knowledge 기록 가이드

Knowledge 파일에는 **반복 활용 가능한 핵심 교훈만** 기록합니다. 산출물 이력이나 링크 목록은 기록하지 않습니다.

| 섹션 | 기록 내용 | 예시 |
|------|----------|------|
| 재사용 가능한 패턴 | 이 프로젝트에서 효과가 검증된 기술적 패턴, 설정, 구조 | "SSE 스트림 이벤트 계약은 `event:` 필드를 반드시 명시해야 클라이언트 파싱 오류 방지" |
| 실수와 회피 방법 | 실수했던 사항과 원인, 재발 방지를 위한 구체적 조치 | "Notion API block 제한(100개)을 초과하면 silent truncation 발생 → 배치 분할 필수" |
| 사용자 선호 | 사용자가 수정을 요청하여 반영한 스타일, 컨벤션, 판단 기준 | "컴포넌트 파일명은 PascalCase, 훅 파일명은 camelCase로 통일" |
