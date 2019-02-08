part of console;

/// A fancy progress bar
class ProgressBar {
  final int complete;

  int current = 0;

  /// Creates a Progress Bar.
  ///
  /// [complete] is the number that is considered 100%.
  ProgressBar({this.complete = 100});

  /// Updates the Progress Bar with a progress of [progress].
  void update(int progress) {
    if (progress == current) {
      return;
    }

    current = progress;

    var ratio = progress / complete;
    var percent = (ratio * 100).toInt();

    var digits = percent.toString().length;

    var w = Console.columns - digits - 4;

    var count = (ratio * w).toInt();
    var before = "${percent}% [";
    var after = "]";

    var out = StringBuffer(before);

    for (int x = 1; x < count; x++) out.write("=");

    out.write(">");

    for (int x = count; x < w; x++) out.write(" ");

    out.write(after);

    if (out.length - 1 == Console.columns) {
      var it = out.toString();

      out.clear();
      out.write(it.substring(0, it.length - 2) + "]");
    }

    Console.overwriteLine(out.toString());
  }
}

/// Specifies the next position of the loading bar
typedef NextPositionLoadingBar = Function();

/// A loading bar
class LoadingBar {
  Timer _timer;
  bool started = true;
  String position = "<";
  String lastPosition;
  NextPositionLoadingBar nextPosition;

  /// Creates a loading bar.
  LoadingBar() {
    nextPosition = _nextPosition;
  }

  /// Starts the Loading Bar
  void start() {
    Console.hideCursor();
    _timer = Timer.periodic(const Duration(milliseconds: 75), (timer) {
      nextPosition();
      update();
    });
  }

  /// Stops the Loading Bar with the specified (and optional) [message].
  void stop([String message]) {
    if (_timer != null) {
      _timer.cancel();
    }

    if (message != null) {
      position = message;
      update();
    }
    Console.showCursor();
    print("");
  }

  /// Updates the Loading Bar
  void update() {
    if (started) {
      Console.write(position);
      started = false;
    } else {
      Console.moveCursorBack(lastPosition.length);
      Console.write(position);
    }
  }

  void _nextPosition() {
    lastPosition = position;
    switch (position) {
      case "|":
        position = "/";
        break;
      case "/":
        position = "-";
        break;
      case "-":
        position = "\\";
        break;
      case "\\":
        position = "|";
        break;
      default:
        position = "|";
        break;
    }
  }
}

/// A wide loading bar. Kind of like a Progress Bar.
class WideLoadingBar {
  int position = 0;

  /// Creates a wide loading bar.
  WideLoadingBar();

  /// Loops the loading bar.
  Timer loop() {
    var width = Console.columns - 2;
    bool goForward = true;
    bool isDone = true;

    return Timer.periodic(const Duration(milliseconds: 50), (timer) async {
      if (!isDone) {
        return;
      }

      isDone = false;

      for (int i = 1; i <= width; i++) {
        position = i;
        await Future.delayed(const Duration(milliseconds: 5));
        if (goForward) {
          forward();
        } else {
          backward();
        }
      }
      goForward = !goForward;
      isDone = true;
    });
  }

  /// Moves the Bar Forward
  void forward() {
    var out = StringBuffer("[");
    var width = Console.columns - 2;
    var after = width - position;
    var before = width - after - 1;
    for (int i = 1; i <= before; i++) {
      out.write(" ");
    }
    out.write("=");
    for (int i = 1; i <= after; i++) {
      out.write(" ");
    }
    out.write("]");
    Console.overwriteLine(out.toString());
  }

  /// Moves the Bar Backward
  void backward() {
    var out = StringBuffer("[");
    var width = Console.columns - 2;
    var before = width - position;
    var after = width - before - 1;
    for (int i = 1; i <= before; i++) {
      out.write(" ");
    }
    out.write("=");
    for (int i = 1; i <= after; i++) {
      out.write(" ");
    }
    out.write("]");
    Console.overwriteLine(out.toString());
  }
}
