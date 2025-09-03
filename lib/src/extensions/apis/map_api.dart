part of 'apis.dart';

extension MapApi<K, V> on Map<K, V> {
  /// Get a value from the map with the specified key.
  /// Returns null if the key doesn't exist.
  V? get(K key) => this[key];

  /// Get a value from the map with the specified key, or a default value if the key doesn't exist.
  V getOrDefault(K key, V defaultValue) => this[key] ?? defaultValue;

  /// Get a value from the map with the specified key, or call orElse if the key doesn't exist.
  V getOrElse(K key, V Function() orElse) => this[key] ?? orElse();

  /// Try to cast a value from the map to the specified type.
  T? tryCast<T>(K key, {T Function()? orElse}) =>
      containsKey(key) ? core.tryAs<T>(this[key], orElse: orElse) : null;

  /// Cast a value from the map to the specified type.
  T cast<T>(K key, {T Function()? orElse}) =>
      core.tryAs<T>(this[key], orElse: orElse) ??
      (orElse != null
          ? orElse()
          : throw CastException(this[key], T.toString()));

  /// Returns a new map with all values casted to the specified type.
  Map<K, T> mapValues<T>(T Function(V value) mapper) =>
      map((k, v) => MapEntry(k, mapper(v)));
}
