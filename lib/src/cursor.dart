part of console;

class Cursor {
  CursorPosition get position => Terminal.getCursorPosition();
  
  Cursor();
  
  void move(int column, int row) {
    Terminal.moveCursor(column: column, row: row);
  }
  
  void moveUp([int times = 1]) {
    Terminal.moveCursorUp(times);
  }
  
  void moveDown([int times = 1]) {
    Terminal.moveCursorDown(times);
  }
  
  void moveLeft([int times = 1]) {
    Terminal.moveCursorBack(times);
  }
  
  void moveRight([int times = 1]) {
    Terminal.moveCursorForward(times);
  }
  
  void show() {
    Terminal.showCursor();
  }
  
  void hide() {
    Terminal.hideCursor();
  }
  
  void write(String text) {
    Terminal.write(text);
  }
  
  void writeAt(int column, int row, String text) {
    Terminal.saveCursor();
    write(text);
    Terminal.restoreCursor();
  }
  
  void save() {
    Terminal.saveCursor();
  }
  
  void restore() {
    Terminal.restoreCursor();
  }
}