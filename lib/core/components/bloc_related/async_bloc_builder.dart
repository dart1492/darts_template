import 'package:darts_template_right/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bloc builder for the AsyncCubit. Exposes optional functino for different key conditions - loading, success, error, etc.
/// IF not stated - resets to the onAll function call.
class AsyncBlocBuilder<T> extends StatelessWidget {
  final Widget? Function(T)? onSuccess;
  final Widget? Function(Failure)? onError;
  final Widget? Function()? onLoading;
  final Widget Function(T, Failure?) onAll;
  final AsyncCubit<T>? cubit;

  const AsyncBlocBuilder({
    super.key,
    this.onError,
    this.onLoading,
    this.onSuccess,
    this.cubit,
    required this.onAll,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: cubit,
      buildWhen: (previous, current) => true,
      builder: (context, state) {
        (state as AsyncState<T>);
        if (state.status == RequestStatus.loading) {
          return onLoading?.call() ?? onAll.call(state.data, state.failure);
        }

        if (state.status == RequestStatus.success) {
          return onSuccess?.call(state.data) ??
              onAll.call(state.data, state.failure);
        }

        if (state.status == RequestStatus.error) {
          return onError?.call(state.failure!) ??
              onAll.call(state.data, state.failure);
        }

        return onAll.call(state.data, state.failure);
      },
    );
  }
}
