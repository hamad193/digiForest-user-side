import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import '../Constants/constants.dart';
import '../Custom Widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  File? selectedImage;

  getImage(ImageSource source) async {
    XFile? pickedImage = await ImagePicker().pickImage(source: source);
    setState(() {
      selectedImage = File(pickedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          backgroundImage1,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Edit Profile"),
            centerTitle: true,
            backgroundColor: myGreenColor,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (selectedImage == null)
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                        color: myWhiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () {
                                getImage(ImageSource.gallery);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.green.shade50,
                                  border:
                                      Border.all(color: myGreenColor, width: 1),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.image,
                                      color: myGreenColor,
                                    ),
                                    SizedBox(width: 10),
                                    Text('From Gallery'),
                                  ],
                                ),
                              )),
                          SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              getImage(ImageSource.camera);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.green.shade50,
                                border:
                                    Border.all(color: myGreenColor, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: myGreenColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text('From Camera'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                        color: myWhiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.file(File(selectedImage!.path)),
                    ),

                  SizedBox(height: 15),

                  MyCustomTextField(
                      controller: fullNameController,
                      hintText: 'Full name',
                      showPrefixIcon: false,
                      icon: Icons.abc),
                  SizedBox(height: 15),
                  MyCustomTextField(
                      controller: phoneController,
                      hintText: 'Phone number',
                      showPrefixIcon: false,
                      icon: Icons.abc),
                  SizedBox(height: 15),

                  MyCustomTextField(
                      controller: areaController,
                      hintText: 'Total Area in Sq ft ',
                      showPrefixIcon: false,
                      icon: Icons.abc),

                  SizedBox(height: 50),
                  InkWell(
                    onTap: () async {
                      try {
                        EasyLoading.show(status: "Please Wait");
                        FirebaseStorage fs = FirebaseStorage.instance;
                        Reference ref = fs.ref().child(
                            DateTime.now().millisecondsSinceEpoch.toString());
                        await ref.putFile(File(selectedImage!.path));
                        String url = await ref.getDownloadURL();

                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          "image": url,
                          "fullName": fullNameController.text,
                          "location": locationController.text,
                          "phone": phoneController.text,
                          "totalArea": areaController.text,
                        });
                        EasyLoading.dismiss();
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        EasyLoading.showError(e.message.toString());
                        EasyLoading.dismiss();
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: myGreenColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                              color: myWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
