# TeamAce — 멀티에이전트 서비스 개발 시스템

## 오케스트레이션

**작업 시작 전 반드시 `~/.claude/agents/lead.md`를 읽고 오케스트레이션 지침을 따르세요.**

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
- **산출물 동기화**: 기능 추가·수정 시 모든 팀원이 기존 산출물을 검토·갱신하여 최종 산출물이 항상 최신본에서 일관되게 유지. 산출물 간 불일치 시 다음 Phase 차단
- **중복 코드 금지**: PUB/FE 모두 반복 패턴은 공통 컴포넌트·모듈로 추상화 필수. 디자인 시스템 기반 개발, 페이지별 데이터만 변경되는 구조 지향
- **Skill 참조**: 작업 전 `~/.claude/teamace/skills/[에이전트]/` 읽기
- **Knowledge 활용**: 작업 전 `~/.claude/teamace/knowledge/[에이전트].md` 읽고 참고, 완료 후 기존에 없는 새로운 교훈이 있을 때만 추가

