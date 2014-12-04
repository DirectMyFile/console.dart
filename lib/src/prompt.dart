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

const Duration _PROMPT_DELAY = const Duration(milliseconds: 2);

/// Prompts a user with the specified [message].
/// If [secret] is true, then the typed input wont be shown to the user.
Future<String> prompt(String message, {bool secret: false}) {
  return Terminal.writeAndFlush(message).then((_) {
    if (secret) stdin.echoMode = false;
    var response = Terminal.readLine();
    if (secret) stdin.echoMode = true;
    return new Future.delayed(_PROMPT_DELAY, () => response);
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
/// You can add more to the list of positive responses using the [positive] argument.
///
/// The input will be changed to lowercase and then checked.
Future<bool> yesOrNo(String message, {List<String> positive: const []}) {
  return prompt(message).then((answer) => _YES_RESPONSES.contains(answer.toLowerCase()) || positive.contains(message.toLowerCase()));
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
