import 'package:console/console.dart';

void main() {
  var shell = ShellPrompt();
  shell.loop().listen((line) {
    if (['stop', 'quit', 'exit'].contains(line.toLowerCase().trim())) {
      shell.stop();
      return;
    }
    print(line);
  });
}
