import "package:console/curses.dart";
import "dart:io";
import "package:console/console.dart";
import "dart:async";

class DemoWindow extends Window {
  bool showWelcomeMessage = true;
  Timer loaderTimer;

  DemoWindow() : super("Hello");

  @override
  void draw() {
    super.draw();

    if (loaderTimer != null) {
      loaderTimer.cancel();
    }

    if (showWelcomeMessage) {
      writeCentered("Welcome!");
    } else {
      Console.centerCursor();
      Console.moveToColumn(1);
      var loader = new WideLoadingBar();
      loaderTimer = loader.loop();
    }
  }

  @override
  void initialize() {
    Keyboard.bindKeys(["q", "Q"]).listen((_) {
      close();
      Console.resetAll();
      Console.eraseDisplay();
      exit(0);
    });

    Keyboard.bindKey("x").listen((_) {
      title = title == "Hello" ? "Goodbye" : "Hello";
      draw();
    });

    Keyboard.bindKey(KeyCode.SPACE).listen((_) {
      showWelcomeMessage = false;
      draw();
    });

    Keyboard.bindKey("p").listen((_) {
      if (loaderTimer != null) {
        loaderTimer.cancel();
        loaderTimer = null;
      }
    });
  }
}

void main() {
  var window = new DemoWindow();
  window.display();
}
