part of console;

class BufferTerminalAdapter extends TerminalAdapter {
  StringBuffer buffer = new StringBuffer();
  String input = "";
  
  @override
  int get columns => 80;
  @override
  int get rows => 20;
  
  @override
  String read() => input;

  @override
  Stream<List<int>> byteStream() {
    var c = new StreamController();
    new Future(() {
      c.add(input.codeUnits);
      c.add("\n".codeUnits);
    });
    return c.stream;
  }

  @override
  void write(String data) {
    buffer.write(data);
  }

  @override
  void writeln(String data) {
    buffer.writeln(data);
  }

  bool echoMode = true;
  bool lineMode = true;

  @override
  int readByte() => 0;
}

void inheritIO(Process process, {String prefix, bool lineBased: true}) {
  if (lineBased) {
    process.stdout.transform(UTF8.decoder).transform(new LineSplitter()).listen((String data) {
      if (prefix != null) {
        stdout.write(prefix);
      }
      stdout.writeln(data);
    });
    
    process.stderr.transform(UTF8.decoder).transform(new LineSplitter()).listen((String data) {
      if (prefix != null) {
        stderr.write(prefix);
      }
      stderr.writeln(data);
    });
  } else {
    process.stdout.listen((data) => stdout.add(data));
    process.stderr.listen((data) => stderr.add(data));
  }
}
