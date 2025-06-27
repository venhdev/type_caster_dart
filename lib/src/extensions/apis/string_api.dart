part of 'apis.dart';

extension StringApi on String {
  String truncate([
    int? maxLength,
    String omission = '...',
    TruncatePosition position = TruncatePosition.end,
  ]) =>
      s.truncate(
        this,
        maxLength: maxLength,
        omission: omission,
        position: position,
      );

  num asNum([num Function()? orElse]) => core.asNum(this, orElse: orElse);
  int asInt([int Function()? orElse]) => core.asInt(this, orElse: orElse);
  double asDouble([double Function()? orElse]) =>
      core.asDouble(this, orElse: orElse);
  bool asBool([bool Function()? orElse]) => core.asBool(this, orElse: orElse);
  List<T> asList<T>(
          [List<T> Function()? orElse,
          T Function(dynamic)? itemDecoder,
          String separator = ',']) =>
      core.asList(
        this,
        orElse: orElse,
        itemDecoder: itemDecoder,
        separator: separator,
      );

  num? tryNum([num Function()? orElse]) => core.tryNum(this, orElse: orElse);
  int? tryInt([int Function()? orElse]) => core.tryInt(this, orElse: orElse);
  double? tryDouble([double Function()? orElse]) =>
      core.tryDouble(this, orElse: orElse);
  bool? tryBool([bool Function()? orElse]) =>
      core.tryBool(this, orElse: orElse);
  List<T>? tryList<T>(
          [List<T> Function()? orElse,
          T Function(dynamic)? itemDecoder,
          String separator = ',']) =>
      core.tryList(
        this,
        orElse: orElse,
        itemDecoder: itemDecoder,
        separator: separator,
      );
}
