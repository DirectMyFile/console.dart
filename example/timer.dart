import "dart:async";
import "package:console/console.dart";

void main() {
  var timer = new TimeDisplay();

  Terminal.write("Waiting 10 Seconds ");
  timer.start();
  
  new Future.delayed(new Duration(seconds: 10)).then((_) {
    timer.stop();
    print("");
  });
}
