# handoff.md — 세션 인계 메모

> 다음 세션(또는 다른 담당)이 **무지시로 이어받을** 수 있게 하는 정규 진입점 [L-L1]. `NEXT_SESSION.md` 같은 임시 파일을 따로 만들지 않는다 — 인계는 여기에만.
> 인터페이스/경계에 영향이 있을 때 갱신(harness P5).

## 지금 상태 (한 문단)
F-001 한 사이클 완주 + main에 머지 완료. P7 close 정상 종료. main 깨끗 (working tree clean), `feat/F-001` 삭제됨. 다음 세션은 P0 부트스트랩 → 곧바로 P2 (F-002 선택)부터 시작.

## 다음 세션이 할 일
1. `bash scripts/new-feature.sh F-002` 로 브랜치 분리 → feature-list.json에서 F-002 status=in_progress, evidence.branch 기입.
2. F-002 intent 분류기 구현 — 입력 문자열 includes 매칭으로 `accident` / `trouble` / `ambiguous` 셋 중 하나 반환. 키워드: `사고`/`박았어`/`충돌` → accident, `시동`/`펑크`/`견인` → trouble, 매칭 없음 → ambiguous.
3. F-003 (모호 fallback Alert with list) + F-004 (라우팅 배지 가시화)까지 router 모듈 전체를 마무리하면 router 모듈 e2e 검증 시점이 옴 (verification.json#modules.router 참조).
4. router 모듈이 완성되면 F-005 (accident-flow extract) + F-007 (trouble-flow 구현) 의 의존성이 풀려 병렬로 진행 가능.

## 열린 결정 / 막힌 것 (blocked)
- 없음.

## 인터페이스 변경 (다른 모듈에 영향)
- **`carcenters.json` / `hospitals.json` 스키마 확정**:
  - 키: 서울 구 이름 (예: `강남구`) → 항목 배열.
  - 항목 필드: `name` (string), `rating` (float), `phone` (string `02-XXX-XXXX`), `address` (string), `gps.{lat,lng}` (float).
  - hospitals만: `kind` ∈ {`GH`, `MC`, `IM`, `OC`, `UN`, `ER`} — SEED 외 확장. trouble-flow 견인 추천 / accident-flow 병원 추천에서 사용 가능.
- 영향 모듈: `router` (F-007 trouble-flow가 이 스키마를 직접 읽음), `accident-flow` (F-005가 기존 mockup 추천 로직을 이 스키마로 갈아끼울 수 있음).

## 현재 브랜치
- `main` (feat/F-001은 머지 후 삭제 완료). 다음 기능은 새 `feat/F-002` 브랜치를 떼서 시작.
