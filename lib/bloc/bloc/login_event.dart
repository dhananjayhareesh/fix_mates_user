part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class PhoneNumberChanged extends LoginEvent {
  final String phoneNumber;

  PhoneNumberChanged(this.phoneNumber);
}

final class SendOtpPressed extends LoginEvent {
  final String phoneNumber;

  SendOtpPressed(this.phoneNumber);
}
