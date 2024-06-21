import 'package:firebase_core/firebase_core.dart';
import 'package:fix_mates_user/firebase_options.dart';
import 'package:fix_mates_user/view/homescreen.dart';
import 'package:fix_mates_user/view/opening_screens/login_screen.dart';
import 'package:fix_mates_user/view/opening_screens/userDetails_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fix Mates App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
