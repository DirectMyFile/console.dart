import 'package:console/console.dart';
import 'package:test/test.dart';

void main() {
  test('draws top left block', () {
    final canvas = DrawingCanvas(4, 4);
    canvas.set(0, 0);
    final actual = canvas.frame('');
    expect(actual, equals('⠁ '));
  });

  test('draws top right block', () {
    final canvas = DrawingCanvas(4, 4);
    canvas.set(1, 0);
    final actual = canvas.frame('');
    expect(actual, equals('⠈ '));
  });

  test('draws bottom block', () {
    final canvas = DrawingCanvas(4, 4);
    canvas.set(0, 2);
    canvas.set(1, 2);
    final actual = canvas.frame('');
    expect(actual, equals('⠤ '));
  });

  test('draws full block', () {
    final canvas = DrawingCanvas(4, 4);
    canvas.set(0, 0);
    canvas.set(1, 0);
    canvas.set(0, 1);
    canvas.set(1, 1);
    canvas.set(0, 2);
    canvas.set(1, 2);
    final actual = canvas.frame('');
    expect(actual, equals('⠿ '));
  });

  test('clears top left block - clear before set', () {
    final canvas = DrawingCanvas(4, 4);
    canvas.set(0, 0);
    canvas.unset(0, 0);
    canvas.set(1, 0);
    final actual = canvas.frame('');
    expect(actual, equals('⠈ '));
  });

  test('clears top left block - clear after set', () {
    final canvas = DrawingCanvas(4, 4);
    canvas.set(0, 0);
    canvas.set(1, 0);
    canvas.unset(0, 0);
    final actual = canvas.frame('');
    expect(actual, equals('⠈ '));
  });
}
