import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_mates_user/utils/current_user_id_helper.dart';
import 'package:fix_mates_user/view/location_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fix_mates_user/view/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  Future<void> _checkLocationPermission(BuildContext context) async {
    PermissionStatus locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      final locationController = TextEditingController();

      final locationData = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MapScreen(locationController: locationController),
        ),
      );

      if (locationData != null) {
        double latitude = locationData['lat'];
        double longitude = locationData['long'];

        // Get the current logged-in user
        String user = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
        String cleanedUser = user.replaceFirst('+91', '');

        Map<String, dynamic>? userData = await getUserDataByPhone(cleanedUser);

        if (userData != null) {
          await FirebaseFirestore.instance
              .collection('usersDetails')
              .doc(userData['id'])
              .set({
            'location': {
              'latitude': latitude,
              'longitude': longitude,
            },
            'locationName':
                locationController.text, // Store the detailed address
          }, SetOptions(merge: true)); // Using merge to update existing data

          await SharedPrefsHelper.storeUserDocumentId(userData['id']);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location updated successfully!')),
          );
        }
      }
    } else if (locationStatus.isDenied) {
      // Handle location permission denied case
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is denied!')),
      );
    } else if (locationStatus.isPermanentlyDenied) {
      // Handle location permission permanently denied case
      openAppSettings();
    }
  }

  Future<void> storeCurrentUserDocumentId(String docId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userDocId', docId);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchStoredLocationDataStream() {
    String user = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
    String cleanedUser = user.replaceFirst('+91', '');

    return FirebaseFirestore.instance
        .collection('usersDetails')
        .where('userPhone', isEqualTo: cleanedUser)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: fetchStoredLocationDataStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildAppBar(context, 'Loading...');
        } else if (snapshot.hasError) {
          return _buildAppBar(context, 'Error');
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          Map<String, dynamic> locationData = snapshot.data!.docs.first.data();
          return _buildAppBar(
              context, locationData['locationName'] ?? 'Unknown Location');
        } else {
          return _buildAppBar(context, 'Location Name');
        }
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, String titleText) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: GestureDetector(
        onTap: () => _checkLocationPermission(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/location.png',
              height: 24.0,
              width: 24.0,
            ),
            const SizedBox(width: 5),
            Text(
              titleText,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Color.fromARGB(255, 4, 7, 188),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: Container(
            height: 25,
            width: 25,
            child: Image.asset('assets/notification.png'),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

Future<Map<String, dynamic>?> getUserDataByPhone(String userPhone) async {
  // Query the collection for the document with the matching userPhone
  var querySnapshot = await FirebaseFirestore.instance
      .collection('usersDetails')
      .where('userPhone', isEqualTo: userPhone)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    print('not empty');
    var doc = querySnapshot.docs.first;

    // Return a map with the document ID and data
    return {
      'id': doc.id, // Document ID
      ...doc.data(), // Document data
    };
  } else {
    print('empty');
    // If no document is found, return null
    return null;
  }
}
