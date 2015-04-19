part of console;

abstract class KeyCode {
  static const String UP = "${Console.ANSI_ESCAPE}A";
  static const String DOWN = "${Console.ANSI_ESCAPE}B";
  static const String RIGHT = "${Console.ANSI_ESCAPE}C";
  static const String LEFT = "${Console.ANSI_ESCAPE}D";

  static const String HOME = "${Console.ANSI_ESCAPE}H";
  static const String END = "${Console.ANSI_ESCAPE}F";

  static const String F1 = "${Console.ANSI_ESCAPE}M";
  static const String F2 = "${Console.ANSI_ESCAPE}N";
  static const String F3 = "${Console.ANSI_ESCAPE}O";
  static const String F4 = "${Console.ANSI_ESCAPE}P";
  static const String F5 = "${Console.ANSI_ESCAPE}Q";
  static const String F6 = "${Console.ANSI_ESCAPE}R";
  static const String F7 = "${Console.ANSI_ESCAPE}S";
  static const String F8 = "${Console.ANSI_ESCAPE}T";
  static const String F9 = "${Console.ANSI_ESCAPE}U";
  static const String F10 = "${Console.ANSI_ESCAPE}V";
  static const String F11 = "${Console.ANSI_ESCAPE}W";
  static const String F12 = "${Console.ANSI_ESCAPE}X";

  static const String INS = "${Console.ANSI_ESCAPE}2~";
  static const String DEL = "${Console.ANSI_ESCAPE}3~";
  static const String PAGE_UP = "${Console.ANSI_ESCAPE}5~";
  static const String PAGE_DOWN = "${Console.ANSI_ESCAPE}6~";

  static const String SPACE = " ";
}

class Keyboard {
  static Map<String, StreamController<String>> _handlers = {};

  static bool _initialized = false;
  static bool echoUnhandledKeys = true;

  static void init() {
    if (!_initialized) {
      stdin.echoMode = false;
      stdin.lineMode = false;
      _initialized = true;

      Console.adapter.byteStream().asBroadcastStream().map((bytes) {
        var it = ASCII.decode(bytes);
        var original = bytes;
        var code = it.replaceAll(Console.ANSI_CODE, "");

        if (code.isNotEmpty) {
          code = code.substring(1);
        }

        if (_inputSequences[code] != null) {
          return [original, _inputSequences[code]];
        } else {
          return [original, it];
        }
      }).listen((List<dynamic> m) {
        if (_handlers.containsKey(m[1])) {
          _handlers[m[1]].add(m[1]);
        } else {
          var bytes = m[0];
          if (echoUnhandledKeys) {
            if (bytes.length == 1 && bytes[0] == 127) {
              Console.moveCursorBack(1);
            }
            stdout.add(m[0]);
            if (bytes.length == 1 && bytes[0] == 127) {
              Console.moveCursorBack(1);
            }
          }
        }
      });
    }
  }

  static Stream<String> bindKey(String code) {
    init();
    if (_handlers.containsKey(code)) {
      return _handlers[code].stream;
    } else {
      return (_handlers[code] = new StreamController<String>.broadcast()).stream;
    }
  }

  static Stream<String> bindKeys(List<String> codes) {
    init();
    var controller = new StreamController<String>.broadcast();
    for (var key in codes) {
      bindKey(key).listen(controller.add);
    }
    return controller.stream;
  }
}
