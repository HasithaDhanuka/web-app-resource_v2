import 'package:flutter/material.dart';
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/Utils/view_wrapper.dart';
import 'package:web_app/firebase/firebase_userOrder.dart';
import 'package:web_app/model/user_order.dart';
import 'package:web_app/widgets/rounded_border.dart';
import 'package:web_app/widgets/userOrderCart.dart';

class DeleteHistoryView extends StatefulWidget {
  const DeleteHistoryView({super.key});

  @override
  State<DeleteHistoryView> createState() => _DeleteHistoryViewState();
}

class _DeleteHistoryViewState extends State<DeleteHistoryView> {
  bool isShowDeleteUserHistory = false;
  @override
  Widget build(BuildContext context) {
    return ViewWrapper(
      desktopView: body(),
      mobileView: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "User Order Delete History ",
                style: TextStyle(
                    color: MyColor.myOrange, fontWeight: FontWeight.bold),
              ),
              Switch(
                  value: isShowDeleteUserHistory,
                  onChanged: (value) {
                    setState(() {
                      isShowDeleteUserHistory = value;
                    });
                  }),
            ],
          ),
          totalPrice(),
          isShowDeleteUserHistory
              ? UserOrderCarts(
                  isRequiredCount: false,
                  tittleName: "Delete History View ",
                  streamer: readDeleteHistoryOrders(),
                  collectionPath: "removeOrders",
                )
              : Container(),
        ],
      ),
    );
  }

  StreamBuilder<List<UserOrder>> totalPrice() {
    return StreamBuilder<List<UserOrder>>(
        stream: readDeleteHistoryOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive(
              strokeWidth: 4,
              semanticsLabel: "Lording",
            );
          }

          if (snapshot.hasError) {
            debugPrint("orders snapshot err :: ${snapshot.hasError}");
            return Center(
                child: Text(
              "is error founded:: ${snapshot.hasError}",
              style: TextStyle(color: MyColor.myRed),
            ));
          } else if (snapshot.hasData) {
            final userOrdersData = snapshot.data!;
            int nTotlePrice = 0;
            //  int nSaveTotalPrice = 0;
            userOrdersData.forEach((element) {
              nTotlePrice = element.userTotalPrice + nTotlePrice;
            });

            return roundedBorder(
                height: 100,
                widget: Center(
                  child: Text(
                    "Delete Income Is $nTotlePrice 円",
                    style: TextStyle(
                        color: MyColor.myRed, fontWeight: FontWeight.w800),
                  ),
                ),
                title: "Income  Price");
          }
          return const Text("Errrr");
        });
  }
}
