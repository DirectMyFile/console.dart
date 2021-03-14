import 'package:console/console.dart';
import 'package:console/utils.dart';

import 'package:vector_math/vector_math.dart';
import 'dart:math';
import 'dart:io';
import 'dart:async';

List<List<double>> points = [
  [-1.0, -1.0, -1.0],
  [-1.0, -1.0, 1.0],
  [1.0, -1.0, 1.0],
  [1.0, -1.0, -1.0],
  [-1.0, 1.0, -1.0],
  [-1.0, 1.0, 1.0],
  [1.0, 1.0, 1.0],
  [1.0, 1.0, -1.0],
];

List<List<int>> quads = [
  [0, 1, 2, 3],
  [0, 4, 5, 1],
  [1, 5, 6, 2],
  [2, 6, 7, 3],
  [3, 7, 4, 0],
  [4, 7, 6, 5],
];

var cube = (() {
  return quads.map((quad) {
    return quad.map((v) {
      return Vector3.array(points[v]);
    }).toList();
  }).toList();
})();

var projection = makePerspectiveMatrix(pi / 3.0, 1.0, 1.0, 50.0);
var canvas = DrawingCanvas(160, 160);

void draw() {
  var now = DateTime.now().millisecondsSinceEpoch;
  var modelView = makeViewMatrix(
    Vector3(0.0, 0.1, 4.0),
    Vector3(0.0, 0.0, 0.0),
    Vector3(0.0, 1.0, 0.0),
  );

  modelView.rotateY(pi * 2 * now / 10000);
  modelView.rotateZ(pi * 2 * now / 11000);
  modelView.rotateX(pi * 2 * now / 9000);
  modelView.scale(Vector3(sin(now / 1000 * pi) / 2 + 1, 1.0, 1.0));
  canvas.clear();

  var transformed = cube.map((quad) {
    return quad.map((v) {
      Matrix4 m;
      var out = Vector3.zero();
      m = projection * modelView;
      out = m.transform3(v);
      return {
        'x': (out[0] * 40 + 80).floor(),
        'y': (out[1] * 40 + 80).floor(),
      };
    });
  });

  transformed.forEach((quadIterable) {
    var i = 0;
    final quad = quadIterable.toList();
    quad.forEach((v) {
      var n = quad[((i.isNegative ? i.abs() : -i) + 1) % 4];
      bresenham(v['x']!, v['y']!, n['x']!, n['y']!, canvas.set);
      i++;
    });
  });

  stdout.write(canvas.frame());
}

void main() {
  Timer.periodic(Duration(milliseconds: 1000 ~/ 24), (_) {
    draw();
  });
}
