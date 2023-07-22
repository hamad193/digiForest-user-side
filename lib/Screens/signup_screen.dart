import 'package:digi_forest/bottom_nav_bar.dart';
import 'package:digi_forest/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Custom Widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImage1), fit: BoxFit.cover)),
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {},
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: myWhiteColor,
                  child: Text('Upload Image'),
                ),
              ),
              SizedBox(height: 25),
              MyCustomTextField(
                  hintText: "Full name",
                  icon: Icons.account_circle,
                  showPrefixIcon: true),
              SizedBox(height: 15),
              MyCustomTextField(
                  hintText: "Phone number",
                  icon: Icons.phone,
                  showPrefixIcon: true),
              SizedBox(height: 15),
              MyCustomTextField(
                  hintText: "Location",
                  icon: Icons.location_on,
                  showPrefixIcon: true),
              SizedBox(height: 15),
              MyCustomTextField(
                  hintText: "Email", icon: Icons.email, showPrefixIcon: true),
              SizedBox(height: 15),
              TextField(
                obscureText: _showPassword,
                decoration: InputDecoration(
                  fillColor: myWhiteColor,
                  filled: true,
                  hintText: "Enter Password",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: myGreenColor,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: EdgeInsets.all(15),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      _togglePasswordView();
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BottomNavigationBarScreen()));
                },
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: myGreenColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'SignUp',
                      style: TextStyle(
                          color: myWhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(color: myWhiteColor, fontSize: 14),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: myWhiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }
}
