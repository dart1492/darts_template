part of 'async_cubit.dart';

class AsyncState<T> {
  T data;
  Failure? failure;
  RequestStatus status;
  AsyncState({
    required this.data,
    this.failure,
    required this.status,
  });

  AsyncState<T> copyWith({
    T? data,
    Failure? failure,
    RequestStatus? status,
  }) {
    return AsyncState<T>(
      data: data ?? this.data,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }
}
