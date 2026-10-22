import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/Utils/view_wrapper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late double screenWidth;
  late double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return ViewWrapper(desktopView: desktopView(), mobileView: mobileView());
  }

  Widget desktopView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: screenWidth * 0.45,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(getFontSize(true)),
              SizedBox(
                height: screenHeight * 0.08,
              ),
              subHeader("Welcome to matsuyama ....", getFontSize(false)),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              subHeader("How about you ?", getFontSize(false)),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              subHeader(
                  "flutter web development testing ....", getFontSize(false)),
            ],
          ),
        ),
        picture()
      ],
    );
  }

  Widget mobileView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: MyColor.myGreen),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            picture(),
            header(30),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            subHeader("How About you ..", 15),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            subHeader("You can contact us and joing with us", 15),
          ],
        ),
      ),
    );
  }

  double getImageSize() {
    if (screenWidth > 1600 && screenHeight > 800) {
      return 600;
    } else if (screenWidth > 1300 && screenHeight > 600) {
      return 550;
    } else if (screenWidth > 1000 && screenHeight > 400) {
      return 300;
    } else {
      return 350;
    }
  }

  double getFontSize(bool isHeader) {
    double fontSize = screenWidth > 950 && screenHeight > 550 ? 30 : 25;
    return isHeader ? fontSize * 1.25 : fontSize;
  }

  Widget header(double fontSize) {
    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: SizedBox(
        height: 150,
        width: 300,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'HI ',
              style: TextStyle(fontSize: fontSize, color: MyColor.myGreen),
            ),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: fontSize,
                // fontFamily: 'Horizon',
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  RotateAnimatedText('Lankan Taste',
                      textStyle: TextStyle(color: MyColor.myGreen)),
                  RotateAnimatedText('スリランカ味',
                      textStyle: TextStyle(color: MyColor.myOrange)),
                  RotateAnimatedText('DIFFERENT',
                      textStyle: TextStyle(color: MyColor.myYellow)),
                ],
                repeatForever: true,
                pause: const Duration(seconds: 1),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),

      // child: AnimatedTextKit(
      //   animatedTexts: [
      //     TypewriterAnimatedText(
      //       "Hi we Team Of Matsuyama",
      //       cursor: "|",
      //       textStyle: TextStyle(
      //           color: MyColor.myRed,
      //           fontSize: fontSize,
      //           fontWeight: FontWeight.bold),
      //       speed: const Duration(milliseconds: 150),
      //     )
      //   ],
      //   isRepeatingAnimation: true,
      //   pause: const Duration(seconds: 3),
      // )

      // child: RichText(
      //   text: TextSpan(
      //       style: TextStyle(color: MyColor.myRed, fontSize: fontSize),
      //       children: <TextSpan>[
      //         const TextSpan(text: "Hi we Team Of Matsuyama"),
      //         TextSpan(
      //           text: "For you",
      //           style: TextStyle(color: MyColor.myGreen),
      //         ),
      //         const TextSpan(text: "!")
      //       ]),
      // ),
    );
  }
//   return DefaultTextStyle(
//   style: const TextStyle(
//     fontSize: 20.0,
//   ),
//   child: AnimatedTextKit(
//     animatedTexts: [
//       WavyAnimatedText('Hello World'),
//       WavyAnimatedText('Look at the waves'),
//     ],
//     isRepeatingAnimation: true,
//     onTap: () {
//       print("Tap Event");
//     },
//   ),
// );

  Widget subHeader(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(color: MyColor.myYellow),
    );
  }

  Widget picture() {
    return SizedBox(
      height: getImageSize(),
      width: getImageSize(),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(getImageSize() / 2),
          child: Lottie.asset("assets/dragon.json",
              //controller: create_button_anim,
              height: 200,
              width: 200,
              fit: BoxFit.cover)),
    );
  }
}
