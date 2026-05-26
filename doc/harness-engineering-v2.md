---
aliases: ["하네스 엔지니어링 v2", "Harness Engineering v2"]
tags: [concept, ai-agent, harness, llm-ops, agentos]
related: ["[[harness-engineering]]", "[[Symposium]]", "[[Ouroboros]]", "[[AgentOS]]", "[[Skill-vs-MCP]]", "[[project_scenario1]]", "[[harness-engineering-lessons-scenario1]]"]
status: draft
created: 2026-05-24
version: 2.0
supersedes: "[[harness-engineering]] (확정 시 대체 예정)"
---

# Harness Engineering (하네스 엔지니어링) — v2

## 목차
| #   | 섹션                                           |
| --- | -------------------------------------------- |
| 1   | 요약                                           |
| 2   | 왜 하네스가 필요한가                                  |
| 3   | 전체 아키텍처 — 앞단(의도) → 뒷단(실행)                    |
| 4   | Part 1 상세 — 의도 닫기                            |
| 5   | Part 2 상세 — 실행 닫기 (Walking Labs · Ouroboros) |
| 6   | 하네스의 장단점                                     |
| 7   | 레슨런 (scenario1)                              |
| 8   | 체크리스트 — 9개 면                                 |
| 9   | 출처 · 관련 자원                                   |

---

## 1. 요약

- 확률적 LLM을 결정론적 시스템처럼 신뢰성 있게 부리기 위해, 모델 둘레에 **"무엇을·언제·어디서·어떻게"를 고정하는 시스템(=하네스)**을 두르는 분야다.
- 목표는 모델을 더 똑똑하게 만드는 게 아니라, **선택 공간을 줄이고 결과를 검증 가능하게** 만드는 것이다.
- 하네스는 두 겹으로 나뉜다:
    - **앞단(의도)** — 무엇을 시킬지를 실행 전에 닫는다.
    - **뒷단(실행)** — 그 계약을 신뢰성 있게 실행·검증한다.

> "모델은 무엇을 쓸지(what)를 결정하고, 하네스는 언제·어디서·어떻게(when/where/how) 쓰는지를 통치한다." — Walking Labs

여기에 한 겹을 앞에 더한 것이 Q00/Ouroboros다 — **그 '무엇을(intent)'을 실행 전에 닫는 것.**

---

## 2. 왜 하네스가 필요한가

- **모델은 실제 경험이 아니라 텍스트로 학습됐다.** 
> 세계와 부딪혀 결과를 확인하며 배운 게 아니라, 사람이 남긴 글의 패턴을 모방하도록 훈련됐다. 그래서 그럴듯한 답은 잘 만들지만, 실제로 일이 됐는지는 스스로 보장하지 못한다 → **실제 결과를 외부에서 확인하는 시스템(하네스)이 필요**하다.

- **모델이 더 커져도 이 문제는 사라지지 않는다.** 
> Sutton의 Bitter Lesson(사람이 짜 넣은 규칙보다 스케일되는 일반 방법이 결국 이긴다)이 맞더라도, 그 방법이 실제 일을 끝내려면 여전히 런타임(하네스)이 받쳐줘야 한다.

- **강한 모델만으로는 부족하다.** 
> 같은 Opus 4.5가 하네스 없으면 20분 만에 무너지고, 있으면 6시간 작업을 완수한다. (Anthropic)

- **진짜 비용은 성능이 아니라 감시 비용(supervision cost)이다.** 
> 사람이 매번 결과를 봐야 하면 위임이 아니다. 하네스의 목적은 사람의 머릿속 판단을 도구·입력·판정 기준으로 옮겨, 매번 안 봐도 되게 만드는 것이다.

- **핵심 명제 — "Context는 Contract가 아니다."** 
	> 배경 문서 주입은 첫 답만 좋게 하고, 실행 중의 선택은 모델 해석에 남긴다. 검증 가능한 계약(Contract)만이 결과를 고정한다.

> 결정론적 제어 = 자유도 제거가 아니라, 필요한 선택만 남기는 설계.

---

