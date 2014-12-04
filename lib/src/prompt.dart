part of console;

const List<String> _YES_RESPONSES = const ["yes", "y", "sure", "ok", "yep", "yeah", "true", "yerp"];

const Duration _PROMPT_DELAY = const Duration(milliseconds: 2);

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
      new Prompt(message).prompt().then((it) {
        controller.add(it);
        new Future(doRead);
      });
    };

    new Future(doRead);

    return controller.stream;
  }
}

class Chooser<T> {
  final String message;
  final List<T> choices;

  Chooser(this.choices, {this.message});

  Future<T> choose() {
    var buff = new StringBuffer();
    if (message != null) buff.writeln(message);

    int i = -1;

    for (var choice in choices) {
      i++;
      buff.writeln("[${i + 1}] ${choice}");
    }

    buff.write("Choice: ");

    var completer = new Completer();

    var process;
    process = (String input) {
      int result = _parseInteger(input);

      if (result == null) {
        bool exists = choices.map((it) => it.toString().trim().toLowerCase()).contains(input.trim().toLowerCase());
        if (exists) {
          var val = choices.firstWhere((it) {
            return it.toString().trim().toLowerCase() == input.trim().toLowerCase();
          });

          completer.complete(val);
          return;
        }
      }

      var choice;

      try {
        choice = choices[result - 1];
        completer.complete(choice);
      } catch (e) {
        new Prompt(buff.toString()).prompt().then(process);
      }
    };

    new Prompt(buff.toString()).prompt().then(process);

    return completer.future;
  }
}

class Prompt {
  final String message;
  final bool secret;
  
  Prompt(this.message, {this.secret: false});

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
  Future<bool> ask({List<String> positive: const []}) {
    return prompt()
        .then((answer) => _YES_RESPONSES.contains(answer.toLowerCase()) || positive.contains(message.toLowerCase()));
  }
  
  Future<String> prompt({ResponseChecker checker}) {
    var completer = new Completer();
    
    var doAsk;
    doAsk = () {
      Terminal.writeAndFlush(message).then((_) {
        if (secret) stdin.echoMode = false;
        var response = Terminal.readLine();
        if (secret) stdin.echoMode = true;
        if (checker != null && !checker(response)) {
          doAsk();
          return;
        }
        completer.complete(response);
      });
    };
    
    doAsk();
    
    return completer.future;
  }
}

Future<String> readInput(String message, {bool secret: false, ResponseChecker checker}) {
  return new Prompt(message, secret: secret).prompt(checker: checker);
}

typedef bool ResponseChecker(String response);

int _parseInteger(String input) {
  try {
    return int.parse(input);
  } catch (e) {
    return null;
  }
}
