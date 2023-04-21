class MyPersonalHttpException implements Exception {
  final String message;

  MyPersonalHttpException(this.message);
  @override
  String toString() {
    return message;
    // return super.toString();
  }
}
