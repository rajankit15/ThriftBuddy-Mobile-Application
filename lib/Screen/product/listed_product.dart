import 'package:at_project/Screen/Home/bottom_bar.dart';
import 'package:at_project/Screen/product/functions.dart';
import 'package:at_project/Screen/product/product_page.dart';
import 'package:at_project/data/product_class.dart';
import 'package:at_project/reusable_widgets/product_container.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ListedItemPage extends StatefulWidget {
  const ListedItemPage({super.key});

  @override
  State<ListedItemPage> createState() => _ListedItemPageState();
}

class _ListedItemPageState extends State<ListedItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Item>>(
              future: getListedProductData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data!.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/not_found.json'),
                      const SizedBox(height: 50),
                      const Text(
                        'Start selling your first item !',
                        style: TextStyle(fontSize: 25),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false,
                          );
                          setState(() {
                            currentNavIndex = 2;
                          });
                        },
                        child: const Text('Sell Item'),
                      )
                    ],
                  );
                } else {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                isListedItem: true,
                              ),
                            ),
                          );
                        },
                        child: productContainer(
                          MediaQuery.of(context).size.width / 2 - 20,
                          snapshot.data![index],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ));
  }
}
