import "dart:io";
import "package:console/console.dart";

var questionCount = 0;
var points = 0;

class Question {
  final String message;
  final answer;
  final List<String> choices;

  Question(this.message, this.answer, {this.choices});

  bool askQuestion() {
    if (choices != null) {
      console.log(message);
      var chooser = new Chooser<String>(scramble(choices), message: "Answer: ");
      return chooser.chooseSync() == answer;
    } else if (answer is String) {
      return new Prompter("${message} ").promptSync().toLowerCase().trim() == answer.toLowerCase().trim();
    } else if (answer is bool) {
      return new Prompter("${message} ").askSync() == answer;
    } else {
      throw new Exception("");
    }
  }
}

void main() {
  var dartPeople = [
    "Lars Bak",
    "Kasper Lund",
    "Seth Ladd",
    "Bob Nystrom",
    "Florian Loitsch",
    "Kathy Walrath"
  ];

  [
    new Question("What conference was Dart released at?", "GOTO Conference", choices: [
      "Google I/O",
      "GOTO Conference",
      "JavaOne",
      "Dart Summit"
    ]),
    new Question("Who is the Product Manager for Dart at Google?", "Seth Ladd", choices: dartPeople),
    new Question("What type system does Dart have?", "Dynamic", choices: [ "Static", "Dynamic" ]),
    new Question("What is the package manager for Dart called?", "pub"),
    new Question("What type of execution model does Dart have?", "Event Loop", choices: [ "Multi Threaded", "Single Threaded", "Event Loop" ]),
    new Question("Does Dart have an interface keyword?", false),
    new Question("Is this valid Dart code?\n  main() => print(\"Hello World\");\nAnswer: ", true),
    new Question("Is this valid Dart code?\n  void main() => print(\"Hello World\");\nAnswer: ", true),
    new Question("Can you use Dart in the browser?", true),
    new Question("What was the first Dart to JavaScript Compiler called?", "dartc"),
    new Question("Before dart2js, what was the name of the Dart to JavaScript Compiler?", "frog"),
    new Question("Is Dart faster than JavaScript in most cases?", true)
  ].forEach((q) {
   questionCount++;
    var correct = q.askQuestion();
    if (correct) {
      print(format("{color.green}${Icon.CHECKMARK}{color.normal} Correct"));
      points++;
    } else {
      print(format("{color.red}${Icon.BALLOT_X}{color.normal} Incorrect"));
    }
  });

  results();
}

void results() {
  print("Quiz Results:");
  print("  Correct: ${points}");
  print("  Incorrect: ${questionCount - points}");
  print("  Score: ${((points / questionCount) * 100).toStringAsFixed(2)}%");
}

List<String> scramble(List<String> choices) {
  var out = new List.from(choices);
  out.shuffle();
  return out;
}
