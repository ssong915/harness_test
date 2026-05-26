# Harness Intent Plan

## Purpose
의도를 계약으로 닫는 게이트(P1). socrates를 재사용해 Seed를 만들고, 그 결과를 SEED.md로 브리지하고, 고유명을 assets.json과 대조해 정체성 계약을 강제한다.

## Success Criteria
- socrates의 `## Seed` YAML을 SEED.md의 goal/constraints/acceptance_criteria로 옮긴다.
- 모든 고유명을 assets.json과 대조(실존 사용 / 신규 명시).
- 세 칸이 다 차고 고유명이 해소돼야 P2로 넘긴다.
- socrates(vendored)는 수정하지 않는다(frozen). 보완은 이 스킬에 누적.

## Boundaries
- 의미 좁히기·Seed 생성을 직접 하지 않는다 → socrates(+ ontology/evolve-step).
- 기능을 고르지 않는다 → harness-feature.
- 배경 자료로 고유명을 진짜라고 단정하지 않는다(Context≠Contract).
