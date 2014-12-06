import "dart:async";
import "package:console/console.dart";

void main() {
  var loader = new WideLoadingBar();
  var timer = loader.loop();
  
  new Future.delayed(new Duration(seconds: 5)).then((_) {
    timer.cancel();
  });
}