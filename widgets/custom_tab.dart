import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/provider_function/logic_function.dart';

class CustomTab extends StatelessWidget {
  const CustomTab(
      {super.key,
      required this.title,
      required this.isShowCount,
      this.iconData});
  final String title;
  final IconData? iconData;
  final bool isShowCount;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(
          child: AutoSizeText(
            title,
            maxFontSize: 25,
            // style: const TextStyle(
            //   fontSize: 17,
            // ),
            minFontSize: 5,
          ),
        ),
        Text(
          isShowCount
              ? " ${context.watch<UserOrdersFind>().totalOrdersCount}"
              : "",
          style: TextStyle(color: MyColor.myRed, fontSize: 30),
        ),
        Icon(iconData),
      ],
    );
  }
}
