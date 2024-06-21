import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_mates_user/view/opening_screens/otp_screen.dart';
import 'package:fix_mates_user/view/opening_screens/userDetails_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  static String verify = "";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController countycode = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  var phone = "";
  @override
  void initState() {
    // TODO: implement initState
    countycode.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/loginScreen.jpg',
                height: 400,
              ),
              const SizedBox(height: 10),
              Text(
                'Phone Verification',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'We need to register your phone before getting started !',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: countycode,
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "|",
                        style: TextStyle(fontSize: 33, color: Colors.grey),
                      ),
                      Expanded(
                        child: TextField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Phone"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool isUserAvailable = await checkUserAvailable(
                      phone: phoneNumberController.text);
                  if (isUserAvailable) {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: countycode.text + phoneNumberController.text,
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        LoginScreen.verify = verificationId;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                    phoneNumber: phoneNumberController.text,
                                    verificationId: verificationId,
                                  )),
                        );
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User not exist')));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserDetailsScreen()));
                  }
                },
                child: const Text('Send OTP'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
