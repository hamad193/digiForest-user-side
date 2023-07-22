import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants/constants.dart';

class MyCustomButton extends StatelessWidget {
  final String label;
  final onPress;

  MyCustomButton({
    required this.label,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: myGreenColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: onPress,
        child: Text(
          label,
          style: TextStyle(
              color: myWhiteColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
