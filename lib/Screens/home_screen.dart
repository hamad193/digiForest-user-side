import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_forest/Constants/constants.dart';
import 'package:digi_forest/Screens/details_screen.dart';
import 'package:digi_forest/Custom%20Widgets/my_drawer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        drawer: MyDrawer(),
        // backgroundColor: Colors.grey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          backgroundColor: myGreenColor,
          title: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(builder: (context) {
                  return InkWell(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: myWhiteColor, shape: BoxShape.circle),
                      child: Icon(
                        Icons.menu,
                        size: 28,
                        color: myGreenColor,
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 36,
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Center(
                    child: TextField(
                      controller: searchController,
                      onChanged: (v) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          fillColor: myWhiteColor,
                          filled: true,
                          hintText: "Search",
                          prefix: Icon(
                            Icons.abc,
                            color: Colors.transparent,
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: myGreenColor,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: myWhiteColor, shape: BoxShape.circle),
                    child: Icon(
                      Icons.filter_list_alt,
                      size: 28,
                      color: myGreenColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Image.asset(
              backgroundImage1,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('plantsData')
                    .where('uid',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var plantsData = snapshot.data!.docs[index];

                      if (searchController.text.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              trailing: InkWell(
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection("plantsData")
                                        .doc(snapshot.data!.docs[index].id)
                                        .delete();
                                  },
                                  child: Icon(Icons.delete,
                                      size: 20, color: Colors.red)),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          data: snapshot.data!.docs[index],
                                        )));
                              },
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(plantsData['image']),
                              ),
                              title: Text(
                                plantsData['plantName'],
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Category: " + plantsData['category']),
                                  // Text("Date Planted: " +
                                  //     DateTime.now().toString().substring(0, 10)),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (plantsData['plantName']
                          .toString()
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase())) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            trailing: InkWell(
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection("plantsData")
                                      .doc(snapshot.data!.docs[index].id)
                                      .delete();
                                },
                                child: Icon(Icons.delete,
                                    size: 20, color: Colors.red)),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                        data: snapshot.data!.docs[index],
                                      )));
                            },
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  NetworkImage(plantsData['image']),
                            ),
                            title: Text(
                              plantsData['plantName'],
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Category: " + plantsData['category']),
                                // Text("Date Planted: " +
                                //     DateTime.now().toString().substring(0, 10)),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
