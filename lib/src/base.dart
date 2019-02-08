part of console;

/// The root of the console API
class Console {
  static const String ANSI_CODE = "\x1b";

  /// ANSI Escape Code
  static const String ANSI_ESCAPE = "\x1b[";
  static bool _cursorCTRLC = false;
  static bool _buffCTRLC = false;
  static bool initialized = false;
  static Color _currentTextColor;
  static Color _currentBackgroundColor;
  static ConsoleAdapter _adapter = StdioConsoleAdapter();

  static ConsoleAdapter get adapter => _adapter;
  static set adapter(ConsoleAdapter val) => _adapter = val;

  /// Initializes the Console
  static void init() {
    if (initialized) return;

    initialized = true;
  }

  static Stream get onResize => ProcessSignal.sigwinch.watch();

  /// Moves the Cursor Forward the specified amount of [times].
  static void moveCursorForward([int times = 1]) => writeANSI("${times}C");

  /// Moves the Cursor Back the specified amount of [times].
  static void moveCursorBack([int times = 1]) => writeANSI("${times}D");

  /// Moves the Cursor Up the specified amount of [times].
  static void moveCursorUp([int times = 1]) => writeANSI("${times}A");

  /// Moves the Cursor Down the specified amount of [times].
  static void moveCursorDown([int times = 1]) => writeANSI("${times}B");

  /// Erases the Display
  static void eraseDisplay([int type = 0]) => writeANSI("${type}J");

  /// Erases the Line
  static void eraseLine([int type = 0]) => writeANSI("${type}K");

  /// Moves the the column specified in [number].
  static void moveToColumn(int number) => writeANSI("${number}G");

  /// Overwrites the current line with [line].
  static void overwriteLine(String line) {
    write("\r");
    eraseLine(2);
    write(line);
  }

  /// Sets the Current Text Color.
  static void setTextColor(int id, {bool xterm = false, bool bright = false}) {
    Color color;
    if (xterm) {
      var c = id.clamp(0, 256);
      color = Color(c, xterm: true);
      sgr(38, [5, c]);
    } else {
      color = Color(id, bright: true);
      if (bright) {
        sgr(30 + id, [1]);
      } else {
        sgr(30 + id);
      }
    }
    _currentTextColor = color;
  }

  static Color getTextColor() => _currentTextColor;
  static Color getBackgroundColor() => _currentBackgroundColor;

  static void hideCursor() {
    if (!_cursorCTRLC) {
      ProcessSignal.sigint.watch().listen((signal) {
        showCursor();
        exit(0);
      });
      _cursorCTRLC = true;
    }
    writeANSI("?25l");
  }

  static void showCursor() {
    writeANSI("?25h");
  }

  static void altBuffer() {
    if (!_buffCTRLC) {
      ProcessSignal.sigint.watch().listen((signal) {
        normBuffer();
        exit(0);
      });
      _buffCTRLC = true;
    }
    writeANSI("?47h");
  }

  static void normBuffer() {
    writeANSI("?47l");
  }

  static void setBackgroundColor(int id,
      {bool xterm = false, bool bright = false}) {
    Color color;
    if (xterm) {
      var c = id.clamp(0, 256);
      color = Color(c, xterm: true);
      sgr(48, [5, c]);
    } else {
      color = Color(id, bright: true);
      if (bright) {
        sgr(40 + id, [1]);
      } else {
        sgr(40 + id);
      }
    }
    _currentBackgroundColor = color;
  }

  static void centerCursor({bool row = true}) {
    if (row) {
      var column = (columns / 2).round();
      var row = (rows / 2).round();
      moveCursor(row: row, column: column);
    } else {
      moveToColumn((columns / 2).round());
    }
  }

  static void moveCursor({int row, int column}) {
    var out = "";
    if (row != null) {
      out += row.toString();
    }
    out += ";";
    if (column != null) {
      out += column.toString();
    }
    writeANSI("${out}H");
  }

  static void setBold(bool bold) => sgr(bold ? 1 : 22);
  static void setItalic(bool italic) => sgr(italic ? 3 : 23);
  static void setBlink(bool blink) => sgr(blink ? 5 : 25);
  static void setUnderline(bool underline) => sgr(underline ? 4 : 24);
  static void setCrossedOut(bool crossedOut) => sgr(crossedOut ? 9 : 29);
  static void setFramed(bool framed) => sgr(framed ? 51 : 54);
  static void setEncircled(bool encircled) => sgr(encircled ? 52 : 54);
  static void setOverlined(bool overlined) => sgr(overlined ? 53 : 55);

  static void setInverted(bool flipped) => sgr(flipped ? 7 : 27);

  static void conceal() => sgr(8);
  static void reveal() => sgr(28);

  static void resetAll() {
    sgr(0);
    _currentTextColor = null;
    _currentBackgroundColor = null;
  }

  static void resetTextColor() {
    sgr(39);
    _currentTextColor = null;
  }

  static void resetBackgroundColor() {
    sgr(49);
    _currentBackgroundColor = null;
  }

  static void sgr(int id, [List<int> params]) {
    String stuff;
    if (params != null) {
      stuff = "${id};${params.join(";")}";
    } else {
      stuff = id.toString();
    }
    writeANSI("${stuff}m");
  }

  static int get rows => _adapter.rows;
  static int get columns => _adapter.columns;

  static void nextLine([int times = 1]) => writeANSI("${times}E");
  static void previousLine([int times = 1]) => writeANSI("${times}F");

  static void write(String content) {
    init();
    _adapter.write(content);
  }

  static String readLine() => _adapter.read();

  static void writeANSI(String after) => write("${ANSI_ESCAPE}${after}");

  static CursorPosition getCursorPosition() {
    var lm = _adapter.lineMode;
    var em = _adapter.echoMode;

    _adapter.lineMode = false;
    _adapter.echoMode = false;

    writeANSI("6n");
    var bytes = <int>[];

    while (true) {
      var byte = _adapter.readByte();
      bytes.add(byte);
      if (byte == 82) {
        break;
      }
    }

    _adapter.lineMode = lm;
    _adapter.echoMode = em;

    var str = String.fromCharCodes(bytes);
    str = str.substring(str.lastIndexOf('[') + 1, str.length - 1);

    List<int> parts =
        List.from(str.split(";").map((it) => int.parse(it))).toList();

    return CursorPosition(parts[1], parts[0]);
  }

  static void saveCursor() => writeANSI("s");
  static void restoreCursor() => writeANSI("u");
}

class CursorPosition {
  final int row;
  final int column;

  CursorPosition(this.column, this.row);

  @override
  String toString() => "(${column}, ${row})";
}
