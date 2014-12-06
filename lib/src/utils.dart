part of console;

Map _combineMaps(List<Map> maps) {
  var out = {};
  for (var it in maps) {
    out.addAll(it);
  }
  return out;
}

