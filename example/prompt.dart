import "package:console/console.dart";


void main() {
  var username;
  var password;
  prompt("Username: ").then((_username) => username = _username).then((_) =>
  prompt("Password: ", secret: true).then((_password) => password = _password)).then((_) =>
  print("${username}:${password}"));
}