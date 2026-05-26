# clean-state-checklist.md — 세션 종료 체크 [L-L1]

> 모든 세션은 clean state로 끝난다. 다음 세션이 신뢰성 있게 이어받기 위한 전제(harness P7). 빠뜨리면 누수 [L-O2].

## 기록 (md/json 최신화)
- [ ] `feature-list.json` 의 이 세션 기능 status·evidence 갱신
- [ ] `progress.md` 에 체크포인트 + 관측 메모 추가
- [ ] 인터페이스 영향 있으면 `handoff.md` 갱신
- [ ] 완료로 바뀐 항목과 모순되는 옛/중복 기록 정리 [L-S1]

## 검증
- [ ] 유닛테스트 green (`verification.json` 의 unit 커맨드)
- [ ] 모듈 완성 시 e2e 시나리오 통과 — `e2e_verified` 는 사람이 마킹 [L-V1]

## 작업트리 / git
- [ ] scratch·tmp 삭제 (`harness/tmp/` 예외)
- [ ] `.env`·secret 미스테이징 확인
- [ ] 기능 커밋 완료, 메시지 prefix 규칙 준수
- [ ] (기능 완료 시) 브랜치 머지 → 브랜치 삭제 [L-P2]

## 다음 세션 진입점
- [ ] `handoff.md` 만 읽어도 이어받을 수 있는 상태인가
