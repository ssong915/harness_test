export const KEYWORDS = {
  accident: ["사고", "박았어", "충돌"],
  trouble: ["시동", "펑크", "견인"],
};

export function classify(input) {
  if (typeof input !== "string" || input.length === 0) return "ambiguous";
  for (const kw of KEYWORDS.accident) if (input.includes(kw)) return "accident";
  for (const kw of KEYWORDS.trouble) if (input.includes(kw)) return "trouble";
  return "ambiguous";
}
