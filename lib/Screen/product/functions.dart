import 'package:at_project/data/product_class.dart';
import 'package:at_project/reusable_widgets/flutterToast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<List<Item>> getProducts() async {
  try {
    var user = FirebaseAuth.instance.currentUser;
    final productsSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('sellerId', isNotEqualTo: user!.uid)
        .get();
    List<Item> productsList = [];

    for (var product in productsSnapshot.docs) {
      var data = product.data();
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
      productsList.add(itemObject);
    }

    return productsList;
  } catch (error) {
    print('Error fetching products: $error');
    return [];
  }
}

Future additemtoFavorite({required String productId,required BuildContext context}) async {
  var user = FirebaseAuth.instance.currentUser;
  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(user!.uid);

  DocumentSnapshot userData = await userRef.get();
  List<dynamic> favorites =
      (userData.data() as Map<String, dynamic>)['favorites'] ?? [];

  if (favorites.contains(productId)) {
    await userRef.update({
      'favorites': FieldValue.arrayRemove([productId]),
    });
    reuseFlutterToast(context: context, text: 'Removed from favorites!');
  } else {
    await userRef.update({
      'favorites': FieldValue.arrayUnion([productId]),
    });
    reuseFlutterToast(context: context, text: 'Added to favorites!');
  }
}

Future<List<Item>> getListedProductData() async {
  try {
    var user = FirebaseAuth.instance.currentUser;
    final productsSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('sellerId', isEqualTo: user!.uid)
        .get();
    List<Item> productsList = [];

    for (var product in productsSnapshot.docs) {
      var data = product.data();
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
      productsList.add(itemObject);
    }

    return productsList;
  } catch (error) {
    print('Error fetching products: $error');
    return [];
  }
}

Future<String> getProductId({required Item item}) async {
  try {
    final productsSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('sellerName', isEqualTo: item.sellerName)
        .where('sellerId', isEqualTo: item.sellerId)
        .where('title', isEqualTo: item.title)
        .where('price', isEqualTo: item.price)
        .where('description', isEqualTo: item.description)
        .where('category', isEqualTo: item.category)
        .get();
    return productsSnapshot.docs[0].id;
  } catch (error) {
    print('Error fetching products: $error');
    return '';
  }
}

Future<bool> isFavorite({required String pId}) async {
  var user = FirebaseAuth.instance.currentUser;
  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(user!.uid);

  DocumentSnapshot userData = await userRef.get();
  List<dynamic> favorites =
      (userData.data() as Map<String, dynamic>)['favorites'] ?? [];

  for (var favorite in favorites) {
    if (favorite == pId) return true;
  }

  return false;
}

Future<List<Item>> getFavoriteList() async {
  try {
    var user = FirebaseAuth.instance.currentUser;
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    DocumentSnapshot userData = await userRef.get();
    List<dynamic> favorites =
        (userData.data() as Map<String, dynamic>)['favorites'] ?? [];

    List<Item> favoriteList = [];

    for (var favorite in favorites) {
      final productsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(favorite)
          .get();
      var data = productsSnapshot.data();
      var imgUrlList =
          (data!['imgUrl'] as List).map((url) => url.toString()).toList();
      var itemObject = Item(
        sellerName: data['sellerName'],
        sellerId: data['sellerId'],
        title: data['title'],
        imgUrl: imgUrlList,
        price: data['price'],
        description: data['description'],
        category: data['category'],
      );
      favoriteList.add(itemObject);
    }

    return favoriteList;
  } catch (error) {
    print('Error fetching products: $error');
    return [];
  }
}
