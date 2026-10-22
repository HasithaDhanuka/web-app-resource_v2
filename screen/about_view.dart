import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:web_app/Utils/colors.dart';

import 'package:web_app/Utils/view_wrapper.dart';
import 'package:web_app/Animation/bullet_list.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView>
    with SingleTickerProviderStateMixin {
  late double screenWidth;
  late double screenHeight;

  final String _about_text =
      "xxxxxx xxxxxxx xxxxxxx xxxxxxxx xxxxxxxx xxxxxxx xxxxxx nnnnnnnnnnnnnnnnnnnnnxxxxxxxxxxxxxxxxxx BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB xxxxxx";

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return ViewWrapper(
      desktopView: desktopView(),
      mobileView: mobileView(),
    );
  }

  // ###########################################################################
//  ********************       Desktop View Of About   ************************
  Widget desktopView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 3,
          child: infoSection(),
        ),
        const Spacer(
          flex: 1,
        ),
        Expanded(
            flex: 3,
            child: BulletList(
              strings: [_about_text, _about_text, _about_text, _about_text],
            ))
      ],
    );
  }

// ###########################################################################
//  ********************       Mobile View Of About   ************************
  Widget mobileView() {
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.05,
        ),
        infoSection(),
        SizedBox(
          height: screenHeight * 0.01,
        ),
        // Container(
        //   height: screenHeight * 1,
        //   child: test(),
        // )
      ],
    );
  }

  BulletList test() {
    print("test ok");
    return BulletList(strings: [
      _about_text,
      _about_text,
      _about_text,
    ]);
  }

  Widget infoSection() {
    return SizedBox(
      width: screenWidth * 0.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          profilePicture(),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          infoText(),
        ],
      ),
    );
  }

  Widget profilePicture() {
    return Container(
      height: getImageSize(),
      width: getImageSize(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(getImageSize() / 2),
        child: Container(
          color: Colors.grey,
          child: Center(
              child: Lottie.asset("assets/elepent.json",
                  //controller: create_button_anim,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }

  double getImageSize() {
    if (screenWidth > 1600 && screenHeight > 800) {
      return 350;
    } else if (screenWidth > 1300 && screenHeight > 600) {
      return 300;
    } else if (screenWidth > 1000 && screenHeight > 400) {
      return 200;
    } else {
      return 150;
    }
  }

  Widget infoText() {
    return Text(
        "xxx xxxx xxxx ccc casdadadaa     xxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxx cc",
        style: TextStyle(color: MyColor.myYellow),
        overflow: TextOverflow.clip);
  }
}
