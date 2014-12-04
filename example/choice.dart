import "package:console/console.dart";

void main() {
  var chooser = new Chooser<String>([
    "A",
    "B",
    "C",
    "D"
  ]);
  
  chooser.choose().then((value) {
    print("You chose ${value}.");
  });
}