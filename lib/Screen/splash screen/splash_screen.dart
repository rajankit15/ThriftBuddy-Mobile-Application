import 'package:at_project/Screen/Authentication/login_page.dart';
import 'package:at_project/Screen/Home/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            LottieBuilder.asset(
              'assets/lottie/splash.json',
              width: 350,
            ),
            const SizedBox(height: 50),
            Text(
              'ThriftBuddy',
              style: GoogleFonts.dancingScript(
                  fontSize: 70,
                  color: Colors.white,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
