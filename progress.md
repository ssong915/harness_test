# progress.md — 작업 체크포인트 로그

> 작업 단위가 끝날 때마다(harness P5) 한 줄씩 추가. 단일 진실은 `feature-list.json`, 여기엔 "무엇을·어떻게 했는지" 서사 체크포인트를 남긴다. 완료로 바뀐 항목의 옛 미완 기록은 정리한다 [L-S1, L-L1].

## 형식
`YYYY-MM-DD | F-XXX | <한 일> | 읽은 파일 / 갱신 파일 | 검증 결과 | 커밋`

## 로그
<!-- 최신이 위로 -->
- 2026-05-27 | F-008 | (P2→P3→P4→P5) feat/F-008 분리 → demo.html + serve.sh 작성. ES module import (router.js) + UI 컴포넌트 3종 render 함수 + chat→classify→배지 가시화 + 데모 버튼. python http.server 로 4개 리소스 200 OK 확인 (HTML/JS/JSON 두개). 사람이 e2e 통과 마킹. verification.json ui-shell unit/e2e 갱신. | 갱신: demo.html·serve.sh(신규), feature-list.json(F-008 done), verification.json(ui-shell verified_by_human=true), progress.md | 정적 구조 PASS, HTTP 200 PASS, e2e PASS (사람 마킹) | feat(ui-shell): F-008 (다음 커밋)
- 2026-05-27 | (P1' Intent Gate v2) | SEED constraints 무너짐 발견 — 외부 mockup HTML 부재 [L-I1, Context≠Contract]. SEED v2로 evolve: '자체 mockup 신규 구축'. assets.json 재작성(hermes-mockup → to-be-built, scenario-router/seoul-poi-data 추가). feature-list에 F-008(ui-shell) 추가, F-005 재정의, DOM 의존 기능들 depends_on에 F-008 추가. verification.json system 기준 + ui-shell 모듈 추가. | 갱신: SEED.md, assets.json, feature-list.json, verification.json, progress.md | 검증 N/A | (다음 커밋)
- 2026-05-26 | F-002 | (P7 close) feat/F-002를 main에 --no-ff 머지 후 브랜치 삭제. handoff.md를 F-003 선결조건(베이스 mockup 누락 결정 필요) + router.js 인터페이스로 갱신. | 갱신: handoff.md, progress.md | N/A | merge: F-002 (23c0c2b)
- 2026-05-26 | F-002 | (P2→P3→P4→P5→P6) feat/F-002 분리 → router.js (classify 3-way) + router.test.mjs (9 cases) 작성. node 유닛 9/9 PASS. 사람이 e2e_verified=true 마킹. verification.json router unit을 'node router.test.mjs'로 보강(기존 '수동 확인' 대체). 모듈 e2e는 F-003+F-004 done 시점으로 보류. evidence.commit 백필. | 갱신: router.js·router.test.mjs(신규), feature-list.json(F-002 done + commit), verification.json(router unit 보강), progress.md | unit PASS, 모듈 e2e 보류 | feat(router): F-002 (87cf0d0) + chore backfill (99746b9)
- 2026-05-26 | F-001 | (P7 close) feat/F-001을 main에 --no-ff 머지 후 브랜치 삭제. 작업트리 clean. handoff.md를 main 기준·F-002 시작 안내로 갱신. clean-state-checklist 7/7 충족. | 갱신: handoff.md, progress.md | N/A | merge: F-001 ... (64842b1)
- 2026-05-26 | F-001 | (P3→P4→P5→P6) 결정론적 Python 생성기로 carcenters.json + hospitals.json (각 25구×3=75 entries) 작성. node 유닛 체크 PASS. 사람이 e2e_verified=true 마킹. handoff.md에 스키마 인터페이스 기록. evidence.commit 백필. | 갱신: carcenters.json·hospitals.json(신규), feature-list.json(F-001 done + commit), verification.json(data verified_by_human=true), handoff.md, progress.md | unit PASS, e2e PASS (사람 마킹) | feat(data): F-001 (1ca1e39) + chore(F-001) backfill (a8c1650)
- 2026-05-26 | F-001 | (P2 start) F-001 선택 → feat/F-001 브랜치 분리 → in_progress 마킹. P3 개발 진입 준비. | 갱신: feature-list.json(F-001 status/branch), progress.md | 검증 보류 (P4) | 미커밋
- 2026-05-26 | (P1 Intent Gate) | Socrates 루프 4단계로 의도 닫음 — HERMES 데모에 3-way 시나리오 라우터 추가. assets.json에 HERMES 자산 3종 등록. main 베이스라인 커밋 1개 생성. | 읽음: AGENTS.md, deps.json, (모든 메타 템플릿) · 갱신: SEED.md, assets.json, feature-list.json(7개 기능), verification.json(4개 모듈), progress.md, .gitignore | 검증 N/A (기획 단계) | chore: harness scaffolding + close Seed

## 관측 메모 [L-O2]
<!-- 이번 세션에 실제로 읽고/쓴 하네스 산출물. 안 쓰인 파일이 누적되면 정리 후보. -->
- 사용됨 (최종): AGENTS.md, deps.json, SEED.md, assets.json, feature-list.json, verification.json, progress.md, handoff.md, clean-state-checklist.md, scripts/new-feature.sh, carcenters.json, hospitals.json.
- 미사용: reliability.md — 데모 성격상 latency/SLO 기준이 의미 약해 비워둠. 다음 세션에서 필요해지면 정의하고, 아니면 정리 후보.
- 단일 진실 검증: feature-list.json(F-001 done) ↔ git log(머지커밋 + 2개 기능 커밋) ↔ progress.md(체크포인트 4개) ↔ verification.json(verified_by_human=true) ↔ handoff.md(다음 시작점 명시) 모두 일관 [L-S1].
- 절차 관측: P1 Socrates에서 "openclaw → HERMES" 정정이 일찍 발생 → assets.json에 실존 자산으로 등록 → 후속 모든 단계에서 동명 가짜 구현 위험 차단됨 [L-I1].
