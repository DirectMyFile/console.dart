# Console

A Console Library for Epicness

## Usage

This library does not work in browsers (for a hopefully obvious reason).

```dart
import "package:console/console.dart";

void main() {
  // Initialize the Console. Throws an exception if advanced terminal features are not supported.
  Console.init();
  
  // Use the library.
}
```

## Unittesting

You can unittest the output produced by this library (and thus your own app that uses this lib). Here is an example:


```dart
library somelib.test;

import 'package:unittest/unittest.dart';
import 'package:console/console.dart';

void main() {

  // Configures Terminal to use a StringBuffer() instead of stdout.
  var output = useStringStdout();
  output.terminalColumns = 80;
  output.terminalLines = 20;

  // makes sure to clear output between test runs
  setUp(() => output.clear());

  group('base functions', () {
    test('centerCursor', () {
      Terminal.centerCursor();
      expect(output.str, equals(Terminal.ANSI_ESCAPE+"10;40H"));
    });
  });
}
```