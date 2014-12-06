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
      expect(output, ansi("10;40H"));
    });
    
    test('showCursor', () {
      Terminal.showCursor();
      expect(output, ansi("?25h"));
    });
    
    test('hideCursor', () {
      Terminal.hideCursor();
      expect(output, ansi("?25l"));
    });
  });
}

class ANSIMatcher extends Matcher {
  final String value;
  
  const ANSIMatcher(this.value);
  
  @override
  Description describe(Description description) {
    return description;
  }

  @override
  bool matches(item, Map matchState) {
    return item.toString() == "${Terminal.ANSI_ESCAPE}${value}";
  }
}

Matcher ansi(String value) => new ANSIMatcher(value);