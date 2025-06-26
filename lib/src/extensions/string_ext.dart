import '../utils/string_utils.dart' as utils;

extension StringExt on String {
  String maybeTruncate([int? maxLength]) =>
      utils.maybeTruncate(this, maxLength);
}
