# Console

A high-level console library.

## Features

- Console Colors (ANSI)
- Icons (UTF-8)
- Keyboard Capture
- Experimental Clipboard Support
- Progress Bars
- Flexible Prompts
- Shell Prompts
- Choosers
- Fancy Formatting
- Loading Bars
- Timer (like pub's timer)
- Fancy Trees (like the npm dependency trees)
- Simple Unit Testing

## Usage

This library does not work in browsers (for a hopefully obvious reason).

```dart
import "package:console/console.dart";

void main() {
  // Initialize the Console. Throws an exception if advanced terminal features are not supported.
  Console.init();
  
  // Use the library...
}
```

## Unit Testing

You can test the output produced by this library (and thus your own project that uses this library). Here is an example:

```dart
import "package:test/test.dart";
import "package:console/console.dart";

void main() {
  final output = new BufferConsoleAdapter();

  setUpAll(() => Console.adapter = output);

  // Clear output between test runs
  setUp(() => output.clear());

  group('base functions', () {
    test('centerCursor', () {
      Console.centerCursor();
      expect(output.toString(), '${Console.ANSI_ESCAPE}10;40H');
    });
  });
}
```
