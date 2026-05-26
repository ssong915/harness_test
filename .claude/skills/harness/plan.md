# Harness Orchestrator Plan

## Purpose
실행 하네스(Part 2) 세션을 phase 루프로 구동한다. 각 phase를 전용 서브스킬에 위임하고, 게이트가 닫혀야 다음으로 넘어간다.

## Success Criteria
- P0(bootstrap) → P1(intent, socrates+SEED 브리지) → P2(feature) → P3(develop) → P4(verify) → P5(record) → P6(commit) → P7(close) 순서를 강제.
- 각 Session Gate(Intent/Scope/Verify/Clean) 미충족 시 다음 phase로 가지 않는다.
- 상태는 repo 파일(SEED.md/feature-list.json/progress.md/handoff.md)에 산다(SoR).
- socrates의 Seed를 SEED.md로 브리지.

## Boundaries
- 서브스킬 내부를 재구현하지 않는다(호출만).
- Seed를 직접 닫지 않는다 → socrates.
- 게이트를 사람 확인 없이 통과로 강제하지 않는다(특히 Verify).
