import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_forest/Constants/constants.dart';
import 'package:digi_forest/Screens/edit_profile_screen.dart';
import 'package:digi_forest/Screens/login_screen.dart';
import 'package:digi_forest/Screens/pick_location_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    super.key,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  String image='';
  String name='';
  String email='';
  @override
  void initState() {
    getUserData();
    super.initState();
  }
  getUserData()async{
    DocumentSnapshot snap=await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {

      image=snap['image'];
      name=snap['fullName'];
      email=snap['email'];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage2), fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(image),
                ),
                Text(
                  "$name",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Text(
                  "$email",
                  style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    // fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.profile_circled),
            iconColor: myGreenColor,
            title: Text("Edit Profile"),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Colors.grey.shade600, size: 16),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen()));
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.location_solid),
            iconColor: myGreenColor,
            title: Text("Add Location"),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Colors.grey.shade600, size: 16),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>PickLocationScreen()));
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.question_circle_fill),
            iconColor: myGreenColor,
            title: Text("About"),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Colors.grey.shade600, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(CupertinoIcons.exclamationmark_circle_fill),
            iconColor: myGreenColor,
            title: Text("Terms & Conditions"),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Colors.grey.shade600, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.lock),
            iconColor: myGreenColor,
            title: Text("Privacy Policy"),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Colors.grey.shade600, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.share),
            iconColor: myGreenColor,
            title: Text("Share This App"),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Colors.grey.shade600, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            iconColor: myGreenColor,
            title: Text(
              "LogOut",
              style: TextStyle(color: Colors.red),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Colors.grey.shade600, size: 16),
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LogInScreen()));
              } catch (e) {
                EasyLoading.dismiss();
              }
            },
          ),
        ],
      ),
    );
  }
}
