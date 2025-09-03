part of 'apis.dart';

extension RecordApi2<A, B> on (A, B) {
  /// Swaps the elements of the record.
  (B, A) swap() => ($2, $1);
  
  /// Maps both elements of the record with the given functions.
  (C, D) mapBoth<C, D>(C Function(A) mapFirst, D Function(B) mapSecond) =>
      (mapFirst($1), mapSecond($2));
      
  /// Maps the first element of the record with the given function.
  (C, B) mapFirst<C>(C Function(A) mapper) => 
      (mapper($1), $2);
      
  /// Maps the second element of the record with the given function.
  (A, D) mapSecond<D>(D Function(B) mapper) => 
      ($1, mapper($2));
      
  /// Converts the record to a list.
  List<dynamic> toList() => [$1, $2];
  
  /// Converts the record to a map with keys "first" and "second".
  Map<String, dynamic> toMap() => {
    'first': $1,
    'second': $2,
  };
}
