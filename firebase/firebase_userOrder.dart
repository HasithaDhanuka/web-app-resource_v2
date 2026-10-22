import 'package:cloud_firestore/cloud_firestore.dart';
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
//   Read Food Item Order
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
//   Read Food Item Order
//*****************************************************************************
Future<bool?> deleteOrder({required String orderID}) async {
  final orderDelete =
      FirebaseFirestore.instance.collection("userOrders").doc(orderID);
  return await orderDelete
      .delete()
      .then((value) => true)
      .catchError((err) => false);
}
