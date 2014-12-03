library console.test.base;

import 'package:laser/unittest_io.dart';
import 'package:console/console.dart';

void main([args, port]) {
  laser(port);

  var output = useStringStdout();
  output.terminalColumns = 80;
  output.terminalLines = 20;

  setUp(() => output.clear());
  
  group('base functions', () {
    test('centerCursor', () {
      Terminal.centerCursor();
      expect(output.str, equals(Terminal.ANSI_ESCAPE + "10;40H"));
    });
  });
}
