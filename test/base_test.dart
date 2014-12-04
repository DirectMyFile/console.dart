library console.test.base;

import 'package:laser/unittest_io.dart';
import 'package:console/console.dart';

void main([args, port]) {
  laser(port);

  var output = new BufferTerminalAdapter();

  setUp(() => output.clear());
  
  group('base functions', () {
    test('centerCursor', () {
      Terminal.centerCursor();
      expect(output.toString(), equals(Terminal.ANSI_ESCAPE + "10;40H"));
    });
  });
}
