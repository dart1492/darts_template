import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../index.dart';

/// designed specifically to register multiple cubits inside of it and then listen to
/// execute function when every registered cubit has RequestStatus.success  or RequestStatus.error status
class CombinedInitializationCubit extends AsyncCubit {
  late Stream _allEventsStream;
  late StreamSubscription _subscription;
  final List<Cubit<AsyncState>> cubitsToListen;

  CombinedInitializationCubit(this.cubitsToListen) : super(initialData: null);

  void startListening() {
    emit(state.copyWith(status: RequestStatus.loading));
    _allEventsStream = StreamGroup.merge(
      cubitsToListen.map((e) => e.stream).toList(),
    );

    _subscription = _allEventsStream.listen((event) async {
      final List<AsyncState<dynamic>> currentStates =
          cubitsToListen.map((elem) => elem.state).toList();

      /// Check if there is a failure present - then return the error state of the combined cubit itself
      if (currentStates.any((state) {
            return state.failure != null;
          }) &&
          state.status != RequestStatus.error) {
        emit(state.copyWith(status: RequestStatus.error, failure: Failure()));
        return;
      }

      bool isAllDone = true;
      for (var element in cubitsToListen) {
        if (element.state.status != RequestStatus.success &&
            element.state.status != RequestStatus.error) {
          isAllDone = false;
        }
      }
      if (isAllDone) {
        emit(state.copyWith(status: RequestStatus.success));
      }
    });
  }

  void stopListening() async {
    await _subscription.cancel();
  }
}
