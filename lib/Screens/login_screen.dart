import 'package:digi_forest/Custom%20Widgets/custom_text_field.dart';
import 'package:digi_forest/Screens/home_screen.dart';
import 'package:digi_forest/bottom_nav_bar.dart';
import 'package:digi_forest/Constants/constants.dart';
import 'package:digi_forest/Screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _showPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height/6),
                  Image.asset(
                    logo2,
                    height: MediaQuery.of(context).size.width * 0.9,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                  SizedBox(height: 50),
                  MyCustomTextField(
                      controller: emailController,
                      hintText: "Email",
                      icon: Icons.email,
                      showPrefixIcon: true),
                  SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    obscureText: _showPassword,
                    decoration: InputDecoration(
                      fillColor: myWhiteColor,
                      filled: true,
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock, color: myGreenColor),
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
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () async {
                      try {
                        EasyLoading.show(status: "Please Wait");
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                        EasyLoading.dismiss();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BottomNavigationBarScreen()));
                      } on FirebaseAuthException catch (e) {
                        EasyLoading.showError(e.message.toString());
                        EasyLoading.dismiss();
                      }
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
                          'Login',
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

  void _togglePasswordView() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }
}
