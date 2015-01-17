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
  static Stream<String> _input = Console.adapter.byteStream().transform(ASCII.decoder).asBroadcastStream();

  static bool _initialized = false;
  
  static void init() {
    if (!_initialized) {
      stdin.echoMode = false;
      stdin.lineMode = false;
      _initialized = true;
    }
  }
  
  static Stream<String> bindKey(String code) {
    init();
    return _input.where((it) {
      return it == code;
    });
  }

  static Stream<String> bindKeys(List<String> codes) {
    init();
    return _input.where((it) {
      return codes.contains(it);
    });
  }
}