# SEED.md — 의도 계약 (Part 1)

> 개발(Part 2)에 들어가기 전에 **무엇을 만들지**를 닫는 계약. `harness` 스킬 P1(Intent Gate)이 이 파일을 채우고, 세 칸이 다 차기 전엔 개발을 시작하지 않는다.

## goal
HERMES 채팅 데모에 시나리오 라우터를 도입하여, 사용자 입력을 **세 갈래(교통사고 / 차량 트러블 / 모호한 입력)** 로 자동 분기시켜 적절한 대응 흐름을 보여주는 동작 HTML 데모를 만든다.

## constraints
- 실존 자산 **HERMES**(= `accident-response-demo-mockup.html`)를 확장한다. 같은 이름의 새 시스템을 만들지 않는다 [L-I1].
- UI는 기존 3종 컴포넌트(**Alert / List / Alert with list**)만 사용. 신규 컴포넌트 추가 금지.
- 데이터는 서울 구별 3개씩의 카센터·병원 **dummy JSON 2개**. 외부 API 호출 금지.
- **단일 HTML 파일 + JSON 2개** 로 동작. 빌드 도구·런타임 의존성 0 (브라우저만으로 열면 동작).
- 기존 사고 응대 8단계 흐름은 회귀 없이 그대로 유지(트리거 → 안전확보 → 119판단 → 정보확인 → 보험연락 → 사진촬영 → 주변추천 → 후속조치).

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
| HERMES (Agent) | 실존 | `hermes-mockup` (accident-response-demo-mockup.html) |
| accident-response-pipeline (skill) | 실존 (재사용) | `hermes-mockup` 내부 8단계 파이프라인 |
| accident-ui-router (skill) | 실존 (책임 확장) | `hermes-mockup` 의 라우팅 진입점 — 이번 세션에서 사고 외 분기 처리까지 책임 확장 |
| car-trouble-pipeline (skill) | **신규** | 이번 세션에서 정의. 사고 파이프라인의 8단계를 트러블용 5단계로 축약한 변형 |
| seoul-poi-data (dummy JSON) | **신규** | 카센터·병원 서울 구별 3개씩 dummy |

## Socratic 기록
- wonder: "openclaw"의 실체 / 산출물 형태 / 기존 mockup과의 관계 / 돌발상황의 범위 / 추가 시나리오 / 개선 축
- reflect: openclaw → HERMES 정정 / 산출물 = HTML 데모 / 기존 mockup 확장 / 교통사고 + 차량 트러블 / 시나리오 라우팅 자동화
- refine: HERMES 데모에 라우터 추가 → 사고/트러블/모호 3-way 분기 → 모호 fallback은 기존 UI 컴포넌트로 재질문
- restate (→ goal): 위 goal 한 줄.
