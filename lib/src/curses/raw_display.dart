part of console.curses;

final String SWITCH_TO_ALTERNATIVE_BUFFER = Terminal.ANSI_ESCAPE + "?47h";

final String SWITCH_TO_NORMAL_BUFFER = Terminal.ANSI_ESCAPE + "?47l";

final String HIDE_CURSOR = Terminal.ANSI_ESCAPE + "?25l";

final String SHOW_CURSOR = Terminal.ANSI_ESCAPE + "?25h";

final String CLEAR_TO_ALTERNATIVE_BUFFER = Terminal.ANSI_ESCAPE + "?1049h";

final String CLEAR_TO_NORMAL_BUFFER = Terminal.ANSI_ESCAPE + "?1049l";

class Display {
  String _term;
  bool _cursor;
  bool _altBuffer;

  String get term => _term;
  bool get cursor => _cursor;
  bool get altBuffer => _altBuffer;

  Display() {
    if (!Platform.environment.containsKey("TERM")) {
      throw "TERM variable not detected"; 
    }
    if (!Platform.environment["TERM"].startsWith("xterm")) {
      throw "Only xterm is supported at this time.";
    }
    _term = Platform.environment["TERM"];
    toggleCursor();
    normalBuffer();
  }

  void normalBuffer() {
    write(SWITCH_TO_NORMAL_BUFFER);
    _altBuffer = false;
  }

  void alternativeBuffer() {
    write(SWITCH_TO_ALTERNATIVE_BUFFER);
    _altBuffer = true;
  }

  void showCursor() {
    write(SHOW_CURSOR);
    _cursor = true;
  }

  void hideCursor() {
    write(HIDE_CURSOR);
    _cursor = false;
  }

  void toggleCursor() {
    write(_cursor ? HIDE_CURSOR : SHOW_CURSOR);
    _cursor = !_cursor;
  }

  void toggleBuffer() {
    write(_altBuffer ? SWITCH_TO_NORMAL_BUFFER : SWITCH_TO_ALTERNATIVE_BUFFER);
    _altBuffer = !_altBuffer;
  }

  void write(String data) {
    stdout.write(data);
  }

}
