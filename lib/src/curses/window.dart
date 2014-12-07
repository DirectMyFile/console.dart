part of console.curses;

abstract class Window {
  String _title;
  Timer _updateTimer;
  
  String get title => _title;
  set title(String value) => _title = value;
  
  Window(String title) {
    _title = title;
    _init();
    initialize();
  }
  
  void initialize();
  
  void _init() {
    stdin.echoMode = false;

    Terminal.onResize.listen((_) {
      draw();
    });
  }
  
  void draw() {
    Terminal.eraseDisplay(2);
    var width = Terminal.columns;
    Terminal.moveCursor(row: 1, column: 1);
    Terminal.setBackgroundColor(7, bright: true);
    _repeatFunction((i) => Terminal.write(" "), width);
    Terminal.setTextColor(0);
    Terminal.moveCursor(row: 1, column: (Terminal.columns / 2).round() - (title.length / 2).round());
    Terminal.write(title);
    _repeatFunction((i) => Terminal.write("\n"), Terminal.rows - 1);
    Terminal.moveCursor(row: 2, column: 1);
    Terminal.centerCursor(row: true);
    Terminal.resetBackgroundColor();
  }
  
  void display() {
    draw();
  }
  
  Timer startUpdateLoop([Duration wait]) {
    if (wait == null) wait = new Duration(seconds: 2);
    _updateTimer = new Timer.periodic(wait, (timer) {
      draw();
    });
    return _updateTimer;
  }
  
  void close() {
    if (_updateTimer != null) {
      _updateTimer.cancel();
    }
    Terminal.eraseDisplay();
    Terminal.moveCursor(row: 1, column: 1);
    stdin.echoMode = true;
  }
  
  void writeCentered(String text) {
    var column = ((Terminal.columns / 2) - (text.length / 2)).round();
    var row = (Terminal.rows / 2).round();
    Terminal.moveCursor(row: row, column: column);
    Terminal.write(text);
  }
}

void _repeatFunction(Function func, int times) {
  for (int i = 1; i <= times; i++) {
    func(i);
  }
}
