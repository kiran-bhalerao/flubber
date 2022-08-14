part of "../useQuery.dart";

class QueryResult<T> {
  final T? data;
  final VoidCallback refetch;
  final bool isLoading;

  QueryResult({
    required this.data,
    required this.refetch,
    required this.isLoading,
  });
}
