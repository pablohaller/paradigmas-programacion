function* squares(n) {
  return n < 0 ? [] : [...new Array(n + 1)].forEach((_, index) => {(yield index ** 2)});
}

[...squares(6)]
