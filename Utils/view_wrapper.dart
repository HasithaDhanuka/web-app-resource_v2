import 'package:flutter/material.dart';

class ViewWrapper extends StatelessWidget {
  const ViewWrapper(
      {super.key, required this.desktopView, required this.mobileView});
  final Widget desktopView;
  final Widget mobileView;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 715 &&
            MediaQuery.of(context).size.height > 550) {
          return desktopView;
        } else {
          return mobileView;
        }
      },
    );
  }
}
