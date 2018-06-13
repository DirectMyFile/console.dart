import "dart:async";
import "dart:math" as Math;

import "package:console/console.dart";
import "package:console/utils.dart";

DrawingCanvas canvas = new DrawingCanvas(160, 160);

void main() {
  new Timer.periodic(new Duration(milliseconds: 1000 ~/ 24), (t) {
    draw();
  });
}

void draw() {
  canvas.clear();
  var time = new DateTime.now();
  bresenham(
    80,
    80,
    sin(time.hour / 24, 30),
    160 - cos(time.hour / 24, 30),
    canvas.set,
  );
  bresenham(
    80,
    80,
    sin(time.minute / 60, 50),
    160 - cos(time.minute / 60, 50),
    canvas.set,
  );

  bresenham(
    80,
    80,
    sin(time.second / 60 + (time.millisecondsSinceEpoch % 1000 / 60000), 75),
    160 -
        cos(time.second / 60 + (time.millisecondsSinceEpoch % 1000) / 60000,
            75),
    canvas.set,
  );
  Console.write(canvas.frame());
}

num sin(num i, num l) {
  return (Math.sin(i * 2 * Math.pi) * l + 80).floor();
}

num cos(num i, num l) {
  return (Math.cos(i * 2 * Math.pi) * l + 80).floor();
}
