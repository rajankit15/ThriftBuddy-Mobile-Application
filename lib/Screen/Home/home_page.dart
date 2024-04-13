import 'package:at_project/Screen/Favorite/favorites_screen.dart';
import 'package:at_project/Screen/Home/bottom_bar.dart';
import 'package:at_project/Screen/Home/products_page.dart';
import 'package:at_project/Screen/Notification/notification_screen.dart';
import 'package:at_project/Screen/product/functions.dart';
import 'package:at_project/Screen/product/listed_product.dart';
import 'package:at_project/Screen/product/product_page.dart';
import 'package:at_project/data/product_class.dart';
import 'package:at_project/reusable_widgets/card.dart';
import 'package:at_project/reusable_widgets/product_container.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void changeLocation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: const Text(
            "We are currently available only in Manipal",
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  var broseCategoryImages = [
    'assets/categories/electronics.jpeg',
    'assets/categories/bikes.jpeg',
    'assets/categories/mobile.jpeg',
    'assets/categories/clothing.jpeg',
  ];

  var broseCategoryTitle = [
    'Laptops & PCs',
    'Bikes',
    'Mobiles & Tablets',
    'Clothing',
  ];

  var sliderImg = [
    'assets/images/slider1.png',
    'assets/images/slider2.png',
    'assets/images/slider4.png',
    'assets/images/slider3.png',
  ];

  final _searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: GestureDetector(
          onTap: changeLocation,
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 15),
              Icon(Icons.location_on_outlined, size: 20),
              SizedBox(width: 2),
              Text('Manipal', style: TextStyle(fontSize: 20)),
              Icon(Icons.arrow_drop_down_rounded, size: 25)
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const NotificationScreen()),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none_outlined),
            iconSize: 27,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const FavoriteScreen()),
                ),
              );
            },
            icon: const Icon(Icons.favorite_border),
            iconSize: 27,
          ),
          const SizedBox(width: 15)
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Future.delayed(const Duration(seconds: 1));
          await getProducts();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(right: 10, left: 20),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  // color: Color.fromRGBO(76, 76, 76, 0.5),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _searchcontroller,
                  decoration: InputDecoration(
                    hintText: 'Search Anything...',
                    hintStyle: const TextStyle(color: Colors.black),
                    contentPadding: const EdgeInsets.all(8.0),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onChanged: (value) {},
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CarouselSlider(
                options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    autoPlay: true,
                    height: 210,
                    enlargeCenterPage: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    enableInfiniteScroll: true,
                    viewportFraction: 0.8),
                items: List.generate(
                  sliderImg.length,
                  (index) => Builder(builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 1.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(sliderImg[index]),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: const Color.fromRGBO(66, 165, 245, 1),
                margin: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                // height: 240,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(7),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Featured Product',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          featuredItem.length,
                          (index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SizedBox(
                                    child: ProductPage(
                                      isListedItem: true,
                                      item: Item(
                                        sellerName: featuredItem[index]
                                            ['sellerName'] as String,
                                        sellerId: featuredItem[index]
                                            ['sellerId'] as String,
                                        title: featuredItem[index]['title']
                                            as String,
                                        imgUrl: featuredItem[index]['imgUrl']
                                            as List<String>,
                                        price: featuredItem[index]['price']
                                            as String,
                                        description: featuredItem[index]
                                            ['description'] as String,
                                        category: featuredItem[index]
                                            ['category'] as String,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 280,
                              child: productContainer(
                                180,
                                Item(
                                  sellerName: featuredItem[index]['sellerName']
                                      as String,
                                  sellerId:
                                      featuredItem[index]['sellerId'] as String,
                                  title: featuredItem[index]['title'] as String,
                                  imgUrl: featuredItem[index]['imgUrl']
                                      as List<String>,
                                  price: featuredItem[index]['price'] as String,
                                  description: featuredItem[index]
                                      ['description'] as String,
                                  category:
                                      featuredItem[index]['category'] as String,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListedItemPage(),
                      ),
                    );
                  },
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 80),
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 15),
                        Text(
                          'Explore Products Listed By You',
                          style: TextStyle(fontSize: 17),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(66, 165, 245, 1),
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(5),
                  //   bottomLeft: Radius.circular(5),
                  // ),
                ),
                margin: const EdgeInsets.only(top: 15, bottom: 10),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(7),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Text(
                            'Browse categories',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                currentNavIndex = 1;
                              });
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          4,
                          (index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductsPage(
                                    title: broseCategoryTitle[index],
                                  ),
                                ),
                              );
                            },
                            child: reuseCard(
                              title: broseCategoryTitle[index],
                              imgUrl: broseCategoryImages[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'All Products',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 15),
                    FutureBuilder<List<Item>>(
                      future: getProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // Data fetched successfully, build the GridView
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
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
