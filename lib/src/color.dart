part of console;

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
      return "${Console.ANSI_ESCAPE}${40 + id}m";
    } else {
      return "${Console.ANSI_ESCAPE}${30 + id}m";
    }
  }
}