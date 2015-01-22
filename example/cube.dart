import "package:console/console.dart";
import "package:vector_math/vector_math.dart";
import "dart:math";
import "dart:io";
import "dart:async";

var points = [
  [-1.0, -1.0, -1.0],
  [-1.0, -1.0, 1.0],
  [1.0, -1.0, 1.0],
  [1.0, -1.0, -1.0],
  [-1.0, 1.0, -1.0],
  [-1.0, 1.0, 1.0],
  [1.0, 1.0, 1.0],
  [1.0, 1.0, -1.0]
];

var quads = [[0,1,2,3],[0,4,5,1],[1,5,6,2],[2,6,7,3],[3,7,4,0],[4,7,6,5]];

var cube = (() {
  return quads.map((quad) {
    return quad.map((v) {
      return new Vector3.array(points[v]);
    }).toList();
  }).toList();
})();

var projection =  makePerspectiveMatrix(PI / 3.0, 1.0, 1.0, 50.0);
var canvas = new Canvas(160, 160);

void draw() {
  var now = new DateTime.now().millisecondsSinceEpoch;
  var modelView = makeViewMatrix(new Vector3(0.0, 0.1, 4.0), new Vector3(0.0, 0.0, 0.0), new Vector3(0.0, 1.0, 0.0));
  modelView = modelView.rotateY(PI * 2 * now / 10000);
  modelView = modelView.rotateZ(PI * 2 * now / 11000);
  modelView = modelView.rotateX(PI * 2 * now / 9000);
  modelView = modelView.scale(new Vector3(sin(now / 1000 * PI) / 2 + 1, 1.0, 1.0));
  canvas.clear();
  
  var transformed = cube.map((quad) {
    return quad.map((v) {
      var m;
      var out = new Vector3.zero();
      m = projection * modelView;
      out = m.transform3(v);
      return {
        "x": (out[0] * 40 + 80).floor(),
        "y": (out[1] * 40 + 80).floor()
      };
    });
  });
  
  transformed.forEach((quad) {
    var i = 0;
    quad = quad.toList();
    quad.forEach((v) {
      
      var n = quad[(i.abs() + 1) % 4];
      bresenham(v["x"], v["y"], n["x"], n["y"], canvas.set);
      i++;
    });
  });
  
  stdout.write(canvas.frame());
}

bresenham(x0, y0, x1, y1, [fn]) {
  var arr = [];
  if (fn == null) {
    fn = (x, y) {
      arr.add({ "x": x, "y": y });
    };
  }
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
      eps += ady;
      if((eps<<1) >= adx) {
        y += sy;
        eps -= adx;
      }
    }
  } else {
    for (var x = x0, y = y0; sy < 0 ? y >= y1 : y <= y1; y += sy) {
      fn(x, y);
      eps += adx;
      
      if ((eps<<1) >= ady) {
        x += sx;
        eps -= ady;
      }
    }
  }
  return arr;
}

void main() {
  new Timer.periodic(new Duration(milliseconds: 1000 / 24), (_) {
    draw();
  });
}