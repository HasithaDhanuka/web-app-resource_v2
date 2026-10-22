import 'package:flutter/material.dart';
import 'package:web_app/Utils/colors.dart';

class BulletPoint extends StatelessWidget {
  const BulletPoint(
      {super.key,
      required this.text,
      required this.animationController,
      required this.index});
  final String text;
  final AnimationController animationController;
  final int index;

  @override
  Widget build(BuildContext context) {
    double _animationStart = 0.1 * index;
    double _animationEnd = _animationStart + 0.4;
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(2, 0), end: Offset(0, 0))
          .animate(CurvedAnimation(
              parent: animationController,
              curve: Interval(_animationStart, _animationEnd,
                  curve: Curves.ease))),
      child: FadeTransition(
        opacity: animationController,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              String.fromCharCode(0x2022),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            Flexible(
              child: Text(text, style: TextStyle(color: MyColor.myOrange)),
            )
          ],
        ),
      ),
    );
  }
}
