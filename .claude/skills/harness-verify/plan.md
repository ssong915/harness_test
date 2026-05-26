# Harness Verify Plan

## Purpose
빌드한 기능/모듈을 verification.json 기준으로 검증하되, 완료 판정은 사람이 하게 한다 (P4).

## Success Criteria
- 기능 단위는 unit, 모듈 완성 시 module e2e를 실 실행으로.
- mockup·스크립트 재생을 검증으로 인정하지 않는다.
- 통과 못 하면 P3로 되돌린다.
- e2e_verified는 사람만 마킹 — 에이전트 자기 선언 금지.
- 테스트가 없으면 통과로 간주하지 않는다.

## Boundaries
- 결과를 확정 기록하지 않는다(잠정 보고만) → harness-record가 사람 확인 후 기록.
- 기능을 고르지 않는다 → harness-feature.
- 커밋/세션 종료를 하지 않는다 → harness-record / harness-close.
