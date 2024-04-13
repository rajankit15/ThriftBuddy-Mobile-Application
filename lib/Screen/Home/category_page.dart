import 'package:at_project/Screen/Home/products_page.dart';
import 'package:at_project/data/product_class.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var categoryImages = [
    'assets/categories/electronics.jpeg',
    'assets/categories/mobile.jpeg',
    'assets/categories/watch.jpeg',
    'assets/categories/dslr.jpeg',
    'assets/categories/home.jpeg',
    'assets/categories/clothing.jpeg',
    'assets/categories/shoes.jpeg',
    'assets/categories/furniture.jpeg',
    'assets/categories/cars.jpeg',
    'assets/categories/bikes.jpeg',
    'assets/categories/books.jpeg',
    'assets/categories/musical.jpeg',
    'assets/categories/others.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: const Text('All Categories'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: GridView.builder(
            // physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 10,
              mainAxisExtent: 165,
            ),
            itemCount: categoryImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductsPage(
                        title: categoryList[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(
                    //   color: const Color.fromRGBO(224, 224, 224, 1),
                    // ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          categoryImages[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        categoryList[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
