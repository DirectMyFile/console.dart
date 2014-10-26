part of console;

RegExp _FMT_REGEX = new RegExp(r"\{\{(.+?)\}\}");

Map<String, Color> _COLORS = {
  "black": new Color(0),
  "gray": new Color(0, bright: true),
  "red": new Color(1),
  "dark_red": new Color(1, bright: true),
  "lime": new Color(2, bright: true),
  "green": new Color(2),
  "gold": new Color(3),
  "yellow": new Color(3, bright: true),
  "blue": new Color(4, bright: true),
  "dark_blue": new Color(4),
  "magenta": new Color(5),
  "light_magenta": new Color(5, bright: true),
  "cyan": new Color(6),
  "light_cyan": new Color(6, bright: true),
  "light_gray": new Color(7),
  "white": new Color(7, bright: true)
};

String format(String input, {List<String> args, Map<String, String> replace}) {
  var out = input;

  var matches = _FMT_REGEX.allMatches(input);
  
  var allKeys = new Set<String>();
  
  for (var match in matches) {
    if (match.group(0).startsWith("\$")) {
      continue;
    }
    
    var key = match.group(1);
    if (!allKeys.contains(key)) {
      allKeys.add(key);
    }
  }
  
  for (var id in allKeys) {
    if (args != null) {
      try {
        var index = int.parse(id);
        if (index < 0 || index > args.length - 1) {
          throw new RangeError.range(index, 0, input.length - 1);
        }
        out = out.replaceAll("{{${index}}}", args[index]);
        continue;
      } on FormatException catch (e) {}
    }

    if (replace != null && replace.containsKey(id)) {
      out = out.replaceAll("{{${id}}}", replace[id]);
      continue;
    }
    
    if (id.startsWith("color:")) {
      var color = id.substring(6);
      if (color.length == 0) {
        throw new Exception("color directive requires an argument");
      }
      
      if (_COLORS.containsKey(color)) {
        out = out.replaceAll("{{${id}}}", _COLORS[color].toString());
        continue;
      }
      
      if (color == "normal") {
        out = out.replaceAll("{{color:normal}}", "${Console.ANSI_ESCAPE}0m");
        continue;
      }
    }
    
    throw new Exception("Unknown Key: ${id}");
  }

  return out;
}
