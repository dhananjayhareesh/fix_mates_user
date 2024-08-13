import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_mates_user/view/location_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fix_mates_user/view/profile_page.dart';

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
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('usersDetails')
              .doc(user.uid)
              .set({
            'location': {
              'latitude': latitude,
              'longitude': longitude,
            },
            'locationName': locationController.text,
          }, SetOptions(merge: true)); // Merge to update only specific fields

          // Update the app bar location name
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location updated successfully!')),
          );
        }
      }
    } else if (locationStatus.isDenied) {
      // Handle location permission denied case
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission is denied!')),
      );
    } else if (locationStatus.isPermanentlyDenied) {
      // Handle location permission permanently denied case
      openAppSettings();
    }
  }

  Future<String> _fetchStoredLocationName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(
              'usersDetails') // Make sure this matches your Firestore collection name
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['locationName'] ?? 'Location Name';
      }
    }
    return 'Location Name';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchStoredLocationName(),
      builder: (context, snapshot) {
        String locationName = snapshot.data ?? 'Location Name';

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
                SizedBox(width: 5),
                Text(
                  locationName,
                  style: TextStyle(
                    fontSize: 15,
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
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/profilepic.png'),
                radius: 18,
              ),
            ),
            const SizedBox(width: 16),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
