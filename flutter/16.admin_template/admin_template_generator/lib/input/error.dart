import 'package:meta/meta.dart';

/// An error in input source detected by the generator.
///
/// Optionally specifies the location of the error and the source code to
/// replace it to fix the error.
class GeneratorError {
  /// Error message for the user.
  final String message;

  /// Optionally, the offset of the incorrect code.
  final int offset;

  /// Optionally, the length of the incorrect code.
  final int length;
  final String fix;

  /// Optionally, the fix for the incorrect code.
  GeneratorError({
    @required this.message,
    this.offset,
    this.length,
    this.fix,
  });

  GeneratorError copyWith({
    String message,
    int offset,
    int length,
    String fix,
  }) {
    return GeneratorError(
      message: message ?? this.message,
      offset: offset ?? this.offset,
      length: length ?? this.length,
      fix: fix ?? this.fix,
    );
  }
}
