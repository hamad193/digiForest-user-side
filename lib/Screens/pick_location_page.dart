import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_forest/Constants/constants.dart';
import 'package:digi_forest/Custom%20Widgets/location_button.dart';
import 'package:digi_forest/Custom%20Widgets/select_location_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({Key? key}) : super(key: key);

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  LatLng? selectedLocation;
  LatLng selectedLatLng = const LatLng(0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pick Location'),
          centerTitle: true,
          backgroundColor: myGreenColor,
        ),
        body: Stack(
          children: [
            Image.asset(
              backgroundImage1,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyRowWidget(
                          onPressed: () async {
                            // Open the LocationPickerPage
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LocationPickerPage(),
                              ),
                            );

                            if (result != null && result is LatLng) {
                              // Handle the selected location
                              setState(() {
                                selectedLatLng = result;
                                _latitudeController.text =
                                    result.latitude.toString();
                                _longitudeController.text =
                                    result.longitude.toString();
                              });
                            }
                          },
                          labelText: 'GPS Coordinates',
                          buttonText: 'Pick Location',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Row(
                          children: [
                            CoordinateTextField(
                              controller: _latitudeController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final double? parsedValue =
                                    double.tryParse(value);
                                if (parsedValue != null) {
                                  // Update your logic with the parsed value
                                }
                              },
                              labelText: 'Latitude',
                            ),

                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                            CoordinateTextField(
                              controller: _longitudeController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final double? parsedValue =
                                    double.tryParse(value);
                                if (parsedValue != null) {
                                  // Update your logic with the parsed value
                                }
                              },
                              labelText: 'Longitude',
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        InkWell(
                          onTap: () async {
                            try {
                              EasyLoading.show(status: "Please Wait");
                              FirebaseStorage fs = FirebaseStorage.instance;
                              Reference ref = fs.ref().child(DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString());


                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                // "image": url,
                                // "fullName": fullNameController.text,
                                // "location": locationController.text,
                                // "phone": phoneController.text,
                                // "totalArea": areaController.text,
                                "lat": _latitudeController.text,
                                "long": _longitudeController.text,
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
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class CoordinateTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final String labelText;

  const CoordinateTextField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.onChanged,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      // style: authTextStyle,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        filled: true,
        fillColor: myWhiteColor,
        labelText: labelText,
        border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
        ),


      ),
    ));
  }
}
