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

    Console.onResize.listen((_) {
      draw();
    });

    Keyboard.echoUnhandledKeys = false;
  }

  void draw() {
    Console.eraseDisplay(2);
    var width = Console.columns;
    Console.moveCursor(row: 1, column: 1);
    Console.setBackgroundColor(7, bright: true);
    _repeatFunction((i) => Console.write(' '), width);
    Console.setTextColor(0);
    Console.moveCursor(
      row: 1,
      column: (Console.columns / 2).round() - (title.length / 2).round(),
    );
    Console.write(title);
    _repeatFunction((i) => Console.write('\n'), Console.rows - 1);
    Console.moveCursor(row: 2, column: 1);
    Console.centerCursor(row: true);
    Console.resetBackgroundColor();
  }

  void display() {
    draw();
  }

  Timer startUpdateLoop([Duration wait]) {
    wait ??= Duration(seconds: 2);
    _updateTimer = Timer.periodic(wait, (timer) {
      draw();
    });
    return _updateTimer;
  }

  void close() {
    if (_updateTimer != null) {
      _updateTimer.cancel();
    }
    Console.eraseDisplay();
    Console.moveCursor(row: 1, column: 1);
    stdin.echoMode = true;
  }

  void writeCentered(String text) {
    var column = ((Console.columns / 2) - (text.length / 2)).round();
    var row = (Console.rows / 2).round();
    Console.moveCursor(row: row, column: column);
    Console.write(text);
  }
}

void _repeatFunction(Function func, int times) {
  for (var i = 1; i <= times; i++) {
    func(i);
  }
}
