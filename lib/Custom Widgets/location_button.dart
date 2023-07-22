import 'package:digi_forest/Constants/constants.dart';
import 'package:flutter/material.dart';

class MyRowWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String labelText;
  final String buttonText;

  const MyRowWidget({
    super.key,
    required this.onPressed,
    required this.labelText,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(labelText, style: TextStyle(color: myWhiteColor),),
        Container(
          width: 120,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(5.0),

          ),
          child: MaterialButton(
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: TextStyle(color: myWhiteColor),
              // style: TextStyle(
              //   color: Theme.of(context).primaryColor,
              // ),
            ),
          ),
        ),
      ],
    );
  }
}