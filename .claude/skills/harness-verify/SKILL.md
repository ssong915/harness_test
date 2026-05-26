---
name: harness-verify
description: |
  Verify a built feature/module (P4). Run the unit tests and, when a module is complete, its module-level e2e scenario from verification.json — with real execution, not mocks. The agent never self-declares "done"; e2e_verified is marked by the human only.
  Triggers (EN): verify, test this, is it done, run e2e, check it works
  Triggers (KO): 검증, 이거 테스트, 다 됐나, e2e 돌려, 동작 확인
  Do NOT use when: picking a feature (-> harness-feature), recording results/committing (-> harness-record), or closing the session (-> harness-close).
  vs harness-record: harness-verify decides whether it passes; harness-record writes the result and commits after it passes.
---

# Harness Verify (P4)

완료를 **사람이** 판정하게 만드는 단계 [L-V1]. 기능 단위는 유닛테스트, 모듈이 다 차면 모듈 e2e를 한 번에 돌린다 [L-V2]. 검증 본체는 mockup·스크립트 재생이 아니라 **실 실행**.

## Details
`verification.json` 에서 이 기능이 속한 모듈의 기준을 찾아 실행한다. 통과 못 하면 P3(개발)로 되돌린다. **에이전트가 "다 됐다"를 스스로 선언하지 않는다** — `e2e_verified`/`verified_by_human` 은 사람이 마킹.

## State Contract
- 읽기: `feature-list.json`(이 기능의 module), `verification.json`(`modules[].unit`, `modules[].e2e.scenario`, `system.criteria`), `reliability.md`(통과선).
- 쓰기: **없음(잠정)**. 검증 결과는 보고만 하고, 확정 기록(`e2e_verified=true`)은 사람 확인 후 `harness-record` 가 쓴다.
- 산출: 테스트 로그 + e2e 시나리오 실행 결과.

## Procedure
1. 기능의 `module` 을 `feature-list.json` 에서 확인.
2. `verification.json.modules[module].unit` 커맨드를 실행(예: `uv run pytest ...`). 실패 → 실패 항목 보고 후 P3로.
3. 그 모듈의 기능이 **모두 done 직전**이면 `modules[module].e2e.scenario` 를 **실 실행**으로 수행(실 LLM/실 서비스, mock 금지). 부분이면 e2e는 보류(아직 모듈 미완).
4. `system.criteria` 가 있으면 전체 happy-path도 점검.
5. 결과를 보고하고, **사람에게 `e2e_verified` 마킹 여부를 묻는다**. 임의로 true 처리 금지.

## Verify Gate
P5(기록)로 가려면:
- 유닛테스트 green.
- (모듈 완성 시) e2e 시나리오가 **실 실행**으로 통과.
- `e2e_verified` 를 **사람이** true로 확인.
어느 하나라도 미충족이면 통과 아님 — P3로 되돌리거나 사람 확인을 기다린다.

## Safety Valve
- "mockup과 픽셀이 다르다"류는 검증 가치 없음으로 처리. "실제 응답을 처리 못 한다"가 유효한 실패 보고.
- 테스트가 없으면 통과로 간주하지 않는다 — `verification.json` 에 기준을 먼저 추가.

## Diagnosis Order [L-O1]
검증이 "전엔 됐는데 지금 안 됨"·"옛 동작이 보임"으로 실패하면, 코드 가설로 뛰기 전에 **런타임부터** 순서대로 의심한다:
1. 서버 재기동 누락(`--reload` 없이 옛 코드가 떠 있음).
2. 브라우저/클라이언트 정적 캐시(Cache-Control 부재) → 하드 리로드.
3. 그 다음에야 코드/머지/환경 가설.
라이브 reproduce(직접 띄워 비교)가 가설 탐색보다 빠르다. (상세 기준: `reliability.md`)

## Output
```
[P4 Verify]
- 모듈: <m>
- unit: <pass/fail + 요약>
- e2e: <실행/보류> <pass/fail + 시나리오>
- e2e_verified: 사람 확인 대기 / 확인됨
- 게이트: 통과 / 미충족(사유) → P3 또는 대기
```