## 3. 전체 아키텍처 — 앞단(의도) → 뒷단(실행)

두 자료는 경쟁하는 정의가 아니라 **같은 파이프라인의 두 부분**이다.

```
사람의 모호한 요청
   │
   ▼  [ PART 1 · 의도를 닫는다 ]   ← Q00 / Ouroboros / Symposium
   │     wonder→reflect→refine→restate→socrates → Seed(goal·constraints·AC)
   ▼
  Seed (실행 계약)
   │
   ▼  [ PART 2 · 실행을 닫는다 ]   ← Walking Labs · Ouroboros(AgentOS)
   │     Instructions·State·Verification·Scope·Lifecycle·Observability
   ▼
검증된 산출물 (사람은 리뷰만)
```

- **Part 1 (의도 닫기)** — 사람의 모호한 요청에서 "무엇을 시킬지"를 질문으로 좁혀, goal·constraints·acceptance_criteria 세 칸을 채운 **Seed(실행 계약)**로 만든다. 같은 단어를 두고 사람과 모델이 다르게 해석하는 일을 실행 전에 없애는 단계다.
- **Part 2 (실행 닫기)** — 그 Seed를 입력으로 받아, 모델이 코드를 쓰되 **언제·어디서·어떻게** 쓰는지를 지시·상태·검증·범위·라이프사이클·관측으로 통제한다. 멀티 세션 장기 작업에서도 컨텍스트를 잃거나 성급히 완료를 선언하지 않게 만들어, 사람은 마지막에 리뷰만 한다.
- **Part 1이 없으면** Part 2가 잘못된 목표를 완벽하게 실행하고, **Part 2가 없으면** Part 1의 좋은 계약이 실행 중 흐트러진다.
- Ouroboros는 이 둘을 모두 포함한다 — 그 Part 2가 구체적으로 무엇인지는 §5-2. Walking Labs는 Part 2에 집중한 갈래다.
---

## 4. PART 1 상세 — 의도를 닫는다 (Intent Layer)

**문제:** "성과"라는 한 단어 안에 매출·학습속도·팀분위기·출시속도가 다 들어 있다. 사람과 모델이 같은 단어를 써도 가리키는 영역이 다르다(same word, different ontology). 협업의 어긋남은 거의 여기서 시작 → **질문이 곧 제어면(control surface)**.

### 4-1. Socratic Extraction (4단계 루프) — Symposium 스킬과 1:1
| 단계 | 스킬 | 역할 |
|---|---|---|
| 01 | `/wonder` | 단어 안 의미 후보를 **펼친다** (좁히지 않음) |
| 02 | `/reflect` | 사람·모델의 의미 **차이를 마주 본다** |
| 03 | `/refine` | 차이를 **같은 의미 한 줄**(shared meaning)로 합친다 |
| 04 | `/restate` | shared meaning으로 goal을 **재진술**한다 |

`/socrates`가 4단계를 **Ralph 루프**로 묶고, 매 사이클 끝 Seed Gate에서 Seed 세 칸(goal·constraints·acceptance_criteria)이 다 찼는지 점검 → 비면 다음 사이클(`Cycle > 5`는 안전밸브).

### 4-2. 의도를 정련하는 보조 컴포넌트
- **`/evolve-step`**: 한 번 모인 Seed는 "한 시야 안의 한 점". 사각지대(놓친 사용자 3 + 잘려나간 가능성 3)를 다시 묻되 **사용자가 ☑한 것만** Seed v2에 반영(자동 채택 금지).
- **`/ontology`**: goal이라는 단어의 **경계(boundary)**를 정한다 — `idea / boundary / properties×3`.
- **Stop Rule**: 직전 Seed와 새 Seed의 ontology **유사도 ≥ 0.85면 수렴(stop)** — 무한 루프를 막는 정량적 종료 조건.

### 4-3. 산출물 = Seed
실행 가능한 계약: `goal` · `constraints` · `acceptance_criteria`. 이것이 Part 2의 입력이 된다.

---

## 5. PART 2 상세 — 실행을 닫는다 (Execution Layer)

