part of console;

Map<String, Color> _COLORS = {
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
  final int id;
  final bool xterm;
  final bool bright;
  
  Color(this.id, {this.xterm: false, this.bright: false});
  
  @override
  String toString() {
    if (xterm) {
      return "${Console.ANSI_ESCAPE}38;5;${id}m";
    }
    
    if (bright) {
      return "${Console.ANSI_ESCAPE}${30 + id}m";
    } else {
      return "${Console.ANSI_ESCAPE}${30 + id}m";
    }
  }
}