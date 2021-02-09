import 'dart:async';
import 'package:console/console.dart';

void main() {
  var timer = TimeDisplay();

  Console.write('Waiting 10 Seconds ');
  timer.start();

  Future.delayed(Duration(seconds: 10)).then((_) {
    timer.stop();
    print('');
  });
}
