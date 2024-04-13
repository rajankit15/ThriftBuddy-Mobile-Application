import 'package:at_project/Screen/Home/chat_page.dart';
import 'package:at_project/Screen/Home/category_page.dart';
import 'package:at_project/Screen/Home/home_page.dart';
import 'package:at_project/Screen/Home/profile_page.dart';
import 'package:at_project/Screen/Home/sell_page.dart';
import 'package:flutter/material.dart';

int currentNavIndex = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onNavItemTapped(int index) {
    setState(() {
      currentNavIndex = index;
    });
  }

  var navBarItem = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.category), label: "Category"),
    const BottomNavigationBarItem(icon: Icon(Icons.add), label: "Sell"),
    const BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account")
  ];

  var navBody = [
    const HomeScreen(),
    const CategoryScreen(),
    const SellScreen(),
    const ChatScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: navBody[currentNavIndex],
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: navBarItem,
        currentIndex: currentNavIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedItemColor: Colors.blue[400],
        onTap: _onNavItemTapped,
      ),
    );
  }
}
