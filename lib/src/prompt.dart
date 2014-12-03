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

/// Prompts a user with the specified [prompt].
/// If [secret] is true, then the typed input wont be shown to the user.
Future<String> prompt(String prompt, {bool secret: false}) {
  return Terminal.writeAndFlush(prompt).then((_) {
    if (secret) stdin.echoMode = false;
    var response = Terminal.readLine();
    if (secret) stdin.echoMode = true;
    return response;
  });
}

/// Prompts a user for a yes or no answer.
/// 
/// The following are considered yes responses:
/// 
/// - yes
/// - y
/// - sure
/// - ok
/// - yep
/// - yeah
/// - true
/// - yerp
/// 
/// The input will be changed to lowercase and then checked.
Future<bool> yesOrNo(String message) {
  return prompt(message).then((answer) => _YES_RESPONSES.contains(answer.toLowerCase()));
}

/// Emulates a Shell Prompt
class ShellPrompt {
  /// Shell Prompt
  String message;
  bool _stop = false;
  
  ShellPrompt({this.message: r"$ "});
    
  /// Stops a Loop
  void stop() {
    _stop = true;
  }
  
  /// Runs a shell prompt in a loop.
  Stream<String> loop() {
    var controller = new StreamController<String>();
    
    var doRead;
    
    doRead = () {
      if (_stop) {
        _stop = false;
        return;
      }
      prompt(message).then((it) {
        controller.add(it);
        new Future(doRead);
      });
    };
    
    new Future(doRead);
    
    return controller.stream;
  }
}
