# Type Caster Example

This example demonstrates the key features of the `type_caster` package.

## Running the Example

```bash
cd example
dart pub get
dart run main.dart
```

## What This Example Shows

- **Basic Type Casting**: Converting between common types with `asString()`, `tryInt()`, etc.
- **Extension Methods**: Using fluent API like `"123".asInt()`  
- **Collection Casting**: Converting strings to Lists, Sets, and Maps
- **DateTime Parsing**: With ISO format and custom patterns
- **Error Handling**: Safe conversions and detailed error messages
- **Custom Types**: Registering your own type casters

## Expected Output

The example will show various type conversions with their results, demonstrating both successful conversions and error handling scenarios.
