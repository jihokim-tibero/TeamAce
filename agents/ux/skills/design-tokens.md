# 디자인 토큰 정의 Skill

## 목적
프로젝트의 시각적 일관성을 위한 디자인 토큰 체계를 정의한다.

## 트리거
- 새 프로젝트 UX 설계 시작
- 디자인 시스템 변경 시

## 입력
- 브랜드 가이드라인 (있는 경우)
- 기존 디자인 시스템 (있는 경우)

## 절차
1. 색상 팔레트 정의:
   - Primary: 50~900 (10단계)
   - Gray: 50~900
   - Error/Danger: 주색 + 배경
   - Success: 주색 + 배경
   - Warning: 주색 + 배경
2. 타이포그래피 스케일:
   - Display / Heading 1-4 / Body / Caption / Label
   - font-family, font-size, line-height, font-weight
3. 간격(Spacing) 스케일: 4px base (4/8/12/16/20/24/32/40/48/64)
4. 반경(Border Radius) 스케일: none/sm/md/lg/full
5. 그림자(Shadow) 스케일: sm/md/lg (선택)

## 출력 형식
테이블 또는 CSS 변수 형태

## 품질 체크리스트
- [ ] Primary/Gray/Error/Success 색상 최소 정의
- [ ] WCAG AA 색 대비 기준 충족
- [ ] 타이포그래피 스케일 6단계 이상
- [ ] 간격 스케일 8단계 이상
- [ ] 반경 스케일 4단계 이상

## 안티패턴
- 색상을 hex 값만 나열하고 용도 미명시
- WCAG 대비 기준 미확인
