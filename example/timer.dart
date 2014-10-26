import "dart:async";
import "package:console/console.dart";

void main() {
  var timer = new TimeDisplay();
  
  timer.start();
  
  new Future.delayed(new Duration(seconds: 10)).then((_) {
    timer.stop();
  });
}