extension ContainsWhere<E> on Iterable<E> {
  bool containsWhere(bool Function(E) test) {
    return where(test).isNotEmpty;
  }
}
