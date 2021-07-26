part of console;

Clipboard? getClipboard() {
  if (Platform.isMacOS) return OSXClipboard();
  if (Platform.isLinux && File('/usr/bin/xclip').existsSync()) {
    return XClipboard();
  }
  if (Platform.isWindows) return WinClipboard();
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

class WinClipboard implements Clipboard {
  @override
  String getContent() {
    OpenClipboard(NULL);
    if (IsClipboardFormatAvailable(CF_TEXT) == FALSE) return '';

    var hg = GetClipboardData(CF_TEXT);
    if (hg == NULL) return '';

    var ptstr = GlobalLock(hg);

    GlobalUnlock(hg);
    CloseClipboard();

    return ptstr.cast<Utf8>().toDartString();
  }

  @override
  void setContent(String content) {
    var ptstr = content.toNativeUtf8();

    OpenClipboard(NULL);
    EmptyClipboard();
    SetClipboardData(CF_TEXT, ptstr.address);
    CloseClipboard();
  }
}