Part 2는 닫힌 Seed를 신뢰성 있게 실행·검증하는 층이다. 이를 구현한 두 갈래가 있다 — repo 파일·관습 기반의 **Walking Labs**, 계약을 런타임으로 강제하는 **Ouroboros / AgentOS**.

> 하네스 없음: 코드 작성 → 테스트 깨짐 → "다 됐다" 선언 → 사람이 수동 수정
> 하네스 있음: 지시 읽기 → 검증 실행 → progress 갱신 → 사람은 리뷰만

### 5-1. Walking Labs — repo 파일·관습 기반
모델 주위에 닫힌 루프 작업 시스템을 repo의 파일·관습·스크립트로 두른다. 핵심은 5+1 서브시스템:

1. **Instructions** — `AGENTS.md`/`CLAUDE.md`로 경계를 박는다. 거대한 단일 지시 파일은 실패하므로, 역할별·모듈별로 쪼갠 점진적 지시.
2. **State** — `progress.md`·`feature_list.json`·git에 상태를 영속한다(저장소 = System of Record). 휘발성 컨텍스트 밖에 두어 멀티 세션 연속성을 확보.
3. **Verification** — 내장 E2E 테스트로 성급한 완료 선언을 막는다. 검증 루프가 없으면 "아직 미충족"이라는 피드백 자체가 없다.
4. **Scope** — `feature_list.json`이 기본 단위. 한 번에 한 기능 + 명시적 "done"으로, 과도하게 손대고 끝맺지 못하는 것을 막는다.
5. **Session Lifecycle** — 초기화 스크립트·clean-state 체크리스트·핸드오프. 초기화는 별도 단계이고, 모든 세션은 clean state로 끝나야 다음 세션이 이어받는다.
6. **(+) Observability** — 런타임을 디버깅·관측 가능하게. 하네스 안에 속한다.

### 5-2. Ouroboros / AgentOS — 계약을 강제하는 런타임
Q00의 Ouroboros는 의도 닫기(Part 1)에서 멈추지 않고, 닫은 Seed를 **실행·검증하는 런타임(AgentOS)**까지 자체 어휘로 갖는다. Walking Labs가 "파일로 지시"한다면, AgentOS는 "시스템이 계약을 강제"한다.

**4겹 설계.** 하네스를 네 층으로 본다:
1. **Intent** — 사람의 의도·책임 경계·성공 조건을 먼저 고정한다 (이 층이 Part 1).
2. **Control** — 도구·순서·권한·중단 조건으로 모델의 선택면을 줄인다.
3. **Playground** — 비개발자도 tool call로 안전하게 실행하는 작업장.
4. **Contract** — AgentOS가 검증할 수 있는 `Seed·AC·event·memory`. 결과를 고정하는 핵심 층.

**AgentOS = 실행·검증 런타임.** Seed를 입력으로 받아 실행하고, 결과를 Contract로 검증한다.
- 상태(event·memory)를 시스템이 관리 → State·Verification을 런타임이 담보한다.
- 완료 판정을 `AC pass / regression / rollback` 지표로 정량화. 통과 못 하면 롤백.
- 종료 조건(Stop Rule): 직전·신규 Seed의 ontology 유사도 ≥ 0.85면 수렴 — 무한 루프 차단.

**모델 독립성 — Skill vs MCP** (→ [[Skill-vs-MCP]])
- **Skill** = 모델에게 말한다 (절차·판단법을 입력으로 전달 = pass by value).
- **MCP** = 환경을 고정한다 (도구·상태·권한·결과 포맷을 시스템 계약으로 노출 = pass by reference).
- Fat skill이면 모델 교체 시 흔들리지만, Contract 기반 AgentOS면 모델 교체는 런타임 변경에 불과하다. 폐쇄망(사내)에서 모델을 갈아끼워도 입력 계약·검증이 유지되는 게 핵심 셀링 포인트.

**팀 확산(거버넌스).** Dashboard(누가 무엇을 실행 중인지) → Sync(스킬·MCP 배포) → Proof(도입률 추적) → Next(PR 리뷰·요구사항 인터뷰·장애 분석으로 확장).

