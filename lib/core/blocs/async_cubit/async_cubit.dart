import 'package:flutter_bloc/flutter_bloc.dart';

import '../../index.dart';

part 'async_state.dart';

class AsyncCubit<T> extends Cubit<AsyncState<T>> {
  AsyncCubit({
    required T initialData,
  }) : super(
          AsyncState<T>(
            data: initialData,
            status: RequestStatus.initial,
          ),
        );

  void invokeCallback(
    FutureFailable<T> callback, {
    Function(T)? onSuccess,

    /// if needs to be loaded only once
    bool repeatLoading = true,
  }) async {
    if (state.status == RequestStatus.success && repeatLoading == false) {
      return;
    }

    if (state.status == RequestStatus.loading) {
      return;
    }
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await callback;
    result.fold(
        (failure) => emit(
              state.copyWith(
                status: RequestStatus.error,
                failure: failure,
              ),
            ), (r) {
      emit(
        state.copyWith(
          status: RequestStatus.success,
          data: r,
        ),
      );

      onSuccess?.call(r);
    });
  }

  void resetState() {
    emit(state.copyWith(status: RequestStatus.initial));
  }
}
