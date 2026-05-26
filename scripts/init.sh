#!/usr/bin/env bash
# 세션 환경 점검(env doctor) — 초기화는 별도 단계 [Part 2: Session Lifecycle].
# 환경을 강제로 바꾸지 않고 점검·안내만 한다(안전).
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"

ok(){ printf "  ✓ %s\n" "$1"; }
warn(){ printf "  ! %s\n" "$1"; }
err(){ printf "  ✗ %s\n" "$1"; }

echo "== harness env doctor =="
echo "  workspace: $ROOT"

# git
command -v git >/dev/null && ok "git ($(git --version))" || err "git 미설치"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  ok "git repo (branch: $(git branch --show-current))"
else
  warn "git repo 아님 — 'git init' 권장"
fi

# 부트스트랩 파일 점검
echo "== 부트스트랩 파일 =="
[ -f CLAUDE.md ] && ok "CLAUDE.md 존재" || warn "CLAUDE.md 없음 — cp CLAUDE.md.template CLAUDE.md"
[ -f AGENTS.local.md ] && ok "AGENTS.local.md 존재" || warn "AGENTS.local.md 없음 — cp AGENTS.local.md.template AGENTS.local.md 후 owner/workspace 기입"
for f in AGENTS.md SEED.md deps.json feature-list.json verification.json assets.json progress.md handoff.md clean-state-checklist.md; do
  [ -f "$f" ] && ok "$f" || warn "$f 없음"
done

echo "== 다음 단계 =="
echo "  1) (Claude Code) cp AGENTS.local.md.template AGENTS.local.md  → owner/workspace 기입"
echo "  2) cp CLAUDE.md.template CLAUDE.md"
echo "  3) repo 루트에서 claude 실행 → harness 스킬 P0(Bootstrap)부터"
