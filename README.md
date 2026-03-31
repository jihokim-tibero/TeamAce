# TeamAce

**멀티에이전트 서비스 개발 시스템** — Claude Code 위에서 동작하는 5-에이전트 오케스트레이션 프레임워크

PM(기획) → PUB(퍼블리싱) + BE(백엔드) → FE(프론트엔드) → QA(검증) 파이프라인을 자동화합니다.

## 설치

```bash
git clone <TeamAce-repo-url>
cd TeamAce
./install.sh
```

설치 후 다음이 세팅됩니다:

| 항목 | 위치 | 설명 |
|------|------|------|
| 에이전트 정의 | `~/.claude/agents/` | lead, pm, pub, fe, be, qa |
| 스킬·계약·하네스 | `~/.claude/teamace/` | 워크플로우 스킬, 핸드오프 계약, 품질 게이트 |
| 글로벌 지침 | `~/.claude/CLAUDE.md` | TeamAce 오케스트레이션 섹션 추가 |
| CLI | `~/.local/bin/teamace` | 프로젝트 초기화·상태 확인 |

## 프로젝트 초기화

각 프로젝트 디렉터리에서 한 번 실행:

```bash
cd ~/my-project
teamace init
```

이 명령은 다음을 수행합니다:
- **Impeccable 디자인 스킬** 설치 (`npx skills add pbakaus/impeccable`)
- 프로젝트 **CLAUDE.md** 생성 (TeamAce 참조 포함)
- Git 플랫폼(GitHub/GitLab) 자동 감지

## 사용법

프로젝트 디렉터리에서 Claude Code를 실행하면 TeamAce가 자동 인식됩니다:

```bash
cd ~/my-project
claude
```

Claude Code에서 작업을 요청하면 Lead 에이전트가 태스크를 분해하고 적절한 에이전트를 호출합니다.

## 에이전트 구성

| 에이전트 | 역할 | 핵심 산출물 |
|---------|------|-----------|
| **PM** | 데이터 드리븐 기획 | PRD, 기능정의서 |
| **PUB** | Impeccable 기반 퍼블리셔 | View 컴포넌트(TSX), 디자인 토큰, View 명세 |
| **FE** | 로우레벨 프론트엔드 | Hooks, Container, 데이터 트랜스폼, 테스트 |
| **BE** | 백엔드 구현 | API, DB 스키마, 관측성 |
| **QA** | 리스크 기반 테스트 | 테스트 시나리오, 회귀 스위트, 버그 리포트 |

### PUB ↔ FE 역할 분리

프론트엔드를 **View(프레젠테이션)**와 **Logic(비즈니스)**으로 명확히 분리합니다:

- **PUB**: `views/`, `shared/ui/`, `tokens.css` — 코드가 곧 시안
- **FE**: `hooks/`, `components/`, `types/`, `providers/` — API 연동, 상태 관리, 성능

## 파이프라인

```
Phase 1: 기획
  PM → PRD + 기능정의서

Phase 2: 설계·퍼블리싱 (병렬)
  PUB → View 코드 + 디자인 토큰
  BE  → API 명세 + 구현

Phase 3: 구현
  FE ← PUB View + BE API → Hooks + Container + 테스트

Phase 4: 검증
  QA → 테스트 시나리오 + 회귀 테스트 + 버그 리포트
  → No-Go 시 수정 루프 (최대 3회)
```

## 품질 보증

- **품질 게이트**: 각 Phase 완료 시 측정 가능한 기준으로 자동 검증
- **하네스 원칙**: 어떤 모델, 어떤 컨텍스트에서도 동일한 품질
- **회귀 방지**: "되던 건 무조건 되게" — 기존 기능 회귀 불허
- **Impeccable 안티패턴**: 8개 필수 금지 항목으로 "뻔한 AI UI" 탈피

## 의존성

| 도구 | 용도 | 필수 |
|------|------|------|
| [Claude Code](https://docs.claude.com) | AI 에이전트 실행 환경 | ✓ |
| [Impeccable](https://github.com/pbakaus/impeccable) | 디자인 스킬 (프로젝트별) | ✓ (PUB) |
| `gh` CLI | GitHub PR/Issue 관리 | GitHub 사용 시 |
| `glab` CLI | GitLab MR/Issue 관리 | GitLab 사용 시 |
| Notion MCP | 문서 산출물 관리 | GitHub 프로젝트 시 |

## CLI 명령어

```bash
teamace init [path]   # 프로젝트 초기화 (Impeccable + CLAUDE.md)
teamace status        # 설치 상태 + 현재 프로젝트 상태 확인
teamace update        # 업데이트 안내
teamace uninstall     # 완전 제거
teamace version       # 버전 확인
teamace help          # 도움말
```

## 디렉터리 구조

```
TeamAce/                          ← 이 리포지토리
├── install.sh                    ← 글로벌 설치
├── uninstall.sh                  ← 제거
├── bin/teamace                   ← CLI
├── src/
│   ├── claude-md/teamace.md      ← → ~/.claude/CLAUDE.md에 추가
│   ├── agents/                   ← → ~/.claude/agents/
│   │   ├── lead.md               ←   오케스트레이터
│   │   ├── pm.md                 ←   PM 에이전트
│   │   ├── pub.md                ←   PUB 에이전트
│   │   ├── fe.md                 ←   FE 에이전트
│   │   ├── be.md                 ←   BE 에이전트
│   │   └── qa.md                 ←   QA 에이전트
│   ├── skills/                   ← → ~/.claude/teamace/skills/
│   │   ├── pm/                   ←   기획 스킬
│   │   ├── pub/                  ←   퍼블리싱 스킬
│   │   ├── fe/                   ←   프론트엔드 스킬
│   │   ├── be/                   ←   백엔드 스킬
│   │   └── qa/                   ←   QA 스킬
│   ├── knowledge/                ← → ~/.claude/teamace/knowledge/
│   ├── contracts/                ← → ~/.claude/teamace/contracts/
│   ├── harness/                  ← → ~/.claude/teamace/harness/
│   └── config/settings.json      ← → ~/.claude/settings.json (병합)
└── README.md
```

## 제거

```bash
teamace uninstall
# 또는
./uninstall.sh
```

프로젝트별 Impeccable 스킬(`.claude/skills/`)과 CLAUDE.md는 수동 제거 필요.

## 라이선스

(라이선스 기입)
