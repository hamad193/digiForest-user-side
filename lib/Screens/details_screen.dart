import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_forest/Constants/constants.dart';
import 'package:digi_forest/Custom%20Widgets/custom_text_field.dart';
import 'package:digi_forest/Custom%20Widgets/my_button.dart';
import 'package:digi_forest/Screens/home_screen.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final dynamic data;

  const DetailScreen({super.key, this.data});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController cuttingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Image.network(
                      widget.data['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 1.75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListView(
                            children: [
                              Text(
                                widget.data['plantName'],
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Category: " + widget.data['category'],
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "Total Trees: ${int.parse(widget.data['numberOfPlants']) - int.parse(widget.data['cuttingTrees'])}",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Date Planted: " +
                                        DateTime.now()
                                            .toString()
                                            .substring(0, 10),
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: myGreenColor,
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (_) {
                                            return Container(
                                              color: Colors.grey.shade200,
                                              height: 500,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(15),
                                                child: Column(
                                                  children: [
                                                    MyCustomTextField(
                                                      hintText:
                                                      'Number of Trees',
                                                      icon: Icons.co2,
                                                      showPrefixIcon: false,
                                                      controller:
                                                      cuttingController,
                                                    ),
                                                    SizedBox(height: 10),
                                                    MyCustomButton(
                                                      label: 'Submit',
                                                      onPress: () async {
                                                        int currentCuttingTrees = int.parse(widget.data['cuttingTrees']);
                                                        int newCuttingTrees = int.parse(cuttingController.text);
                                                        int totalCuttingTrees = currentCuttingTrees + newCuttingTrees;

                                                        int currentNumberOfPlants = int.parse(widget.data['numberOfPlants']);
                                                        int updatedNumberOfPlants = currentNumberOfPlants - newCuttingTrees;

                                                        await FirebaseFirestore.instance
                                                            .collection("plantsData")
                                                            .doc(widget.data['docId'])
                                                            .update({
                                                          'cuttingTrees': totalCuttingTrees.toString(),
                                                          'numberOfPlants': currentNumberOfPlants.toString(),
                                                        });

                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },

                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Text(
                                      "Cut Trees",
                                      style: TextStyle(color: myWhiteColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.data['description'],
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 25,
                    top: 25,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color: myWhiteColor, shape: BoxShape.circle),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: myGreenColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
