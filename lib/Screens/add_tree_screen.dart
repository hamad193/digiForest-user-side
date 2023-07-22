import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_forest/Constants/constants.dart';
import 'package:digi_forest/Custom%20Widgets/custom_text_field.dart';
import 'package:digi_forest/Custom%20Widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

const List<String> list = <String>[
  'Tuber',
  'Rooted Plants',
];

class AddTreeScreen extends StatefulWidget {
  const AddTreeScreen({Key? key}) : super(key: key);

  @override
  State<AddTreeScreen> createState() => _AddTreeScreenState();
}

class _AddTreeScreenState extends State<AddTreeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberOfPlantController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String dropdownValue = list.first;

  File? selectedImage;

  void uploadImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      selectedImage = File(pickedFile!.path);
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
            title: Text("Add Tree"),
            centerTitle: true,
            backgroundColor: myGreenColor,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (selectedImage == null)
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                        color: myWhiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () {
                                uploadImage(ImageSource.gallery);
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
                                uploadImage(ImageSource.camera);
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
                              )),
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
                      controller: nameController,
                      hintText: 'Plant name',
                      showPrefixIcon: false,
                      icon: Icons.abc),
                  SizedBox(height: 15),
                  MyCustomTextField(
                      controller: numberOfPlantController,
                      hintText: 'Number of Plants',
                      showPrefixIcon: false,
                      icon: Icons.abc),
                  SizedBox(height: 15),
                  MyCustomTextField(
                      controller: descriptionController,
                      hintText: 'Description',
                      showPrefixIcon: false,
                      icon: Icons.abc),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      underline: Container(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 30),
                  MyCustomButton(
                    label: 'Upload',
                    onPress: () async {
                      EasyLoading.show(status: "Please Wait");

                      var docId = Uuid().v1();
                      FirebaseStorage fs = FirebaseStorage.instance;
                      Reference ref = await fs.ref().child(
                          DateTime.now().millisecondsSinceEpoch.toString());
                      await ref.putFile(File(selectedImage!.path));
                      String image = await ref.getDownloadURL();

                      try {
                        await FirebaseFirestore.instance
                            .collection("plantsData")
                            .doc(docId)
                            .set({
                          "docId": docId,
                          "image": image,
                          "uid": FirebaseAuth.instance.currentUser!.uid,
                          "plantName": nameController.text,
                          "description": descriptionController.text,
                          "numberOfPlants": numberOfPlantController.text,
                          "category": dropdownValue,
                          "plantationDate": DateTime.now(),
                          "cuttingTrees": "0",
                        });
                      } catch (e) {
                        print(e);
                      }
                      EasyLoading.dismiss();
                      Navigator.pop(context);
                    },
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
