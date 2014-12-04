import "package:console/console.dart";

void main() {
  var chooser = new Chooser<String>([
    "A",
    "B",
    "C",
    "D"
  ], message: "Select a Letter: ");
  
  var letter = chooser.choose();
  print("You chose ${letter}.");
}