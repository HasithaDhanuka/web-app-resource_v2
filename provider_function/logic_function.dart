import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:web_app/model/food.dart';

class FoodItemProperty extends ChangeNotifier {
  late String getItemName;
  late int getItemPrice;
  late int getItemCount;
  late String getItemUrl;
  late String getItemID;
  String getDescription = "";

  void setItemProperty({
    required String itemName,
    required int itemPrice,
    required int itemCount,
    required String itemUrl,
    required String itemID,
    String? description,
    // required Future Allet,
  }) {
    getItemName = itemName;
    getItemPrice = itemPrice;
    getItemCount = itemCount;
    getItemUrl = itemUrl;
    getItemID = itemID;
    getDescription = description ?? "";

    notifyListeners();
  }
}

// *****************************************************************
// ##################    TEXT FIELD   ##############################
class TextFieldChanger extends ChangeNotifier {
  bool bItemNameValidate = false;
  bool bItemPriceValidate = false;
  bool bItemCountValidate = false;
  bool bItemUrlValidate = false;

  bool getUserNameValidate = false;
  bool getUserTelNumberValidate = false;
  bool getUserPostalCodeValidate = false;
  bool getUserAddressValidate = false;

  void itemNameChanger(bool nameValidate) {
    bItemNameValidate = nameValidate;
    notifyListeners();
  }

  void itemPriceChanger(bool priceValidate) {
    bItemPriceValidate = priceValidate;
    notifyListeners();
  }

  void itemCountChanger(bool countValidate) {
    bItemCountValidate = countValidate;
    notifyListeners();
  }

  void itemUrlChanger(bool urlValidate) {
    bItemUrlValidate = urlValidate;
    notifyListeners();
  }

  void orderSendScreen({
    bool bUserNameValidate = false,
    bool bUserTelNumberValidate = false,
    bool bUserPostalCodeValidate = false,
    bool bUserAddressValidate = false,
  }) {
    getUserNameValidate = bUserNameValidate;
    getUserTelNumberValidate = bUserTelNumberValidate;
    getUserPostalCodeValidate = bUserPostalCodeValidate;
    getUserAddressValidate = bUserAddressValidate;

    notifyListeners();
  }
}

// *****************************************************************
// ##################    ORDER CART   ##############################
class OrderFoodItems extends ChangeNotifier {
  late List<FoodItem> listOfOrder = [];
  int ntotalPrice = 0;
  void getOrder({required FoodItem foodItem}) {
    listOfOrder.add(foodItem);

    notifyListeners();
  }

  void removeOrder({required int orderIndex}) {
    ntotalPrice = ntotalPrice - listOfOrder[orderIndex].itemPrice;
    listOfOrder.removeAt(orderIndex);

    notifyListeners();
  }

  void currentPrice({required int currentPrice}) {
    ntotalPrice = ntotalPrice + currentPrice;

    notifyListeners();
  }

  void orderListClear() {
    listOfOrder.clear();
    // print(listOfOrder.length);
    //  print(listOfOrder);
    notifyListeners();
  }

  int get getTotalPrice => ntotalPrice;
  List<FoodItem> get getOrderList => listOfOrder;
}

// // **************************************************************************
// // ##################    Delete Order Income   ##############################
// class DeleteOrdersIncome extends ChangeNotifier {
//   //late List<int> listOfOrderPrices = [];
//   int ntotalPrice = 0;
//   bool isHistory = true;

//   bool isSwitchON({required bool isOn}) {
//     isHistory = isOn;
//     notifyListeners();
//     return isHistory;
//   }

//   void setTotlePrice({required int price}) {
//     ntotalPrice = price;
//     print("222222");

//     print("notifire toatle price :: ${ntotalPrice}");
//     notifyListeners();
//   }

//   int get getTotalPrice => ntotalPrice;
// }

// *****************************************************************
// ##################    USER  ORDERS   ############################

class UserOrdersFind extends ChangeNotifier {
  int lengthOfOrders = 0;
  Future<int> getUserOrder({required int ordersLength}) async {
    lengthOfOrders = await ordersLength;
    //  print("order length is ::${lengthOfOrders}");
    notifyListeners();
    return lengthOfOrders;
  }

  int get totalOrdersCount => lengthOfOrders;
}

// *****************************************************************
// ##################    GET LOCAL IMAGE   ############################
class GetImgLocal extends ChangeNotifier {
  Uint8List imagedata = Uint8List(0);
  String imageName = "";
  bool isImageFile = false;
  bool isEnableCreateButton = true;

  Future<bool> getImageLocal() async {
    final resultFile = await FilePicker.pickFile(type: FileType.image);
    if (resultFile == null) {
      isImageFile = false;
      imagedata = Uint8List(0);
      imageName = "";
      createButtonEnable();
      return false;
    }

    imagedata = await resultFile.readAsBytes();
    imageName = resultFile.name;
    isImageFile = true;
    notifyListeners();
    return true;
  }

  void getImageClear() {
    isImageFile = false;
    imagedata = Uint8List(0);
    imageName = "";
    notifyListeners();
  }

  void createButtonEnable() {
    isEnableCreateButton = true;
    notifyListeners();
  }

  void createButtonDisable() {
    isEnableCreateButton = false;
    notifyListeners();
  }

  Uint8List get fileBytes => imagedata;
  bool get isFile => isImageFile;
  String get fileName => imageName;
}

class DatabaseClassifier extends ChangeNotifier {
  List<String> classifier = [
    "OtherItems",
    "GrainsItems",
    "PowderItems",
    "CookingItems"
  ];
  List<bool> isSelected = [true, false, false, false];
  int currentIndex = 1;
  String collectionPath = "";
  void getCurrentItem(int index) {
    collectionPath = classifier[index];
    currentIndex = index;
    //final getItemIndex = isSelected[index];

    notifyListeners();
  }

  String get getCollectionPath => collectionPath;
}
