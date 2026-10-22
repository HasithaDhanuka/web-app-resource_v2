import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      required this.icondata,
      required this.url,
      required this.color});
  final IconData icondata;
  final String url;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => OpenURL(url),
      icon: Icon(icondata),
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
