import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_app/model/food.dart';

class UserOrder {
  late String userid;
  late final String userName;
  late final String userAddruss;
  late final int userPostalCode;
  late final int userTotalPrice;
  final int deliveryCharge;
  late int userPhoneNumber;
  late bool? isDelivery;
  late Timestamp? timestamp;
  late final List<FoodItem> userOrders;

  UserOrder({
    this.userid = "",
    required this.userName,
    required this.userAddruss,
    required this.userPostalCode,
    required this.userTotalPrice,
    this.deliveryCharge = 0,
    required this.userPhoneNumber,
    this.isDelivery,
    this.timestamp,
    required this.userOrders,
  });

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "userName": userName,
        "userAddruss": userAddruss,
        "userPostalCode": userPostalCode,
        "userTotalPrice": userTotalPrice,
        "deliveryCharge": deliveryCharge,
        "userPhoneNumber": userPhoneNumber,
        "isDelivery": isDelivery,
        "timeStamp": timestamp ?? FieldValue.serverTimestamp(),
        "userOrders": userOrders.map((e) => e.toJson()).toList(),
      };

  factory UserOrder.fromMap(Map<String, dynamic> data) {
    return UserOrder(
      userid: data["userid"],
      userName: data["userName"],
      userAddruss: data["userAddruss"],
      userPostalCode: data["userPostalCode"],
      userTotalPrice: data["userTotalPrice"],
      // Keep the previous invoice behavior for older orders without this field.
      deliveryCharge: (data["deliveryCharge"] as num?)?.toInt() ??
          (data["isDelivery"] == true ? 200 : 0),
      userPhoneNumber: data["userPhoneNumber"],
      isDelivery: data["isDelivery"],
      timestamp: data["timeStamp"],
      userOrders: List<FoodItem>.from(
          data["userOrders"].map((item) => FoodItem.fromMap(item))),
    );
  }
}
