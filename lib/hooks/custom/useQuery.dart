import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'event_bus.dart';
part "query_class/QueryNotifier.dart";
part "query_class/QueryOptions.dart";
part "query_class/QueryRefetch.dart";
part "query_class/QueryResult.dart";
part "query_class/QueryState.dart";

// useQuery does not provide caching solution
// it will just help to store req data, loading state and refetch data whenever user wants, either from same widget or different

QueryResult<T> useQuery<T>(QueryOptions<T> options) {
  final isFirst = useRef(true);

  final queryProvider = useMemoized(() {
    return StateNotifierProvider<QueryNotifier<T>, QueryState<T>>((ref) {
      return QueryNotifier();
    });
  }, []);

  update(QueryState<T> newState) {
    options.ref.read(queryProvider.notifier).update(newState);
  }

  run() async {
    if (options.queryFn == null) {
      throw "queryFn required";
    }

    if (options.enabled != true) {
      return;
    }

    final prevData = options.ref.watch(queryProvider).data;
    update(QueryState(data: prevData, isLoading: true));
    try {
      final value = await options.queryFn!(prevData);
      update(QueryState(data: value, isLoading: false));

      if (options.onSuccess != null) {
        options.onSuccess!(value, prevData);
      }
    } catch (e) {
      update(QueryState(data: prevData, isLoading: false));

      if (options.onError != null) {
        options.onError!(e, prevData);
      }
    }
  }

  final streamSub = useMemoized(() {
    if (options.queryKey == null) {
      throw "queryKey required";
    }

    return QueryRefetch.listen(options.queryKey!, run);
  }, [options.queryKey]);

  useEffect(() {
    if (options.runOnMount == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        run();
      });
    }

    return;
  }, [options.runOnMount]);

  useEffect(() {
    if (!isFirst.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        run();
      });
    }

    return;
  }, [...?options.dependencies, options.enabled]);

  useEffect(() {
    isFirst.value = false;
    return () => streamSub.cancel();
  }, []);

  return QueryResult(
    data: options.ref.watch(queryProvider).data,
    refetch: run,
    isLoading: options.ref.watch(queryProvider).isLoading,
  );
}
