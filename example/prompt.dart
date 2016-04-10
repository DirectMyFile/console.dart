import "package:console/console.dart";

main() async {
  var username = await readInput("Username: ");
  var password = await readInput("Password: ", secret: true);
  print("${username} -> ${password}");
}
