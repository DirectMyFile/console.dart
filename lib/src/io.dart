part of console;

void inheritIO(Process process, {String? prefix, bool lineBased = true}) {
  if (lineBased) {
    process.stdout
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .listen((String data) {
      if (prefix != null) {
        stdout.write(prefix);
      }
      stdout.writeln(data);
    });

    process.stderr
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .listen((String data) {
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
