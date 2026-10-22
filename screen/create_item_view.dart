import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/firebase/firebase_storage.dart';
import 'package:web_app/screen/popup_view.dart';
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
  late AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  final itemNameController = TextEditingController();
  final itemPricesController = TextEditingController();
  final itemURLController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
    itemNameController.dispose();
    itemPricesController.dispose();
    itemURLController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: MyColor.myGreen),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
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
                          itemPricesController.value.text.isEmpty
                              ? true
                              : false);

                      context.read<TextFieldChanger>().itemUrlChanger(
                          itemURLController.value.text.isEmpty ? true : false);

                      if (itemNameController.value.text.isEmpty ||
                          itemPricesController.value.text.isEmpty ||
                          itemURLController.value.text.isEmpty) {
                        return;
                      }

                      CreateItemModule(
                          foodItem: FoodItem(
                              itemName: itemNameController.text,
                              itemPrice: int.parse(itemPricesController.text),
                              itemUrl: itemURLController.text));
                      Future.delayed(const Duration(milliseconds: 200),
                          () async {
                        itemNameController.clear();
                        itemPricesController.clear();
                        itemURLController.clear();
                      });
                    },
                  )
                : const CircularProgressIndicator
                    .adaptive(), //   Create button end
            Consumer<TextFieldChanger>(
              builder: (context, value, child) {
                return Container(
                  child: itemNameController.value.text.isEmpty ||
                          itemPricesController.value.text.isEmpty ||
                          itemURLController.value.text.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                child: Lottie.asset("assets/c1.json",
                                    controller: animationController,
                                    height: 200,
                                    // width: 200,
                                    fit: BoxFit.cover)),
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
                                itemUrl: itemURLController.text),
                          ),
                        ),
                );
              },
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
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
