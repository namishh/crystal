export function range(length, start = 1) {
  return Array.from({ length }, (_, i) => i + start);
}

export const getArrayOfKeys = (dict) => {
  const a = []
  for (var key in dict) {
    a.push(dict[key])
  }
  return a
}
