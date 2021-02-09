import 'package:console/console.dart';

var questionCount = 0;
var points = 0;

class Question {
  final String message;
  final answer;
  final List<String> choices;

  Question(this.message, this.answer, {this.choices});

  bool askQuestion() {
    if (choices != null) {
      print(message);
      var chooser = Chooser<String>(scramble(choices), message: 'Answer: ');
      return chooser.chooseSync() == answer;
    } else if (answer is String) {
      return Prompter('${message} ').promptSync().toLowerCase().trim() ==
          answer.toLowerCase().trim();
    } else if (answer is bool) {
      return Prompter('${message} ').askSync() == answer;
    } else {
      throw Exception('');
    }
  }
}

void main() {
  const dartPeople = [
    'Dan Grove',
    'Michael Thomsen',
    'Leaf Petersen',
    'Bob Nystrom',
    'Vyacheslav Egorov',
    'Kathy Walrath',
  ];

  [
    Question('What conference was Dart released at?', 'GOTO Conference',
        choices: ['Google I/O', 'GOTO Conference', 'JavaOne', 'Dart Summit']),
    Question('Who is a Product Manager for Dart at Google?', 'Michael Thomsen',
        choices: dartPeople),
    Question('What is the package manager for Dart called?', 'pub'),
    Question('What type of execution model does Dart have?', 'Event Loop',
        choices: ['Multi Threaded', 'Single Threaded', 'Event Loop']),
    Question('Does Dart have an interface keyword?', false),
    Question(
        'Is this valid Dart code?\n  main() => print(\"Hello World\");\nAnswer: ',
        true),
    Question(
        'Is this valid Dart code?\n  void main() => print(\"Hello World\");\nAnswer: ',
        true),
    Question('Can you use Dart in the browser?', true),
    Question('What was the first Dart to JavaScript Compiler called?', 'dartc'),
    Question(
        'Before dart2js, what was the name of the Dart to JavaScript Compiler?',
        'frog'),
  ].forEach((q) {
    questionCount++;
    var correct = q.askQuestion();
    if (correct) {
      print(format('{color.green}${Icon.CHECKMARK}{color.normal} Correct'));
      points++;
    } else {
      print(format('{color.red}${Icon.BALLOT_X}{color.normal} Incorrect'));
    }
  });

  results();
}

void results() {
  print('Quiz Results:');
  print('  Correct: ${points}');
  print('  Incorrect: ${questionCount - points}');
  print('  Score: ${((points / questionCount) * 100).toStringAsFixed(2)}%');
}

List<String> scramble(List<String> choices) {
  var out = List<String>.from(choices);
  out.shuffle();
  return out;
}
