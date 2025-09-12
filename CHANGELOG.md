## [0.1.3]

- Fixed: MappedListIterable JSON serialization error in stringify/indentJson functions

## [0.1.0]

- Added: Full DateTime casting support with pattern options
- Added: Map<K,V> casting with key/value decoders
- Added: Set<T> casting with item decoders

- Enhanced: Null safety across all casters
- Added: New extension methods for Map and Set types
- Enhanced: Error handling with detailed context information
- Added: Custom type casting registry for application-defined types
- Improved: Documentation with examples for all new types

## [0.0.7+7]

- Enhanced: `List` casting now applies `itemDecoder` when provided.

## [0.0.5+5]

- Added: DateTime API extension

## [0.0.4]

- Refactor: Core type casting and extension system
- Added: Extension API system (e.g., StringApi)
- Removed: Deprecated files and APIs (e.g., dynamic_cast.dart, maybeTruncate)

## [0.0.1+1.beta]

### Added

- Core type casting functionality for built-in Dart types
- Comprehensive error handling with CastException

<!-- [1.0.0]: https://github.com/venhdev/type_caster_dart/releases/tag/v1.0.0 -->
[0.0.1+1.beta]: https://github.com/venhdev/type_caster_dart/releases/tag/0.0.1+1.beta
