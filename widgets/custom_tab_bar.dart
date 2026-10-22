import 'package:flutter/material.dart';
import 'package:web_app/Utils/colors.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key, required this.controller, required this.tabs});
  final TabController controller;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double tabBarScaling = screen_width > 1400
        ? 0.6
        : screen_width > 1100
            ? 0.5
            : 0.8;
    return Padding(
      padding: EdgeInsets.only(right: screen_width * 0.05),
      child: SizedBox(
        width: screen_width * tabBarScaling,
        child: Theme(
          data: ThemeData(
              highlightColor: Colors.transparent,
              splashColor: const Color.fromARGB(239, 241, 5, 5),
              hoverColor: const Color.fromARGB(19, 250, 3, 3)),
          child: TabBar(
            labelColor: MyColor.myRed,
            unselectedLabelColor: MyColor.myWhite,
            indicatorColor: MyColor.myRed,
            dividerColor: Colors.transparent,
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return const Color.fromARGB(70, 70, 241, 36);
                }
                return null;
              },
            ),
            controller: controller,
            tabs: tabs,
          ),
        ),
      ),
    );
  }
}
