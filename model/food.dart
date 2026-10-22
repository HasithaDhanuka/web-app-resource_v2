import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  late String id;
  late String? collectionPath;
  late final String itemName;
  late final int itemPrice;
  late final int? itemCount;
  late final String itemUrl;
  late final String? description;
  late Timestamp? timestamp;
  FoodItem({
    this.id = "",
    this.collectionPath = "",
    required this.itemName,
    required this.itemPrice,
    this.itemCount,
    required this.itemUrl,
    this.description,
    this.timestamp,
  });
// send json
  Map<String, dynamic> toJson() => {
        "id": id,
        "collectionPath": collectionPath,
        "itemName": itemName,
        "itemPrice": itemPrice,
        "itemCount": itemCount,
        "itemUrl": itemUrl,
        "description": description,
        "timeStamp": timestamp ?? FieldValue.serverTimestamp(),
      };

  factory FoodItem.fromMap(Map<String, dynamic> data) {
    return FoodItem(
      id: data["id"],
      collectionPath: data["collectionPath"],
      itemName: data["itemName"],
      itemPrice: data["itemPrice"],
      itemCount: data["itemCount"],
      itemUrl: data["itemUrl"],
      description: data["description"],
      timestamp: data["timeStamp"],
    );
  }
}
