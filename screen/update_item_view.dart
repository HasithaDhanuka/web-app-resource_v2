// ignore_for_file: non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/widgets/text_field_module.dart';
import 'package:web_app/model/food.dart';
import 'package:web_app/firebase/firebase_food.dart';
import 'package:web_app/provider_function/logic_function.dart';
import 'package:web_app/screen/foodItem_frame_view.dart';

class UpdateDeleteItem extends StatefulWidget {
  const UpdateDeleteItem({super.key});

  @override
  State<UpdateDeleteItem> createState() => _UpdateDeleteItemState();
}

class _UpdateDeleteItemState extends State<UpdateDeleteItem> {
  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _itemNameController.dispose();
    _itemPriceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FoodItem>>(
        stream: ReadFoodItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          }
          if (snapshot.hasError) {
            return Center(
                child: Text(
              "Error founded:: ${snapshot.hasError}",
              style: TextStyle(color: MyColor.myRed),
            ));
          } else if (snapshot.hasData) {
            final itemdata = snapshot.data!;
            return SizedBox(
              height: 500,
              child: ListView.builder(
                  // scrollDirection: Axis.horizontal,
                  itemCount: itemdata.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = itemdata[index];
                    return ListOfItems(
                        itemName: item.itemName,
                        itemPrice: item.itemPrice,
                        itemUrl: item.itemUrl,
                        iteamId: item.id);
                  }),
            );
          } else {
            return Text(
              "Some Thing Is Wrong",
              style: TextStyle(color: MyColor.myRed),
            );
          }
        });
  }

  Padding ListOfItems(
      {required itemName,
      required itemPrice,
      required itemUrl,
      required iteamId}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
      child: Card(
        color: Colors.black12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: FoodTile(
                itemName: itemName,
                itemPrice: itemPrice,
                itemUrl: itemUrl,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  "ID :$iteamId",
                  style: TextStyle(color: MyColor.myRed),
                  maxFontSize: 30,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //      Edite Button  *********************************************
                    EditItemButton(
                      item_Name: itemName,
                      itemPrice: itemPrice,
                      itemUrl: itemUrl,
                      itemID: iteamId,
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    //       Delete Button  *********************************************
                    DeleteButton(itemID: iteamId),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//*****************************************************************************
//   Delete Button
//*****************************************************************************
  IconButton DeleteButton({required String itemID}) {
    return IconButton(
      onPressed: () {
        DeleteItem(itemID: itemID);
      },
      icon: Icon(
        Icons.delete,
        size: 50,
        color: MyColor.myRed,
      ),
    );
  }

//*****************************************************************************
//   Edit Button
//*****************************************************************************
  IconButton EditItemButton(
      {required String item_Name,
      required int itemPrice,
      required String itemUrl,
      required String itemID}) {
    return IconButton(
      onPressed: () async {
        context.read<FoodItemProperty>().setItemProperty(
              itemName: item_Name,
              itemPrice: itemPrice,
              itemUrl: itemUrl,
              itemID: itemID,
            );

        final item_name_price = await ItemEditeField();
        String get_ietm_Name = item_name_price![0];
        String get_item_price = item_name_price[1];

        if (get_ietm_Name.isEmpty && get_item_price.isEmpty) {
          return;
        }

        get_ietm_Name.isEmpty ? get_ietm_Name = item_Name : get_ietm_Name;
        get_item_price.isEmpty
            ? get_item_price = itemPrice.toString()
            : get_item_price;

        EditItem(
            item_ID: itemID,
            itemName: get_ietm_Name,
            itemPrice: int.parse(get_item_price));
      },
      icon: Icon(
        Icons.edit,
        color: MyColor.myGreen,
        size: 50,
      ),
    );
  }

//*****************************************************************************
//   Dialog Edit View
//*****************************************************************************
  Future<List<String>?> ItemEditeField() => showDialog<List<String>>(
        context: context,
        builder: (context) => AlertDialog(
          shadowColor: MyColor.myOrange,
          backgroundColor: Colors.black,
          title: Text(
            "Change Item Details",
            style: TextStyle(color: MyColor.myOrange),
          ),
          content: SizedBox(
            height: 200,
            width: 400,
            child: Center(
              child: Column(
                children: <Widget>[
                  Consumer<FoodItemProperty>(builder: (context, value, child) {
                    return customInputField(
                        inputFieldName: value.getItemName,
                        inputEditingController: _itemNameController,
                        isNumberTypeKeybord: false,
                        isValidate: false,
                        keyBordType: TextInputType.name);
                  }),
                  Consumer<FoodItemProperty>(builder: (context, value, child) {
                    return customInputField(
                        inputFieldName: "${value.getItemPrice} ￥",
                        inputEditingController: _itemPriceController,
                        isNumberTypeKeybord: true,
                        isValidate: false,
                        keyBordType: TextInputType.number);
                  }),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                List<String> Items_name_price = [
                  _itemNameController.text,
                  _itemPriceController.text
                ];

                Navigator.of(context).pop(Items_name_price);
                _itemNameController.clear();
                _itemPriceController.clear();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: const StadiumBorder(),
                  side: BorderSide(color: MyColor.myGreen, width: 4)),
              child: Text(
                "UPDATE",
                style: TextStyle(color: MyColor.myOrange),
              ),
            ),
          ],
        ),
      );
}