### 5-3. 두 접근 비교 — Walking Labs vs Ouroboros(AgentOS)
같은 Part 2를 다르게 구현한다 (§5-2의 Skill↔MCP 구분과 같은 축).

| 측면 | Walking Labs | Ouroboros / AgentOS |
|---|---|---|
| 기반 | repo 파일·관습 + 스크립트 | 런타임·플랫폼 (AgentOS) |
| 계약 방식 | 모델에게 "말한다" (지시 = Skill) | 시스템이 "고정한다" (계약 = MCP) |
| 강제력 | 약(soft) — 지시를 안 따르면 샘 | 강(hard) — AC·이벤트를 시스템이 검증·차단 |
| 모델 교체 | 흔들릴 수 있음 (fat skill) | 강건 — 계약 유지, 런타임만 교체 |
| 도입 비용 | 낮음 — 어떤 repo에도 바로 | 높음 — AgentOS 플랫폼 필요 |
| 투명성 | 높음 — 전부 repo의 파일 | 낮음 — 런타임 내부 |
| 지향 | 범용·교육 (오픈 커리큘럼) | 사내·폐쇄망 거버넌스 |

**고르는 기준**
- **빠르게·투명하게 시작** → Walking Labs식 파일 하네스.
- **강제력·모델 독립성·거버넌스가 중요** → AgentOS식 런타임.
- scenario1은 전자(파일 하네스)로 운영했다.

---

## 6. 하네스의 장단점

### 6-1. 장점 (scenario1에서 확실히 효과 본 것)
- **프롬프트 직접 지시의 확연한 감소.** 지시만 잘 닫아두면(세션 시작·종료 포함) 사람이 매번 끌고 가는 과정이 크게 줄고, 전체가 **완결적으로** 굴러간다.
- **진입점 정돈의 위력.** `Agent.md`에 세션 시작/종료·규약을 잘 정돈하니 **"Agent.md 읽고 준비해" 한마디로 충분**해졌다 (지시 비용 급감).
- **pre-commit 훅 자동 테스트** — 커밋 시점 검증이 확실히 효과적.
- **멀티 세션 연속성 + 완료 게이트** — 상태가 repo(SoR)에 남아 세션이 끊겨도 이어지고, 성급한 완료 선언을 차단.
- **감시 비용↓** — 위 모두가 "사람이 매번 안 봐도 되게" 만드는 방향.

### 6-2. 단점·비용 (scenario1 실측 + 안티패턴)
**운영 비용 (실측):**
- 정확히 지시를 닫는 데 **시간이 더 걸리고 계속 신경 써야** 한다.
- **사람 기억 의존** — 세션 시작/종료 트리거를 사람이 깜박하면 그대로 샌다.
- **권한 병목** — git 등이 `deny`면 사람 요청 대기, `ask`면 중지·판단 탈취. (해법: §7 브랜치 격리)
- **관측성 부재** — 세션 컨텍스트 예산·어떤 산출물이 실제로 쓰였는지를 못 본다.

**하네스가 실패하는 법 (안티패턴):**
- **기준 과잉** — 모든 판단을 문서화하려다 실행 속도가 사라짐. 하네스는 문서 양이 아니라 제어할 위험의 크기에 맞춘다.
- **검증 부재** — 좋은 말만 있고 통과 조건(AC)이 없음.
- **소유자 부재** — 규칙을 바꿀 책임자가 없어 오래된 규칙이 남음.
- **메타 중복** — 진실 소스가 둘 이상이라 서로 어긋남.
- **mock 자기검증** — 실 실행이 아닌 staged proxy로 "됐다"고 판단.
- 🔴 **동명 가짜 (정체성 미검증)** — intent를 안 닫아 이름만 같은 것을 진짜로 착각, "정확히 잘못된 것을 신뢰성 있게" 만듦. Part 1 부재의 대표 실패 (scenario1 실증, §7).

---

## 7. 레슨런 — scenario1을 하네스로 개발하며 얻은 것

