import 'package:flutter/material.dart';

Widget editTextField(
    {required String header,
    required String content,
    required TextEditingController controller}) {
  controller.text = content;

  return Padding(
    padding: const EdgeInsets.all(15),
    child: TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(bottom: 5),
        labelText: header,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: content,
        labelStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
      controller: controller,
      style: const TextStyle(
        fontSize: 20,
        // fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  );
}

Widget TextFieldForDesc({
  required String header,
  required String content,
  required TextEditingController? textarea,
}) {
  textarea!.text = content;

  return Padding(
    padding: const EdgeInsets.all(15),
    child: Column(
      children: [
        TextField(
          controller: textarea,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            labelText: header,
            border: const OutlineInputBorder(),
            labelStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          style: const TextStyle(
            fontSize: 20,
            // fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}
