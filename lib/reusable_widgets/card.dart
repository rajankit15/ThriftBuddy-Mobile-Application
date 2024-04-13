import 'package:flutter/material.dart';

Widget reuseCard({required String title, String? imgUrl}) {
  return Container(
    constraints: const BoxConstraints(maxHeight: 80),
    margin: const EdgeInsets.all(5),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imgUrl != null) Image.asset(imgUrl),
        const SizedBox(width: 10),
        Text(
          title,
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}
