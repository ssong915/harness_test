# Harness Feature Plan

## Purpose
한 번에 한 기능만 골라 전용 브랜치로 격리하고 in_progress로 표시한다 (P2).

## Success Criteria
- Seed가 닫힌 뒤에만 진입한다.
- 정확히 하나의 todo(의존 해소)를 고른다 — 임의 다중 선택 금지.
- 기능 브랜치를 떼고(`scripts/new-feature.sh`) evidence.branch에 기록.
- feature-list.json status를 in_progress로, progress.md에 시작 체크포인트.
- 큰 기능은 하위로 쪼갠 뒤 하나를 고른다.

## Boundaries
- Seed를 닫지 않는다 → socrates / 오케스트레이터 Intent Gate.
- 코드를 구현하지 않는다(P3은 일반 코딩).
- 검증하지 않는다 → harness-verify.
- 기록/커밋하지 않는다 → harness-record.
- main/타인 브랜치 위에서 개발 시작을 허용하지 않는다.
