import 'package:flutter/material.dart';
import 'package:web_app/Utils/colors.dart';

Widget titleSubtitle(
    {required String title, required String subTitle, required Icon icon}) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: MyColor.myOrange),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 14, color: MyColor.myOrange),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(fontSize: 10, color: MyColor.myGreen),
        ),
        leading: icon,
      ),
    ),
  );
}
