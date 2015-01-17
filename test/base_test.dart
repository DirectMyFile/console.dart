library console.test.base;

import 'package:laser/unittest_io.dart';
import 'package:console/console.dart';

void main([args, port]) {
  laser(port);

  var output = new BufferTerminalAdapter();

  setUp(() => output.clear());
  
  group('base functions', () {
    test('centerCursor', () {
      Console.centerCursor();
      expect(output, ansi("10;40H"));
    });
    
    test('hideCursor', () {
      Console.hideCursor();
      expect(output, ansi("?25l"));
    });
    
    test('showCursor', () {
      Console.showCursor();
      expect(output, ansi("?25h"));
    });
    
    test('moveCursorForward', () {
      Console.moveCursorForward(1);
      expect(output, ansi("1C"));
    });
    
    test('moveCursorBack', () {
      Console.moveCursorForward(1);
      expect(output, ansi("1D"));
    });
    
    test('moveCursorUp', () {
      Console.moveCursorForward(1);
      expect(output, ansi("1A"));
    });
    
    test('moveCursorDown', () {
      Console.moveCursorForward(1);
      expect(output, ansi("1B"));
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
    return item.toString() == "${Console.ANSI_ESCAPE}${value}";
  }
}

Matcher ansi(String value) => new ANSIMatcher(value);