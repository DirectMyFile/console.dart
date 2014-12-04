import "package:console/curses.dart";
import "dart:io";
import "package:console/console.dart";

class HelloWindow extends Window {
  HelloWindow() : super("Hello");
  
  @override
  void draw() {
    super.draw();
    
    writeCentered("Hello World");
  }

  @override
  void initialize() {
    Keyboard.bindKeys(["q", "Q"]).listen((_) {
      close();
      Terminal.resetAll();
      Terminal.eraseDisplay();
      exit(0);
    });
  }
}

void main() {
  var window = new HelloWindow();
  window.display();
}