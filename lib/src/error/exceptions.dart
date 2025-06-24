import '../vendor/colored_logger/colored_logger.dart';

class CastException implements Exception {
  /// Error message
  final String? message;

  final dynamic src; // source type
  final String dst; // destination type

  /// Optional inner exception
  final Object? innerException;

  CastException(this.src, this.dst, {this.message, this.innerException});

  @override
  String toString() {
    final srcType = src?.runtimeType.toString() ?? 'null';
    final buffer = StringBuffer('Cannot cast $srcType to $dst');
    if (message != null) buffer.write(' | Message: $message');
    if (src != null) buffer.write(' | Source: $src');
    if (innerException != null) buffer.write(' | Inner: $innerException');
    return buffer.toString().red.toString();
  }
}
