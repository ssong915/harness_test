# Harness Bootstrap Plan

## Purpose
세션 시작 시 컨텍스트를 의존성 순서대로 읽고, 브랜치를 점검하고, 직전 handoff를 복원해 사람의 재지시 없이 작업을 이어가게 한다 (P0).

## Success Criteria
- `deps.json.read_order` 전체를 팬아웃해 읽는다("하나만 읽기" 금지).
- `AGENTS.local.md` 부재 시 셋업 안내 후 중단(추측 시작 금지).
- 현재 git 브랜치를 파악하고, main/타인 브랜치면 분리 필요를 표시한다.
- `handoff.md` 의 상태를 복원해 보고한다.
- 새 산출물을 만들지 않는다(읽기 + CLAUDE.md 사전 갱신만).

## Boundaries
- Seed를 닫지 않는다 → `socrates`.
- 기능을 고르거나 브랜치를 만들지 않는다 → `harness-feature`.
- 세션을 종료하지 않는다 → `harness-close`.
- workspace 스코프 밖 파일을 읽지 않는다.
