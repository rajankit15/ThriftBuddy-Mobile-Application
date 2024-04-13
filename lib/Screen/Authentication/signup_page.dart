import 'package:at_project/Screen/Authentication/firebase%20functions/functions.dart';
import 'package:at_project/reusable_widgets/button.dart';
import 'package:at_project/reusable_widgets/flutterToast.dart';
import 'package:at_project/reusable_widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _phonecontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmpasswordcontrller = TextEditingController();

  @override
  void dispose() {
    _namecontroller.clear();
    _emailcontroller.clear();
    _phonecontroller.clear();
    _passwordcontroller.clear();
    _confirmpasswordcontrller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'SignUp Page',
                  style: GoogleFonts.playfairDisplay(fontSize: 50),
                ),
                const Text(
                  'Create a new Account',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                reuseTextField(
                    hintText: 'Name',
                    icon: const Icon(Icons.person),
                    isPassword: false,
                    controller: _namecontroller,
                    isphone: false,
                    inputType: TextInputType.emailAddress),
                const SizedBox(height: 30),
                reuseTextField(
                    hintText: 'Email address',
                    icon: const Icon(Icons.mail),
                    isPassword: false,
                    controller: _emailcontroller,
                    isphone: false,
                    inputType: TextInputType.emailAddress),
                const SizedBox(height: 30),
                reuseTextField(
                    hintText: 'Phone Number',
                    icon: const Icon(Icons.phone),
                    isPassword: false,
                    controller: _phonecontroller,
                    isphone: true,
                    inputType: TextInputType.phone),
                const SizedBox(height: 30),
                reuseTextField(
                  hintText: 'Password',
                  icon: const Icon(Icons.lock),
                  isPassword: true,
                  controller: _passwordcontroller,
                  isphone: false,
                  inputType: TextInputType.text,
                ),
                const SizedBox(height: 3),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Password should be at least 6 characters',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                reuseTextField(
                    hintText: 'Re-enter Password',
                    icon: const Icon(Icons.lock),
                    isPassword: true,
                    controller: _confirmpasswordcontrller,
                    isphone: false,
                    inputType: TextInputType.visiblePassword),
                const SizedBox(height: 3),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Password should be at least 6 characters',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),
                reuseButton(
                  onTap: () {
                    if (_confirmpasswordcontrller.text !=
                        _passwordcontroller.text) {
                      reuseFlutterToast(
                          context: context, text: 'Password does not match');
                    } else {
                      registerNewUser(
                        context: context,
                        name: _namecontroller.text,
                        email: _emailcontroller.text,
                        phone: _phonecontroller.text,
                        password: _passwordcontroller.text,
                      );
                    }
                    FocusScope.of(context).unfocus();
                  },
                  text: 'Register',
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an Account? Login",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
