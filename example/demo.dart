import "package:console/console.dart";
import "dart:io";


void main() {
  Terminal.init();
  print("Demo of Console Features");
  print("------------------------");
  Terminal.setCrossedOut(true);
  print("Crossed Out");
  Terminal.setCrossedOut(false);
  Terminal.setBold(true);
  print("Bold");
  Terminal.setBold(false);
  Terminal.setTextColor(1, bright: true);
  print("Bright Red");
  Terminal.resetAll();
  print("Progress Bar");
  var bar = new ProgressBar(complete: 5);
  bar.update(3);
  print("${Icon.CHECKMARK} Icons");
}