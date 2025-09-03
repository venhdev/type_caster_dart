part of 'apis.dart';

extension SetApi<T> on Set<T> {
  /// Returns a new list with the elements of this set.
  List<T> toListCast() => toList();
  
  /// Returns the first element that satisfies the given predicate, or null if there is no such element.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
  
  /// Returns a new set with all elements casted to the specified type.
  Set<R> mapCast<R>(R Function(T element) mapper) => 
      map(mapper).toSet();
      
  /// Converts this set to a string using the given separator.
  String join([String separator = ', ']) => 
      toList().join(separator);
}
