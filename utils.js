export function range(length, start = 1) {
  return Array.from({ length }, (_, i) => i + start);
}
