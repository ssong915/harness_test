---
name: harness-intent
description: |
  Intent gate (P1). Close the Seed for this harness by running the vendored socrates loop, then bridge its output into the repo's SEED.md and reconcile every proper noun against assets.json (use the real asset; forbid same-named custom rebuilds). Development does not start until this gate passes. This is the extension point where scenario1 lesson supplements accumulate — socrates stays frozen.
  Triggers (EN): intent gate, close the seed, lock intent, what are we actually building
  Triggers (KO): 의도 닫기, 시드 닫아, 뭘 만들지 확정, 의도 게이트
  Do NOT use when: only expanding/clarifying meaning without harness wiring (-> socrates directly), or the Seed is already closed and you are picking a feature (-> harness-feature).
  vs socrates: socrates produces the canonical Seed in .symposium/scratch/socrates.md; harness-intent adapts it into SEED.md, enforces the identity contract against assets.json, and is where lesson-driven supplements live.
---

# Harness Intent (P1)

개발에 들어가기 전 **의도를 계약으로 닫는** 게이트 [L-I1, L-I2]. Part 1은 vendored `socrates` 를 그대로 재사용하고, 이 스킬은 그 산출(Seed)을 하네스의 `SEED.md` 로 옮기고 **정체성 계약**을 강제한다. 닫히기 전엔 P2로 가지 않는다.

## Details
- 의미 좁히기·Seed 생성은 `socrates`(+ 필요 시 `ontology`/`evolve-step`)에 위임한다 — **socrates 내부는 건드리지 않는다(frozen, vendored @1fdf881).**
- 이 스킬의 고유 책임 = **브리지 + 정체성 게이트 + 레슨 보완**. scenario1에서 아쉬웠던 점(L-I1: 동명 가짜)을 막는 추가 검사는 *여기에* 누적한다.

## Symposium 유지 vs 여기서 보완 (갭 분석)
의미·의도 닫기는 Symposium이 이미 충분히 한다 — **중복 구현 금지, 그대로 재사용**:
- 의미 확장·차이·합의·재진술 → `wonder`/`reflect`/`refine`/`restate`
- Seed 닫기(goal·constraints·acceptance_criteria) + Seed Gate → `socrates`
- 의미 경계 → `ontology` · 사각지대 → `evolve-step` · 수렴 → `interview-harness`

Symposium이 **안 보는** 것만 이 스킬이 보완한다 — 모두 한 교훈(scenario1 L-I1)의 두 면:
- **정체성 계약** — 고유명이 *실존하는 그것*인지 `assets.json` 과 대조. 동명 가짜 구현 금지, 보유 자산 재사용 강제(새로 만들지 말 것).
- **계약으로 검증(Context≠Contract)** — 자칭("이름이 맞다고 답함")이나 배경 자료의 양은 근거가 아니다(Q11-12). 실존 연결 증거(`ref` 도달·`use` 절차)를 요구한다.

> 새 보완을 더하기 전 항상 "이게 Symposium에 이미 있나?"를 먼저 확인한다 — 있으면 그쪽을 쓰고 여기엔 추가하지 않는다.

## State Contract
- 읽기: `.symposium/scratch/socrates.md`(socrates가 쓴 `## Seed` YAML), `assets.json`(실존 자산), `SEED.md`(기존 값).
- 쓰기: `SEED.md` 의 `## goal` / `## constraints` / `## acceptance_criteria` / `## 핵심 명사 / 정체성 점검` 표.
- 비파괴: socrates의 scratch는 읽기만(수정 안 함).

## Procedure
1. `.symposium/scratch/socrates.md` 에 닫힌 `## Seed` 가 있는지 확인. 없으면 → `socrates` 를 먼저 돌리도록 위임(Seed 생성).
2. Seed YAML(goal/constraints/acceptance_criteria)을 파싱해 `SEED.md` 의 해당 섹션에 매핑(기존 값은 덮어쓰되 이력은 남기지 않음 — 단일 진실).
3. **정체성 게이트 [L-I1]**: goal/constraints에 등장하는 고유명(서비스·제품·에이전트 이름)을 모두 추출 → 각각을 `assets.json` 과 대조.
   - 실존 자산이면: `SEED.md` 핵심 명사 표에 그 asset id를 적고, acceptance_criteria에 "실존 자산 `<id>` 사용, 동명 가짜 구현 금지"를 추가. **자칭은 통과 근거가 아니다(Q11-12)** — `assets.json` 의 `ref`(이미지/레포/엔드포인트)가 실제로 도달 가능한지, `use`(기동 절차)가 있는지 *연결 증거*를 확인한다. "물어보면 이름이 맞다고 답한다"만으론 불충분.
   - 자산이 없으면: 사람에게 "(a) 신규 구현 / (b) 실존 자산을 assets.json에 등록" 을 묻는다. 배경 자료가 많다고 진짜라고 단정하지 않는다(Context≠Contract).
4. `SEED.md` 의 세 칸이 다 찼고 모든 고유명이 해소됐는지 확인.

## Intent Gate
P2(feature)로 가려면:
- `SEED.md` 의 goal·constraints·acceptance_criteria 가 모두 채워짐(socrates의 `empty` 잔존 없음).
- 모든 고유명이 `assets.json` 과 대조돼 처리됨 — 실존이면 **연결 증거(ref 도달·use 절차) 확인**(자칭만으론 불통과), 신규면 명시.
미충족이면 그 항목을 명시하고 socrates 또는 사용자 확인으로 되돌린다. **개발 시작 금지.**

## Extension Point (레슨 보완 누적 — 갭-테스트 필수)
socrates는 얼린 채로 두고(vendored @1fdf881), 새 교훈은 이 스킬에 더한다. **추가 전 갭-테스트**: "이미 Symposium이 하나?" → 하면 그쪽을 쓰고 여기엔 안 더한다. 안 하는 빈틈만 보완한다.
- 후보(미반영): 보유 자산 우선순위 규칙, 금지 명사 목록, 도메인별 정체성 체크리스트 등.
- 반영됨: 정체성 게이트(자칭 불충분 → 연결 증거), assets.json 대조, Context≠Contract.

## Output
```
[P1 Intent]
- socrates Seed: 닫힘/미닫힘
- SEED.md: goal / constraints(n) / acceptance_criteria(n) 기입
- 정체성: <고유명> → <asset id 사용 / 신규 / 사람 확인 대기>
- 게이트: 통과 → P2 / 미충족(사유) → socrates·사용자 확인
```
