# Harness Close Plan

## Purpose
세션을 clean state로 종료해 다음 세션의 연속성을 보장한다 (P7).

## Success Criteria
- clean-state-checklist.md 전 항목 점검.
- scratch/tmp 삭제(harness/tmp 예외), 작업트리 clean, 테스트 green.
- handoff.md만으로 다음 세션이 이어받을 수 있다.
- 관측 메모(읽고/쓴 산출물) 기록 + 컨텍스트 확인 안내.
- 기능 완료 시 브랜치 머지·삭제.

## Boundaries
- 한 기능을 커밋하는 단계가 아니다 → harness-record.
- 세션을 시작/복원하지 않는다 → harness-bootstrap.
- 미충족 항목이 있으면 "종료"로 보고하지 않는다(생략 금지).
