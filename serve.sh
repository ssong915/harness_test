#!/usr/bin/env bash
# demo.html 을 ES module이 동작하는 환경에서 띄우는 헬퍼.
# Chrome/Firefox 는 file:// 의 ES module import 를 막기 때문에 로컬 서버 필요.
# 사용: bash serve.sh   →   http://localhost:8000/demo.html
set -euo pipefail
PORT="${1:-8000}"
echo "▶ HERMES demo at http://localhost:${PORT}/demo.html"
echo "  (Ctrl+C 로 종료)"
exec python3 -m http.server "$PORT"
