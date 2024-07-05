part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class PhoneNumberValid extends LoginState {}

final class PhoneNumberInvalid extends LoginState {}

final class OtpSent extends LoginState {}

final class UserNotFound extends LoginState {}

final class LoginError extends LoginState {
  final String error;

  LoginError(this.error);
}
