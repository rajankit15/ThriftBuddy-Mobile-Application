import 'package:flutter/material.dart';

Widget reuseButton({required Function() onTap, required String text}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(15),
        backgroundColor: Colors.blue[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        fixedSize: const Size(320, double.infinity)),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 19),
    ),
  );
}
