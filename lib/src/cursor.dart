part of console;

class Cursor {
  CursorPosition get position => Console.getCursorPosition();
  
  Cursor();
  
  void move(int column, int row) {
    Console.moveCursor(column: column, row: row);
  }
  
  void moveUp([int times = 1]) {
    Console.moveCursorUp(times);
  }
  
  void moveDown([int times = 1]) {
    Console.moveCursorDown(times);
  }
  
  void moveLeft([int times = 1]) {
    Console.moveCursorBack(times);
  }
  
  void moveRight([int times = 1]) {
    Console.moveCursorForward(times);
  }
  
  void show() {
    Console.showCursor();
  }
  
  void hide() {
    Console.hideCursor();
  }
  
  void write(String text) {
    Console.write(text);
  }
  
  void writeAt(int column, int row, String text) {
    Console.saveCursor();
    write(text);
    Console.restoreCursor();
  }
  
  void save() {
    Console.saveCursor();
  }
  
  void restore() {
    Console.restoreCursor();
  }
}