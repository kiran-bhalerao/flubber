import 'package:flubber/dio/dio_client.dart';
import 'package:flubber/hooks/custom/useQuery.dart';
import 'package:flubber/model/todo.dart';

Future<dynamic> getTodo(int todoId) {
  return dio.get("/todos/$todoId");
}

QueryResult<Todo> useTodo(int todoId, QueryOptions<Todo> options) {
  var query = useQuery<Todo>(QueryOptions(
    ref: options.ref,
    queryKey: "child-1",
    queryFn: (prevData) async {
      final res = await getTodo(todoId);
      return Todo.fromJson(res.data);
    },
    dependencies: [todoId],
    enabled: options.enabled,
    runOnMount: options.runOnMount,
    onSuccess: options.onSuccess,
    onError: options.onError,
  ));

  return query;
}
