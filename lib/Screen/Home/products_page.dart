import 'package:at_project/Screen/product/product_page.dart';
import 'package:at_project/data/product_class.dart';
import 'package:at_project/reusable_widgets/product_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.title});

  final String title;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Future<List<Item>> fetchFilteredProducts() async {
    var user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.title)
        .where('sellerId', isNotEqualTo: user!.uid)
        .get();

    List<Item> products = [];

    for (var product in querySnapshot.docs) {
      var data = product.data() as Map<String, dynamic>;
      var imgUrlList =
          (data['imgUrl'] as List).map((url) => url.toString()).toList();
      var itemObject = Item(
        sellerName: data['sellerName'],
        sellerId: data['sellerId'],
        title: data['title'],
        imgUrl: imgUrlList,
        price: data['price'],
        description: data['description'],
        category: data['category'],
      );
      products.add(itemObject);
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: FutureBuilder<List<Item>>(
          future: fetchFilteredProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Lottie.asset('assets/lottie/C_Soon.json'),
              );
            } else {
              // Data fetched successfully, build the GridView
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  mainAxisExtent: 290,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(
                            item: snapshot.data![index],
                            isListedItem: false,
                          ),
                        ),
                      );
                    },
                    child: productContainer(
                      MediaQuery.of(context).size.width / 2 - 15,
                      snapshot.data![index],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
