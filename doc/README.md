# doc/ — 이 템플릿이 *왜* 이렇게 만들어졌는가

이 폴더는 템플릿의 구조·스킬·파일 세트가 어떤 근거에서 나왔는지를 설명한다. 코드(템플릿)만 보면 "무엇"은 알 수 있지만 "왜"는 알 수 없어서 함께 둔다.

| 파일 | 내용 |
|---|---|
| `harness-engineering-v2-deck.html` | 개념 슬라이드 덱 — 빠르게 훑는 용도 (브라우저에서 열기) |
| `harness-engineering-v2.md` | 개념 노트 — 하네스가 왜 필요한가 / Part 1(의도, Symposium·Ouroboros) + Part 2(실행, Walking Labs) 아키텍처 / 장단점 / 9개 면 체크리스트 |
| `harness-engineering-lessons-scenario1.md` | **레슨런** — scenario1을 하네스로 개발하며 얻은 교훈(L-I1·S1·S2·S3·V1·V2·P1·P2·L1·O1·O2). 템플릿의 각 파일·스킬에 임베딩된 설계 결정의 출처. |

## 구조 ↔ 근거 매핑 (요약)

- **Part 1 = vendored Symposium**(`.claude/skills/` 의 wonder/…/socrates) — 개념 노트 §4. "이미 있는 자산을 재사용한다"는 레슨(L-I1)에 따라 새로 만들지 않고 고정 복사.
- **Part 2 = native 하네스 스킬**(`harness` 오케스트레이터 + bootstrap/intent/feature/verify/record/close) — 개념 노트 §5-1(Walking Labs 5+1 서브시스템). 레슨런의 L-xx가 각 스킬의 Gate·State Contract로 들어가 있다.
- **파일 세트**(SEED/assets/deps/feature-list/verification/progress/handoff/clean-state/reliability) — 레슨런이 "있었으면" 했던 것들의 구현. `harness-engineering-lessons-scenario1.md` 의 개선안 D1~D7과 대응.

> 참고: 두 `.md` 는 Obsidian vault 노트라 `[[위키링크]]` 가 포함돼 있다. 이 repo 안에서는 링크가 해석되지 않지만 본문은 그대로 읽힌다. 원본·갱신본은 vault(`00-concepts/`, `99-meta/planning/`)에 있다.
