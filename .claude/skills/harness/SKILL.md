---
name: harness
description: |
  Orchestrate a harness-driven development session as a phase loop: bootstrap → intent gate → pick one feature → develop → verify → record → commit → clean-state close. Calls sub-skills in order and checks the gate between phases. Does not reimplement them. State lives in the repo's harness files (SEED.md, feature-list.json, progress.md, handoff.md), not in chat.
  Triggers (EN): harness, run harness, start session, next feature, end session, close session
  Triggers (KO): 하네스, 세션 시작, 다음 기능, 세션 종료, 마무리
  Do NOT use when: only closing a vague request into a Seed (-> socrates), only reviewing Seed blind spots (-> evolve-step), or the repo has no AGENTS.md + feature-list.json (not a harness repo yet -> run scripts/init.sh first).
  vs socrates: Socrates closes intent into a Seed (Part 1); Harness runs the full execution lifecycle (Part 2) and calls Socrates for its intent phase.
---

# Harness (orchestrator)

확률적 LLM을 결정론적으로 부리는 실행 하네스(Part 2)의 세션 구동기. 라이프사이클을 phase로 강제하고, 각 phase는 전용 서브스킬에 위임한다. 직접 구현하지 않고 **호출 + 게이트 점검**만 한다 (socrates가 wonder/reflect/…를 부르는 것과 같은 패턴).

## Details

진입점은 `CLAUDE.md`(자동 로드) → 이 스킬. phase 순서대로 서브스킬을 호출하고, 각 게이트가 닫혀야 다음 phase로 간다.

| phase | 위임 대상 | 한 줄 |
|---|---|---|
| P0 | `harness-bootstrap` | 컨텍스트 자동 읽기·브랜치 가드·handoff 복원 |
| P1 | `harness-intent` (→ vendored `socrates`) | 의도를 Seed로 닫고 SEED.md로 브리지 + 정체성 게이트 |
| P2 | `harness-feature` | 기능 1개 선택 + 브랜치 격리 |
| P3 | (일반 코딩) | 최소·안전 구현 |
| P4 | `harness-verify` | 모듈 검증, 사람 판정 |
| P5 | `harness-record` | md/json 기록 + 잔존 정리 + 커밋 |
| P7 | `harness-close` | clean-state 종료·handoff 정리 |

## State Contract

상태는 채팅이 아니라 **repo 파일**에 산다(System of Record). 이 스킬이 phase 간에 읽고/쓰는 정본:

- 읽기: `AGENTS.md`, `AGENTS.local.md`, `deps.json`(read_order), `SEED.md`, `assets.json`, `feature-list.json`, `verification.json`, `handoff.md`
- 쓰기(서브스킬 통해): `SEED.md`(P1), `feature-list.json`·`progress.md`·`handoff.md`(P5), git(P5/P6)
- P1 브리지는 `harness-intent` 가 담당: `socrates` 산출(`.symposium/scratch/socrates.md` 의 `## Seed`)을 **`SEED.md`** 로 옮기고 `assets.json` 과 정체성을 대조한다. 이후 Part 2는 `SEED.md` 만 입력으로 본다.

## Session Gates

phase 사이에서 점검. 닫히지 않으면 다음으로 가지 않는다.

- **Intent Gate (P1→P2)**: `SEED.md` 의 goal·constraints·acceptance_criteria 가 다 찼는가? 고유명이 `assets.json` 의 실존 자산과 대조됐는가(동명 가짜 금지)? 아니면 `socrates` 로 되돌아간다. *Seed가 닫히기 전엔 개발(P2~) 금지.*
- **Scope Gate (P2)**: 고른 기능이 정확히 하나인가? 의존(`depends_on`)이 풀렸는가? 기능 브랜치로 분리됐는가?
- **Verify Gate (P4→P5)**: 모듈 검증이 통과했는가? `e2e_verified` 는 사람이 마킹했는가(에이전트 자기 선언 금지)? 아니면 P3로.
- **Clean Gate (P7)**: `clean-state-checklist.md` 가 다 체크됐는가? `handoff.md` 만으로 다음 세션이 이어받을 수 있는가?

## Safety Valve

- 한 세션 = 한 기능을 원칙으로 한다. 한 기능이 너무 커지면 `feature-list.json` 에서 쪼갠다(P2로 되돌림).
- 어느 게이트도 사람의 명시 확인 없이 "통과"로 강제하지 않는다(특히 Verify Gate).

## Output

각 phase마다:
1. 현재 phase + 호출한 서브스킬 + 한 일
2. 읽은 파일 / 갱신한 파일
3. 게이트 상태(닫힘/열림, 미충족 시 무엇이 필요한지)
4. 다음 phase 또는 사람이 결정할 것

## Constraints

1. 응답 언어 한국어, 코드·주석 영어.
2. workspace 스코프 밖(타인 `devs/<X>/`) 미접근.
3. Intent Gate 전 개발 금지. 세션 종료(P7) 생략 금지.
4. 완료 판정은 사람.
