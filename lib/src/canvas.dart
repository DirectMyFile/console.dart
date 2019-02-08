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

  ConsoleCanvas({PixelSpec defaultSpec = PixelSpec.EMPTY}) {
    pixels = List<List<PixelSpec>>.generate(width, (i) {
      return List<PixelSpec>.filled(height, defaultSpec);
    });
    cursor = Cursor();
  }

  @override
  void setPixel(int x, int y, dynamic spec) {
    pixels[x][y] = spec is PixelSpec
        ? spec
        : spec is int
            ? PixelSpec(color: spec)
            : throw Exception("Invalid Pixel Spec: ${spec}");
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
  static const PixelSpec EMPTY = PixelSpec();

  final int color;

  const PixelSpec({this.color = 0});
}
