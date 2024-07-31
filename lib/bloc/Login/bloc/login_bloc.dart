import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonClickedLoadingEvent>(loginButtonClickedLoadingEvent);
    on<LoginLoadingStopEvent>(loginLoadingStopEvent);
  }

  FutureOr<void> loginButtonClickedLoadingEvent(
      LoginButtonClickedLoadingEvent event, Emitter<LoginState> emit) {
    emit(LoginButtonClickedLoadingState());
  }

  FutureOr<void> loginLoadingStopEvent(
      LoginLoadingStopEvent event, Emitter<LoginState> emit) {
    emit(LoginLoadingStopState());
  }
}
