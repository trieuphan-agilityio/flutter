main() {}

/// Splits a stream of consecutive strings into lines.
///
/// The input string is provided in smaller chunks through
/// the `source` stream.
Stream<String> lines(Stream<String> source) async* {
  // Stores any partial line from the previous chunk.
  var partial = '';
  // Wait until a new chunk is available, then process it.
  await for (var chunk in source) {
    var lines = chunk.split('\n');
    lines[0] = partial + lines[0];
    partial = lines.removeLast();
    for (var line in lines) {
      yield line;
    }
  }
  // Add final partial line to output stream, if any.
  if (partial.isNotEmpty) yield partial;
}
