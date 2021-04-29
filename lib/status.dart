class Status {
  final String _value;
  const Status(this._value);
  @override
  String toString() => 'Status.$_value';

  static const none = Status('NONE');
  static const timeoutError = Status('TIME_OUT_ERROR');
}