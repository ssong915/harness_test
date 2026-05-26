# Harness Record Plan

## Purpose
검증 통과한 작업을 단일 진실에 기록하고, 잔존/중복을 정리하고, 커밋한다 (P5+P6).

## Success Criteria
- feature-list.json status+evidence가 실제 상태와 일치(단일 진실).
- deps.json.edges로 함께 갱신할 파일을 동기화.
- 완료 항목과 모순되는 옛/중복 기록 제거(충돌·환각 방지).
- progress.md 체크포인트 + 관측 메모(읽고/쓴 산출물).
- prefix 규칙으로 커밋, evidence.commit에 sha 기입.

## Boundaries
- 검증을 수행하지 않는다 → harness-verify (통과 후에만 기록).
- e2e_verified를 임의로 true로 만들지 않는다(사람 확인값을 옮길 뿐).
- 세션 종료/clean-state를 하지 않는다 → harness-close.
- 중복 추적 파일을 새로 만들지 않는다.
