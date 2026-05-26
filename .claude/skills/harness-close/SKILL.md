---
name: harness-close
description: |
  End the session in a clean state (P7). Run clean-state-checklist.md, ensure md/json are current, delete scratch, confirm handoff.md alone lets the next session resume, note observability (context budget / artifact use), and merge+delete the feature branch when the feature is done.
  Triggers (EN): end session, wrap up, close session, clean up, done for now
  Triggers (KO): 세션 종료, 마무리, 정리하고 끝내자, 오늘은 여기까지
  Do NOT use when: still recording a just-finished feature (-> harness-record first), or starting/resuming (-> harness-bootstrap).
  vs harness-record: Record commits one feature; Close finalizes the whole session and guarantees clean continuity.
---

# Harness Close (P7)

모든 세션을 **clean state로** 끝낸다 [L-L1]. 다음 세션이 무지시로 이어받을 수 있어야 종료한다 — 빠뜨리면 누수 [L-O2].

## Details
`clean-state-checklist.md` 를 끝까지 점검하고, 인계 진입점(`handoff.md`)을 정리하고, 관측 메모를 남기고, 완료된 기능이면 브랜치를 머지·삭제한다. 생략 불가 단계.

## State Contract
- 읽기: `clean-state-checklist.md`, `feature-list.json`, `progress.md`, `handoff.md`.
- 쓰기: `handoff.md`(다음 세션 진입점), `progress.md`(관측 메모), git(브랜치 머지·삭제 — 기능 완료 시).
- 삭제: scratch/tmp (`harness/tmp/` 예외).

## Procedure
1. `clean-state-checklist.md` 항목을 하나씩 점검(기록 최신화 / 검증 green / 작업트리·git / 다음 세션 진입점).
2. scratch·tmp 정리(`harness/tmp/` 예외), `.env`·secret 미스테이징 확인.
3. `handoff.md` 갱신: "지금 상태 / 다음 할 일 / 막힌 것 / 현재 브랜치" — **이 파일만 읽어도 이어받을 수 있게**.
4. 관측 메모[L-O2]: 이번 세션에 실제 읽고/쓴 산출물을 `progress.md` 에 남기고, 컨텍스트 여유는 사람이 `/context` 로 확인하도록 안내. *(완전 자동화 안 됨 — 신호 노출까지.)*
5. 기능이 done이면: 브랜치 머지 → `git branch -d feat/<id>` [L-P2].

## Clean Gate
세션을 닫으려면:
- `clean-state-checklist.md` 항목이 모두 체크됨.
- 테스트 green, 작업트리 정리됨, scratch 제거됨.
- `handoff.md` 만으로 다음 세션이 이어받을 수 있음.
미충족 항목이 있으면 그것을 처리하기 전엔 "종료"로 보고하지 않는다.

## Output
```
[P7 Close]
- clean-state: <전부 체크 / 미충족 항목>
- 정리: scratch/tmp 삭제, 작업트리 clean
- handoff: 다음 세션 진입점 갱신(요약)
- 브랜치: feat/<id> 머지·삭제 / 유지(기능 미완)
- 관측 메모: 읽고/쓴 산출물 / 컨텍스트 확인 안내
- 세션 종료 가능: 예 / 아니오(사유)
```
