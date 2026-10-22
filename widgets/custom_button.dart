import 'package:flutter/material.dart';

//*********************************************//
//#######     Rounded Elevated Button  ########//
//*********************************************//
Widget reUsableButton(
    {required VoidCallback onPressed,
    required String buttonName,
    required Color borderSideColor}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: const StadiumBorder(),
        side: BorderSide(color: borderSideColor, width: 4)),
    child: Text(
      buttonName,
      style: TextStyle(color: borderSideColor),
    ),
  );
}
