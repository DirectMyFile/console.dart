import "package:console/console.dart";

import "dart:io";

void main() {
  var canvas = new DrawingCanvas(120, 120);

  void draw() {
    for (var x = 1; x < canvas.width; x++) {
      for (var y = 1; y < canvas.height; y++) {
        canvas.set(x, y);
      }
    }
    print(canvas.frame());
  }

  while (true) {
    draw();
    sleep(const Duration(milliseconds: 16));
  }
}
