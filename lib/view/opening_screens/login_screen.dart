import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_mates_user/bloc/Login/bloc/login_bloc.dart';
import 'package:fix_mates_user/view/opening_screens/otp_screen.dart';
import 'package:fix_mates_user/view/opening_screens/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController countycode = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool phoneNumberValid = true; // Validation state for phone number

  @override
  void initState() {
    super.initState();
    countycode.text = "+91";
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = LoginBloc();
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listener: (context, state) {
        if (state is LoginButtonClickedLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.blue,
              ));
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Image.asset(
                  'assets/loginScreen.jpg',
                  height: 300,
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Fix',
                        style: GoogleFonts.lobster(
                          color: Colors.blue,
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' Mates',
                        style: GoogleFonts.lobster(
                          color: Colors.grey,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  ' Keeping Your Home Running Smoothly, Every Time.',
                  style: GoogleFonts.caveat(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Log in or sign up',
                  style: GoogleFonts.rowdies(
                      fontSize: 18,
                      fontWeight: FontWeight.w200,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            SizedBox(
                              width:
                                  70, // Increased width of the code prefix field
                              child: TextField(
                                controller: countycode,
                                enabled: false,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: phoneNumberController,
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {
                                  setState(() {
                                    phoneNumberValid = value.length == 10;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter mobile number",
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 15, // Adjusted vertical padding
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: 10), // Added space for validation message
                      if (!phoneNumberValid)
                        Text(
                          'Please enter a valid 10-digit phone number',
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: phoneNumberValid
                      ? () async {
                          loginBloc.add(LoginButtonClickedLoadingEvent());
                          bool isUserAvailable = await checkUserAvailable(
                            phone: phoneNumberController.text,
                          );
                          if (isUserAvailable) {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber:
                                  countycode.text + phoneNumberController.text,
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {},
                              codeSent:
                                  (String verificationId, int? resendToken) {
                                LoginScreen.verify = verificationId;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OtpScreen(
                                      phoneNumber: phoneNumberController.text,
                                      verificationId: verificationId,
                                    ),
                                  ),
                                );
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User does not exist')),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetailsScreen(
                                  phoneNumber: phoneNumberController.text,
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                  child: Text(
                    'Send OTP',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<bool> checkUserAvailable({required String phone}) async {
  try {
    QuerySnapshot obj = await FirebaseFirestore.instance
        .collection('usersDetails')
        .where('userPhone', isEqualTo: phone)
        .get();

    return obj.docs.isNotEmpty;
  } catch (e) {
    print(e);
    return false;
  }
}
