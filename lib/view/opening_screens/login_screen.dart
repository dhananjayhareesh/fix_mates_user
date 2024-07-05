import 'package:fix_mates_user/bloc/bloc/login_bloc.dart';
import 'package:fix_mates_user/view/opening_screens/otp_screen.dart';
import 'package:fix_mates_user/view/opening_screens/userDetails_screen.dart';
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

  @override
  void initState() {
    super.initState();
    countycode.text = "+91";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
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
                  color: Colors.black,
                ),
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
                            width: 70,
                            child: TextField(
                              controller: countycode,
                              enabled: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Expanded(
                            child: BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                                return TextField(
                                  controller: phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    context.read<LoginBloc>().add(
                                          PhoneNumberChanged(value),
                                        );
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter mobile number",
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 15,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is PhoneNumberInvalid) {
                          return Text(
                            'Please enter a valid 10-digit phone number',
                            style: TextStyle(color: Colors.red),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is PhoneNumberValid
                        ? () {
                            context.read<LoginBloc>().add(
                                  SendOtpPressed(
                                    phoneNumberController.text,
                                  ),
                                );
                          }
                        : null,
                    child: Text(
                      'Send OTP',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is OtpSent) {
                    print('Navigating to OTP screen'); // Debug print
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen(
                          phoneNumber: phoneNumberController.text,
                          verificationId: LoginScreen.verify,
                        ),
                      ),
                    );
                  } else if (state is UserNotFound) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User does not exist')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(),
                      ),
                    );
                  } else if (state is LoginError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
