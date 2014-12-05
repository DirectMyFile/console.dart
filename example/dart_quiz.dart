import "package:console/console.dart";

var questionCount = 0;

void main() {
  question("What conference was Dart released at?", "GOTO Conference", [
    "Google I/O",
    "GOTO Conference",
    "JavaOne",
    "Dart Summit"
  ]);

  var dartPeople = [
    "Lars Bak",
    "Kasper Lund",
    "Seth Ladd",
    "Bob Nystrom",
    "Florian Loitsch",
    "Kathy Walrath"
  ];

  question("Who is the Product Manager for Dart at Google?", "Seth Ladd", dartPeople);
}

void question(String question, String correct, List<String> choices) {
  questionCount++;
  print("${question}");
  var chooser = new Chooser<String>(scramble(choices), message: "Select an Answer: ", formatter: (value, i) {
    return "  [${i}] ${value}";
  });
  var choice = chooser.chooseSync();
  if (choice != correct) {
    print(format("{color.red}${Icon.BALLOT_X}{color.normal} Sorry, the correct answer is '${correct}'"));
  } else {
    print(format("{color.green}${Icon.CHECKMARK}{color.normal} Correct"));
  }
}

List<String> scramble(List<String> choices) {
  var out = new List.from(choices);
  out.shuffle();
  return out;
}
