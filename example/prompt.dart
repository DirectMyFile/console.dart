import "package:console/console.dart";


void main() {
  var username = readInput("Username: ");
  var password = readInput("Password: ", secret: true);
  print("${username} -> ${password}");
}
