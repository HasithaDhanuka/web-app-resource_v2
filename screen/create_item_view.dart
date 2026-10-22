import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/Utils/view_wrapper.dart';
import 'package:web_app/firebase/firebase_storage.dart';
import 'package:web_app/screen/popup_view.dart';
import 'package:web_app/widgets/rounded_border.dart';
import 'package:web_app/widgets/text_field_module.dart';
import 'package:web_app/firebase/firebase_food.dart';
import 'package:web_app/model/food.dart';
import 'package:web_app/provider_function/logic_function.dart';
import 'package:web_app/screen/foodItem_frame_view.dart';

class CreateItem extends StatefulWidget {
  const CreateItem({super.key});

  @override
  State<CreateItem> createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItem> with TickerProviderStateMixin {
  final itemNameController = TextEditingController();
  final itemPricesController = TextEditingController();
  final itemCountController = TextEditingController();
  final itemURLController = TextEditingController();
  final descriptionController = TextEditingController();
  String dataBasePath = "OtherItems";
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    itemNameController.dispose();
    itemPricesController.dispose();
    itemCountController.dispose();
    itemURLController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ViewWrapper(
        desktopView: Padding(
          padding: const EdgeInsets.all(30.0),
          child: roundedBorder(
              height: null, widget: createViewBody(), title: "Create View"),
        ),
        mobileView: roundedBorder(
            height: null, widget: createViewBody(), title: "Create View"),
      ),
    );
  }

//*************************************************************************/
//*****************     Create View  B o d y    *****************************/
  Widget createViewBody() {
    return Column(
      children: <Widget>[
        Consumer<TextFieldChanger>(builder: (context, value, child) {
          return customInputField(
              inputFieldName: "Item Name",
              inputEditingController: itemNameController,
              isNumberTypeKeybord: false,
              isValidate: value.bItemNameValidate,
              keyBordType: TextInputType.name);
        }),
        Consumer<TextFieldChanger>(builder: (context, value, child) {
          return customInputField(
              inputFieldName: "Item Price",
              inputEditingController: itemPricesController,
              isNumberTypeKeybord: true,
              isValidate: value.bItemPriceValidate,
              keyBordType: TextInputType.number);
        }),
        Consumer<TextFieldChanger>(builder: (context, value, child) {
          return customInputField(
              inputFieldName: "Item Count",
              inputEditingController: itemCountController,
              isNumberTypeKeybord: true,
              isValidate: value.bItemCountValidate,
              keyBordType: TextInputType.number);
        }),
        context.watch<GetImgLocal>().isFile
            ? Container()
            : Consumer<TextFieldChanger>(builder: (context, value, child) {
                return customInputField(
                    inputFieldName: "Item URL",
                    inputEditingController: itemURLController,
                    isNumberTypeKeybord: false,
                    isValidate: value.bItemUrlValidate,
                    keyBordType: TextInputType.multiline);
              }),
        customInputField(
            inputFieldName: "Description",
            inputEditingController: descriptionController,
            isNumberTypeKeybord: false,
            isValidate: false,
            keyBordType: TextInputType.multiline),
//*************************************************************************/
//*****************   Toggle Custom Buttons      *****************************/
        Consumer<DatabaseClassifier>(builder: (context, value, child) {
          final isSelected = value.isSelected;
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ToggleButtons(
                isSelected: isSelected,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                //  selectedBorderColor: MyColor.myOrange,
                selectedColor: MyColor.myWhite,
                fillColor: MyColor.myOrange,
                color: MyColor.myRed,
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 40.0,
                ),
                onPressed: (int index) {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                    value.getCurrentItem(index);
                    dataBasePath = value.getCollectionPath;
                    // print("item is :: ${value.getItemClassifier}");
                    // print("Current Index is ${index}");
                  }
                },
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("වෙනත් වර්ග"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("ධාන්‍ය වර්ග"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("පිටි වර්ග"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("පිසින කෑම"),
                  ),
                ]),
          );
        }),

//*************************************************************************/
//*****************     GET IMAGE FUNCTION    *****************************/
        Consumer<GetImgLocal>(builder: (context, value, child) {
          return getImage(
            //###########    GET BUTTON    ##########################
            imgGet: () async {
              final isImage = await value.getImageLocal();

              if (isImage == false) {
                itemURLController.clear();
                value.getImageClear();
                return;
              }
              value.createButtonDisable();
              String? imgUrl = await upLoadImage(
                  imagePath: value.fileName, data: value.fileBytes);

              itemURLController.text = imgUrl!;

              if (imgUrl.isNotEmpty) {
                value.createButtonEnable();
              }

              imgUrl = "";
            },
            //###########    IMAGE DELETE BUTTON     ###################
            imgDelete: () async {
              final isDelete =
                  await deleteCloudImage(imagePath: value.fileName);

              isDelete!
                  // ignore: use_build_context_synchronously
                  ? isSuccessPopup(
                      context: context,
                      title: "Image is Deleted ",
                      msg: "Image is Delete Success",
                      function: () {},
                      isSuccess: true)
                  // ignore: use_build_context_synchronously
                  : isSuccessPopup(
                      context: context,
                      title: "Image Deleted Faild ",
                      msg: "Image Delete Is Faild",
                      function: () {},
                      isSuccess: false);

              value.isEnableCreateButton = true;
              value.getImageClear();
              itemURLController.clear();
            },
            isImage: value.isFile,
            imageFileDetil: value.fileBytes,
          );
        }),

//*********************     Create button()      ****************************
        context.watch<GetImgLocal>().isEnableCreateButton
            ? createButton(
                buttonName: "Create",
                modifyFunction: () async {
                  //     set provider function

                  context.read<TextFieldChanger>().itemNameChanger(
                      itemNameController.value.text.isEmpty ? true : false);

                  context.read<TextFieldChanger>().itemPriceChanger(
                      itemPricesController.value.text.isEmpty ? true : false);

                  context.read<TextFieldChanger>().itemCountChanger(
                      itemCountController.value.text.isEmpty ? true : false);

                  context.read<TextFieldChanger>().itemUrlChanger(
                      itemURLController.value.text.isEmpty ? true : false);

                  if (itemNameController.value.text.isEmpty ||
                      itemPricesController.value.text.isEmpty ||
                      itemCountController.value.text.isEmpty ||
                      itemURLController.value.text.isEmpty) {
                    return;
                  }

                  await CreateItemModule(
                    collectionPath: dataBasePath,
                    foodItem: FoodItem(
                        itemName: itemNameController.text,
                        itemPrice: int.parse(itemPricesController.text),
                        itemCount: int.parse(itemCountController.text),
                        itemUrl: itemURLController.text,
                        description: descriptionController.text),
                  );

                  itemNameController.clear();
                  itemPricesController.clear();
                  itemCountController.clear();
                  itemURLController.clear();
                  descriptionController.clear();
                },
              )
            : const CircularProgressIndicator.adaptive(), //   Create button end
        Consumer<TextFieldChanger>(
          builder: (context, value, child) {
            return Container(
              child: itemNameController.value.text.isEmpty ||
                      itemPricesController.value.text.isEmpty ||
                      itemCountController.value.text.isEmpty ||
                      itemURLController.value.text.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          child: Image.network(
                              "https://64.media.tumblr.com/6d46bf44a332d592cea529d4afaec529/tumblr_mzxhgq5R1M1sxudx7o1_r1_400.gif"),
                        ),
                        // child: Lottie.asset("assets/c1.json",
                        //     controller: animationController,
                        //     height: 200,
                        //     // width: 200,
                        //     fit: BoxFit.cover)),
                        Text(
                          "Still Not Setup The Item",
                          style: TextStyle(color: MyColor.myOrange),
                        ),
                      ],
                    )
                  : Center(
                      child: SizedBox(
                        height: 300,
                        width: 300,
                        child: FoodTile(
                          itemName: itemNameController.text,
                          itemPrice: int.parse(itemPricesController.text),
                          itemCount: int.parse(itemCountController.text),
                          itemUrl: itemURLController.text,
                          isUserOrderOrNot: false,
                        ),
                      ),
                    ),
            );
          },
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }

  Widget createButton(
      {required String buttonName, required VoidCallback modifyFunction}) {
    return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: ElevatedButton(
          onPressed: modifyFunction,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: const StadiumBorder(),
              side: BorderSide(color: MyColor.myGreen, width: 4)),
          child: SizedBox(
              width: 200,
              height: 50,
              child: Center(
                  child: Text(
                buttonName,
                style: TextStyle(color: MyColor.myRed),
              ))),
        ));
  }
}

