---
name: harness-record
description: |
  Record results and commit (P5+P6). After a feature passes verification, update the single source of truth (feature-list.json status + evidence), append a progress.md checkpoint, update handoff.md only if interfaces changed, clean up stale/duplicate entries, then git commit the feature.
  Triggers (EN): record, log progress, update status, commit this, write it down
  Triggers (KO): 기록, 진행 기록, 상태 갱신, 커밋해, 기록 남겨
  Do NOT use when: verification has not passed yet (-> harness-verify), or ending the whole session/cleaning state (-> harness-close).
  vs harness-verify: Verify decides pass/fail; Record writes the confirmed result and commits.
---

# Harness Record (P5 + P6)

기록을 단일 진실에 남기고 커밋하는 단계 [L-S1, L-L1]. 완료로 바뀐 항목과 모순되는 옛/중복 기록을 함께 정리해 충돌·환각을 막는다.

## Details
검증 통과(P4 Verify Gate) + 사람의 `e2e_verified` 확인 후에만 확정 기록한다. 상태 단일 진실은 `feature-list.json`, 서사 체크포인트는 `progress.md`, 인계는 `handoff.md`(인터페이스 영향 시만). 그다음 git 커밋(P6).

## State Contract
- 읽기: `deps.json`(edges로 함께 갱신할 파일 판단), `feature-list.json`, `progress.md`, `handoff.md`.
- 쓰기:
  - `feature-list.json`: 기능 `status` 갱신(+ `e2e_verified` 사람 확인값, `evidence.commit/test_file/branch`). **중복 추적 파일 만들지 않음.**
  - `progress.md`: 작업 단위 체크포인트 + 관측 메모(이번에 읽고/쓴 산출물) [L-O2].
  - `handoff.md`: 인터페이스/경계 영향 있을 때만.
  - git: `git add` + commit.

## Procedure
1. 검증 통과 + `e2e_verified` 사람 확인 됐는지 재확인(아니면 → P4).
2. `feature-list.json` status·evidence 갱신.
3. `deps.json.edges` 를 보고 함께 갱신할 파일 동기화(예: feature→progress, feature→handoff).
4. **잔존 정리**: 이 기능을 미완으로 적은 옛 기록·중복을 progress/handoff에서 제거 [L-S1, stale_policy].
5. `progress.md` 체크포인트 + 관측 메모.
6. 커밋: prefix `feat/fix/refactor/docs/chore(<scope>):`, 한 커밋 = 한 기능/한 영역. `.env`·secret 미포함 확인.

## Record Gate
- 단일 진실(`feature-list.json`)이 실제 상태와 일치한다.
- 옛/중복 기록이 정리됐다.
- 커밋이 prefix 규칙으로 완료됐고 `evidence.commit` 에 sha가 기입됐다.

## Output
```
[P5 Record]
- feature-list: <id> status → <done/...> (evidence: commit/test/branch)
- progress: 체크포인트 + 관측 메모
- handoff: 갱신함/불필요(인터페이스 영향 없음)
- 정리: 제거한 옛/중복 기록
- commit: <prefix(scope): msg> (<sha>)
- 다음: 다음 기능(P2) 또는 세션 종료(P7)
```
