# View 명세 작성·발행 Skill

## 목적
PUB가 구현한 View 컴포넌트의 **계약**(props·state·a11y·디자인 결정)을 문서화하여 FE·QA·후속 PUB 작업이 추측 없이 진행되도록 한다. 코드 자체가 시안이지만, "왜 이렇게 만들었나"는 명세로 고정한다.

- GitHub → Notion (Notion MCP)
- GitLab → Git Wiki (`glab api`)

## 트리거
- 새 View 컴포넌트 구현 완료 시
- 기존 View의 props·state가 변경될 때
- Impeccable `/audit` + `/polish` 통과 직후(스펙을 확정 시점으로 박제)

## 입력
- 구현 완료된 View 컴포넌트(TSX)
- PM 기획서/기능 명세서 해당 섹션
- design tokens (`styles/tokens.css`)

## 출력 템플릿 (Wiki/Notion 페이지)

```markdown
# View: [ViewName]

## 목적
(한 문단: 어떤 사용자 시나리오의 어떤 단계에서 보이는 View인가)

## 위치
- 코드: `features/[domain]/views/[ViewName].tsx`
- Storybook: (있으면)

## Props
| 이름 | 타입 | 필수 | 기본값 | 설명 |
|------|------|------|--------|------|
| items | `Item[]` | ✓ | — | 표시할 항목 |
| onSelect | `(id: string) => void` | ✓ | — | 항목 선택 콜백 |
| ... | | | | |

**금지**: `any`, 넓은 object. 모든 props는 좁은 타입.

## 5-state 동작
| 상태 | 트리거 | UI | 사용자 액션 |
|------|--------|----|-----------|
| idle | 초기 | 안내 문구 + CTA | CTA 클릭 |
| loading | fetch 중 | 스켈레톤 | 없음(비활성화) |
| success | 데이터 1+ | 리스트 | 선택/필터 |
| empty | 데이터 0 | 빈 상태 일러스트 + 재시도 | 재시도/생성 |
| error | 예외 | 에러 메시지 + 재시도 | 재시도/지원 문의 |

## 디자인 결정
- 색: `--color-surface-1`(OKLCH) — Tailwind `bg-surface-1`로 사용
- 타이포: `--font-display` (제목) / `--font-body` (본문)
- 간격: 기본 `space-y-4`, 카드 내부 `p-6`
- **왜**: (선택 이유를 한두 줄. 예: 상위 대시보드와 표면 위계 일치)

## data-testid
| 요소 | testid |
|------|--------|
| 루트 | `[viewname]-root` |
| 리스트 아이템 | `[viewname]-item-[id]` |
| 빈 상태 CTA | `[viewname]-empty-cta` |
| 에러 재시도 | `[viewname]-error-retry` |

## 접근성 (a11y)
- 역할/레이블: (ARIA role + label)
- 키보드: Tab 순서, Enter/Space 트리거, Esc 닫기
- 명암비: text/bg AA 이상
- 스크린리더: `aria-live` 사용처 명시

## 제약 / 알려진 이슈
- (있으면: 예 "가상 스크롤 미도입 — 1k+ 항목 시 FE에서 페이지네이션 필요")

## 관련
- PM 명세: [링크]
- BE API (있으면): [링크]
```

## 절차
1. View 구현 완료 + `/audit` + `/polish` 통과 확인
2. 위 템플릿을 채운 Markdown 작성
3. 플랫폼 감지 후 발행:
   - GitLab:
     ```bash
     PROJ=$(git remote get-url origin | sed -E 's#.+[:/](.+/.+)(\.git)?$#\1#' | sed 's|/|%2F|g')
     glab api "projects/$PROJ/wikis" --method POST \
       -f title="Views/[ViewName]" \
       -f content="$(cat view-spec.md)" -f format="markdown"
     ```
   - GitHub: Notion MCP `create-pages`
4. MR 본문에 Wiki URL 포함
5. FE에 핸드오프: `[PUB→FE] View 완료: <Wiki URL> / testid: [...]`

## 품질 체크리스트
- [ ] Props 테이블 빠짐 없음 (any 금지)
- [ ] 5-state 전체 테이블 채움
- [ ] data-testid 전부 기록
- [ ] a11y 섹션 실제 키보드/스크린리더 동작 반영
- [ ] 디자인 결정에 **왜** 한 줄 이상
- [ ] Wiki/Notion URL을 MR 본문과 FE 핸드오프에 포함

## 안티패턴
- 구현만 하고 Wiki 발행 누락 → FE가 testid/상태를 코드만 보고 추측
- "디자인 결정" 섹션에 결과만 적고 이유 생략
- props 표에 `any`/`object`
- 에러/empty 상태를 빠뜨린 불완전한 5-state 표
- 변경 후 Wiki 갱신을 잊어 Wiki ↔ 코드 드리프트
