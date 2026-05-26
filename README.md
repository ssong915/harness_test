# harness-template

어떤 프로젝트에서도 **복사해서 바로 시작**하는 하네스 템플릿. 확률적 LLM을 결정론적으로 부리기 위한 실행 하네스(Part 2)를 파일 세트 + 구동 스킬로 제공하고, 의도 닫기(Part 1)를 앞단에 둔다.

> 설계 근거: [[harness-engineering-v2]] · 레슨런 [[harness-engineering-lessons-scenario1]]. scenario1을 하네스로 개발하며 얻은 교훈(L-xx)을 파일마다 임베딩했다.

## 쓰는 법 (Claude Code)

```bash
# 1) 새 프로젝트로 가져오기 — 이 repo의 .git(템플릿 이력·remote)은 가져오지 말 것.
#    택1:
#    (A) GitHub "Use this template" 로 새 repo 생성 (이력 없이 깨끗)  ← 권장
#    (B) git clone <this> myproj && cd myproj && rm -rf .git && git init
#    (C) rsync -a --exclude='.git' harness-template/ myproj/   (또는 cp -R 후 rm -rf myproj/.git)

# 2) 개인 식별 파일 생성 (gitignore 대상 — 템플릿만 커밋됨)
cp AGENTS.local.md.template AGENTS.local.md   # owner / workspace 기입
cp CLAUDE.md.template CLAUDE.md

# 3) repo 루트에서 세션 시작
claude
#    첫 명령: "md 읽어서 CLAUDE.md 참조 파일 사전 재구성해줘"
#    → 이후 harness 스킬이 P0(Bootstrap)부터 라이프사이클을 구동한다.
bash scripts/init.sh   # (선택) 환경/파일 점검
```

> ⚠️ 이 템플릿 자체가 git repo다. 위 (A)~(C) 중 하나로 **이력 없이** 시작해야 새 프로젝트가 템플릿의 remote로 푸시되는 사고를 막는다.

단일 개발자가 기본(`workspace = .`). 멀티 개발자는 `AGENTS.local.md` 의 workspace를 `devs/<owner>/` 로 두고 같은 파일 세트를 그 폴더에 복제한다.

## 라이프사이클 (harness 스킬)

`CLAUDE.md`(자동 로드) → `.claude/skills/harness/SKILL.md` 가 phase를 구동:

`P0 Bootstrap`(자동 읽기·브랜치 가드) → `P1 Intent Gate`(SEED 닫기, 미니 Socratic) → `P2 Pick One Feature`(브랜치 분리) → `P3 Develop` → `P4 Verify`(모듈 e2e, 사람 판정) → `P5 Record`(md/json) → `P6 Commit` → `P7 Session End`(clean-state).

## 파일 지도

| 파일 | 역할 | 레슨 |
|---|---|---|
| `CLAUDE.md.template` | 세션 진입점·부트스트랩 | — |
| `AGENTS.md` | 공통 운영 규칙 | L-S1·S2·S3·V1·V2·P1·P2·L1·I1·I2 |
| `AGENTS.local.md.template` | 개인 식별(owner/workspace) | L-S3 |
| `SEED.md` | Part 1 의도 계약(goal·constraints·AC) | L-I1·I2 |
| `assets.json` | 보유 자산 레지스트리(동명 가짜 방지) | L-I1 |
| `deps.json` | 의존성 + 읽기 순서/팬아웃 | L-S2 |
| `feature-list.json` | 작업 상태 단일 진실(한 번에 한 기능) | L-S1·P1·V2 |
| `verification.json` | 모듈 단위 검증 기준(feature-list와 분리) | L-V2 |
| `progress.md` | 체크포인트 로그 + 관측 메모 | L-S1·O2 |
| `handoff.md` | 세션 인계 진입점 | L-L1 |
| `clean-state-checklist.md` | 세션 종료 체크 | L-L1·O2 |
| `reliability.md` | SLO + 진단 순서 | L-O1·O2 |
| `scripts/new-feature.sh` | 기능별 브랜치 격리 | L-P2 |
| `scripts/init.sh` | 환경/파일 점검(env doctor) | — |
| `.claude/skills/harness/SKILL.md` | 라이프사이클 구동기 | 전부 |

## 한계

- **관측성(L-O2)은 완전 자동화 안 됨** — 컨텍스트 예산은 `/context` 로 사람이 확인, 산출물 사용은 `progress.md` 관측 메모로 수동 추적까지가 한계.
- 협업(멀티 개발자) 하네스는 scenario1에서 미검증(§1.6) — 단일 개발자 경로가 검증된 기본.
