library console.utils;

List<dynamic> bresenham(x0, y0, x1, y1, [fn]) {
  var arr = [];
  fn ??= (x, y) {
    arr.add({'x': x, 'y': y});
  };
  var dx = x1 - x0;
  var dy = y1 - y0;
  var adx = dx.abs();
  var ady = dy.abs();
  var eps = 0;
  var sx = dx > 0 ? 1 : -1;
  var sy = dy > 0 ? 1 : -1;

  if (adx > ady) {
    for (var x = x0, y = y0; sx < 0 ? x >= x1 : x <= x1; x += sx) {
      fn(x, y);
      eps += ady as int;
      if ((eps << 1) >= adx) {
        y += sy;
        eps -= adx as int;
      }
    }
  } else {
    for (var x = x0, y = y0; sy < 0 ? y >= y1 : y <= y1; y += sy) {
      fn(x, y);
      eps += adx as int;

      if ((eps << 1) >= ady) {
        x += sx;
        eps -= ady as int;
      }
    }
  }
  return arr;
}
