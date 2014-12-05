part of console.curses;

class Display {
  String _term;

  String get term => _term;

  Display() {
    _term = Platform.environment["TERM"];
  }

}
