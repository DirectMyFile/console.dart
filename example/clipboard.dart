import 'package:console/console.dart';

import 'dart:io';

void main() {
  var clip = getClipboard();
  if (clip == null) {
    throw Exception('${Platform.operatingSystem} is not supported.');
  }

  var prev = clip.getContent();
  print('Previous clipboard: $prev');

  clip.setContent('Hello!');

  var cur = clip.getContent();
  print('Current clipboard: $cur');
}
