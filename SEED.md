# SEED.md — 의도 계약 (Part 1)

> 개발(Part 2)에 들어가기 전에 **무엇을 만들지**를 닫는 계약. `harness` 스킬 P1(Intent Gate)이 이 파일을 채우고, 세 칸이 다 차기 전엔 개발을 시작하지 않는다.

## goal
HERMES 채팅 데모에 시나리오 라우터를 도입하여, 사용자 입력을 **세 갈래(교통사고 / 차량 트러블 / 모호한 입력)** 로 자동 분기시켜 적절한 대응 흐름을 보여주는 동작 HTML 데모를 만든다.

## constraints
- **자체 HTML mockup을 신규 구축**한다 (`demo.html`). 외부 mockup 파일이 repo에 없어 v1 SEED의 "기존 mockup 확장" 전제가 무너졌으므로 v2에서 방향 전환 [L-I1].
- HERMES 브랜드/체계(채팅 + UI 컴포넌트 3종 + 사이드 컨텍스트 패널 + 사고 응대 8단계)의 **컨셉은 유지**하되, 구현은 처음부터 새로 한다.
- UI 컴포넌트는 **Alert / List / Alert with list** 세 종류만 사용. 신규 컴포넌트 추가 금지.
- 데이터는 서울 구별 3개씩의 카센터·병원 **dummy JSON 2개**. 외부 API 호출 금지.
- **단일 demo.html + JSON 2개 + router.js** 로 동작. 빌드 도구·런타임 의존성 0 (브라우저만으로 열면 동작).
- 사고 응대 8단계 흐름: 트리거 → 안전확보 → 119판단 → 정보확인 → 보험연락 → 사진촬영 → 주변추천 → 후속조치 (이 순서·항목 유지).

## acceptance_criteria
1. 채팅 입력에 **"사고", "박았어", "충돌"** 중 어느 하나가 포함되면 → 사고 응대 8단계로 진입·완주.
2. 채팅 입력에 **"시동", "펑크", "견인"** 중 어느 하나가 포함되면 → 차량 트러블 흐름(보험견인 안내 + 주변 카센터 추천 + 후속조치)으로 진입·완주.
3. 채팅 입력이 어떤 키워드와도 매칭되지 않으면(예: "도와줘") → Alert with list로 "사고인가요? 차량 트러블인가요? 다른 도움인가요?" 분기 질문 → 선택에 따라 위 1·2 흐름으로 진입.
4. 라우팅 결과(어느 시나리오로 갔는지)가 화면의 시각 요소(배지/라벨)로 노출된다.
5. 브라우저에서 HTML 파일을 열면 의존성 설치 없이 즉시 동작. 카센터/병원 데이터가 입력값(위치) 기반으로 화면에 표시된다.
- 실존 자산을 사용한다(`assets.json` 참조). **이름만 같은 커스텀 구현 금지.**

## 핵심 명사 / 정체성 점검 [L-I1]
| 명사 | 실존? | 출처/자산 (assets.json) |
|---|---|---|
| HERMES (Agent) | **신규(컨셉 재구축)** | 외부 자산 파일 부재로 v2 SEED에서 자체 mockup으로 재정의. 동명의 기존 자산이 repo에 들어오면 다시 v3로 재바인딩한다. |
| accident-response-pipeline | **신규** | demo.html 내부 함수/모듈로 신규 구현 (8단계 흐름) |
| accident-ui-router → scenario-router | **신규** | F-002 `router.js classify` 가 이 책임 — 사고/트러블/모호 3-way |
| car-trouble-pipeline | **신규** | demo.html 내부 함수/모듈로 신규 구현 (5단계 흐름) |
| seoul-poi-data (dummy JSON) | **신규/완료** | F-001로 carcenters.json + hospitals.json (각 25구×3) 작성됨 |

## Socratic 기록
- wonder (v1): "openclaw"의 실체 / 산출물 형태 / 기존 mockup과의 관계 / 돌발상황의 범위 / 추가 시나리오 / 개선 축
- reflect (v1): openclaw → HERMES 정정 / 산출물 = HTML 데모 / 기존 mockup 확장 / 교통사고 + 차량 트러블 / 시나리오 라우팅 자동화
- refine (v1): HERMES 데모에 라우터 추가 → 사고/트러블/모호 3-way 분기 → 모호 fallback은 기존 UI 컴포넌트로 재질문
- restate v1 (→ 이전 goal): HERMES 채팅 데모를 확장…

- 결함 발견 (P1 후속): SEED constraints의 "기존 mockup 확장" 전제가 실 파일 부재로 무너짐 [L-I1 — Context ≠ Contract]. F-001/F-002 산출물은 영향 없음 (데이터+pure JS).
- evolve v2: 자체 mockup 신규 구축으로 전환. HERMES 컨셉/8단계 흐름은 유지, 구현은 처음부터.
- restate v2 (→ 현 goal): 위 goal 한 줄.
