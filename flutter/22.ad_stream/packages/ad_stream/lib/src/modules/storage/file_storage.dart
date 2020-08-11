import 'dart:typed_data';

abstract class FileReader {
  /// Read a file in bytes at [filePath]
  Uint8List read(String filePath);
}

abstract class FileWriter {
  /// Write a file content in bytes to [filePath]
  write(Uint8List content, String filePath);
}

abstract class FileStorage implements FileReader, FileWriter {}
