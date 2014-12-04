import "package:console/console.dart";

void main() {
  var chooser = new Chooser<String>([
    "A",
    "B",
    "C",
    "D"
  ], message: "Select a Letter: ");
  
  chooser.choose().then((value) {
    print("You chose ${value}.");
  });
}