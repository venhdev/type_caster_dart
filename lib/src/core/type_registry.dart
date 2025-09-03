import 'dart:collection';

/// A registry for custom type casters.
///
/// This class provides a way to register custom type casters for specific types,
/// which can then be used by the `tryAs<T>` and related functions.
class TypeCasterRegistry {
  /// Singleton instance of the registry.
  static final TypeCasterRegistry _instance = TypeCasterRegistry._();

  /// Gets the singleton instance of the registry.
  static TypeCasterRegistry get instance => _instance;

  /// Private constructor to enforce the singleton pattern.
  TypeCasterRegistry._();

  /// Map of type names to their corresponding caster functions.
  final Map<Type, Function> _casters = HashMap<Type, Function>();

  /// Registers a custom caster function for a specific type.
  ///
  /// The [casterFn] function should take a dynamic value and optional orElse function
  /// and return an instance of type T.
  ///
  /// Example:
  /// ```dart
  /// TypeCasterRegistry.instance.register<User>((dynamic value, {User Function()? orElse}) {
  ///   if (value is Map<String, dynamic>) {
  ///     return User.fromJson(value);
  ///   }
  ///   if (orElse != null) {
  ///     return orElse();
  ///   }
  ///   throw CastException(value, 'User');
  /// });
  /// ```
  void register<T>(T Function(dynamic value, {T Function()? orElse}) casterFn) {
    _casters[T] = casterFn;
  }

  /// Unregisters a custom caster for the specified type.
  void unregister<T>() {
    _casters.remove(T);
  }

  /// Clears all registered custom casters.
  void clear() {
    _casters.clear();
  }

  /// Checks if a custom caster is registered for the specified type.
  bool hasCustomCaster<T>() {
    return _casters.containsKey(T);
  }

  /// Gets the custom caster function for the specified type.
  /// Returns null if no custom caster is registered for the type.
  T Function(dynamic value, {T Function()? orElse})? getCustomCaster<T>() {
    final caster = _casters[T];
    if (caster == null) return null;
    return caster as T Function(dynamic value, {T Function()? orElse});
  }

  /// Tries to cast the value using a registered custom caster.
  /// Returns null if no custom caster is registered for the type or if the cast fails.
  T? tryCustomCast<T>(dynamic value, {T Function()? orElse}) {
    if (!hasCustomCaster<T>()) return null;

    try {
      final caster = _casters[T] as T Function(dynamic, {T Function()? orElse});
      return caster(value, orElse: orElse);
    } catch (_) {
      return orElse?.call();
    }
  }
}
