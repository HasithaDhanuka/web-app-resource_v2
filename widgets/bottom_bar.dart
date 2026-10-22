import 'package:flutter/material.dart';
import 'package:web_app/widgets/custom_icon_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 2,
            width: screenWidth * 0.9,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: screenHeight * 0.05,
          child: Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.05, right: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CustomIconButton(
                        icondata: FontAwesomeIcons.github,
                        url: "https://github.com/HasithaDhanuka",
                        color: Colors.blue),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    const CustomIconButton(
                        icondata: FontAwesomeIcons.youtube,
                        url: "https://www.youtube.com/",
                        color: Colors.blue),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    const CustomIconButton(
                        icondata: FontAwesomeIcons.facebook,
                        url: "https://www.facebook.com/",
                        color: Colors.blue),
                  ],
                ),
                const Text(
                  "Made with flutter web \u00a9 2021",
                  style: TextStyle(color: Colors.black26),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
