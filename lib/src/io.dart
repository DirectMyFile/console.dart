part of console;

// Set up Terminal to use a StringBuffer based stdout. Useful for testing.
Stdout useStringStdout([Stdout custom]) {
  _STDOUT = custom !=null ? custom : new StringBufferStdout();
  return _STDOUT;
}

class StringBufferStdout implements Stdout {
  bool hasTerminal = true;
  int terminalColumns = 80;
  int terminalLines = 20;

  StringBuffer buffer;
  StringBufferStdout() {
    buffer = new StringBuffer();
  }

  String get str => buffer.toString();
  void clear() => buffer.clear();

  Encoding get encoding => UTF8;
  void set encoding(Encoding encoding) {}
  void write(object) => buffer.write(object);
  void writeln([object = "" ]) => buffer.writeln(object);
  void writeAll(objects, [sep = ""]) => buffer.writeAll(objects, sep);
  void add(List<int> data) => buffer.write(data.join());
  void addError(error, [StackTrace stackTrace]) => buffer.write(error);
  void writeCharCode(int charCode) => buffer.writeCharCode(charCode);
  Future addStream(Stream<List<int>> stream) => stream.listen((data) => buffer.write(data)).asFuture();
  Future flush() => new Future.value();
  Future close() => new Future.value();
  Future get done => new Future.value();
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
