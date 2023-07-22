import 'package:digi_forest/Constants/constants.dart';
import 'package:flutter/material.dart';

class CElevatedButton extends StatelessWidget {
  final String bText;
  final bool loading;
  final VoidCallback onPressed;

  const CElevatedButton({
    Key? key,
    required this.bText,
    required this.loading,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ElevatedButton(

        style: ElevatedButton.styleFrom(
          backgroundColor: myGreenColor,

          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: loading
              ? const CircularProgressIndicator(

          )
              : Text(
            bText,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: myWhiteColor,
            ),
          ),
        ),
      ),
    );
  }
}