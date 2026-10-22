import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/model/food.dart';
import 'package:web_app/provider_function/logic_function.dart';
import 'package:web_app/screen/popup_view.dart';
import 'package:web_app/widgets/network_image_render.dart';

class FoodTile extends StatelessWidget {
  const FoodTile(
      {super.key,
      required this.itemName,
      required this.itemPrice,
      required this.itemUrl});
  final String itemName;
  final int itemPrice;
  final String itemUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  style: TextStyle(
                      fontSize: 16,
                      color: MyColor.myOrange,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            footer: Container(
              height: 20,
              color: const Color.fromARGB(151, 0, 0, 0),
              child: Center(
                child: AutoSizeText(
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
                final orderComplete =
                    await popUpItem(context, itemUrl: itemUrl, canOrder: false);
                if (orderComplete == null || orderComplete == false) {
                  return;
                } else {
                  // ignore: use_build_context_synchronously
                  context.read<OrderFoodItems>().getOrder(
                      foodItem: FoodItem(
                          itemName: itemName,
                          itemPrice: itemPrice,
                          itemUrl: itemUrl));
                  // ignore: use_build_context_synchronously
                  context
                      .read<OrderFoodItems>()
                      .currentPrice(currentPrice: itemPrice);
                }
              },
            )),
      ),
    );
  }
}
