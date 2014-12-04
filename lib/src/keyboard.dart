part of console;

abstract class KeyCode {
  static const String UP = "${Terminal.ANSI_ESCAPE}A";
  static const String DOWN = "${Terminal.ANSI_ESCAPE}B";
  static const String RIGHT = "${Terminal.ANSI_ESCAPE}C";
  static const String LEFT = "${Terminal.ANSI_ESCAPE}D";

  static const String HOME = "${Terminal.ANSI_ESCAPE}H";
  static const String END = "${Terminal.ANSI_ESCAPE}F";

  static const String F1 = "${Terminal.ANSI_ESCAPE}M";
  static const String F2 = "${Terminal.ANSI_ESCAPE}N";
  static const String F3 = "${Terminal.ANSI_ESCAPE}O";
  static const String F4 = "${Terminal.ANSI_ESCAPE}P";
  static const String F5 = "${Terminal.ANSI_ESCAPE}Q";
  static const String F6 = "${Terminal.ANSI_ESCAPE}R";
  static const String F7 = "${Terminal.ANSI_ESCAPE}S";
  static const String F8 = "${Terminal.ANSI_ESCAPE}T";
  static const String F9 = "${Terminal.ANSI_ESCAPE}U";
  static const String F10 = "${Terminal.ANSI_ESCAPE}V";
  static const String F11 = "${Terminal.ANSI_ESCAPE}W";
  static const String F12 = "${Terminal.ANSI_ESCAPE}X";

  static const String INS = "${Terminal.ANSI_ESCAPE}2~";
  static const String DEL = "${Terminal.ANSI_ESCAPE}3~";
  static const String PAGE_UP = "${Terminal.ANSI_ESCAPE}5~";
  static const String PAGE_DOWN = "${Terminal.ANSI_ESCAPE}6~";

  static const String SPACE = " ";
}

class Keyboard {
  static Stream<String> _input = terminalAdapter.byteStream().transform(ASCII.decoder).asBroadcastStream();

  static Stream<String> listenKey(String code) {
    return _input.where((it) {
      return it == code;
    });
  }

  static Stream<String> listenKeys(List<String> codes) {
    return _input.where((it) {
      return codes.contains(it);
    });
  }
}