part of console;

/// The root of the console API
class Terminal {
  /// ANSI Escape Code
  static const String ANSI_ESCAPE = "\x1b[";
  static bool _registeredCTRLC = false;
  static bool initialized = false;
  static Color _currentTextColor;
  static Color _currentBackgroundColor;

  static String TERM;
  
  /// Initializes the Console
  static void init() {
    if (initialized) return;
    
    initialized = true;
    
    try {
      stdout.terminalColumns;
    } on StdoutException catch (e) {
      throw "Advanced Terminal Features are not supported with your current environment.";
    }
    
    if (Platform.isLinux) {
      TERM = Platform.environment["TERM"];
    }
  }
  
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
    moveToColumn(1);
    eraseLine(2);
    write(line);
  }

  /// Sets the Current Text Color.
  static void setTextColor(int id, {bool xterm: false, bool bright: false}) {
    Color color;
    if (xterm) {
      var c = id.clamp(0, 256);
      color = new Color(c, xterm: true);
      sgr(38, [5, c]);
    } else {
      color = new Color(id, bright: true);
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
    if (!_registeredCTRLC) {
      ProcessSignal.SIGINT.watch().listen((signal) {
        showCursor();
        exit(0);
      });
      _registeredCTRLC = true;
    }
    writeANSI("?25l");
  }
  static void showCursor() {
    writeANSI("?25h");
  }
  
  static void setBackgroundColor(int id, {bool xterm: false, bool bright: false}) {
    Color color;
    if (xterm) {
      var c = id.clamp(0, 256);
      color = new Color(c, xterm: true);
      sgr(48, [5, c]);
    } else {
      color = new Color(id, bright: true);
      if (bright) {
        sgr(40 + id, [1]);
      } else {
        sgr(40 + id);
      }
    }
    _currentBackgroundColor = color;
  }

  static void centerCursor({bool row: true}) {
    if (row) {
      var column = (stdout.terminalColumns / 2).round();
      var row = (stdout.terminalLines / 2).round();
      moveCursor(row: row, column: column);
    } else {
      moveToColumn((stdout.terminalColumns / 2).round());
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
    stdin.echoMode = true;
    stdin.lineMode = true;
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

  static int get rows => stdout.terminalLines;
  static int get columns => stdout.terminalColumns;

  static void nextLine([int times = 1]) => writeANSI("${times}E");
  static void previousLine([int times = 1]) => writeANSI("${times}F");
  
  static void write(String content) {
    init();
    stdout.write(content);
  }
  
  static String readLine() => stdin.readLineSync();
  
  static void writeANSI(String after) => write("${ANSI_ESCAPE}${after}");
  
  static bool _bytesEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
  
  
  static CursorPosition getCursorPosition() {
    var lm = stdin.lineMode;
    var em = stdin.echoMode;
    
    stdin.lineMode = false;
    stdin.echoMode = false;
    
    writeANSI("6n");
    var bytes = [];
    
    while (true) {
      var byte = stdin.readByteSync();
      bytes.add(byte);
      if (byte == 82) {
        break;
      }
    }
    
    stdin.lineMode = lm;
    stdin.echoMode = em;
    
    var str = new String.fromCharCodes(bytes);
    
    List<int> parts = new List.from(str.substring(2, str.length - 1).split(";").map((it) => int.parse(it)));
    
    return new CursorPosition(parts[0], parts[1]);
  }
  
  static void saveCursor() => writeANSI("s");
  static void restoreCursor() => writeANSI("u");
}

class CursorPosition {
  final int row;
  final int column;

  CursorPosition(this.row, this.column);
  
  @override
  String toString() => "(${row}, ${column})";
}
