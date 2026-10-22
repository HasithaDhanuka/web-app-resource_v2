import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      required this.icondata,
      required this.url,
      required this.color});
  final FaIconData icondata;
  final String url;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => OpenURL(url),
      icon: FaIcon(icondata),
      color: color,
    );
  }

  Future<void> OpenURL(String url) async {
    Uri _uri = Uri.parse(url);
    await canLaunchUrl(_uri)
        ? await launchUrl(_uri)
        : throw "Cant open this $_uri";
    // await canLaunch(url) ? await launch(url) : throw "";
  }
}