> A to Z까지 하네스로 개발한 **scenario1**(HERMES 사고대응)의 실전 교훈. 각 레슨을 §8의 9개 면에 매핑. 더 깊은 회고(원인·개선 D1~D7·미규명): [[harness-engineering-lessons-scenario1]]

### Intent (앞단 — 가장 비싼 실패)
- 🔴 **L-I1. 의도를 계약으로 안 닫으면 동명 가짜를 신뢰성 있게 만든다.** scenario1에서 원한 건 실존 HERMES Agent였는데, intent를 닫지 않아 모델이 "HERMES Agent"라는 이름의 커스텀 LLM을 만들었다 — 기능은 유사하나 정체성이 가짜. 실행 하네스(Part 2)는 "이름이 HERMES인 게 동작한다"를 통과시켰지만 "실존 서비스인가(what)"는 아무도 안 물었다. 풍부한 배경 컨텍스트가 오히려 오해를 강화했다(Context≠Contract). → 대응: AC에 정체성 계약("실존 자산 사용, 동명 가짜 금지") + 보유 자산을 `assets.json`으로 하네스에 인지시킨다.
- **L-I2. 의도(기획)를 닫기 전엔 실행하지 않는다.** 기획 세션엔 실행 명령(`init.sh` 등)을 넣지 않고 문서·대화만. 기획 반복 → 완전 확인 → 환경 세팅 → 검증 → 구현 순.

### State / Instructions
- **L-S1. 상태 소스는 하나 — 메타 중복은 진실을 오염.** `dev-features.json`을 폐기, 모듈별 `feature-list.json` 하나만 단일 진실. 두 파일의 같은 ID가 다른 의미를 가져 혼란·환각을 낳았다.
- **L-S2. 의존성을 명시하고 읽기 순서를 박아라.** md 하네스는 파일 간 의존이 암묵적 — "하나만 읽어"는 전체를 못 끌어온다. 진입점에서 필요한 전부로의 **팬아웃**을 닫고, 작업 완료 시 **잔존 내용을 정리**(중복·옛 상태 → 충돌·환각 방지).
- **L-S3. 분배가 사람 지정에 의존하면 누락 시 무방비.** 세션 진입 시 읽을 파일을 사람이 지정 → 깜박하면 무방비, 브랜치 미설정 시 **남의 브랜치를 건드리는** 사고까지. → 진입 자동 로드 + 브랜치 가드.

### Verification
- **L-V1. 완료 판정은 사람만, 검증은 실 실행으로.** `e2e_verified`는 사용자만 마킹, 자기 선언 금지. 시연/검증 본체는 **실 LLM 작동**이지 mockup·스크립트 재생이 아니다 — "mockup과 픽셀이 다르다"는 무가치, "실제 응답을 처리 못 한다"가 가치.
- **L-V2. 검증 기준은 모듈 단위로 묶어 별도 파일에.** 기능 단위는 유닛테스트, **모듈 완성 타이밍에 한 번에 e2e** → "매 세션 검증" 부담 제거. `feature-list.json`엔 넣지 말 것(관심사 분리).

### Scope / 병렬
- **L-P1. 병렬은 쉽게 직렬로 무너진다.** worktree로 코드는 분리돼도 **메타 파일(progress/handoff/feature-list) 공유**·워크트리 미분리·운영 부담·대기로 한 세션에 묶였다. 멀티 에이전트 뷰 문제도 결국 이 멀티 세션 문제.
- **L-P2. 브랜치 격리 → 권한 확대 (해법).** 기능별 브랜치 + 분리 세션/워크트리 → 머지 후 브랜치 삭제. "git 꼬임" 걱정이 사라지므로 **권한을 넉넉히 줘도 안심** → `deny/ask` 병목과 메타 충돌을 한 레버로 해소.

### Lifecycle
- **L-L1. 핸드오프는 정규 파일에만, 세션은 clean state로 끝낸다.** `NEXT_SESSION.md` 같은 임시 파일 금지 — 정규 파일(progress·handoff·feature-list·BOOTSTRAP)에만 반영, scratch는 삭제. 다음 세션이 항상 같은 진입점을 갖게.

