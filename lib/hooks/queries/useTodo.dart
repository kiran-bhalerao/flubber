import 'package:flubber/dio/dio_client.dart';
import 'package:flubber/hooks/custom/useQuery.dart';
import 'package:flubber/model/todo.dart';

class UseTodo {
  static const key = "use-todo-key";

  static Future<dynamic> _getTodo(int todoId) {
    return dio.get("/todos/$todoId");
  }

  static QueryResult<Todo> query(int todoId, QueryOptions<Todo> options) {
    var query = useQuery<Todo>(QueryOptions(
      ref: options.ref,
      queryKey: key,
      queryFn: (prevData) async {
        final res = await _getTodo(todoId);
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
}
