# AGENTS.md (공통 운영 규칙)

이 repo에서 하네스(에이전트)를 돌릴 때의 공통 규칙. 라이프사이클은 `harness` 스킬(`.claude/skills/harness/SKILL.md`)을 따르고, 이 파일은 그 규칙의 근거를 담는다.

## 정체성 — 나는 누구이고 어디서 일하는가

- 세션은 **repo 루트에서 시작**한다. 자동 로드는 `CLAUDE.md`(→ `AGENTS.md` + `AGENTS.local.md`)뿐이다.
- `AGENTS.local.md` 로 `owner` 와 `workspace` 를 식별한다. 없으면 셋업 안내 후 중단.
- **단일 개발자(기본)**: `workspace` = repo 루트. 산출물(`progress.md`·`handoff.md`·`feature-list.json` 등)이 루트에 있다.
- **멀티 개발자(옵션)**: `workspace` = `devs/<owner>/`. 산출물은 본인 폴더 안에서만 갱신하고, 다른 `devs/<X>/` 는 읽기·수정 금지(인계는 본인 `handoff.md` 로).

## 읽기 순서 — 단일 진입점에서 팬아웃 [L-S2]

- 파일 간 의존은 암묵적이므로 `deps.json` 에 **읽는 순서(read_order)와 의존(edges)** 을 명시한다.
- 세션 시작 시 "하나만 읽고 마는" 것을 금지 — `read_order` 를 따라 필요한 전부를 끌어온다.
- 한 파일을 고치면 `deps.json` 의 edge로 **함께 갱신할 파일**을 찾아 동기화하고, 완료된 항목과 모순되는 **잔존 기록을 정리**한다(중복·stale → 충돌·환각 방지).

## 상태는 하나의 진실 [L-S1]

- 작업 상태의 단일 진실은 `feature-list.json`(+ `progress.md`). 같은 정보를 표현하는 **중복 추적 파일을 만들지 않는다**. 요약 메타가 1:N을 못 담으면 진실을 손상시킨다.

## 브랜치·격리·권한 [L-P1, L-P2, L-S3]

- **기능 = 브랜치 = 세션** 1:1. `scripts/new-feature.sh <id>` 로 기능 브랜치를 떼고, 머지 후 **브랜치를 삭제**한다.
- 격리가 돼 있으면 git이 꼬여도 브랜치 단위로 폐기 가능 → **git 권한을 넉넉히 줘도 안전**(deny/ask 병목 회피).
- 브랜치 미설정 상태로 작업 시작 금지(타인 브랜치 오염 방지). 메타 파일은 가능하면 worktree/세션별로 분리해 동시 세션 충돌을 막는다.

## 검증 — 완료는 사람이 판정 [L-V1, L-V2]

- 기능 단위는 유닛테스트, **모듈 단위는 `verification.json` 의 시나리오로 한 번에 e2e**. 검증 기준은 `feature-list.json` 이 아니라 `verification.json` 에 둔다(관심사 분리).
- `e2e_verified` 는 **사람만** 마킹. 에이전트의 "다 됐다" 자기 선언 금지. 검증 본체는 mockup이 아니라 **실 실행**.

## 세션 라이프사이클 [L-L1, L-O2]

- 모든 세션은 **clean state로 끝난다**(`clean-state-checklist.md`). scratch/tmp는 반영 후 삭제(`harness/tmp/` 예외).
- 인계는 임시 파일(`NEXT_SESSION.md` 등) 금지 — 정규 파일(`progress.md`·`handoff.md`·`feature-list.json`)에만.
- 관측성: 세션에서 실제 읽고/쓴 산출물을 `progress.md` 에 남겨 안 쓰이는 하네스 파일이 쌓이지 않게 한다.

## 의도 우선 [L-I1, L-I2]

- **기획(Seed)이 닫히기 전엔 개발하지 않는다.** `SEED.md` 의 goal·constraints·acceptance_criteria 가 차야 실행에 들어간다.
- 고유명(서비스·제품·에이전트 이름)은 `assets.json` 의 실존 자산과 대조 — **이름만 같은 커스텀 구현 금지**. 배경 자료가 많다고 진짜로 단정하지 않는다.

## 커밋 규칙

- prefix: `feat/fix/refactor/docs/chore(<scope>):`. 한 커밋 = 한 기능/한 영역.
- `.env`·secret 커밋 금지.

## 금기

- workspace 스코프 밖(특히 타인 `devs/<X>/`) 직접 수정.
- 의도 미확정 상태에서 개발 착수.
- 자기 검증 통과 선언 / mock으로 완료 판정.
