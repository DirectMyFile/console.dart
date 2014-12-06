part of console;

final Map<String, Color> _COLORS = {
  "black": new Color(0),
  "gray": new Color(0, bright: true),
  "red": new Color(1),
  "dark_red": new Color(1, bright: true),
  "lime": new Color(2, bright: true),
  "green": new Color(2),
  "gold": new Color(3),
  "yellow": new Color(3, bright: true),
  "blue": new Color(4, bright: true),
  "dark_blue": new Color(4),
  "magenta": new Color(5),
  "light_magenta": new Color(5, bright: true),
  "cyan": new Color(6),
  "light_cyan": new Color(6, bright: true),
  "light_gray": new Color(7),
  "white": new Color(7, bright: true)
};

class Color {
  static const Color BLACK = const Color(0);
  static const Color GRAY = const Color(0, bright: true);
  static const Color RED = const Color(1);
  static const Color DARK_RED = const Color(1, bright: true);
  static const Color LIME = const Color(2, bright: true);
  static const Color GREEN = const Color(2);
  static const Color GOLD = const Color(3);
  static const Color YELLOW = const Color(3, bright: true);
  static const Color BLUE = const Color(4, bright: true);
  static const Color DARK_BLUE = const Color(4);
  static const Color MAGENTA = const Color(5);
  static const Color LIGHT_MAGENTA = const Color(5, bright: true);
  static const Color CYAN = const Color(6);
  static const Color LIGHT_CYAN = const Color(6, bright: true);
  static const Color LIGHT_GRAY = const Color(7);
  static const Color WHITE = const Color(7, bright: true);
  
  final int id;
  final bool xterm;
  final bool bright;
  
  const Color(this.id, {this.xterm: false, this.bright: false});
  
  void makeCurrent({bool background: false}) {
    if (background) {
      Terminal.setBackgroundColor(id, xterm: xterm, bright: bright);
    } else {
      Terminal.setTextColor(id, xterm: xterm, bright: bright);
    }
  }
  
  @override
  String toString({bool background: false}) {
    if (xterm) {
      return "${Terminal.ANSI_ESCAPE}${background ? 38 : 48};5;${id}m";
    }
    
    if (bright) {
      return "${Terminal.ANSI_ESCAPE}${(background ? 40 : 30) + id}m";
    } else {
      return "${Terminal.ANSI_ESCAPE}${(background ? 40 : 30) + id}m";
    }
  }
}

class TextPen {
  final StringBuffer buffer;
  
  TextPen({StringBuffer buffer}) :
    this.buffer = buffer == null ? new StringBuffer() : buffer;
  
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
    buffer.write(Terminal.ANSI_ESCAPE + "0m");
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
    console.log(buffer.toString());
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