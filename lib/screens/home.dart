import 'package:flubber/hooks/custom/useQuery.dart';
import 'package:flubber/hooks/queries/useTodo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoId = useState(1);
    final todo = useTodo(todoId.value, QueryOptions(ref: ref));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(todoId.value.toString()),
            Text(todo.data?.title ?? '-'),
            ElevatedButton(
              onPressed: todo.isLoading
                  ? null
                  : () {
                      todoId.value = todoId.value + 1;
                    },
              child: Text(todo.isLoading ? "Loading" : "Load Next"),
            )
          ],
        ),
      ),
    );
  }
}
