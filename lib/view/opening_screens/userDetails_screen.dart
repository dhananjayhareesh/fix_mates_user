import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_mates_user/view/homescreen.dart';
import 'package:fix_mates_user/view/opening_screens/otp_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  static String verify = "";
  UserDetailsScreen({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final String countyCode = '+91';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            ElevatedButton(
              onPressed: () async {
                final CollectionReference firebaseUsersInstance =
                    FirebaseFirestore.instance.collection('usersDetails');
                final data = {
                  'userEmail': emailController.text,
                  'userName': nameController.text,
                  'userPhone': phoneController.text,
                };
                firebaseUsersInstance.add(data);

                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: countyCode + phoneController.text,
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {},
                  codeSent: (String verificationId, int? resendToken) {
                    UserDetailsScreen.verify = verificationId;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtpScreen(
                                phoneNumber: phoneController.text,
                                verificationId: verificationId,
                              )),
                    );
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
