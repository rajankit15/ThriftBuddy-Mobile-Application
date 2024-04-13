import 'dart:io';
import 'package:at_project/Screen/Authentication/firebase%20functions/functions.dart';
import 'package:at_project/data/product_class.dart';
import 'package:at_project/reusable_widgets/button.dart';
import 'package:at_project/reusable_widgets/flutterToast.dart';
import 'package:at_project/reusable_widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  String userName = '';
  void printUserDataForCurrentUser() async {
    Map<String, dynamic>? userData = await fetchUserDataForCurrentUser();
    if (userData != null) {
      setState(() {
        userName = userData['name'];
      });
    } else {
      print('Unable to fetch user data for the currently logged-in user.');
    }
  }

  @override
  void initState() {
    printUserDataForCurrentUser();
    super.initState();
  }

  String? _selectedCategory;
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();

  final picker = ImagePicker();
  List<XFile> imgFile = [];

  void selectImage() async {
    final List<XFile> pickedFile = await picker.pickMultiImage();
    if (pickedFile.isNotEmpty) {
      imgFile.addAll(pickedFile);
    }
    setState(() {});
  }

  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell a Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildDropdown(
                  'Category', 'category', categoryList, _selectedCategory,
                  (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              }),
              const SizedBox(height: 20),
              buildDisabledTextField('Seller Name', userName),
              const SizedBox(height: 20),
              reuseTextField(
                hintText: 'Enter Title',
                icon: const Icon(Icons.abc),
                isPassword: false,
                controller: titlecontroller,
                isphone: false,
                inputType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              reuseTextField(
                hintText: 'Enter Price',
                icon: const Icon(Icons.currency_rupee),
                isPassword: false,
                controller: pricecontroller,
                isphone: false,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: false,
                controller: desccontroller,
                keyboardType: TextInputType.text,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  hintText: 'Enter Description',
                  prefixIcon: const Icon(Icons.description),
                ),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectImage,
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 10),
              if (imgFile.isEmpty)
                const Text('No image selected')
              else
                ...List.generate(
                  imgFile.length,
                  (index) => Container(
                    margin: const EdgeInsets.all(3),
                    child: Image.file(
                      File(imgFile[index].path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: reuseButton(
                  onTap: () async {
                    if (titlecontroller.text.isEmpty ||
                        pricecontroller.text.isEmpty ||
                        desccontroller.text.isEmpty ||
                        _selectedCategory == null ||
                        imgFile.isEmpty) {
                      reuseFlutterToast(
                          context: context, text: 'Fill all fields');
                      return;
                    } else {
                      setState(() {
                        _isloading = true;
                      });
                      if (_isloading == true) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 10),
                                  Text('Posting Your Product...'),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      try {
                        User? user = FirebaseAuth.instance.currentUser;
                        List<String> imgUrls = await uploadProductImages(
                            imgFiles: imgFile,
                            id: user!.uid,
                            title: titlecontroller.text);
                        Item x = Item(
                          sellerName: userName,
                          sellerId: user.uid,
                          title: titlecontroller.text,
                          imgUrl: imgUrls,
                          price: pricecontroller.text,
                          description: desccontroller.text,
                          category: _selectedCategory.toString(),
                        );
                        addSellProductInfo(x, user.uid);
                        reuseFlutterToast(
                          context: context,
                          text: 'Your Ad has been successfully P\posted',
                        );
                        titlecontroller.clear();
                        pricecontroller.clear();
                        desccontroller.clear();
                        _selectedCategory = null;
                        setState(() {
                          imgFile.clear();
                        });
                      } catch (e) {
                        print('Error adding product info to Firestore: $e');
                      } finally {
                        setState(() {
                          _isloading = false;
                        });
                        Navigator.pop(context);
                      }
                    }
                  },
                  text: 'Sell Item',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(String label, String attribute, List<String> options,
      String? selectedValue, void Function(String?) onChanged) {
    return FormBuilderDropdown(
      name: label,
      initialValue: selectedValue,
      decoration: InputDecoration(
        labelText: 'Select $label',
        hintText: 'Select $label',
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      items: options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
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
