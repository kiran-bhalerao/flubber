part of "../useQuery.dart";

class QueryOptions<T> {
  final WidgetRef ref;
  final String? queryKey;
  final Future<T> Function(T? data)? queryFn;
  final List<Object?>? dependencies;
  final void Function(T? data, T? prevData)? onSuccess;
  final void Function(dynamic error, T? prevData)? onError;
  bool? enabled;
  bool? runOnMount;

  QueryOptions({
    required this.ref,
    this.queryKey,
    this.queryFn,
    this.dependencies,
    this.onSuccess,
    this.onError,
    this.enabled = true,
    this.runOnMount = true,
  });
}
