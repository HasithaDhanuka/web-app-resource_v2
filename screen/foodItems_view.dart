import 'package:flutter/material.dart';
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/Utils/view_wrapper.dart';
import 'package:web_app/model/food.dart';
import 'package:web_app/screen/foodItem_frame_view.dart';
import 'package:web_app/widgets/rounded_border.dart';
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
            crossAxisItemsCount: 4, scrollDirectionAxis: Axis.vertical),
        mobileView: mobileView(
            crossAxisItemsCount: 2, scrollDirectionAxis: Axis.horizontal));
  }

// ***************************************************************//
// ####################   DESKTOP VIEW    ##########################//

  Widget desktopView(
      {required int crossAxisItemsCount, required Axis scrollDirectionAxis}) {
    //final int cross_axis_items;
    return SingleChildScrollView(
      scrollDirection: scrollDirectionAxis,
      physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            roundedBorder(
              title: "Other Items",
              height: 400,
              widget: bodyOfDevicer(
                crossAxisItemsCount: crossAxisItemsCount,
                scrollDirectionAxis: scrollDirectionAxis,
                readfoodItems: ReadOtherItems(),
              ),
            ),
            roundedBorder(
              title: "Grains Items",
              height: 400,
              widget: bodyOfDevicer(
                crossAxisItemsCount: crossAxisItemsCount,
                scrollDirectionAxis: scrollDirectionAxis,
                readfoodItems: ReadGrainsItems(),
              ),
            ),
            roundedBorder(
              title: "Powder Items",
              height: 400,
              widget: bodyOfDevicer(
                crossAxisItemsCount: crossAxisItemsCount,
                scrollDirectionAxis: scrollDirectionAxis,
                readfoodItems: ReadPowderItems(),
              ),
            ),
          ],
        ),
      ),
    );
  }
// ***************************************************************//
// ####################   Mobile VIEW    ##########################//

  Widget mobileView(
      {required int crossAxisItemsCount, required Axis scrollDirectionAxis}) {
    return Column(
      children: [
        roundedBorder(
          title: "පිසින ලද කෑම ඇනවුමී",
          height: 400,
          widget: bodyOfDevicer(
            crossAxisItemsCount: crossAxisItemsCount,
            scrollDirectionAxis: scrollDirectionAxis,
            readfoodItems: ReadCookingItems(),
          ),
        ),
        roundedBorder(
          title: "Other Items",
          height: 400,
          widget: bodyOfDevicer(
            crossAxisItemsCount: crossAxisItemsCount,
            scrollDirectionAxis: scrollDirectionAxis,
            readfoodItems: ReadOtherItems(),
          ),
        ),
        roundedBorder(
          title: "Grains Items",
          height: 400,
          widget: bodyOfDevicer(
            crossAxisItemsCount: crossAxisItemsCount,
            scrollDirectionAxis: scrollDirectionAxis,
            readfoodItems: ReadGrainsItems(),
          ),
        ),
        roundedBorder(
          title: "Powder Items",
          height: 400,
          widget: bodyOfDevicer(
            crossAxisItemsCount: crossAxisItemsCount,
            scrollDirectionAxis: scrollDirectionAxis,
            readfoodItems: ReadPowderItems(),
          ),
        ),
      ],
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
            itemLength: productItems,
            isUserOrder: false,
          );
        } else {
          return Text(
            "Item Not Founded",
            style: TextStyle(color: MyColor.myOrange),
          );
        }
      },
    );
  }
}
// ***************************************************************//
// ####################   Grid VIEW    ##########################//

Widget gridItemViewr({
  required int crossAxisItemsCount,
  required Axis scrollDirectionAxis,
  required List<FoodItem> itemLength,
  required bool isUserOrder,
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
          foodItem: items,
          itemName: items.itemName,
          itemPrice: items.itemPrice,
          itemCount: isUserOrder ? 1 : items.itemCount,
          itemUrl: items.itemUrl,
          isUserOrderOrNot: isUserOrder,
        );
      });
}
