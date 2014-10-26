part of console;

const List<String> _YES_RESPONSES = const [
  "yes",
  "y",
  "sure",
  "ok",
  "yep",
  "yeah",
  "true",
  "yerp"
];

String prompt(String prompt, {bool secret: false}) {
  stdout.write(prompt);
  
  if (secret) {
    stdin.echoMode = false;
  }
  
  var response = Console.readLine();
  if (secret) {
    print("");
  }
  return response;
}

bool yesOrNo(String message) {
  var answer = prompt(message);
  return _YES_RESPONSES.contains(answer.toLowerCase());
}
