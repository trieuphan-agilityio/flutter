import 'dart:async';
import 'dart:convert';

main() {
  final splitDecoded = StreamTransformer<List<int>, String>.fromBind((stream) {
    return stream.transform(utf8.decoder);
  });
}
