import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleStateCubit<T> extends Cubit<T> {
  T initialState;
  SimpleStateCubit(this.initialState) : super(initialState);

  void setState(T Function(T) oldToNew) {
    emit(oldToNew(state));
  }
}
