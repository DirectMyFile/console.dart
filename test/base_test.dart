library console.test.base;

import 'dart:convert';
import 'package:test/test.dart';
import 'package:console/console.dart';

void main([args, port]) {
  final output = new BufferConsoleAdapter();

  setUpAll(() => Console.adapter = output);

  setUp(() => output.clear());

  group('base functions', () {
    test('centerCursor', () {
      Console.centerCursor();
      expect(output, ansi('10;40H'));
    });

    test('hideCursor', () {
      Console.hideCursor();
      expect(output, ansi('?25l'));
    });

    test('showCursor', () {
      Console.showCursor();
      expect(output, ansi('?25h'));
    });

    test('moveCursorForward', () {
      Console.moveCursorForward(1);
      expect(output, ansi('1C'));
    });

    test('moveCursorBack', () {
      Console.moveCursorBack(1);
      expect(output, ansi('1D'));
    });

    test('moveCursorUp', () {
      Console.moveCursorUp(1);
      expect(output, ansi('1A'));
    });

    test('moveCursorDown', () {
      Console.moveCursorDown(1);
      expect(output, ansi('1B'));
    });
  });
}

class ANSIMatcher extends Matcher {
  final String value;

  const ANSIMatcher(this.value);

  @override
  Description describe(Description description) => description;

  @override
  bool matches(item, Map matchState) =>
      item.toString() == '${Console.ANSI_ESCAPE}${value}';

  @override
  Description describeMismatch(item, Description mismatchDescription,
          Map matchState, bool verbose) =>
      mismatchDescription.add('${utf8.encode(item.toString())} != '
          ' ${utf8.encode(value.toString())}');
}

Matcher ansi(String value) => new ANSIMatcher(value);
