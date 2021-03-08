import 'package:console/console.dart';

void main() {
  Keyboard.init();

  Keyboard.bindKey('up').listen((_) {
    print('Up.');
  });

  Keyboard.bindKey('down').listen((_) {
    print('Down.');
  });
}
