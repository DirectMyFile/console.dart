part of console;

class DrawingCanvas {
  static final List<List<int>> _map = [
    [0x1, 0x8],
    [0x2, 0x10],
    [0x4, 0x20],
    [0x40, 0x80]
  ];

  final int width;
  final int height;

  List<int> content;

  DrawingCanvas(this.width, this.height) {
    if (width % 2 != 0) {
      throw new Exception("Width must be a multiple of 2!");
    }

    if (height % 4 != 0) {
      throw new Exception("Height must be a multiple of 4!");
    }

    content = new List<int>(width * height ~/ 8);
    _fillContent();
  }

  void _doIt(x, y, void func(coord, mask)) {
    if (!(x >= 0 && x < width && y >= 0 && y < height)) {
      return;
    }

    x = x.floor();
    y = y.floor();
    var nx = (x / 2).floor();
    var ny = (y / 4).floor();
    var coord = (nx + width / 2 * ny).toInt();
    var mask = _map[y % 4][x % 2];
    func(coord, mask);
  }

  void _fillContent([int byte = 0]) {
    for (var i = 0; i < content.length; i++) {
      content[i] = byte;
    }
  }

  void clear() {
    _fillContent();
  }

  void set(int x, int y) {
    _doIt(x, y, (coord, mask) {
      content[coord] |= mask;
    });
  }

  void unset(int x, int y) {
    _doIt(x, y, (coord, mask) {
      content[coord] &= mask;
    });
  }

  void toggle(int x, int y) {
    _doIt(x, y, (coord, mask) {
      content[coord] ^= mask;
    });
  }

  String frame([String delimiter = "\n"]) {
    var result = [];
    for (var i = 0, j = 0; i < content.length; i++, j++) {
      if (j == width / 2) {
        result.add(delimiter);
        j = 0;
      }

      if (content[i] == 0) {
        result.add(' ');
      } else {
        result.add(new String.fromCharCode(0x2800 + content[i]));
      }
    }
    result.add(delimiter);
    return result.join();
  }
}
