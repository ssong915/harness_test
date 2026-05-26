# handoff.md — 세션 인계 메모

> 다음 세션(또는 다른 담당)이 **무지시로 이어받을** 수 있게 하는 정규 진입점 [L-L1]. `NEXT_SESSION.md` 같은 임시 파일을 따로 만들지 않는다 — 인계는 여기에만.
> 인터페이스/경계에 영향이 있을 때 갱신(harness P5).

## 지금 상태 (한 문단)
F-001(data) + F-002(router/intent 분류기) 두 사이클 완주, 둘 다 main에 머지됨. router.js + router.test.mjs 추가, node 9/9 PASS. 다음은 F-003(모호 fallback) — 다만 F-003 부터는 **DOM/HTML 의존**이 시작되는데 베이스 mockup HTML(`accident-response-demo-mockup.html`)이 이 repo에 없음 → 다음 세션 진입 전 결정 필요.

## 다음 세션이 할 일
1. **선결**: SEED constraints의 베이스 mockup HTML 처리 — (a) 외부에서 파일 가져와 repo에 추가, (b) SEED를 "처음부터 자체 mockup HTML 구축"으로 갱신. 결정 안 되면 F-003 진입 불가.
2. 결정 후 `bash scripts/new-feature.sh F-003` → 모호 fallback (Alert with list 분기 질문) 구현.
3. F-004 (라우팅 결과 배지/라벨)까지 끝나면 router 모듈 e2e 검증 시점.
4. router 모듈 완성 → F-005 (accident-flow extract) + F-007 (trouble-flow 구현) 의존 해소.

## 열린 결정 / 막힌 것 (blocked)
- **베이스 mockup HTML 누락** [L-I1]: SEED에 "기존 mockup 확장"으로 명시했으나 파일이 repo에 없음. F-003 이후 작업의 선결 조건. (a) 외부 첨부, (b) SEED 갱신 중 선택 필요.

## 인터페이스 변경 (다른 모듈에 영향)
- **`router.js` 인터페이스 확정** (이번 세션):
  - `import { classify, KEYWORDS } from './router.js'`
  - `classify(input: string): 'accident' | 'trouble' | 'ambiguous'`
  - `KEYWORDS = { accident: [...], trouble: [...] }` (확장 가능한 키워드 풀)
- 영향 모듈: 모든 후속 router/flow 기능이 이 함수를 진입점으로 사용.
- **`carcenters.json` / `hospitals.json` 스키마** (이전 세션 유지):
  - 키: 서울 구 이름 → 항목 배열.
  - 항목 필드: `name` / `rating` / `phone` / `address` / `gps.{lat,lng}`.
  - hospitals만: `kind` ∈ {`GH`, `MC`, `IM`, `OC`, `UN`, `ER`}.

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
