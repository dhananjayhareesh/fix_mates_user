part of 'user_details_bloc.dart';

@immutable
abstract class UserDetailsEvent {}

class UserDetailsSubmitted extends UserDetailsEvent {
  final String name;
  final String email;
  final String phone;

  UserDetailsSubmitted(this.name, this.email, this.phone);
}

class PhoneVerificationRequested extends UserDetailsEvent {
  final String phone;

  PhoneVerificationRequested(this.phone);
}
