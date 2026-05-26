# Vendored Skills (frozen)

이 디렉토리의 일부 스킬은 외부 레포에서 **버전을 고정해 복사(vendoring)** 한 것이다.
**upstream 레포가 업데이트돼도 따라가지 않는다.** 필요하면 *이 복사본 위에서* 직접 확장한다(로컬 개발 OK).

## Symposium (Part 1 — 의도 닫기)

- 출처: `git@github.com:Q00/Symposium.git`
- 고정 버전: **v0.1.0** / commit **`1fdf881eb74aa9ff3fdc6f82bc0e99bf221b6f32`** (2026-05-14)
- 라이선스: MIT (© Symposium contributors) — 전문은 `LICENSE-symposium.txt`
- vendoring 일시: 2026-05-24
- 정책: **DO NOT auto-update from upstream.** 서브모듈·심링크가 아닌 *얼린 복사본*이므로 의도적으로 갱신하지 않는 한 고정. 갱신이 필요하면 이 파일에 새 commit을 명시하고 의식적으로 재복사한다.

### 포함된 스킬 (vendored)
- `wonder/`, `reflect/`, `refine/`, `restate/` — Socratic 4단계
- `socrates/` — 4단계를 Ralph 루프로 묶어 Seed를 닫는 오케스트레이터
- `ontology/`, `evolve-step/`, `interview-harness/` — 경계 정의·사각지대·수렴

### 하네스와의 연결
- 하네스 Part 1(의도 게이트)은 **`socrates` 를 호출**해 Seed를 닫는다.
- Symposium은 Seed를 `.symposium/scratch/socrates.md` 의 `## Seed` 에 쓴다. 하네스 오케스트레이터가 그 결과를 본 템플릿의 **`SEED.md`** 로 옮겨, 이후 Part 2가 `SEED.md` 를 단일 입력으로 읽게 한다.

## Native 스킬 (vendored 아님 — 이 템플릿 소유)
- `harness/` 및 `harness-*` (bootstrap/feature/verify/record/close) — Part 2 실행 라이프사이클. 레슨런에서 도출된 것으로 외부 자산이 아니다.
