import "package:console/console.dart";

void main() {
  Console.init();
  print("Demo of Console Features");
  print("------------------------");
  Console.setCrossedOut(true);
  print("Crossed Out");
  Console.setCrossedOut(false);
  Console.setBold(true);
  print("Bold");
  Console.setBold(false);
  Console.setTextColor(1, bright: true);
  print("Bright Red");
  Console.resetAll();
  print("Progress Bar");
  var bar = new ProgressBar(complete: 5);
  bar.update(3);
  print("${Icon.CHECKMARK} Icons");
}
