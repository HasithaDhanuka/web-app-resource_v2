import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_app/model/food.dart';
import 'package:web_app/model/user_order.dart';

//*****************************************************************************
//   Create Food Item Order
//*****************************************************************************

Future<bool?> createOrder({required UserOrder userOrder}) async {
  final collection = FirebaseFirestore.instance.collection("userOrders");

  final getDoctItem = collection.doc();
  userOrder.userid = getDoctItem.id;
  final setJson = userOrder.toJson();

//  print("${setJson}");
  return getDoctItem.set(setJson).then((value) {
    //   print("Order send success !");
    return true;
  }).catchError((error) {
    //   print("Oder Error");
    return false;
  });
}

//*****************************************************************************
//   Read User Food Order
//*****************************************************************************
Stream<List<UserOrder>> readUserOrders() {
  final firestoreUserOrders = FirebaseFirestore.instance
      .collection("userOrders")
      .orderBy('timeStamp')
      .snapshots();

  return firestoreUserOrders.map((snapshot) =>
      snapshot.docs.map((doc) => UserOrder.fromMap(doc.data())).toList());
}

//*****************************************************************************
//   Update Customer And Delivery Details In An Existing Order
//   Saves customer fields and the per-order delivery fee without closing editor.
//*****************************************************************************
Future<bool> updateOrderCustomerDetails({
  required String orderID,
  required String userName,
  required int userPhoneNumber,
  required int userPostalCode,
  required String userAddress,
  required int deliveryCharge,
}) async {
  try {
    await FirebaseFirestore.instance.collection("userOrders").doc(orderID).update({
      "userName": userName,
      "userPhoneNumber": userPhoneNumber,
      "userPostalCode": userPostalCode,
      "userAddruss": userAddress,
      "deliveryCharge": deliveryCharge,
    });
    return true;
  } catch (_) {
    return false;
  }
}

//*****************************************************************************
//   Update Items In An Existing Order
//   Replaces the item list and stores a total calculated from the saved units.
//*****************************************************************************
Future<bool> updateOrderItems({
  required String orderID,
  required List<FoodItem> orders,
}) async {
  try {
    final totalPrice = orders.fold<int>(
      0,
      (total, item) => total + item.itemPrice,
    );

    await FirebaseFirestore.instance.collection("userOrders").doc(orderID).update({
      "userOrders": orders.map((item) {
        final itemData = item.toJson();
        itemData["timeStamp"] = item.timestamp;
        return itemData;
      }).toList(),
      "userTotalPrice": totalPrice,
    });
    return true;
  } catch (_) {
    return false;
  }
}

//*****************************************************************************
//   Read Of Delete User Order
//*****************************************************************************
Stream<List<UserOrder>> readDeleteHistoryOrders() {
  final firestoreUserOrders = FirebaseFirestore.instance
      .collection("removeOrders")
      .orderBy('timeStamp', descending: true)
      .snapshots();

  return firestoreUserOrders.map((snapshot) =>
      snapshot.docs.map((doc) => UserOrder.fromMap(doc.data())).toList());
}

//*****************************************************************************
//   Delete Food Item Order
//*****************************************************************************
Future<bool?> deleteOrder(
    {required String collectionPath, required String orderID}) async {
  final orderDelete =
      FirebaseFirestore.instance.collection(collectionPath).doc(orderID);

/////////               History User Order Delete                //////////
  if (collectionPath == "removeOrders") {
    // print("history delete   ${collectionPath}");
    return orderDelete
        .delete()
        .then((value) => true)
        .catchError((err) => false);
  }

  // /////////       History User Cooking Order Delete          /////////////
  // if (collectionPath == "removeCookingOrders") {
  //   // print("history delete   ${collectionPath}");
  //   return orderDelete
  //       .delete()
  //       .then((value) => true)
  //       .catchError((err) => false);
  // }

  final DocumentSnapshot snapshot = await orderDelete.get();
  final getOrder = snapshot.data() as Map<String, dynamic>;
  UserOrder getUserOrder = UserOrder.fromMap(getOrder);

// //////////////    Cooking Order Classifier Database         //////////////
//   if (collectionPath == "CookingItems") {
//     print(collectionPath + " path ++");
//     final removeCookingItemsCollection =
//         FirebaseFirestore.instance.collection("removeCookingOrders").doc();
//     getUserOrder.userid = removeCookingItemsCollection.id;

//     final json = getUserOrder.toJson();
//     return removeCookingItemsCollection.set(json).then((value) {
//       return orderDelete
//           .delete()
//           .then((value) => true)
//           .catchError((err) => false);

//       //   print("Order send success !");
//     }).catchError((error) {
//       //   print("Oder Error");
//       return false;
//     });
//   }

/////////    remove Order Collection and Creating Delete History    //////////
  final removeCollection =
      FirebaseFirestore.instance.collection("removeOrders").doc();
  getUserOrder.userid = removeCollection.id;

  final json = getUserOrder.toJson();
  print({"order path :: $orderDelete.path"});
  return removeCollection.set(json).then((value) {
    return orderDelete
        .delete()
        .then((value) => true)
        .catchError((err) => false);
  }).catchError((error) {
    return false;
  });
}
