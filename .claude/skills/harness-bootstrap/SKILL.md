---
name: harness-bootstrap
description: |
  Session start (P0). Read the harness context in dependency order, guard the git branch, and restore the previous session's handoff — so work begins from a known state without the human re-instructing. Writes nothing except the CLAUDE.md Reference File Dictionary.
  Triggers (EN): bootstrap, session start, start of session, resume work, what was I doing
  Triggers (KO): 부트스트랩, 세션 시작, 이어서, 어디까지 했지
  Do NOT use when: intent is not yet closed and needs a Seed (-> socrates / harness intent gate), picking a feature (-> harness-feature), or ending a session (-> harness-close).
  vs harness: Harness orchestrates all phases; harness-bootstrap is only the P0 read+guard step it calls first.
---

# Harness Bootstrap (P0)

세션을 "알아서 읽고 시작"하게 만드는 단계. 사람이 매번 "이 파일들 읽어"라고 지시하지 않아도, 단일 진입점에서 필요한 전부를 순서대로 끌어온다 [L-S2].

## Details

`CLAUDE.md`(자동 로드)가 이 단계를 호출한다. 컨텍스트를 읽고 브랜치를 점검한 뒤 `harness` 오케스트레이터의 P1으로 넘긴다. **새 작업 산출물을 만들지 않는다**(읽기 중심 + CLAUDE.md 사전 갱신만).

## State Contract

- 읽기(순서 고정): `deps.json` 의 `read_order` 를 그대로 따른다 — 기본값
  `AGENTS.md → AGENTS.local.md → SEED.md → assets.json → feature-list.json → verification.json → progress.md → handoff.md → reliability.md → clean-state-checklist.md`.
  "하나만 읽고 마는" 것 금지 — read_order 전체를 팬아웃한다.
- 쓰기: `CLAUDE.md` 의 **참조 파일 사전(Reference File Dictionary)** 만 갱신(로컬 전용, gitignore라 dirty 안 잡힘).
- `AGENTS.local.md` 가 없으면 아무것도 읽지 말고 셋업 안내 후 중단.

## Procedure

1. `AGENTS.local.md` 로 `owner`/`workspace` 식별. 없으면 → "셋업 필요" 출력(`cp AGENTS.local.md.template AGENTS.local.md` 후 기입), **중단**.
2. `deps.json.read_order` 순서대로 `<workspace>` 기준 파일을 읽는다. 누락 파일은 경고로 남기되 멈추지 않는다.
3. `CLAUDE.md` 참조 파일 사전을 본인 `workspace` 경로로 갱신.
4. **브랜치 가드** [L-S3, L-P2]:
   - 현재 브랜치 확인(`git branch --show-current`).
   - `main`/`master` 이거나 타인 작업 브랜치면 → "기능 브랜치 분리 필요"를 경고하고 P2(`harness-feature`)에서 분리하도록 표시. 분리 전 코드 수정 시작 금지.
   - 작업트리가 dirty면 그 사실을 보고(이전 세션 미정리 가능성).
5. `handoff.md` 를 읽어 "지금 상태 / 다음 할 일 / 막힌 것 / 현재 브랜치"를 복원해 보고.

## Bootstrap Gate

다음이 충족돼야 P1으로 넘어간다:
- `owner`/`workspace` 식별됨.
- read_order의 핵심 파일(`AGENTS.md`, `feature-list.json`, `SEED.md`)을 읽음.
- 현재 브랜치 상태가 파악됨(가드 통과 또는 "분리 필요" 표시).

미충족이면 그 항목을 명시하고 멈춘다(추측으로 진행 금지).

## Output

```
[P0 Bootstrap]
- owner / workspace: ...
- 읽음: <read_order에서 실제로 읽은 파일들>
- 브랜치: <현재 브랜치> (가드: 통과 / 분리 필요)
- 이어받기(handoff): 지금 상태 / 다음 할 일 / 막힌 것
- 다음: P1 Intent Gate (socrates) — 또는 SEED가 이미 닫혔으면 P2
```
