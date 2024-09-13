import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<FetchProfileData>(_onFetchProfileData);
    on<UpdateProfileData>(_onUpdateProfileData);
  }

  Future<void> _onFetchProfileData(
      FetchProfileData event, Emitter<ProfileState> emit) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDocId = prefs.getString('userDocId');

      if (userDocId != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('usersDetails')
            .doc(userDocId)
            .get();

        emit(ProfileLoaded(
            userName: userDoc['userName'], userEmail: userDoc['userEmail']));
      }
    } catch (e) {
      emit(ProfileError("Error fetching user data: $e"));
    }
  }

  Future<void> _onUpdateProfileData(
      UpdateProfileData event, Emitter<ProfileState> emit) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDocId = prefs.getString('userDocId');

      if (userDocId != null) {
        await FirebaseFirestore.instance
            .collection('usersDetails')
            .doc(userDocId)
            .update({
          'userName': event.newName,
          'userEmail': event.newEmail,
        });

        emit(ProfileLoaded(userName: event.newName, userEmail: event.newEmail));
      }
    } catch (e) {
      emit(ProfileError("Error updating user data: $e"));
    }
  }
}
