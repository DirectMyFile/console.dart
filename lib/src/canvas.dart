part of console;

abstract class Canvas {
  int get width;
  int get height;

  void setPixel(int x, int y, int value);
}

class ConsoleCanvas extends Canvas {
  int get width => Console.columns;
  int get height => Console.rows;

  List<List<PixelSpec>> pixels;
  Cursor cursor;

  ConsoleCanvas({PixelSpec defaultSpec: PixelSpec.EMPTY}) {
    pixels = new List<List<PixelSpec>>.generate(width, (i) {
      return new List<PixelSpec>.filled(height, defaultSpec);
    });
    cursor = new Cursor();
  }

  @override
  void setPixel(int x, int y, dynamic spec) {
    pixels[x][y] = spec is PixelSpec
        ? spec
        : spec is int
            ? new PixelSpec(color: spec)
            : throw new Exception("Invalid Pixel Spec: ${spec}");
  }

  void flush() {
    cursor.move(0, 0);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var pixel = pixels[x][y];
        Console.write("\x1b[48;5;${pixel.color}m ");
        cursor.move(x, y);
      }
    }
  }
}

class PixelSpec {
  static const PixelSpec EMPTY = const PixelSpec();

  final int color;

  const PixelSpec({this.color: 0});
}
