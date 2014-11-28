part of console;

/// A fancy progress bar
class ProgressBar {
  final int complete;
  
  int current = 0;
    
  /// Creates a Progress Bar.
  /// 
  /// [complete] is the number that is considered 100%.
  ProgressBar({this.complete: 100});
  
  /// Updates the Progress Bar with a progress of [progress].
  void update(int progress) {
    if (progress == current) {
      return;
    }
    
    current = progress;
    
    var ratio = progress / complete;
    var percent = (ratio * 100).toInt();

    var digits = percent.toString().length;
    
    var w = Terminal.columns - digits - 4;
    
    var count = (ratio * w).toInt();
    var before = "${percent}% [";
    var after = "]";
    
    var out = new StringBuffer(before);
    
    for (int x = 1; x < count; x++)
      out.write("=");
    
    out.write(">");
    
    for (int x = count; x < w; x++)
      out.write(" ");
    
    out.write(after);
    
    if (out.length - 1 == Terminal.columns) {
      var it = out.toString();
          
      out.clear();
      out.write(it.substring(0, it.length - 2) + "]"); 
    }
    
    Terminal.overwriteLine(out.toString());
  }
}

/// Specifies the next position of the loading bar
typedef NextPositionLoadingBar();

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
    Terminal.hideCursor();
    _timer = new Timer.periodic(new Duration(milliseconds: 75), (timer) {
      nextPosition();
      update();
    });
  }
  
  /// Stops the Loading Bar with the specified (and optional) [message].
  void stop([String message]) {
    _timer.cancel();
    if (message != null) {
      position = message;
      update();
    }
    Terminal.showCursor();
    print("");
  }
  
  /// Updates the Loading Bar
  void update() {
    if (started) {
      Terminal.write(position);
      started = false;
    } else {
      Terminal.moveCursorBack(lastPosition.length);
      Terminal.write(position);
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
    var width = Terminal.columns - 2;
    bool goForward = true;
    
    return new Timer.periodic(new Duration(milliseconds: 50), (timer) {
      for (int i = 1; i <= width; i++) {
        position = i;
        sleep(new Duration(milliseconds: 5));
        if (goForward) {
          forward();
        } else {
          backward();
        }
      }
      goForward = !goForward;
    });
  }
  
  /// Moves the Bar Forward
  void forward() {
    var out = new StringBuffer("[");
    var width = Terminal.columns - 2;
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
    Terminal.overwriteLine(out.toString());
  }
  
  /// Moves the Bar Backward
  void backward() {
    var out = new StringBuffer("[");
    var width = Terminal.columns - 2;
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
    Terminal.overwriteLine(out.toString());
  }
}
