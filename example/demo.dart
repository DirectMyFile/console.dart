import "package:console/console.dart";
import "dart:io";


void main() {
  Terminal.init();
  stdout.writeln("Demo of Console Features");
  stdout.writeln("------------------------");
  Terminal.setCrossedOut(true);
  stdout.writeln("Crossed Out");
  Terminal.setCrossedOut(false);
  Terminal.setBold(true);
  stdout.writeln("Bold");
  Terminal.setBold(false);
  Terminal.setTextColor(1, bright: true);
  stdout.writeln("Bright Red");
  Terminal.resetAll();
  stdout.writeln("Progress Bar");
  var bar = new ProgressBar(complete: 5);
  bar.update(3);
  stdout.writeln("${Icon.CHECKMARK} Icons");
  stdout.writeln("You can even copy and paste to the clipboard! (Hard to demo with a screenshot)");
}