class Clock {
  const Clock._();

  static int nowMillis() => DateTime.now().millisecondsSinceEpoch;
}
