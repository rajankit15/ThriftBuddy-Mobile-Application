import 'package:flutter/material.dart';

Widget reuseTextField(
    {required String hintText,
    required Widget icon,
    required bool isPassword,
    required TextEditingController controller,
    required bool isphone,
    required TextInputType inputType}) {
  return TextField(
    obscureText: isPassword,
    controller: controller,
    keyboardType: inputType,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      hintText: hintText,
      prefixIcon: icon,
    ),
    style: const TextStyle(fontSize: 18),
  );
}
