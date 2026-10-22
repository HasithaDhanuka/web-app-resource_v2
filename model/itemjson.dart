// class ProductItems {
//   late final String itemName;
//   late final String itemPrice;
//   late final String itemUrl;

//   ProductItems(
//       {required this.itemName, required this.itemPrice, required this.itemUrl});

//   static ProductItems fromJson(json) => ProductItems(
//         itemName: json["itemName"],
//         itemPrice: json["itemPrice"],
//         itemUrl: json["itemUrl"],
//       );
// }

class FoodItem {
  late String id;
  late final String itemName;
  late final int itemPrice;
  late final String itemUrl;

  FoodItem(
      {this.id = "",
      required this.itemName,
      required this.itemPrice,
      required this.itemUrl});
// send json
  Map<String, dynamic> toJson() => {
        "id": id,
        "itemName": itemName,
        "itemPrice": itemPrice,
        "itemUrl": itemUrl,
      };

  factory FoodItem.fromMap(Map<String, dynamic> data) {
    return FoodItem(
        id: data["id"],
        itemName: data["itemName"],
        itemPrice: data["itemPrice"],
        itemUrl: data["itemUrl"]);
  }

// Recevid json
  // static FoodItem fromJson(Map<String, dynamic> json) => FoodItem(
  //     id: json["id"],
  //     itemName: json["itemName"],
  //     itemPrice: json["itemPrice"],
  //     itemUrl: json["itemUrl"]);
}
