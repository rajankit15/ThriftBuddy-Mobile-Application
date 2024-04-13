import 'package:at_project/Screen/product/functions.dart';
import 'package:at_project/Screen/product/product_page.dart';
import 'package:at_project/data/product_class.dart';
import 'package:at_project/reusable_widgets/product_container.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // Stream<List<Map<String, dynamic>>> fetchChatsStream() async* {
  //   try {
  //     while (true) {
  //       List<Map<String, dynamic>> fetchedMessages = await fetchMessages(
  //         senderId: widget.senderId,
  //         receiverId: widget.receiverId,
  //       );
  //       yield fetchedMessages;

  //       await Future.delayed(Duration(seconds: 1));
  //     }
  //   } catch (error) {
  //     print("Error fetching chat messages: $error");
  //   }
  // }

  Stream<List<Item>> favList() async* {
    try {
      while (true) {
        List<Item> fetchedFavorites = await getFavoriteList();
        yield fetchedFavorites;
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      print('Error fetching favorites: $e');
      yield [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: StreamBuilder(
              stream: favList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text(
                    'No favorites yet!',
                    style: TextStyle(fontSize: 22),
                  ));
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
                                isListedItem: false,
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
              }),
        ));
  }
}
