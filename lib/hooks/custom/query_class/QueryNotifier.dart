part of "../useQuery.dart";

class QueryNotifier<T> extends StateNotifier<QueryState<T>> {
  QueryNotifier() : super(QueryState(data: null, isLoading: false));

  update(QueryState<T> newState) {
    state = newState;
  }
}
