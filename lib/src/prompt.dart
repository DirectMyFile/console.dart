part of console;

const List<String> _YES_RESPONSES = const [
  "yes",
  "y",
  "sure",
  "ok",
  "yep",
  "yeah",
  "true",
  "yerp",
];

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
      new Prompter(message).prompt().then((it) {
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
  final ChooserEntryFormatter<T> formatter;

  Chooser(this.choices,
      {this.message: "Choice: ", this.formatter: _defaultFormatter});

  static String _defaultFormatter(input, int index) => "[${index}] ${input}";

  T chooseSync() {
    var buff = new StringBuffer();
    int i = -1;

    for (var choice in choices) {
      i++;
      buff.writeln(formatter(choice, i + 1));
    }

    buff.write(message);

    while (true) {
      var input = new Prompter(buff.toString()).promptSync();
      int result = _parseInteger(input);

      if (result == null) {
        bool exists = choices
            .map((it) => it.toString().trim().toLowerCase())
            .contains(input.trim().toLowerCase());
        if (exists) {
          var val = choices.firstWhere((it) {
            return it.toString().trim().toLowerCase() ==
                input.trim().toLowerCase();
          });

          return val;
        }
      }

      var choice;

      try {
        choice = choices[result - 1];
        return choice;
      } catch (e) {}
    }
  }

  Future<T> choose() {
    var buff = new StringBuffer();
    int i = -1;

    for (var choice in choices) {
      i++;
      buff.writeln(formatter(choice, i + 1));
    }

    buff.write(message);

    var completer = new Completer();

    var process;
    process = (String input) {
      int result = _parseInteger(input);

      if (result == null) {
        bool exists = choices
            .map((it) => it.toString().trim().toLowerCase())
            .contains(input.trim().toLowerCase());
        if (exists) {
          var val = choices.firstWhere((it) {
            return it.toString().trim().toLowerCase() ==
                input.trim().toLowerCase();
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
        new Prompter(buff.toString()).prompt().then(process);
      }
    };

    new Prompter(buff.toString()).prompt().then(process);

    return completer.future;
  }
}

typedef String ChooserEntryFormatter<T>(T choice, int index);

class Prompter {
  final String message;
  final bool secret;

  Prompter(this.message, {this.secret: false});

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
  bool askSync({List<String> positive: const []}) {
    var answer = promptSync();
    return _YES_RESPONSES.contains(answer.toLowerCase()) ||
        positive.contains(message.toLowerCase());
  }

  Future<bool> ask({List<String> positive: const []}) {
    return prompt().then((answer) {
      return _YES_RESPONSES.contains(answer.toLowerCase()) ||
          positive.contains(message.toLowerCase());
    });
  }

  String promptSync({ResponseChecker checker}) {
    while (true) {
      Console.adapter.write(message);
      if (secret) Console.adapter.echoMode = false;
      var response = Console.readLine();
      if (secret) {
        Console.adapter.echoMode = true;
        print("");
      }
      if (checker != null ? checker(response) : true) {
        return response;
      }
    }
  }

  Future<String> prompt({ResponseChecker checker}) {
    var completer = new Completer();

    var doAsk;
    doAsk = () {
      Console.adapter.write(message);
      new Future(() {
        if (secret) Console.adapter.echoMode = false;
        var response = Console.readLine();
        if (secret) Console.adapter.echoMode = true;
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

Future<String> readInput(String message,
    {bool secret: false, ResponseChecker checker}) {
  return new Prompter(message, secret: secret).prompt(checker: checker);
}

typedef bool ResponseChecker(String response);

int _parseInteger(String input) {
  try {
    return int.parse(input);
  } catch (e) {
    return null;
  }
}