//*****************************************************************/
//*****************     GET IMAGE     *****************************/
Widget getImage({
  required bool isImage,
  required VoidCallback imgGet,
  required VoidCallback imgDelete,
  required Uint8List imageFileDetil,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      !isImage
          ? const Icon(
              Icons.no_food_outlined,
              size: 100,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.memory(
                imageFileDetil,
                height: 200.0,
                width: 200.0,
                fit: BoxFit.cover,
              ),
            ),
      Column(
        children: <Widget>[
          IconButton(
              onPressed: imgGet,
              icon: const Icon(
                Icons.camera,
                size: 100,
              )),
          IconButton(
              onPressed: imgDelete,
              icon: const Icon(
                Icons.delete_forever,
                size: 100,
              )),
        ],
      )
    ],
  );
}

// Widget buildProgress() {
//   return StreamBuilder<TaskSnapshot>(
//       stream: uploadTask?.snapshotEvents,
//       builder: (context, snapshot) {
//         double progress = 0;
//         if (snapshot.hasData) {
//           final data = snapshot.data!;
//           progress = data.bytesTransferred / data.totalBytes;
//         }
//         print("progress is :: ${(100 * progress)}");

//         return SizedBox(
//           height: 20,
//           child: Stack(fit: StackFit.expand, children: [
//             LinearProgressIndicator(
//               value: progress,
//               backgroundColor: Colors.grey,
//               color: Colors.green,
//             ),
//           ]),
//         );
//       });
// }
