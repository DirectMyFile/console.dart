import "package:console/console.dart";

void main() {
  Keyboard.init();
  
  Keyboard.bindKey("end").listen((_) {
    print("End.");
  });
}