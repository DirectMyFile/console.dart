import "dart:async";

import "package:console/console.dart";

DrawingCanvas canvas = new DrawingCanvas(100, 100);

main() {
  Console.eraseDisplay(1);

  int l = 1;
  new Timer.periodic(const Duration(seconds: 2), (_) {
    l += 2;

    for (var i = 0; i < l; i++) {
      canvas.set(1, i + 1);
    }

    Console.moveCursor(row: 1, column: 1);

    print(canvas.frame());
  });
}
