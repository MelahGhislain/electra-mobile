import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('onCreate Bloc: (${bloc.runtimeType})');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('onEvent Bloc: (${bloc.runtimeType}) event: $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange Bloc: (${bloc.runtimeType}) change: $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('onTransition Bloc: (${bloc.runtimeType}) transition: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('onError Bloc: (${bloc.runtimeType}) error: $error');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('onClose Bloc: (${bloc.runtimeType})');
  }
}
