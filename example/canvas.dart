import 'package:console/console.dart';

void main() async {
  var canvas = ConsoleCanvas(defaultSpec: PixelSpec(color: 0));

  for (var i = 0; i < 5; i++) {
    canvas.setPixel(i, i, 170);
  }

  canvas.flush();
}
