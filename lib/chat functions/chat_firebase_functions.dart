import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<String> getcurrentUserName({required String userId}) async {
  var details =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  return details['name'];
}

Future<String> getSellerImgUrl({required String userId}) async {
  var details =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  return details['imgUrl'];
}

Future addmessagetoFirebase({
  required user1Id,
  required user1Name,
  required user1ImgUrl,
  required user2ImgUrl,
  required user2Id,
  required user2Name,
  required String message,
}) async {
  final chatCollection = FirebaseFirestore.instance.collection('chats');

  final querySnapshot1 = await chatCollection
      .where('user1Id', isEqualTo: user2Id)
      .where('user2Id', isEqualTo: user1Id)
      .limit(1)
      .get();

  final querySnapshot2 = await chatCollection
      .where('user1Id', isEqualTo: user1Id)
      .where('user2Id', isEqualTo: user2Id)
      .limit(1)
      .get();

  if (querySnapshot1.docs.isNotEmpty) {
    // If document exists, update the 'message' array
    final existingDocument = querySnapshot1.docs.first;
    await existingDocument.reference.update({
      'message': FieldValue.arrayUnion([
        {
          'text': message,
          'senderId': user2Id,
          'time': DateTime.now(),
        }
      ])
    });
  } else if (querySnapshot2.docs.isNotEmpty) {
    // If document exists, update the 'message' array
    final existingDocument = querySnapshot2.docs.first;
    await existingDocument.reference.update({
      'message': FieldValue.arrayUnion([
        {
          'text': message,
          'senderId': user2Id,
          'time': DateTime.now(),
        }
      ])
    });
  } else {
    // If document does not exist, create a new document
    await chatCollection.add({
      'user1Id': user1Id,
      'user1Name': user1Name,
      'user1ImgUrl': user1ImgUrl,
      'user2ImgUrl': user2ImgUrl,
      'user2Id': user2Id, // Corrected user2Id field
      'user2Name': user2Name,
      'message': [
        {
          'text': message,
          'senderId': user2Id,
          'time': DateTime.now(),
        }
      ]
    });
  }
}

Future<List<Map<String, dynamic>>> fetchMessages({
  required String senderId,
  required String receiverId,
}) async {
  final chatCollection = FirebaseFirestore.instance.collection('chats');

  final querySnapshot1 = await chatCollection
      .where('user1Id', isEqualTo: senderId)
      .where('user2Id', isEqualTo: receiverId)
      .limit(1)
      .get();

  final querySnapshot2 = await chatCollection
      .where('user1Id', isEqualTo: receiverId)
      .where('user2Id', isEqualTo: senderId)
      .limit(1)
      .get();

  if (querySnapshot1.docs.isNotEmpty || querySnapshot2.docs.isNotEmpty) {
    List<Map<String, dynamic>> messages = [];
    if (querySnapshot1.docs.isNotEmpty) {
      final existingDocument = querySnapshot1.docs.first;

      for (var message in existingDocument['message']) {
        messages.add({
          'text': message['text'],
          'time': message['time'],
          'senderId': message['senderId'],
        });
      }
    }

    if (querySnapshot2.docs.isNotEmpty) {
      final existingDocument = querySnapshot2.docs.first;

      for (var message in existingDocument['message']) {
        messages.add({
          'text': message['text'],
          'time': message['time'],
          'senderId': message['senderId'],
        });
      }
    }

    return messages;
  } else {
    return [];
  }
}

Future<List<DocumentSnapshot>> fetchChats({required String userId}) async {
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('chats')
      .where('user1Id', isEqualTo: userId)
      .get();

  final QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
      .collection('chats')
      .where('user2Id', isEqualTo: userId)
      .get();

  // Merge both query results
  final List<QueryDocumentSnapshot> documents1 = querySnapshot.docs;
  final List<QueryDocumentSnapshot> documents2 = querySnapshot2.docs;
  documents1.addAll(documents2);

  return documents1;
}

Future updateProductDetails({
  required String productid,
  required String title,
  required String price,
  required String description,
  required BuildContext context,
}) async {
  try {
    DocumentReference productref =
        FirebaseFirestore.instance.collection('products').doc(productid);
    await productref.update({
      'title': title,
      'price': price,
      'description': description,
    });

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Product details updated'),
            content:
                const Text('Product details have been updated successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          );
        });
  } catch (e) {
    print('cannot update product details : $e');
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cannot update Product details'),
            content: const Text('Product details cannot be updated.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          );
        });
  }
}
