part of "../useQuery.dart";

class QueryRefetch {
  String queryKey;

  QueryRefetch({required this.queryKey}) {
    queryKey = _createQueryString(queryKey);
  }

  refetch() {
    _eventBus.fire(this);
  }

  static _createQueryString(String queryKey) {
    return "__${(QueryRefetch).toString()}__$queryKey";
  }

  static StreamSubscription<QueryRefetch> listen(String queryKey, Function fn) {
    return _eventBus.on<QueryRefetch>().listen((event) {
      if (event.queryKey == _createQueryString(queryKey)) {
        fn();
      }
    });
  }
}
