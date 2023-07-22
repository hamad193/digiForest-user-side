import 'package:digi_forest/Constants/constants.dart';
import 'package:flutter/material.dart';

class MyCustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool showPrefixIcon;
  final TextEditingController? controller;

  const MyCustomTextField({
    required this.hintText,
    required this.icon,
    required this.showPrefixIcon,
    super.key, this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: myWhiteColor,
        filled: true,
        hintText: hintText,
        prefixIcon: showPrefixIcon == false
            ? null
            : Icon(
                icon,
                color: myGreenColor,
              ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.all(15),
      ),
    );
  }
}
