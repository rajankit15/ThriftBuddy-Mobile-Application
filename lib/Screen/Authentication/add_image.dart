import 'dart:io';
import 'package:at_project/Screen/Authentication/firebase%20functions/functions.dart';
import 'package:at_project/Screen/Authentication/login_page.dart';
import 'package:at_project/reusable_widgets/button.dart';
import 'package:at_project/reusable_widgets/flutterToast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';

class AddImagePage extends StatefulWidget {
  const AddImagePage({super.key});

  @override
  State<AddImagePage> createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  File? _image;
  String? _selectedGender;

  final picker = ImagePicker();

  Future getImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Opening Gallery...'),
            ],
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 500));

    Navigator.pop(context);

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String name = args['name'] ?? '';
    final String email = args['email'] ?? '';
    final String phone = args['phone'] ?? '';
    final String password = args['password'] ?? '';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Complete Verification'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              backgroundImage: _image != null ? FileImage(_image!) : null,
              radius: 90,
              child: _image == null
                  ? const Icon(
                      Icons.person,
                      size: 80,
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromRGBO(66, 165, 245, 1), width: 2),
                  borderRadius: BorderRadius.circular(30)),
              child: GestureDetector(
                onTap: () {
                  getImage();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add Image',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.add_a_photo)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(15),
              child: buildDropdown(
                  'Gender',
                  'gender',
                  ['Male', 'Female', 'Other'],
                  _selectedGender, (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              }),
            ),
            const SizedBox(height: 50),
            reuseButton(
              onTap: () async {
                if (_image == null) {
                  reuseFlutterToast(
                      context: context, text: 'Select a profile picture');
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Creating Account'),
                          ],
                        ),
                      );
                    },
                  );
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password);

                    //function to add image to firebase storage
                    String url = await uploadImagetoFirebase(
                        imagefile: _image, id: userCredential.user!.uid);

                    //function to add data to firebase firestore
                    try {
                      await addUserdata(
                        name: name,
                        email: email,
                        phone: phone,
                        imgUrl: url,
                        gender: _selectedGender ?? '',
                        listedProduct: [],
                      );
                    } catch (e) {
                      print('Error : $e');
                      reuseFlutterToast(
                          context: context, text: 'User Registration failed');
                    }

                    Navigator.pop(context);

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false);

                    reuseFlutterToast(
                      context: context,
                      text: "Account Created",
                    );
                  } on FirebaseAuthException catch (e) {
                    reuseFlutterToast(context: context, text: '$e');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                    reuseFlutterToast(
                      context: context,
                      text: "Account Created",
                    );
                    print('Error : $e');
                  }
                }
              },
              text: 'Create Account',
            )
          ],
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
}
