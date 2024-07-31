// user_details_state.dart
part of 'user_details_bloc.dart';

@immutable
abstract class UserDetailsState {}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsSubmissionInProgress extends UserDetailsState {}

class UserDetailsSubmissionSuccess extends UserDetailsState {}

class UserDetailsSubmissionFailure extends UserDetailsState {
  final String error;

  UserDetailsSubmissionFailure(this.error);
}

class PhoneVerificationInProgress extends UserDetailsState {}

class PhoneVerificationSuccess extends UserDetailsState {
  final String verificationId;

  PhoneVerificationSuccess(this.verificationId);
}

class PhoneVerificationFailure extends UserDetailsState {
  final String error;

  PhoneVerificationFailure(this.error);
}
