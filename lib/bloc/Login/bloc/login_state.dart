part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginButtonClickedLoadingState extends LoginState {}

class LoginLoadingStopState extends LoginState {}
