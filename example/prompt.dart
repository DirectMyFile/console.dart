import "package:console/console.dart";


void main() {
  var username;
  var password;
  readInput("Username: ").then((_username) => username = _username).then((_) =>
  readInput("Password: ", secret: true).then((_password) => password = _password)).then((_) =>print("${username}:${password}"));
}
