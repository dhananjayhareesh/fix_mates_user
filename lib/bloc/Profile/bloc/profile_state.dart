part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String userName;
  final String userEmail;
  ProfileLoaded({required this.userName, required this.userEmail});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
