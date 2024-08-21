import 'dart:async';
import 'package:darts_template_right/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AsyncBlocListener<T> extends StatelessWidget {
  final Function(T)? onSuccess;
  final Function(Failure)? onError;
  final Function()? onLoading;
  final AsyncCubit<T>? cubit;

  final Widget? child;

  const AsyncBlocListener({
    super.key,
    this.child,
    this.onError,
    this.onLoading,
    this.onSuccess,
    this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AsyncCubit<T>, AsyncState<T>>(
      bloc: cubit,
      listener: (context, state) {
        if (state.status == RequestStatus.error) {
          onError?.call(state.failure!);
        }

        if (state.status == RequestStatus.success) {
          onSuccess?.call(state.data);
        }

        if (state.status == RequestStatus.loading) {
          onLoading?.call();
        }
      },
      child: child ?? const SizedBox(),
    );
  }
}

class MultiAsyncBlocListener extends StatefulWidget {
  final List<AsyncBlocListener> listeners;
  final Widget? child;
  const MultiAsyncBlocListener({
    super.key,
    this.child,
    required this.listeners,
  });

  @override
  State<MultiAsyncBlocListener> createState() => _MultiAsyncBlocListenerState();
}

class _MultiAsyncBlocListenerState extends State<MultiAsyncBlocListener> {
  late List<StreamSubscription> subscriptions;

  @override
  void initState() {
    super.initState();
    subscriptions = widget.listeners.map((listener) {
      return listener.cubit!.stream.listen(
        (state) {
          if (state.status == RequestStatus.error) {
            listener.onError?.call(state.failure!);
          }

          if (state.status == RequestStatus.success) {
            listener.onSuccess?.call(state.data);
          }

          if (state.status == RequestStatus.loading) {
            listener.onLoading?.call();
          }
        },
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}
