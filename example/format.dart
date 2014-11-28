import "package:console/console.dart";

void main() {
  // Basic Builtin Variables
  {
    // Single Bracket Variable Style
    print(format("User: {env.USER}"));
    print(format("Hostname: {platform.hostname}"));
    
    // Switch to Double Bracket Variable Style
    VariableStyle.DEFAULT = VariableStyle.DOUBLE_BRACKET;
    
    // Double Bracket Variable Style
    print(format("User: {{env.USER}}"));
    print(format("Hostname: {{platform.hostname}}"));
    
    // Switch to Bash Bracket Variable Style
    VariableStyle.DEFAULT = VariableStyle.BASH_BRACKET;
    
    // Bash Bracket Variable Style
    print(format(r"User: ${env.USER}"));
    print(format(r"Hostname: ${platform.hostname}"));
  }
  
  VariableStyle.DEFAULT = VariableStyle.SINGLE_BRACKET;
  
  // Custom Variables
  {
    // Using Replacement Variables
    print(format("Hello, {name}", replace: {
      "name": "Alex"
    }));
    
    // Using Argument Based Variables
    print(format("Hello, {0}", args: ["Alex"]));
  }
  
  // Text Color
  {
    // Using @color syntax
    print(format("{@gold}Hello!{@end}"));
    
    // Using color.* syntax
    print(format("{color.gold}Hello!{color.end}"));
  }
  
  // Use Zones to isolate actions with a format variable style
  VariableStyle.withStyle(VariableStyle.DOUBLE_BRACKET, () {
    print(format("Dart Version: {{platform.version}}"));
    print(format("Script Path: {{platform.script}}"));
  });
}
