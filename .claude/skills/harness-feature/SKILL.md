---
name: harness-feature
description: |
  Pick exactly one feature (P2). From feature-list.json choose a single todo whose dependencies are resolved, isolate it on its own git branch, mark it in_progress, and write a start checkpoint. Enforces "one feature at a time" and branch isolation so parallel sessions never collide.
  Triggers (EN): next feature, pick a feature, start this feature, what should I work on
  Triggers (KO): 다음 기능, 기능 하나 고르자, 이거 작업 시작, 뭐부터 할까
  Do NOT use when: the Seed is not closed yet (-> socrates, intent gate first), verifying a built feature (-> harness-verify), or recording/committing (-> harness-record).
  vs harness: Harness orchestrates all phases; harness-feature is only the P2 select+isolate step.
---

# Harness Feature (P2)

한 번에 **딱 하나**의 기능만 연다 [L-P1, L-V2]. 그 기능을 전용 브랜치로 격리해, 동시 세션이 메타 파일·작업트리에서 충돌하지 않게 한다 [L-P2].

## Details
Seed가 닫힌 뒤(Intent Gate 통과)에만 진입한다 [L-I2]. 기능을 고르고 → 브랜치를 떼고 → `in_progress` 로 표시 → `progress.md` 에 시작 체크포인트. 개발(P3)은 이 단계가 아니다.

## State Contract
- 읽기: `SEED.md`(닫혔는지), `feature-list.json`(후보), `verification.json`(고른 기능이 속한 모듈의 검증 시나리오 존재 확인), `assets.json`(고유명이면 실존 자산 사용).
- 쓰기: `feature-list.json`(고른 기능 `status: todo→in_progress`, `evidence.branch` 기입), `progress.md`(시작 체크포인트), git(기능 브랜치 생성).

## Procedure
1. `SEED.md` 가 닫혔는지 확인. 안 닫혔으면 → "Intent Gate 먼저"(socrates)로 돌려보내고 중단.
2. `feature-list.json` 에서 `status: todo` 이고 `depends_on` 이 모두 `done` 인 기능을 후보로. **정확히 하나** 고른다(사용자에게 객관식 제시 가능, 임의 선택 금지).
3. 브랜치 격리: `scripts/new-feature.sh <id>` (없으면 `git switch -c feat/<id>`). 작업트리 dirty면 먼저 정리 안내.
4. 그 기능을 `in_progress` 로, `evidence.branch = feat/<id>` 기입.
5. `progress.md` 에 `YYYY-MM-DD | <id> | 시작 | 브랜치 feat/<id>` 체크포인트.

## Scope Gate
다음이 충족돼야 P3(개발)로 간다:
- 고른 기능이 **정확히 하나**다.
- 그 기능의 `depends_on` 이 모두 풀렸다(아니면 blocked로 두고 다른 기능 선택).
- 기능 브랜치로 분리됐다(main/타인 브랜치 위에서 개발 금지).
- `verification.json` 에 이 모듈의 검증 시나리오가 있다(없으면 먼저 추가).

미충족이면 그 항목을 명시하고 멈춘다.

## Safety Valve
- 기능이 너무 커서 한 세션에 안 끝날 것 같으면 `feature-list.json` 에서 **하위 기능으로 쪼갠 뒤** 다시 하나를 고른다.

## Output
```
[P2 Feature]
- 고른 기능: <id> <title> (module: <m>)
- 브랜치: feat/<id> (격리됨)
- feature-list: status → in_progress
- 게이트: Scope Gate 통과/미충족(사유)
- 다음: P3 개발
```
