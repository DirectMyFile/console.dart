import "dart:async";
import "package:console/console.dart";

void main() {
  var loader = new WideLoadingBar();
  var timer = loader.loop();

  new Future.delayed(const Duration(seconds: 5)).then((_) {
    timer.cancel();
  });
}
