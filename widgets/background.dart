import 'package:flutter/material.dart';
import 'package:web_app/Utils/colors.dart';

class Background extends StatelessWidget {
  const Background(
      {super.key, required this.backgroundURL, required this.child});
  final Widget child;
  final String backgroundURL;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [buildBackground(), child],
    );
  }

  ShaderMask buildBackground() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [MyColor.myBlack12, MyColor.myBlack87],
          begin: Alignment.center,
          end: Alignment.bottomCenter,
        ).createShader(bounds);
      },
      blendMode: BlendMode.darken,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(backgroundURL),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(
                  MyColor.myBlack.withOpacity(0.3), BlendMode.darken),
        )),
        //child: child,
      ),
    );
  }
}
