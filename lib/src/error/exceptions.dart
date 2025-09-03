import '../vendor/colored_logger/colored_logger.dart';

/// Exception thrown when a type cast operation fails.
class CastException implements Exception {
  /// Custom error message explaining the failure
  final String? message;

  /// Source value that failed to be cast
  final dynamic src;

  /// Target type name that the source failed to be cast to
  final String dst;

  /// Explicit source type name (optional)
  final String? srcType;

  /// Optional inner exception that caused the cast failure
  final Object? innerException;

  /// Optional stack trace where the cast operation failed
  final StackTrace? stackTrace;

  /// Optional context information about where/why the cast was attempted
  final String? context;

  /// Creates a new [CastException] with detailed information about the failed cast.
  ///
  /// - [src]: The source value that failed to be cast
  /// - [dst]: The target type name
  /// - [message]: Optional message explaining the failure
  /// - [innerException]: Optional inner exception that caused the failure
  /// - [srcType]: Optional explicit source type name
  /// - [stackTrace]: Optional stack trace where the failure occurred
  /// - [context]: Optional context information
  CastException(
    this.src,
    this.dst, {
    this.message,
    this.innerException,
    this.srcType,
    this.stackTrace,
    this.context,
  });

  /// Returns a detailed string representation of the exception.
  @override
  String toString() {
    final srcTypeStr = srcType ?? src?.runtimeType.toString() ?? 'null';
    final buffer = StringBuffer('Cannot cast $srcTypeStr to $dst');

    if (message != null) buffer.write(' | Message: $message');
    if (src != null) {
      // Format source value representation based on its type
      String srcStr;
      if (src is String) {
        srcStr = '"$src"';
      } else if (src is num || src is bool) {
        srcStr = src.toString();
      } else {
        srcStr = src.toString();
      }
      buffer.write(' | Source: $srcStr');
    }

    if (context != null) buffer.write(' | Context: $context');
    if (innerException != null) buffer.write(' | Inner: $innerException');

    return buffer.toString().red.toString();
  }

  /// Creates a new [CastException] with a more specific message.
  CastException withMessage(String newMessage) {
    return CastException(
      src,
      dst,
      message: newMessage,
      innerException: innerException,
      srcType: srcType,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// Creates a new [CastException] with additional context information.
  CastException withContext(String newContext) {
    return CastException(
      src,
      dst,
      message: message,
      innerException: innerException,
      srcType: srcType,
      stackTrace: stackTrace,
      context: newContext,
    );
  }
}
