import 'dart:math';

String getRandomId() {
  final random = Random();
  return random.nextInt(1000000000).toRadixString(16);
}
