part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginButtonClickedLoadingEvent extends LoginEvent {}

class LoginLoadingStopEvent extends LoginEvent {}
