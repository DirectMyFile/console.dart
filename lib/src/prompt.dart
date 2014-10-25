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
  stdin.lineMode = false;
  stdin.echoMode = false;
  var data = "";
  loop: while (true) {
    var byte = stdin.readByteSync();

    var char = new String.fromCharCode(byte);

    if (char == "\n" || char == "\r" || char == "\u0004") {
      Console.write("\n");
      break loop;
    }

    if (char == "\u0003") {
      exit(0);
    }

    if (char == '\b' || char == '\x7f' || char == '\x1b\x7f' || char == '\x1b\b') {
      if (data.length == 1) {
        data = "";
      } else if (data.length != 0) {
        data = data.substring(0, data.length - 1);
      }

      var display = "${prompt}";

      if (data.length > 0) {
        if (secret) {
          for (int i = 1; i <= data.length; i++) {
            display += "*";
          }
        } else {
          display += data;
        }
      }

      Console.overwriteLine(display);
      continue;
    }

    if (secret) {
      Console.write("*");
    } else {
      Console.write(char);
    }
    data += char;
  }
  stdin.lineMode = true;
  stdin.echoMode = true;
  return data;
}

bool yesOrNo(String message) {
  var answer = prompt(message);
  return _YES_RESPONSES.contains(answer.toLowerCase());
}
