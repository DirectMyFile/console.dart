part of console;

final Map<String, Color> _COLORS = {
  'black': Color(0),
  'gray': Color(0, bright: true),
  'dark_red': Color(1),
  'red': Color(1, bright: true),
  'green': Color(2),
  'lime': Color(2, bright: true),
  'gold': Color(3),
  'yellow': Color(3, bright: true),
  'dark_blue': Color(4),
  'blue': Color(4, bright: true),
  'magenta': Color(5),
  'light_magenta': Color(5, bright: true),
  'cyan': Color(6),
  'light_cyan': Color(6, bright: true),
  'light_gray': Color(7),
  'white': Color(7, bright: true)
};

class Color {
  static const Color BLACK = Color(0);
  static const Color GRAY = Color(0, bright: true);
  static const Color RED = Color(1, bright: true);
  static const Color DARK_RED = Color(1);
  static const Color LIME = Color(2, bright: true);
  static const Color GREEN = Color(2);
  static const Color GOLD = Color(3);
  static const Color YELLOW = Color(3, bright: true);
  static const Color BLUE = Color(4, bright: true);
  static const Color DARK_BLUE = Color(4);
  static const Color MAGENTA = Color(5);
  static const Color LIGHT_MAGENTA = Color(5, bright: true);
  static const Color CYAN = Color(6);
  static const Color LIGHT_CYAN = Color(6, bright: true);
  static const Color LIGHT_GRAY = Color(7);
  static const Color WHITE = Color(7, bright: true);

  final int id;
  final bool xterm;
  final bool bright;

  const Color(this.id, {this.xterm = false, this.bright = false});

  static Map<String, Color> getColors() => _COLORS;

  void makeCurrent({bool background = false}) {
    if (background) {
      Console.setBackgroundColor(id, xterm: xterm, bright: bright);
    } else {
      Console.setTextColor(id, xterm: xterm, bright: bright);
    }
  }

  @override
  String toString({bool background = false}) {
    if (xterm) {
      return '${Console.ANSI_ESCAPE}${background ? 38 : 48};5;${id}m';
    }

    if (bright) {
      return '${Console.ANSI_ESCAPE}1;${(background ? 40 : 30) + id}m';
    } else {
      return '${Console.ANSI_ESCAPE}0;${(background ? 40 : 30) + id}m';
    }
  }
}

class TextPen {
  final StringBuffer buffer;

  TextPen({StringBuffer buffer})
      : this.buffer = buffer == null ? StringBuffer() : buffer;

  TextPen black() => setColor(Color.BLACK);
  TextPen blue() => setColor(Color.BLUE);
  TextPen red() => setColor(Color.RED);
  TextPen darkRed() => setColor(Color.DARK_RED);
  TextPen lime() => setColor(Color.LIME);
  TextPen green() => setColor(Color.GREEN);
  TextPen gold() => setColor(Color.GOLD);
  TextPen yellow() => setColor(Color.YELLOW);
  TextPen darkBlue() => setColor(Color.DARK_BLUE);
  TextPen magenta() => setColor(Color.MAGENTA);
  TextPen lightMagenta() => setColor(Color.LIGHT_MAGENTA);
  TextPen cyan() => setColor(Color.CYAN);
  TextPen lightCyan() => setColor(Color.LIGHT_CYAN);
  TextPen lightGray() => setColor(Color.LIGHT_GRAY);
  TextPen white() => setColor(Color.WHITE);
  TextPen gray() => setColor(Color.GRAY);

  TextPen normal() {
    buffer.write(Console.ANSI_ESCAPE + '0m');
    return this;
  }

  TextPen text(String input) {
    buffer.write(input);
    return this;
  }

  TextPen setColor(Color color) {
    buffer.write(color.toString());
    return this;
  }

  TextPen print() {
    normal();
    Console._adapter.writeln(buffer.toString());
    return this;
  }

  TextPen reset() {
    buffer.clear();
    return this;
  }

  void call([String input]) {
    if (input != null) {
      text(input);
    } else {
      print();
    }
  }

  @override
  String toString() => buffer.toString();
}
