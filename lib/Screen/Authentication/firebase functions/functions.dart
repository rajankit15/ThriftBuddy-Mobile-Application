import 'dart:io';
import 'package:at_project/Screen/Authentication/add_image.dart';
import 'package:at_project/Screen/Authentication/login_page.dart';
import 'package:at_project/Screen/Home/bottom_bar.dart';
import 'package:at_project/data/product_class.dart';
import 'package:at_project/reusable_widgets/flutterToast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void validateUserLogin(
    {required BuildContext context,
    required String email,
    required String password}) async {
  if (email.isEmpty || password.isEmpty) {
    reuseFlutterToast(context: context, text: 'Enter email and password Field');
  } else if (!(email.contains('@') && email.contains('.com'))) {
    reuseFlutterToast(context: context, text: 'Enter a valid email address');
  } else {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Loading...'),
            ],
          ),
        );
      },
    );
    UserCredential uc;
    try {
      uc = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (uc.user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false);
      }
    } on FirebaseAuthException {
      Navigator.pop(context);
      reuseFlutterToast(context: context, text: 'Invaid Login Credentials');
    }
  }
}

void registerNewUser(
    {required BuildContext context,
    required String name,
    required String email,
    required String phone,
    required String password}) {
  if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
    reuseFlutterToast(context: context, text: 'Enter all the fields correctly');
  } else if ((!(email.contains('@') && email.contains('.com'))) ||
      phone.length != 10) {
    reuseFlutterToast(
        context: context, text: 'Enter a valid email address and Phone Number');
  } else {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Creating Account...'),
            ],
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context); // Close the dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AddImagePage(),
          settings: RouteSettings(arguments: {
            'name': name,
            'email': email,
            'phone': phone,
            'password': password
          }),
        ),
      );
    });
  }
}

Future<String> uploadImagetoFirebase(
    {File? imagefile, required String id}) async {
  try {
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profile/$id');
    UploadTask uploadTask = firebaseStorageRef.putFile(imagefile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print('Error uploading image to Firebase Storage: $e');
    return '';
  }
}

Future<void> addUserdata({
  required String name,
  required String email,
  required String phone,
  required String imgUrl,
  required String gender,
  required List<Map<String, dynamic>> listedProduct,
}) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is signed in, use their UID as document ID
      String uid = user.uid;
      CollectionReference userRef =
          FirebaseFirestore.instance.collection('users');
      await userRef.doc(uid).set({
        'name': name,
        'emailAddress': email,
        'phoneNo': phone,
        'imgUrl': imgUrl,
        'gender': gender,
        'listedItem': listedProduct,
      });
      print('User data added successfully for UID: $uid');
    } else {
      print('No user is currently signed in.');
    }
  } catch (e) {
    print('Error adding user data: $e');
  }
}

Future forgetPassword({required String email}) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    print('Error : $e');
  }
}

Future<void> userSignOut({required BuildContext context}) async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Signing out..."),
            ],
          ),
        );
      },
    );

    await Future.delayed(const Duration(seconds: 2));
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  } catch (e) {
    // Show error dialog if sign out fails
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Column(
            children: [
              SizedBox(height: 15),
              Text("Error Signing out..."),
              SizedBox(height: 15),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
    print('error : $e');
  } finally {
    if (Navigator.canPop(context)) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }
}

Future<Map<String, dynamic>?> fetchUserDataForCurrentUser() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is signed in
      String uid = user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        // Document exists, return its data
        return snapshot.data();
      } else {
        // Document does not exist
        print('Document does not exist for user with UID: $uid');
        return null;
      }
    } else {
      // User is not signed in
      print('No user is currently signed in.');
      return null;
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return null;
  }
}

Future addSellProductInfo(Item item, String id) async {
  try {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('products').add({
      'category': item.category,
      'description': item.description,
      'imgUrl': item.imgUrl,
      'price': item.price,
      'sellerId': item.sellerId,
      'sellerName': item.sellerName,
      'title': item.title,
    });

    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'listedItem': FieldValue.arrayUnion([
        {
          'itemName': item.title,
          'itemId': docRef.id,
        }
      ])
    });
  } catch (e) {
    print('Error adding product info to Firestore: $e');
  }
}

Future<List<String>> uploadProductImages(
    {required List<XFile> imgFiles,
    required String id,
    required String title}) async {
  List<String> imageUrls = [];

  try {
    for (XFile imgFile in imgFiles) {
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
          'product/$id/$title/${DateTime.now().millisecondsSinceEpoch}_${imgFiles.indexOf(imgFile)}');
      UploadTask uploadTask = firebaseStorageRef.putFile(File(imgFile.path));
      await uploadTask.whenComplete(() async {
        String imageUrl = await firebaseStorageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      });
    }
    return imageUrls;
  } catch (e) {
    print('Error uploading product images to Firebase Storage: $e');
    return [];
  }
}

// Future<String> uploadImagetoFirebase(
//     {File? imagefile, required String id}) async {
//   try {
//     Reference firebaseStorageRef =
//         FirebaseStorage.instance.ref().child('profile/$id');
//     UploadTask uploadTask = firebaseStorageRef.putFile(imagefile!);
//     TaskSnapshot taskSnapshot = await uploadTask;
//     String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//     return downloadUrl;
//   } catch (e) {
//     print('Error uploading image to Firebase Storage: $e');
//     return '';
//   }
// }