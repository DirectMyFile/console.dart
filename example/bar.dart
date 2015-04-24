import "dart:async";

import "package:console/console.dart";

Canvas canvas = new Canvas(100, 100);

main() {
  Console.eraseDisplay(1);

  int l = 10;
  new Timer.periodic(new Duration(seconds: 2), (_) {
    l += 1;

    for (var i = 0; i < l; i++) {
      canvas.set(i, i);
    }

    Console.moveCursor(row: 1, column: 1);

    print(canvas.frame());
  });
}
