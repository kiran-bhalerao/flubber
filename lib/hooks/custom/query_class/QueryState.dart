part of "../useQuery.dart";

class QueryState<T> {
  final T? data;
  final bool isLoading;

  QueryState({
    required this.data,
    required this.isLoading,
  });
}
