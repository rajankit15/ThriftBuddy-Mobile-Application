import 'package:at_project/Screen/Home/message_page.dart';
import 'package:at_project/Screen/product/functions.dart';
import 'package:at_project/chat%20functions/chat_firebase_functions.dart';
import 'package:at_project/data/product_class.dart';
import 'package:at_project/reusable_widgets/button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage(
      {super.key, required this.item, required this.isListedItem});

  final Item item;
  final bool isListedItem;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String userId = '';
  String userName = '';
  String receiverImgUrl = '';
  String senderImgUrl = '';
  String productId = '';
  bool isfav = false;

  void getdata() async {
    userName = await getcurrentUserName(userId: userId);
    receiverImgUrl = await getSellerImgUrl(userId: widget.item.sellerId);
    senderImgUrl = await getSellerImgUrl(userId: userId);
    productId = await getProductId(item: widget.item);
    isfav = await isFavorite(pId: productId);
    setState(() {});
  }

  @override
  void initState() {
    var currentUser = FirebaseAuth.instance.currentUser;
    userId = currentUser!.uid;
    getdata();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        actions: [
          if (widget.isListedItem == false)
            IconButton(
              onPressed: () {
                additemtoFavorite(productId: productId, context: context);
                setState(() {
                  isfav = !isfav;
                });
              },
              icon: isfav
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_border_outlined,
                    ),
            ),
          const SizedBox(width: 10)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(10),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 250,
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                  ),
                  items: List.generate(
                    widget.item.imgUrl.length,
                    (index) => Builder(builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          widget.item.imgUrl[index],
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
                          fit: BoxFit.contain,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Text('Category : ${widget.item.category}',
                            style: const TextStyle(fontSize: 13)),
                        const Spacer(),
                        Text('${widget.item.imgUrl.length} Images'),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(widget.item.title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    // const SizedBox(height: 5),
                    Text(
                      '₹ ${widget.item.price}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.item.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                // margin: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Seller Details',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Name: ${widget.item.sellerName}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (widget.isListedItem == false)
                Center(
                  child: reuseButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagePage(
                            senderId: userId,
                            senderName: userName.toString(),
                            receiverId: widget.item.sellerId,
                            receiverName: widget.item.sellerName,
                            receiverImgUrl: receiverImgUrl.toString(),
                            senderImgUrl: senderImgUrl.toString(),
                          ),
                        ),
                      );
                    },
                    text: 'Enquire Now',
                  ),
                ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