### Observability
- **L-O1. "옛 동작이 보임" → 코드 가설 전에 런타임부터.** 진단 순서: ① 서버 재기동 누락(`--reload` 없음) → ② 브라우저 정적 JS 캐시(Cache-Control 부재) → ③ 그 다음에야 코드/머지. 라이브 reproduce가 가설 탐색보다 빠르다.
- **L-O2. 세션 용량·산출물 효과가 안 보인다.** 단일 세션이 어디까지 효율적인지 몰라 **컨텍스트량을 감으로** 보며 진행. `reliability.md` 등이 실제로 쓰였는지도 불명 → 컨텍스트 예산·산출물 사용을 표면화해야.

> **종합:** scenario1의 가장 비싼 실패(L-I1)는 Part 1 부재에서 왔다 — 실행 하네스(Part 2)를 아무리 잘 둘러도 무엇을 닫을지 정하지 않으면 가장 비싼 순간(시연 직전)에 사람이 소환된다. 나머지(State·Verification·Scope·Lifecycle·Observability)는 Part 2의 살을 어떻게 단단히 하느냐의 교훈.

---

## 8. 체크리스트 — 하네스 한 벌의 9개 면 (레슨 연결)

하네스를 만들 때 점검할 9개 면. 오른쪽은 scenario1에서 깨졌던 레슨(§7).

| 면 | 점검 질문 | 어디서 | scenario1 레슨 |
|---|---|---|---|
| **Intent** | 무엇을 시킬지(goal·경계·성공 조건)를 닫았나 | Part 1 | 🔴 L-I1·L-I2 |
| **Control** | 도구·순서·권한·중단 조건으로 선택면을 줄였나 | 공통 | L-P2(권한) |
| **Instructions** | 지시가 모듈별로 쪼개졌나 (단일 거대 파일 X) | Part 2 | L-S2·L-S3 |
| **State (SoR)** | 상태가 repo에 영속되나 (컨텍스트 밖, 단일 진실) | Part 2 | L-S1·L-S2 |
| **Scope** | 한 번에 한 기능 + 명시적 done이 있나 | Part 2 | L-V2·L-P1 |
| **Lifecycle** | 초기화가 별도 단계이고, 매 세션이 clean state로 끝나나 | Part 2 | L-L1·L-S3 |
| **Verification** | 완료 주장을 실 증거로 검증하나 (E2E, 사람 판정) | 공통 | L-V1·L-V2 |
| **Observability** | 런타임·컨텍스트 예산·산출물 사용을 관측하나 | Part 2 | L-O1·L-O2 |
| **Contract** | 모델이 바뀌어도 유지되는 계약인가 | 공통 | L-I1(정체성 계약) |

---

## 9. 출처 · 관련 자원

**1차 출처**
- KT 특강 슬라이드: `~/Downloads/특강자료_session1.html`, `특강자료_session2.html` (이재규/Q00)
- [[Symposium]]: `20-code/Symposium/` (github.com/Q00/Symposium) — Part 1 인터뷰 레이어
- Walking Labs: github.com/walkinglabs/learn-harness-engineering · walkinglabs.github.io/learn-harness-engineering/ko/ — Part 2 커리큘럼

**실증·레슨런 출처 (scenario1)**
- [[project_scenario1]] (HERMES 사고대응) — §6·§7 레슨의 출처
- 상세 회고: [[harness-engineering-lessons-scenario1]] (원인 진단 · 5-서브시스템 매핑 · 개선 D1~D7 · TBD)
- 메모리 feedback: `feedback_dev_features_vs_feature_list`, `feedback_scenario1_tracking_meta`, `feedback_scenario1_demo_vs_real`, `feedback_scenario1_session_handoff_files`, `feedback_uvicorn_reload_trap`, `feedback_scenario1_static_cache`, `feedback_session_and_push_strategy`

**관련 자원 (실증 아님)**
- paper-mode (`01-workflow/llm-os/`) — 하네스로 만든 건 아니나, 원하는 하네스 구조의 **스킬 제작 시 도구로 참조 가능**.