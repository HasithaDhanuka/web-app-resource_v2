// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_app/model/food.dart';

//*****************************************************************************
//   Create Food Item
//*****************************************************************************
Future CreateItemModule({required FoodItem foodItem}) async {
  final collection = FirebaseFirestore.instance.collection("foods");

  // QuerySnapshot itemCount = await collection.get();
  // newItem = itemCount.size + 1;

  final getDoctItem = collection.doc();
  foodItem.id = getDoctItem.id;
  final setJson = foodItem.toJson();
  await getDoctItem.set(setJson);
}

//*****************************************************************************
//   Stream Food items
//*****************************************************************************
Stream<List<FoodItem>> ReadFoodItems() {
  final firestore = FirebaseFirestore.instance
      .collection("foods")
      .orderBy("timeStamp", descending: true)
      .snapshots();
  return firestore.map((snapshot) =>
      snapshot.docs.map((doc) => FoodItem.fromMap(doc.data())).toList());
}

//*****************************************************************************
//   Update Food Item
//*****************************************************************************
Future EditItem(
    {required String item_ID,
    required String itemName,
    required int itemPrice}) async {
  final item_Edit = FirebaseFirestore.instance.collection("foods").doc(item_ID);
  await item_Edit.update({
    "itemName": itemName,
    "itemPrice": itemPrice,
    "timeStamp": FieldValue.serverTimestamp(),
  });
}

//*****************************************************************************
//   Delete Food items
//*****************************************************************************
Future DeleteItem({required String itemID}) async {
  final delete_direction =
      FirebaseFirestore.instance.collection("foods").doc(itemID);
  await delete_direction.delete();
}
