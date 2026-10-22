import 'package:flutter/material.dart';
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/Utils/view_wrapper.dart';
import 'package:web_app/model/food.dart';
import 'package:web_app/screen/foodItem_frame_view.dart';
import '../firebase/firebase_food.dart';

class FoodItemsView extends StatefulWidget {
  const FoodItemsView({super.key});

  @override
  State<FoodItemsView> createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItemsView> {
  // late Future<List<ProductItems>> productItem;
  ////   For WEB
  // static Future<List<ProductItems>> getProduct() async {
  //   const url =
  //       "https://github.com/HasithaDhanuka/matsuyama_web/blob/main/assets/jsonfile/item.json";
  //   //"https://drive.google.com/uc?export=view&id=1cVyziSI0oSriADOiS7ZoOcNeZQQwKx-h";
  //   final response = await http.get(Uri.parse(url));
  //   final body = json.decode(response.body);
  //   print("network is loading");
  //   print(body);
  //   return body.map<ProductItems>(ProductItems.fromJson).toList();
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  //   //  productItem = getItems(context);
  // }

  // static Future<List<ProductItems>> getItems(BuildContext context) async {
  //   final data =
  //       await DefaultAssetBundle.of(context).loadString("jsonfile/item.json");
  //   final body = json.decode(data);
  //   return body.map<ProductItems>(ProductItems.fromJson).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return ViewWrapper(
        desktopView: desktopView(
            crossAxisItemsCount: 5, scrollDirectionAxis: Axis.vertical),
        mobileView: mobileView(
            crossAxisItemsCount: 2, scrollDirectionAxis: Axis.horizontal));
  }

// ***************************************************************//
// ####################   DESKTOP VIEW    ##########################//

  Widget desktopView(
      {required int crossAxisItemsCount, required Axis scrollDirectionAxis}) {
    //final int cross_axis_items;
    return Center(
      child: bodyOfDevicer(
        crossAxisItemsCount: crossAxisItemsCount,
        scrollDirectionAxis: scrollDirectionAxis,
        readfoodItems: ReadFoodItems(),
      ),
    );
  }
// ***************************************************************//
// ####################   Mobile VIEW    ##########################//

  Widget mobileView(
      {required int crossAxisItemsCount, required Axis scrollDirectionAxis}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: MyColor.myGreen),
            borderRadius: BorderRadius.circular(20),
          ),
          height: 300,
          child: bodyOfDevicer(
            crossAxisItemsCount: crossAxisItemsCount,
            scrollDirectionAxis: scrollDirectionAxis,
            readfoodItems: ReadFoodItems(),
          )),
    );
  }

// ***************************************************************//
// ####################   Steram Data    ##########################//
  Widget bodyOfDevicer(
      {required int crossAxisItemsCount,
      required Axis scrollDirectionAxis,
      required Stream<List<FoodItem>> readfoodItems}) {
    return StreamBuilder<List<FoodItem>>(
      stream: readfoodItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator.adaptive();
        }

        if (snapshot.hasError) {
          return Center(
              child: Text(
            'Error: ${snapshot.error}',
            style: TextStyle(color: MyColor.myRed),
          ));
        } else if (snapshot.hasData) {
          final productItems = snapshot.data!;

          return gridItemViewr(
              crossAxisItemsCount: crossAxisItemsCount,
              scrollDirectionAxis: scrollDirectionAxis,
              itemLength: productItems);
        } else {
          return Text(
            "Item Not Founded",
            style: TextStyle(color: MyColor.myOrange),
          );
        }
      },
    );
  }

// ->  FutureBuilder
  // FutureBuilder<List<FoodItem>> bodyOfDevicer({required int crossAxisItemsCount}) {
  //   return FutureBuilder<List<FoodItem>>(
  //     future: ReadFoodItems().first, //productItem,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const CircularProgressIndicator();
  //       } else if (snapshot.hasData) {
  //         final productItems = snapshot.data;
  //         return GridView.builder(
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: crossAxisItemsCount,
  //             ),
  //             itemCount: _productItems?.length,
  //             itemBuilder: (BuildContext, index) {
  //               final items = _productItems?[index];
  //               // print(products[index]);
  //               // return Container();
  //               return FoodTile(
  //                 itemName: items!.itemName,
  //                 itemPrice: items.itemPrice,
  //                 itemUrl: items.itemUrl,
  //               );
  //             });
  //       } else {
  //         return Text("Item Not Founded");
  //       }
  //     },
  //   );
  // }
}
// ***************************************************************//
// ####################   Grid VIEW    ##########################//

Widget gridItemViewr({
  required int crossAxisItemsCount,
  required Axis scrollDirectionAxis,
  required List<FoodItem> itemLength,
}) {
  return GridView.builder(
      scrollDirection: scrollDirectionAxis,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisItemsCount,
      ),
      itemCount: itemLength.length,
      itemBuilder: (BuildContext context, int index) {
        final items = itemLength[index];

        return FoodTile(
          itemName: items.itemName,
          itemPrice: items.itemPrice,
          itemUrl: items.itemUrl,
        );
      });
}
