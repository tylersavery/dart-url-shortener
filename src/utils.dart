import 'dart:math';

String generateRandomString(int len, [String chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz']) {
  var r = Random();
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}
