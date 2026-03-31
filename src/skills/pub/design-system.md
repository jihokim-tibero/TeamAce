# 디자인 시스템 코드화 Skill

## 목적
프로젝트의 디자인 토큰과 공유 UI 컴포넌트를 코드로 구축한다. Impeccable 스킬의 디자인 원칙을 TeamAce의 코드 구조에 맞게 적용한다.

## 전제 조건
- Impeccable 스킬이 프로젝트에 설치되어 있어야 함 (`.claude/skills/`)
- Impeccable 레퍼런스 파일을 디자인 판단의 근거로 활용

## 트리거
- 새 프로젝트 시작 시 (디자인 시스템 초기 구축)
- 기존 디자인 시스템 변경/확장 요청

## 입력
- 브랜드 가이드라인 (있는 경우)
- 기존 디자인 시스템 (있는 경우)
- Impeccable 레퍼런스: `typography.md`, `color-and-contrast.md`, `spatial-design.md`, `motion-design.md`

## 절차

### 1. Impeccable 레퍼런스 확인

디자인 토큰 정의 전, 프로젝트의 `.claude/skills/` 내 Impeccable 레퍼런스를 읽고 원칙 파악:
- `color-and-contrast.md` → OKLCH 팔레트 구성 원칙
- `typography.md` → 서체 선택·스케일 기준
- `spatial-design.md` → 간격·그리드 체계
- `motion-design.md` → 트랜지션 원칙

### 2. 디자인 토큰 CSS 변수 정의 (`styles/tokens.css`)

```css
:root {
  /* 색상 — OKLCH 기반 (Impeccable color-and-contrast.md 준수) */
  --color-primary-50: oklch(0.97 0.02 250);
  --color-primary-500: oklch(0.55 0.15 250);
  --color-primary-900: oklch(0.25 0.08 250);
  /* Gray — 순수 검정 금지, 컬러 틴트 (Impeccable 안티패턴) */
  --color-gray-50: oklch(0.97 0.005 250);
  --color-gray-900: oklch(0.15 0.01 250);
  /* Semantic */
  --color-error: oklch(0.55 0.2 25);
  --color-success: oklch(0.65 0.2 145);
  --color-warning: oklch(0.75 0.15 85);

  /* 타이포그래피 (Impeccable typography.md 준수) */
  --font-sans: '[의도적 선택 서체]', system-ui, sans-serif;
  --font-mono: '[의도적 선택 서체]', ui-monospace, monospace;
  --text-xs: 0.75rem;    /* 12px */
  --text-sm: 0.875rem;   /* 14px */
  --text-base: 1rem;     /* 16px */
  --text-lg: 1.125rem;   /* 18px */
  --text-xl: 1.25rem;    /* 20px */
  --text-2xl: 1.5rem;    /* 24px */
  --text-3xl: 1.875rem;  /* 30px */

  /* 간격 — 4px base (Impeccable spatial-design.md 준수) */
  --space-1: 0.25rem;  /* 4px */
  --space-2: 0.5rem;   /* 8px */
  --space-3: 0.75rem;  /* 12px */
  --space-4: 1rem;     /* 16px */
  --space-5: 1.25rem;  /* 20px */
  --space-6: 1.5rem;   /* 24px */
  --space-8: 2rem;     /* 32px */
  --space-10: 2.5rem;  /* 40px */
  --space-12: 3rem;    /* 48px */
  --space-16: 4rem;    /* 64px */

  /* 반경 */
  --radius-none: 0;
  --radius-sm: 0.25rem;
  --radius-md: 0.5rem;
  --radius-lg: 0.75rem;
  --radius-xl: 1rem;
  --radius-full: 9999px;

  /* 그림자 — 의미 있는 elevation만 (Impeccable 안티패턴) */
  --shadow-sm: 0 1px 2px oklch(0.15 0.01 250 / 0.05);
  --shadow-md: 0 4px 6px oklch(0.15 0.01 250 / 0.07);
  --shadow-lg: 0 10px 15px oklch(0.15 0.01 250 / 0.1);

  /* 트랜지션 (Impeccable motion-design.md 준수) */
  --duration-fast: 150ms;
  --duration-normal: 250ms;
  --duration-slow: 350ms;
  --easing-default: cubic-bezier(0.4, 0, 0.2, 1);
}

@media (prefers-reduced-motion: reduce) {
  :root {
    --duration-fast: 0ms;
    --duration-normal: 0ms;
    --duration-slow: 0ms;
  }
}
```

### 3. 공유 UI 컴포넌트 구현 (`shared/ui/`)
- Button (variant: primary/secondary/ghost/danger, size: sm/md/lg)
- Input (type: text/email/password/search, 상태: idle/focus/error/disabled)
- Card (elevation 기반, 카드 중첩 금지)
- Badge, Tag, Avatar, Spinner, Skeleton
- 각 컴포넌트에 data-testid, ARIA 필수

### 4. Tailwind config 확장
- tokens.css 변수를 Tailwind theme으로 매핑
- 커스텀 유틸리티 클래스 정의

### 5. Impeccable 검증
- `/colorize` 커맨드로 색상 체계 검증
- `/typeset` 커맨드로 타이포그래피 검증
- `/audit` 커맨드로 전체 디자인 시스템 품질 확인

## 출력 형식
```
src/
├── styles/
│   └── tokens.css
├── shared/
│   └── ui/
│       ├── Button.tsx
│       ├── Input.tsx
│       ├── Card.tsx
│       └── index.ts (barrel export)
└── tailwind.config.ts (확장)
```

## 품질 체크리스트
- [ ] Impeccable 레퍼런스 4개 파일 읽기 완료
- [ ] OKLCH 색상 체계 사용 (hex/rgb 금지)
- [ ] WCAG AA 색 대비 기준 충족
- [ ] 타이포그래피 스케일 7단계 이상
- [ ] 간격 스케일 10단계 이상
- [ ] 반경 스케일 6단계 이상
- [ ] prefers-reduced-motion 대응
- [ ] 공유 UI 컴포넌트에 data-testid + ARIA
- [ ] Impeccable 안티패턴 전체 준수
- [ ] `/colorize` + `/typeset` + `/audit` 검증 완료

## 안티패턴
- Impeccable 레퍼런스를 읽지 않고 임의로 토큰 정의
- Inter를 기본 서체로 사용
- #000000 순수 검정 사용
- hex/rgb 색상값 사용 (OKLCH 대신)
- WCAG 대비 미검증
- prefers-reduced-motion 미대응
- 그림자를 장식용으로 남발
