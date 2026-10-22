import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/model/food.dart';
import 'package:web_app/screen/popup_view.dart';
import 'package:web_app/widgets/network_image_render.dart';

class FoodTile extends StatelessWidget {
  const FoodTile({
    super.key,
    this.foodItem,
    required this.itemName,
    required this.itemPrice,
    this.itemCount,
    required this.itemUrl,
    required this.isUserOrderOrNot,
  });

  final FoodItem? foodItem;
  final String itemName;
  final int itemPrice;
  final int? itemCount;
  final String itemUrl;
  final bool isUserOrderOrNot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GridTile(
                  header: Container(
                    color: const Color.fromARGB(151, 7, 7, 7),
                    height: 30,
                    child: Center(
                      child: AutoSizeText(
                        itemName,
                        maxFontSize: 15,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 8,
                            color: MyColor.myOrange,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  footer: Container(
                    height: 20,
                    color: const Color.fromARGB(151, 0, 0, 0),
                    child: Center(
                      child: itemCount == 0
                          ? AutoSizeText(
                              "Out Of Stock",
                              maxFontSize: 14,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: MyColor.myRed,
                                  fontWeight: FontWeight.w700),
                            )
                          : AutoSizeText(
                              "$itemPrice 円",
                              maxFontSize: 14,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: MyColor.myGreen,
                                  fontWeight: FontWeight.w700),
                            ),
                    ),
                  ),
                  child: netImageView(
                    imgURL: itemUrl,
                    onTap: () async {
                      if (isUserOrderOrNot) return;
                      updateItem(context, foodItem: foodItem!);
                    },
                  )),
            ),
          ),
        ),
        Positioned(
            left: 0.0,
            bottom: 0.0,
            width: 40.0,
            height: 40.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: itemCount == 0
                    ? MyColor.myRed.withOpacity(0.8)
                    : MyColor.myGreen.withOpacity(0.8),
                child: Center(
                  child: Text(
                    "+ $itemCount",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}









// class FoodTile extends StatelessWidget {
//   const FoodTile({
//     super.key,
//     this.foodItem,
//     required this.itemName,
//     required this.itemPrice,
//     required this.itemUrl,
//   });

//   final FoodItem? foodItem;
//   final String itemName;
//   final int itemPrice;
//   final String itemUrl;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: GridTile(
//             header: Container(
//               color: const Color.fromARGB(151, 7, 7, 7),
//               height: 30,
//               child: Center(
//                 child: AutoSizeText(
//                   itemName,
//                   maxFontSize: 15,
//                   maxLines: 2,
//                   style: TextStyle(
//                       fontSize: 8,
//                       color: MyColor.myOrange,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//             footer: Container(
//               height: 20,
//               color: const Color.fromARGB(151, 0, 0, 0),
//               child: Center(
//                 child: AutoSizeText(
//                   "$itemPrice 円",
//                   maxFontSize: 14,
//                   style: TextStyle(
//                       fontSize: 14,
//                       color: MyColor.myGreen,
//                       fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ),
//             child: netImageView(
//               imgURL: itemUrl,
//               onTap: () async {
//                 updateItem(context, foodItem: foodItem!);
//               },
//             )),
//       ),
//     );
//   }
// }
