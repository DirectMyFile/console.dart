part of console;

/// A timer display that mimics pub's timer.
class TimeDisplay {
  Stopwatch _watch;
  bool _isStart = true;
  String _lastMsg;
  Timer _updateTimer;
  bool _running = false;

  bool get running => _running;

  TimeDisplay();

  /// Starts the Timer
  void start([int place = 1]) {
    Console.adapter.echoMode = false;
    _watch = new Stopwatch();
    _updateTimer = new Timer.periodic(new Duration(milliseconds: 10), (timer) {
      update(place);
    });
    _watch.start();
    _running = true;
  }

  /// Stops the Timer
  void stop() {
    Console.adapter.echoMode = true;
    _watch.stop();
    _updateTimer.cancel();
    _running = false;
  }

  /// Updates the Timer
  void update([int place = 1]) {
    if (_isStart) {
      var msg = "(${_watch.elapsed.inSeconds}s)";
      _lastMsg = msg;
      Console.write(msg);
      _isStart = false;
    } else {
      Console.moveCursorBack(_lastMsg.length);
      var msg = "(${(_watch.elapsed.inMilliseconds / 1000).toStringAsFixed(place)}s)";
      _lastMsg = msg;
      Console.setBold(true);
      Console.setTextColor(Color.GRAY.id);
      Console.write(msg);
      Console.setBold(false);
    }
  }
}
