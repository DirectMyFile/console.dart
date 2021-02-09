import 'dart:async';

import 'package:console/console.dart';

DrawingCanvas canvas = DrawingCanvas(100, 100);

void main() {
  Console.eraseDisplay(1);

  var l = 1;
  Timer.periodic(const Duration(seconds: 2), (_) {
    l += 2;

    for (var i = 0; i < l; i++) {
      canvas.set(1, i + 1);
    }

    Console.moveCursor(row: 1, column: 1);

    print(canvas.frame());
  });
}
