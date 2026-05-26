#!/usr/bin/env python3
"""Measure tokens/second for OpenRouter free-tier models. 3 runs each, average reported."""
import os, sys, time, json, urllib.request, urllib.error

API_KEY = os.environ["OPENROUTER_API_KEY"]
URL = "https://openrouter.ai/api/v1/chat/completions"
PROMPT = "Explain how a transformer neural network works in about 200 words."
RUNS = 3

MODELS = [
    ("Owl Alpha",            "openrouter/owl-alpha"),
    ("GLM 4.5 Air",          "z-ai/glm-4.5-air:free"),
    ("Qwen3 Coder 480B",     "qwen/qwen3-coder:free"),
    ("Nemotron 3 Super 120B","nvidia/nemotron-3-super-120b-a12b:free"),
    ("MiniMax M2.5",         "minimax/minimax-m2.5:free"),
]

def call(model_id):
    body = json.dumps({
        "model": model_id,
        "messages": [{"role": "user", "content": PROMPT}],
        "max_tokens": 400,
    }).encode()
    req = urllib.request.Request(
        URL,
        data=body,
        headers={
            "Authorization": f"Bearer {API_KEY}",
            "Content-Type": "application/json",
        },
        method="POST",
    )
    t0 = time.perf_counter()
    try:
        with urllib.request.urlopen(req, timeout=180) as resp:
            data = json.loads(resp.read())
    except urllib.error.HTTPError as e:
        return None, None, f"HTTP {e.code}: {e.read().decode()[:200]}"
    except Exception as e:
        return None, None, f"ERR: {type(e).__name__}: {e}"
    elapsed = time.perf_counter() - t0
    if "error" in data:
        return None, None, f"API error: {json.dumps(data['error'])[:200]}"
    usage = data.get("usage") or {}
    ct = usage.get("completion_tokens")
    if not ct:
        return None, None, f"no completion_tokens in usage: {usage}"
    return ct, elapsed, None

results = []
for name, mid in MODELS:
    print(f"\n=== {name} ({mid}) ===", flush=True)
    runs = []
    err = None
    for i in range(RUNS):
        ct, el, e = call(mid)
        if e:
            print(f"  run {i+1}: {e}", flush=True)
            err = e
            break
        tps = ct / el
        print(f"  run {i+1}: {ct} tok in {el:.2f}s = {tps:.2f} t/s", flush=True)
        runs.append((ct, el, tps))
        time.sleep(1)
    if runs:
        avg_tps = sum(r[2] for r in runs) / len(runs)
        avg_el  = sum(r[1] for r in runs) / len(runs)
        avg_ct  = sum(r[0] for r in runs) / len(runs)
        results.append((name, mid, avg_tps, avg_ct, avg_el, len(runs), None))
    else:
        results.append((name, mid, None, None, None, 0, err))

print("\n\n## Tokens/sec results (avg of 3 runs)\n")
print("| 모델 | OpenRouter ID | 평균 t/s | 평균 출력 토큰 | 평균 응답 시간 | 비고 |")
print("|------|---------------|---------:|---------------:|---------------:|------|")
for name, mid, tps, ct, el, n, err in results:
    if tps is None:
        print(f"| {name} | `{mid}` | N/A | N/A | N/A | {err[:80]} |")
    else:
        note = "" if n == 3 else f"{n}회만 성공"
        print(f"| {name} | `{mid}` | **{tps:.2f}** | {ct:.0f} | {el:.2f}s | {note} |")
