import 'package:flutter/material.dart';
//  import 'dart:ui_web' as ui;
//  import 'dart:html' as html;

//##############    Canvers kit with Network Image ###############
Widget netImageView({required String imgURL, VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Image.network(
      imgURL,
      fit: BoxFit.cover,
      // Fall back to an HTML image when the browser cannot provide image bytes.
      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      errorBuilder: (context, error, stackTrace) {
        // Keep the failed-image state visible without logging tokenized URLs.
        debugPrint('Network image failed to load (${error.runtimeType}).');
        return const Center(child: Icon(Icons.broken_image_outlined));
      },
    ),
  );
}









//########################     Some Problom founded with canvers kit    ###########################

// class NetImageView extends StatelessWidget {
//   const NetImageView({super.key, required this.imgURL, this.onTap});

//   final String imgURL;

//   final VoidCallback? onTap;
//   @override
//   Widget build(BuildContext context) {
//     ui.platformViewRegistry.registerViewFactory(
//         imgURL,
//         (int _) => html.ImageElement()
//           ..src = imgURL
//           ..style.width = "100%"
//           ..style.height = "100%"
//           ..style.objectFit = "cover"
//         //..onClick.listen((_) => onTap!()),
//         );
//     return InkWell(
//       onTap: onTap,
//       child: Stack(children: [
//         HtmlElementView(viewType: imgURL),
//         Container(
//           color: Colors.transparent,
//         ),
//       ]),
//     );
//   }
// }

