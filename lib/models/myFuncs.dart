import 'dart:math';

String randomChatId(){
  var rng = new Random();
  var num = "";
  for (var i = 0; i < 5; i++) {
    num += rng.nextInt(100).toString();
  }
  return num;
}