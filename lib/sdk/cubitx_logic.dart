import 'dart:async';
import 'package:get/get.dart';

abstract class Cubit<S> {
  late Rx<S> _state;
  final List<StreamSubscription> _subs = [];

  S state() => _state.value;

  Cubit(S initialState, {List<Cubit> dependencies = const <Cubit>[]}) {
    _state = Rx(onStateComputed(initialState));

    for (var dep in dependencies) {
      _subs.add(dep._state.listen((_) =>
      {
        _state.value = onStateComputed(_state.value)
      }));
    }

    onStarted();
  }

  void stopCubit() {
    for (var sub in _subs) {
      sub.cancel();
    }
    _subs.clear();
    onStopped();
  }

  void onStarted() {}

  void onStopped() {}

  void update(S state) {
    _state.value = onStateComputed(state);
  }

  S onStateComputed(S state) {
    return state;
  }
}
