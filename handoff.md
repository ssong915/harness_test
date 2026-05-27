# handoff.md — 세션 인계 메모

> 다음 세션(또는 다른 담당)이 **무지시로 이어받을** 수 있게 하는 정규 진입점 [L-L1]. `NEXT_SESSION.md` 같은 임시 파일을 따로 만들지 않는다 — 인계는 여기에만.
> 인터페이스/경계에 영향이 있을 때 갱신(harness P5).

## 지금 상태 (한 문단)
F-001(data) + F-002(router/intent 분류기) + SEED v2(자체 mockup 신규 구축으로 전환) + F-008(demo.html 쉘) 완주. main 위에 `demo.html` / `router.js` / `carcenters.json` / `hospitals.json` / `serve.sh` 가 모두 있고 `bash serve.sh` 로 `http://localhost:8000/demo.html` 열면 라우팅 가시화까지 동작. 모든 후속 기능(F-003/F-004/F-005/F-006/F-007)의 의존이 해소됨.

## 어떻게 실행해보나
```bash
cd /Users/ssong/Documents/ssong/harness_test
bash serve.sh
# 브라우저에서 http://localhost:8000/demo.html
```

## 다음 세션이 할 일
1. 다음 기능 선택 — 의존 그래프상 다음 후보:
   - **F-006** (trouble-flow 명세, 코드 0줄) — 가장 가벼움, F-007 선결.
   - **F-003** (모호 fallback, Alert with list 다이얼로그) — UX 흐름 닫기.
   - **F-004** (배지 폴리시) — 시각 마무리.
   - **F-005** (사고 8단계 구현) — 가치 큰 기능, 분량 있음.
   - **F-007** (트러블 5단계 구현) — F-006 선행 후.
2. `bash scripts/new-feature.sh F-XXX` → `feature-list.json` 의 status/branch 갱신 → P3 개발 진입.
3. router 모듈 e2e (F-003+F-004 done 시점) / accident-flow 모듈 e2e (F-005 done) / trouble-flow 모듈 e2e (F-006+F-007 done) 가 남은 모듈 검증.

## 열린 결정 / 막힌 것 (blocked)
- 없음. 모든 후속 기능 의존성 해소.

## 인터페이스 (다른 모듈에 영향)
- **`demo.html` window.HERMES API** (F-008에서 신규):
  - `classify(text)` → 'accident' | 'trouble' | 'ambiguous'
  - `renderAlert({ title, message, buttons: [{label, variant, onClick}] })`
  - `renderList({ title, items: [{label, required}] })`
  - `renderAlertWithList({ title, message, items, buttons })`
  - `setBadge(scenario)` — 배지 색·라벨 갱신
  - 후속 기능(F-003/F-005/F-007)은 demo.html 내부 코드에 시나리오 흐름을 추가하거나, 외부 JS 파일로 분리하고 demo.html 에서 import 한다.
- **`router.js`** (F-002): `import { classify, KEYWORDS } from './router.js'`. `KEYWORDS = { accident:[...], trouble:[...] }` (확장 가능 풀).
- **`carcenters.json` / `hospitals.json`** (F-001): 서울 구 이름 → 항목 배열. 항목 필드: `name` / `rating` / `phone` / `address` / `gps.{lat,lng}`. hospitals만 `kind` ∈ {`GH`, `MC`, `IM`, `OC`, `UN`, `ER`}.

## 현재 브랜치
- `main` (feat/F-008까지 머지 후 삭제 완료). 다음 기능은 새 `feat/F-XXX` 브랜치를 떼서 시작.
