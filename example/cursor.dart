import "package:console/console.dart";

void main() {
  var cursor = new Cursor();

  cursor.moveDown(3);
  cursor.write("3: This is the third line.");
  cursor.moveUp(1);
  cursor.write("2: This is the second line.");
  cursor.moveUp(1);
  cursor.write("1: This is the first line.");
}
