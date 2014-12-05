part of console.curses;

class Display {
  String _term;

  String get term => _term;

  Display() {
    if (!Platform.environment.containsKey("TERM")) {
      throw "TERM variable not detected"; 
    }
    _term = Platform.environment["TERM"];
  }

}
