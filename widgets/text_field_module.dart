import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_app/Utils/colors.dart';

Padding customInputField({
  required String inputFieldName,
  required TextEditingController inputEditingController,
  required bool isNumberTypeKeybord,
  required bool isValidate,
  required TextInputType keyBordType,
  int maxLine = 1,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: TextField(
      style: TextStyle(color: MyColor.myWhite),
      controller: inputEditingController,
      keyboardType: keyBordType,
      maxLines: maxLine,
      inputFormatters: [
        isNumberTypeKeybord
            ? FilteringTextInputFormatter.digitsOnly
            : FilteringTextInputFormatter.singleLineFormatter
      ],
      decoration:
          inputDecoration(item_Name: inputFieldName, isValidate: isValidate),
    ),
  );
}

InputDecoration inputDecoration(
    {required String item_Name, required bool isValidate}) {
  return InputDecoration(
    errorText: isValidate ? "Field is Empty " : null,
    labelText: item_Name,
    labelStyle: TextStyle(color: MyColor.myGreen),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 3, color: MyColor.myWhite), //<-- SEE HERE
      borderRadius: BorderRadius.circular(50.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 3, color: MyColor.myGreen), //<-- SEE HERE
      borderRadius: BorderRadius.circular(50.0),
    ),
    errorBorder: isValidate
        ? OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: MyColor.myRed), //<-- SEE HERE
            borderRadius: BorderRadius.circular(50.0),
          )
        : null,
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 3, color: MyColor.myGreen), //<-- SEE HERE
      borderRadius: BorderRadius.circular(50.0),
    ),
  );
}
