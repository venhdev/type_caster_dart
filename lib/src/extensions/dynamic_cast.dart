import 'package:type_caster/type_caster.dart';

extension DynamicCastExtension on Object {
  String asString() => StringCaster().cast(this);
  String? tryString() => StringCaster().tryCast(this);

  int asInt() => IntCaster().cast(this);
  int? tryInt() => IntCaster().tryCast(this);

  double asDouble() => DoubleCaster().cast(this);
  double? tryDouble() => DoubleCaster().tryCast(this);

  bool asBool() => BoolCaster().cast(this);
  bool? tryBool() => BoolCaster().tryCast(this);

  List<T> asList<T>({
    List<T> Function()? orElse,
    T Function(dynamic)? itemDecoder,
    bool allowStringToList = true,
    String separator = ',',
  }) =>
      ListCaster<T>().cast(
        this,
        orElse: orElse,
        itemDecoder: itemDecoder,
        allowStringToList: allowStringToList,
        separator: separator,
      );

  List<T>? tryList<T>({
    List<T> Function()? orElse,
    T Function(dynamic)? itemDecoder,
    bool allowStringToList = true,
    String separator = ',',
  }) =>
      ListCaster<T>().tryCast(
        this,
        orElse: orElse,
        itemDecoder: itemDecoder,
        allowStringToList: allowStringToList,
        separator: separator,
      );
}
