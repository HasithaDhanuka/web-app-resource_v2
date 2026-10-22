import 'package:flutter/material.dart';
import 'package:web_app/firebase/firebase_userOrder.dart';
import 'package:web_app/widgets/userOrderCart.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _CartViewState();
}

class _CartViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    return UserOrderCarts(
      isRequiredCount: true,
      tittleName: "Customer Orders",
      streamer: readUserOrders(),
      collectionPath: "userOrders",
    );
  }
}
