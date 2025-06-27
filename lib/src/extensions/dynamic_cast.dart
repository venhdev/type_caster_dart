import '../core/caster_core.dart';
import '../utils/string_utils.dart' as s;

part 'string_apis.dart';

T? tryAs<T>(dynamic dst) => (dst is T) ? dst : null;
String? tryString(dynamic val) => StringCaster().tryCast(val);
num? tryNum(dynamic val) => NumberCaster().tryCast(val);
int? tryInt(dynamic val) => IntCaster().tryCast(val);
double? tryDouble(dynamic val) => DoubleCaster().tryCast(val);
bool? tryBool(dynamic val) => BoolCaster().tryCast(val);

String asString(dynamic val) => StringCaster().cast(val);
num asNum(dynamic val) => NumberCaster().cast(val);
int asInt(dynamic val) => IntCaster().cast(val);
double asDouble(dynamic val) => DoubleCaster().cast(val);
bool asBool(dynamic val) => BoolCaster().cast(val);
List<T> asList<T>(
  dynamic val, {
  List<T> Function()? orElse,
  T Function(dynamic)? itemDecoder,
  bool allowStringToList = true,
  String separator = ',',
}) =>
    ListCaster<T>().cast(
      val,
      orElse: orElse,
      itemDecoder: itemDecoder,
      allowStringToList: allowStringToList,
      separator: separator,
    );

extension DynamicCastExtension on Object {
  T? tryAs<T>() => (this is T) ? (this as T) : null;

  String asString() => StringCaster().cast(this);
  String? tryString() => StringCaster().tryCast(this);

  num asNum() => NumberCaster().cast(this);
  num? tryNum() => NumberCaster().tryCast(this);

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
