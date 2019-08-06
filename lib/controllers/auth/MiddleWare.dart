class MiddleWare {
  static MiddleWare shared = MiddleWare();
  _MiddleWare() {}

  double screenSize = 0;
}

String trim(String str) {
  // function definition
  assert(str != null);
  return str.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
}
