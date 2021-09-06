extension SafeLookup<E> on List<E> {
  E? get(int index) {
    try {
      return this[index];
    } on Error {
      return null;
    }
  }
}

extension ListWithIndex<E> on List<E> {
  Iterable<T> mapIndex<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}