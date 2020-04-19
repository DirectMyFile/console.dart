import 'package:console/console.dart';

void main() {
  var pen = TextPen();

  for (var c in Color.getColors().entries) {
    pen.setColor(c.value);
    pen.text('${c.key}\n');
  }
  pen.print();
}
