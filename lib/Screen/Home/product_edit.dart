import 'package:at_project/chat%20functions/chat_firebase_functions.dart';
import 'package:at_project/data/product_class.dart';
import 'package:at_project/reusable_widgets/button.dart';
import 'package:at_project/reusable_widgets/editTextField.dart';
import 'package:at_project/reusable_widgets/flutterToast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key, required this.productId});

  final String? productId;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  var titleController = TextEditingController();
  var priceController = TextEditingController();
  var descriptionController = TextEditingController();

  Future<Item?> fetchProductData({required String productId}) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('products').doc(productId);

    DocumentSnapshot productSnapshot = await productRef.get();
    var data = productSnapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      print('No product found with ID: $productId');
      return null;
    }

    Item productDetail = Item(
      sellerName: data['sellerName'],
      sellerId: data['sellerId'],
      title: data['title'],
      imgUrl: (data['imgUrl'] as List<dynamic>).cast<String>(),
      price: data['price'],
      description: data['description'],
      category: data['category'],
    );

    return productDetail;
  }

  Future removeProduct() async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              removeProduct();
              Navigator.pop(context);
              reuseFlutterToast(context: context, text: 'Product Deleted');
            },
            child: const Text('Mark as Sold'),
          )
        ],
      ),
      body: FutureBuilder(
        future: fetchProductData(productId: widget.productId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Item itemInfo = snapshot.data as Item;
          return SingleChildScrollView(
            child: Column(
              children: [
                editTextField(
                  header: 'Title',
                  content: itemInfo.title,
                  controller: titleController,
                ),
                editTextField(
                  header: 'Price',
                  content: itemInfo.price,
                  controller: priceController,
                ),
                TextFieldForDesc(
                  header: 'Description',
                  content: itemInfo.description,
                  textarea: descriptionController,
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: buildDisabledTextField('Category', itemInfo.category),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: itemInfo.imgUrl.length,
                    itemBuilder: (context, index) {
                      return Image.network(itemInfo.imgUrl[index]);
                    },
                  ),
                ),
                reuseButton(
                    onTap: () {
                      updateProductDetails(
                        productid: widget.productId!,
                        title: titleController.text,
                        price: priceController.text,
                        description: descriptionController.text,
                        context: context,
                      );
                    },
                    text: 'Save Changes'),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDisabledTextField(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
            controller: TextEditingController(text: value.toString()),
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(fontSize: 18),
              hintText: 'Enter $label',
              border: const OutlineInputBorder(),
            ),
            style: const TextStyle(
              fontSize: 18,
            )),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
