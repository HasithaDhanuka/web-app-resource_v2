import 'package:flutter/material.dart';

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
          colors: [Colors.black12, Colors.black87],
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
              ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
        )),
        //child: child,
      ),
    );
  }
}
