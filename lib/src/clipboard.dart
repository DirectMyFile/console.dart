part of console;

Clipboard getClipboard() {
  if (Platform.isMacOS) return OSXClipboard();
  if (Platform.isLinux && File('/usr/bin/xclip').existsSync()) {
    return XClipboard();
  }
  return null;
}

abstract class Clipboard {
  String getContent();

  void setContent(String content);
}

class OSXClipboard implements Clipboard {
  @override
  String getContent() {
    var result = Process.runSync('/usr/bin/pbpaste', []);
    if (result.exitCode != 0) {
      throw Exception('Failed to get clipboard content.');
    }
    return result.stdout.toString();
  }

  @override
  void setContent(String content) {
    Process.start('/usr/bin/pbpaste', []).then((process) {
      process.stdin.write(content);
      process.stdin.close();
    });
  }
}

class XClipboard implements Clipboard {
  @override
  String getContent() {
    var result =
        Process.runSync('/usr/bin/xclip', ['-selection', 'clipboard', '-o']);
    if (result.exitCode != 0) {
      throw Exception('Failed to get clipboard content.');
    }
    return result.stdout.toString();
  }

  @override
  void setContent(String content) {
    Process.start('/usr/bin/xclip', ['-selection', 'clipboard'])
        .then((process) {
      process.stdin.write(content);
      process.stdin.close();
    });
  }
}
