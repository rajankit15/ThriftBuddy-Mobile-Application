import 'package:at_project/Screen/Authentication/firebase%20functions/functions.dart';
import 'package:at_project/Screen/Authentication/forget_password.dart';
import 'package:at_project/Screen/Authentication/signup_page.dart';
import 'package:at_project/reusable_widgets/button.dart';
import 'package:at_project/reusable_widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login Page',
                      style: GoogleFonts.playfairDisplay(fontSize: 50),
                    ),
                    const Text(
                      'Sign in with your email and password',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 80),
                    reuseTextField(
                        hintText: 'Email Address',
                        icon: const Icon(Icons.mail),
                        isPassword: false,
                        controller: _emailcontroller,
                        isphone: false,
                        inputType: TextInputType.emailAddress),
                    const SizedBox(height: 30),
                    reuseTextField(
                        hintText: 'Enter Password',
                        icon: const Icon(Icons.lock),
                        isPassword: true,
                        controller: _passwordcontroller,
                        isphone: false,
                        inputType: TextInputType.text),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (contex) => const ForgetPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'forget password ?',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    reuseButton(
                        text: 'Login',
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          validateUserLogin(
                            context: context,
                            email: _emailcontroller.text,
                            password: _passwordcontroller.text,
                          );
                          // _emailcontroller.clear();
                          // _passwordcontroller.clear();
                        }),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an Account?",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(117, 117, 117, 1)),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color.fromRGBO(66, 165, 245, 1),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
