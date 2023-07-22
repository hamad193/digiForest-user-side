import 'package:digi_forest/Constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowMapScreen extends StatefulWidget {
  const ShowMapScreen({Key? key}) : super(key: key);

  @override
  State<ShowMapScreen> createState() => _ShowMapScreenState();
}

class _ShowMapScreenState extends State<ShowMapScreen> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userDocument;


  String latitude ='';
  String longitude='';
  @override
  void initState() {
    getUserData();
    super.initState();
  }
  getUserData()async{
    DocumentSnapshot snap=await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {

      latitude=snap['lat'];
      longitude=snap['long'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Map'),
        backgroundColor: myGreenColor,
      ),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(double.parse(latitude),
                double.parse(longitude)),
            zoom: 15,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('locationMarker'),
              position: LatLng(double.parse(latitude),
                  double.parse(longitude)),
            ),
          },
        ),
      ),
    );
  }
}
