#!/usr/bin/env bash
# 기능별 브랜치 격리 [L-P2]. 기능 = 브랜치 = 세션 1:1.
# 격리가 돼 있으면 git이 꼬여도 브랜치 단위로 폐기 가능 → git 권한을 넉넉히 줘도 안전(deny/ask 병목 회피).
# 사용: scripts/new-feature.sh <feature-id> [base-branch]
set -euo pipefail

FID="${1:?feature-id 필요 (예: F-001)}"
BASE="${2:-main}"

# 작업트리가 깨끗한지 확인 (다른 작업과 섞이지 않게)
if [ -n "$(git status --porcelain)" ]; then
  echo "✗ 작업트리가 dirty 합니다. 커밋/스태시 후 다시 실행하세요." >&2
  exit 1
fi

git fetch --quiet origin "$BASE" 2>/dev/null || true
git switch -c "feat/${FID}" "$BASE" 2>/dev/null || git switch -c "feat/${FID}"
echo "✓ 브랜치 feat/${FID} (base=${BASE}) 생성·전환. 기능 완료·머지 후 'git branch -d feat/${FID}' 로 삭제하세요."
