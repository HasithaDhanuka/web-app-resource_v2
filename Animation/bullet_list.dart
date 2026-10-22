import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_app/Animation/bullet_point.dart';

class BulletList extends StatefulWidget {
  const BulletList({super.key, required this.strings});
  final List<String> strings;
  //final Function animTest;

  @override
  _BulletListState createState() => _BulletListState();
}

class _BulletListState extends State<BulletList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  void animStart() {
    Timer(const Duration(milliseconds: 200),
        () => _animationController.forward());
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    animStart();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.strings.length * 2, (index) {
        if (index.isEven) {
          return Flexible(
            flex: 2,
            child: BulletPoint(
              text: widget.strings[index ~/ 2],
              animationController: _animationController,
              index: index ~/ 2,
            ),
          );
        } else {
          return Spacer(flex: 1);
        }
      }),
    );
  }
}
