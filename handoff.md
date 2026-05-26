# handoff.md — 세션 인계 메모

> 다음 세션(또는 다른 담당)이 **무지시로 이어받을** 수 있게 하는 정규 진입점 [L-L1]. `NEXT_SESSION.md` 같은 임시 파일을 따로 만들지 않는다 — 인계는 여기에만.
> 인터페이스/경계에 영향이 있을 때 갱신(harness P5).

## 지금 상태 (한 문단)
P1 Intent Gate 통과(Seed 닫힘), P2 첫 기능 F-001 선택·격리, P3 carcenters.json + hospitals.json 생성, P4 사람 검증 통과, P5+P6 기록·커밋 직전. 브랜치 `feat/F-001` 위에 있음. 다음은 main으로 머지 + 두 번째 기능 선택(F-002 intent 분류기 권장).

## 다음 세션이 할 일
1. 이 세션의 F-001 커밋을 main에 머지하고 `feat/F-001` 브랜치 삭제 (P6 마무리).
2. F-002 (router/intent 분류기) 선택 → `scripts/new-feature.sh F-002` 로 브랜치 분리 → P3 개발 진입.
3. F-002·F-003·F-004 가 끝나면 router 모듈 e2e 검증 시점 — F-005 (accident-flow extract) 와 F-007 (trouble-flow 구현) 의존성 모두 해소.

## 열린 결정 / 막힌 것 (blocked)
- 없음.

## 인터페이스 변경 (다른 모듈에 영향)
- **`carcenters.json` / `hospitals.json` 스키마 확정**:
  - 키: 서울 구 이름 (예: `강남구`) → 항목 배열.
  - 항목 필드: `name` (string), `rating` (float), `phone` (string `02-XXX-XXXX`), `address` (string), `gps.{lat,lng}` (float).
  - hospitals만: `kind` ∈ {`GH`, `MC`, `IM`, `OC`, `UN`, `ER`} — SEED 외 확장. trouble-flow 견인 추천 / accident-flow 병원 추천에서 사용 가능.
- 영향 모듈: `router` (F-007 trouble-flow가 이 스키마를 직접 읽음), `accident-flow` (F-005가 기존 mockup 추천 로직을 이 스키마로 갈아끼울 수 있음).

## 현재 브랜치
- `feat/F-001` (기능=브랜치=세션 1:1, 머지 후 삭제 [L-P2])
