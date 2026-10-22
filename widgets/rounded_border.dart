import 'package:flutter/material.dart';
import 'package:web_app/Utils/colors.dart';

Widget roundedBorder({
  required double? height,
  required Widget widget,
  required String title,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Container(
      color: Colors.transparent,
      height: height,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(color: MyColor.myOrange),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: MyColor.myGreen)),
        ),
        child: widget,
      ),
    ),
  );
}
