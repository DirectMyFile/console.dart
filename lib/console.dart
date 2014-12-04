library console;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

part 'src/base.dart';
part 'src/clipboard.dart';
part 'src/format.dart';
part 'src/icons.dart';
part 'src/io.dart';
part 'src/progress.dart';
part 'src/prompt.dart';
part 'src/timer.dart';
part 'src/tree.dart';
part 'src/color.dart';
part 'src/keyboard.dart';

TerminalAdapter terminalAdapter = new StdioTerminalAdapter();

abstract class TerminalAdapter {
  int get rows;
  int get columns;
  
  void write(String data);
  void writeln(String data);
  String read();
  int readByte();
  Stream<List<int>> byteStream();
  
  bool get echoMode;
       set echoMode(bool value);
  bool get lineMode;
       set lineMode(bool value);
}

class StdioTerminalAdapter extends TerminalAdapter {
  @override
  int get columns => stdout.terminalColumns;
  @override
  int get rows => stdout.terminalLines;

  @override
  String read() => stdin.readLineSync();

  @override
  Stream<List<int>> byteStream() => stdin;

  @override
  void write(String data) {
    console.log.write(data);
  }

  @override
  void writeln(String data) {
    console.log.writeln(data);
  }

  @override
  set echoMode(bool value) {
    stdin.echoMode = value;
  }

  @override
  bool get echoMode => stdin.echoMode;

  @override
  set lineMode(bool value) {
    stdin.lineMode = value;
  }

  @override
  bool get lineMode => stdin.lineMode;

  @override
  int readByte() => stdin.readByteSync();
}