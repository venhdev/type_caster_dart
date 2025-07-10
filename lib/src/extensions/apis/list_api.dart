part of 'apis.dart';

extension ListApi on List {
  T? firstWhereOrNull<T>(
    bool Function(dynamic value) condition, {
    T Function()? orElse,
  }) {
    try {
      return firstWhere(condition, orElse: orElse);
    } catch (e) {
      return null;
    }
  }
}
