extension SafeLookup<E> on List<E> {
  E get(int index) {
    try {
      return this[index];
    } on Error {
      return null;
    }
  }
}