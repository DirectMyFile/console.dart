import "package:console/curses.dart";
import "package:console/console.dart";

class HelloWindow extends Window {
  HelloWindow() : super("Hello");
  
  @override
  void initialize() {
    Terminal.write("Hello World!");
  }
}

void main() {
  var window = new HelloWindow();
  window.open();
}