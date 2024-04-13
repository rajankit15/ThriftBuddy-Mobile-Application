import 'package:at_project/data/product_class.dart';
import 'package:flutter/material.dart';

Widget productContainer(double containerWidth, Item items) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(3),
    ),
    padding: const EdgeInsets.all(5),
    margin: const EdgeInsets.all(3.5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 160,
          width: containerWidth,
          child: Image.network(
            items.imgUrl[0],
            fit: BoxFit.fill,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 10),
        Text(
          items.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '₹ ${items.price}',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
