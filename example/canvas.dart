import "package:console/console.dart";

void main() {
  var canvas = new Canvas(160, 160);
  canvas.toggle(1, 1);
  print(canvas.frame());
}