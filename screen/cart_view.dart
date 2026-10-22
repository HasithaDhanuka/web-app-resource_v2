import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/widgets/custom_button.dart';
import 'package:web_app/firebase/firebase_userOrder.dart';
import 'package:web_app/model/user_order.dart';
import 'package:web_app/provider_function/logic_function.dart';
import 'package:web_app/screen/popup_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final userNameEditingController = TextEditingController();
  final userPhoneNunberEditingController = TextEditingController();
  final userPostalCodeEditingController = TextEditingController();
  final userAddrassEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userNameEditingController.clear();
    userPhoneNunberEditingController.clear();
    userPostalCodeEditingController.clear();
    userAddrassEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderFoodItems>(builder: (context, value, chaild) {
      return value.listOfOrder.isEmpty
          ? isItemOrder()
          : Column(
              children: [
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                      itemCount: value.getOrderList.length,
                      itemBuilder: (BuildContext contect, int index) {
                        final orderList = value.getOrderList[index];

                        return orderCart(
                          itemName: orderList.itemName,
                          itemPrice: orderList.itemPrice,
                          itemUrl: orderList.itemUrl,
                          nOrderIndex: index,
                        );
                      }),
                ),
                totalPrice(
                    value: value,
                    onPressed: () async {
                      final orderSend = await popupOrder(
                          context: context,
                          userNameEditingController: userNameEditingController,
                          userPhoneNunberEditingController:
                              userPhoneNunberEditingController,
                          userPostalCodeEditingController:
                              userPostalCodeEditingController,
                          userAddrassEditingController:
                              userAddrassEditingController);
                      if (orderSend == true) {
                        final bIsSuccess = await createOrder(
                          userOrder: UserOrder(
                            userName: userNameEditingController.text,
                            userAddruss: userAddrassEditingController.text,
                            userPostalCode:
                                int.parse(userPostalCodeEditingController.text),
                            userTotalPrice: value.getTotalPrice,
                            userPhoneNumber: int.parse(
                                userPhoneNunberEditingController.text),
                            userOrders: value.getOrderList,
                          ),
                        );

                        if (bIsSuccess == true) {
                          // ignore: use_build_context_synchronously
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.leftSlide,
                            headerAnimationLoop: false,
                            dialogType: DialogType.success,
                            showCloseIcon: false,
                            title: 'Succes',
                            desc: ' Order Is Deliverd ',
                            btnOkOnPress: () {
                              //debugPrint('OnClcik');
                            },
                            btnOkIcon: Icons.check_circle,
                          ).show();
                        }

                        value.orderListClear();
                        userNameEditingController.clear();
                        userPhoneNunberEditingController.clear();
                        userPostalCodeEditingController.clear();
                        userAddrassEditingController.clear();
                      }
                    }),
              ],
            );
    });
  }
// ***************************************************************//
// ####################   Order Cart    ##########################//

  Widget isItemOrder() {
    return SizedBox(
      height: 500,
      child: Card(
        color: Colors.transparent,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Lottie.asset("assets/wating.json",
                  height: 200, width: 200, fit: BoxFit.cover)),
          Text(
            "Data is Not allow",
            style: TextStyle(color: MyColor.myRed),
          ),
        ]),
      ),
    );
  }

// ***************************************************************//
// ####################   Order Cart    ##########################//
  Widget orderCart(
      {required String itemName,
      required int itemPrice,
      required String itemUrl,
      required int nOrderIndex}) {
    return SizedBox(
      height: 120,
      child: Card(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  itemUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    itemName,
                    style: TextStyle(color: MyColor.myGreen, fontSize: 15),
                  ),
                  Text(
                    "$itemPrice 円",
                    style: TextStyle(color: MyColor.myGreen, fontSize: 15),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  context
                      .read<OrderFoodItems>()
                      .removeOrder(orderIndex: nOrderIndex);
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: MyColor.myRed,
                )),
          ],
        ),
      ),
    );
  }
}
// ***************************************************************//
// ###################   Total Price    ##########################//

Widget totalPrice(
    {required OrderFoodItems value, required VoidCallback onPressed}) {
  return SizedBox(
    height: 100,
    child: Card(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Total Price ",
            style: TextStyle(color: MyColor.myOrange, fontSize: 30),
          ),
          Text(
            "${value.getTotalPrice} 円",
            style: TextStyle(color: MyColor.myGreen, fontSize: 30),
          ),
          reUsableButton(
              onPressed: onPressed,
              buttonName: "Order",
              borderSideColor: MyColor.myRed),
        ],
      ),
    ),
  );
}
