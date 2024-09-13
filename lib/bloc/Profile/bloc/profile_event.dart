part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class FetchProfileData extends ProfileEvent {}

class UpdateProfileData extends ProfileEvent {
  final String newName;
  final String newEmail;

  UpdateProfileData(this.newName, this.newEmail);
}
