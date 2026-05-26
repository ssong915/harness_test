# progress.md — 작업 체크포인트 로그

> 작업 단위가 끝날 때마다(harness P5) 한 줄씩 추가. 단일 진실은 `feature-list.json`, 여기엔 "무엇을·어떻게 했는지" 서사 체크포인트를 남긴다. 완료로 바뀐 항목의 옛 미완 기록은 정리한다 [L-S1, L-L1].

## 형식
`YYYY-MM-DD | F-XXX | <한 일> | 읽은 파일 / 갱신 파일 | 검증 결과 | 커밋`

## 로그
<!-- 최신이 위로 -->
- 2026-05-26 | F-001 | (P3→P4→P5) 결정론적 Python 생성기로 carcenters.json + hospitals.json (각 25구×3=75 entries) 작성. node 유닛 체크 PASS. 사람이 e2e_verified=true 마킹. handoff.md에 스키마 인터페이스 기록. | 갱신: carcenters.json·hospitals.json(신규), feature-list.json(F-001 done), verification.json(data verified_by_human=true), handoff.md, progress.md | unit PASS, e2e PASS (사람 마킹) | feat(data): F-001 ... (다음 커밋)
- 2026-05-26 | F-001 | (P2 start) F-001 선택 → feat/F-001 브랜치 분리 → in_progress 마킹. P3 개발 진입 준비. | 갱신: feature-list.json(F-001 status/branch), progress.md | 검증 보류 (P4) | 미커밋
- 2026-05-26 | (P1 Intent Gate) | Socrates 루프 4단계로 의도 닫음 — HERMES 데모에 3-way 시나리오 라우터 추가. assets.json에 HERMES 자산 3종 등록. main 베이스라인 커밋 1개 생성. | 읽음: AGENTS.md, deps.json, (모든 메타 템플릿) · 갱신: SEED.md, assets.json, feature-list.json(7개 기능), verification.json(4개 모듈), progress.md, .gitignore | 검증 N/A (기획 단계) | chore: harness scaffolding + close Seed

## 관측 메모 [L-O2]
<!-- 이번 세션에 실제로 읽고/쓴 하네스 산출물. 안 쓰인 파일이 누적되면 정리 후보. -->
- 사용됨: AGENTS.md, deps.json, SEED.md, assets.json, feature-list.json, verification.json, progress.md
- 미사용(이번 세션): handoff.md(아직 인계 사항 없음 — 첫 기능 끝나면 갱신), reliability.md(현 단계에서 SLO 정의 보류 — 데모 성격상 latency 기준이 의미 약함), clean-state-checklist.md(P7에서 사용 예정)
- 컨텍스트 여유: /context 로 확인 권장
