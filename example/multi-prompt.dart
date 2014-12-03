import "dart:async";
import "package:console/console.dart";

class Prompt {
  Prompt(this.key, this.message, {this.secret: false});

  final String key;
  final String message;

  final bool secret;
}

Future<Map<String, String>> promptMultiple(List<Prompt> prompts) {
  var future = new Future(() => null);
  var results = {};

  for (var p in prompts) {
    future = future.then((_) {
      return prompt(p.message, secret: p.secret);
    }).then((value) {
      results[p.key] = value;
    });
  }

  future = future.then((_) {
    return results;
  });

  return future;
}


void main() {
  var prompts = [new Prompt("name", "What is your name? "), new Prompt("age", "What is your age? ")];

  promptMultiple(prompts).then((results) {
    print("Hello ${results['name']}, you are ${results['age']} years old.");
  });
}
