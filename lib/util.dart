extension ListUtils<T> on List<T> {
  num sumBy(num Function(T element) f) {
    return map(f).reduce((x, y) => x + y);
  }
}
