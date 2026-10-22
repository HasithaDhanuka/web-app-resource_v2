// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_app/model/food.dart';

//*****************************************************************************
//   Create Food Item
//*****************************************************************************
Future CreateItemModule(
    {required FoodItem foodItem, required String collectionPath}) async {
  final collection = FirebaseFirestore.instance.collection(collectionPath);

  // QuerySnapshot itemCount = await collection.get();
  // newItem = itemCount.size + 1;

  final getDoctItem = collection.doc();
  foodItem.id = getDoctItem.id;
  foodItem.collectionPath = collectionPath;
  final setJson = foodItem.toJson();
  await getDoctItem.set(setJson);
}

//*****************************************************************************
//   Stream Cooking Items
//*****************************************************************************
Stream<List<FoodItem>> ReadCookingItems() {
  final firestore = FirebaseFirestore.instance
      .collection("CookingItems")
      .orderBy("timeStamp", descending: true)
      .snapshots();
  return firestore.map((snapshot) =>
      snapshot.docs.map((doc) => FoodItem.fromMap(doc.data())).toList());
}

//*****************************************************************************
//   Stream Other items
//*****************************************************************************
Stream<List<FoodItem>> ReadOtherItems() {
  final firestore = FirebaseFirestore.instance
      .collection("OtherItems")
      .orderBy("timeStamp", descending: true)
      .snapshots();
  return firestore.map((snapshot) =>
      snapshot.docs.map((doc) => FoodItem.fromMap(doc.data())).toList());
}

//*****************************************************************************
//   Stream Grains items
//*****************************************************************************
Stream<List<FoodItem>> ReadGrainsItems() {
  final firestore = FirebaseFirestore.instance
      .collection("GrainsItems")
      .orderBy("timeStamp", descending: true)
      .snapshots();
  return firestore.map((snapshot) =>
      snapshot.docs.map((doc) => FoodItem.fromMap(doc.data())).toList());
}

//*****************************************************************************
//   Stream Powder items
//*****************************************************************************PowderItems
Stream<List<FoodItem>> ReadPowderItems() {
  final firestore = FirebaseFirestore.instance
      .collection("PowderItems")
      .orderBy("timeStamp", descending: true)
      .snapshots();
  return firestore.map((snapshot) =>
      snapshot.docs.map((doc) => FoodItem.fromMap(doc.data())).toList());
}

//*****************************************************************************
//   Stream Food items
//*****************************************************************************
// Stream<List<FoodItem>> ReadFoodItems() {
//   final firestore = FirebaseFirestore.instance
//       .collection("foods")
//       .orderBy("timeStamp", descending: true)
//       .snapshots();
//   return firestore.map((snapshot) =>
//       snapshot.docs.map((doc) => FoodItem.fromMap(doc.data())).toList());
// }

//*****************************************************************************
//   Update Food Item
//*****************************************************************************
Future EditItem({
  required String item_ID,
  required String collectionPath,
  required String itemName,
  required int itemPrice,
  required String itemUrl,
  String? description,
  int? itemCount,
}) async {
  final item_Edit =
      FirebaseFirestore.instance.collection(collectionPath).doc(item_ID);
  await item_Edit.update({
    "itemName": itemName,
    "itemPrice": itemPrice,
    "itemCount": itemCount,
    "itemUrl": itemUrl,
    "description": description,
    "timeStamp": FieldValue.serverTimestamp(),
  });
}

//*****************************************************************************
//   Delete Food items
//*****************************************************************************
Future DeleteItem(
    {required String itemID, required String collectionPath}) async {
  final delete_direction =
      FirebaseFirestore.instance.collection(collectionPath).doc(itemID);
  await delete_direction.delete();
}
