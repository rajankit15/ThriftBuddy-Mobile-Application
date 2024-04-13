import 'package:at_project/Screen/Authentication/firebase%20functions/functions.dart';
import 'package:at_project/reusable_widgets/button.dart';
import 'package:at_project/reusable_widgets/flutterToast.dart';
import 'package:at_project/reusable_widgets/textfield.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailcontroller = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Enter your Email address to receive password reset link',
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              reuseTextField(
                hintText: 'Enter Email',
                icon: const Icon(Icons.email),
                isPassword: false,
                controller: emailcontroller,
                isphone: false,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),
              reuseButton(
                onTap: () {
                  forgetPassword(email: emailcontroller.text.trim());
                  emailcontroller.clear();
                  reuseFlutterToast(
                    context: context,
                    text: 'Password reset link sent',
                  );
                },
                text: 'Sent Reset Link',
              )
            ],
          ),
        ),
      ),
    );
  }
}
