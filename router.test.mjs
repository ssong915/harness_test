import { classify } from "./router.js";

const CASES = [
  ["사고났어", "accident"],
  ["차에 박았어", "accident"],
  ["충돌했어 도와줘", "accident"],
  ["시동이 안 걸려", "trouble"],
  ["타이어 펑크났어", "trouble"],
  ["견인 좀 불러줘", "trouble"],
  ["도와줘", "ambiguous"],
  ["", "ambiguous"],
  ["안녕", "ambiguous"],
];

let failed = 0;
for (const [input, expected] of CASES) {
  const got = classify(input);
  const ok = got === expected;
  console.log(`${ok ? "✓" : "✗"} classify(${JSON.stringify(input)}) → ${got} ${ok ? "" : `(expected ${expected})`}`);
  if (!ok) failed++;
}

if (failed > 0) {
  console.error(`\n${failed} / ${CASES.length} failed`);
  process.exit(1);
}
console.log(`\nPASS — ${CASES.length} / ${CASES.length}`);
