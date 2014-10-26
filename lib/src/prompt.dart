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

class ShellPrompt {
  String message;
  bool _stop = false;
  
  ShellPrompt({this.message: r"$ "});
  
  String read() {
    return prompt(message);
  }
  
  void stop() {
    _stop = true;
  }
  
  Stream<String> loop() {
    var controller = new StreamController<String>();
    
    var doRead;
    
    doRead = () {
      if (_stop) {
        _stop = false;
        return;
      }
      var input = read();
      controller.add(input);
      new Future(doRead);
    };
    
    new Future(doRead);
    
    return controller.stream;
  }
}