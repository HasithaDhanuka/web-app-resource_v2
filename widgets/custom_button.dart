import 'package:flutter/material.dart';

//*********************************************//
//#######     Rounded Elevated Button  ########//
//*********************************************//
Widget reUsableButton(
    {required VoidCallback onPressed,
    required String buttonName,
    required Color borderSideColor}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: const StadiumBorder(),
        side: BorderSide(color: borderSideColor, width: 4)),
    child: Text(
      buttonName,
      style: TextStyle(color: borderSideColor),
    ),
  );
}

// Widget toggleCustomButtons(
//     {required List<bool> isSelected, required Function onPressed}) {
//   // List<bool> isSelected = [true, false, false];
//   return ToggleButtons(
//       isSelected: isSelected,
//       borderRadius: const BorderRadius.all(Radius.circular(8)),
//       selectedBorderColor: Colors.red[700],
//       selectedColor: Colors.white,
//       fillColor: Colors.red[200],
//       color: Colors.red[400],
//       constraints: const BoxConstraints(
//         minHeight: 40.0,
//         minWidth: 80.0,
//       ),
//       onPressed: (int index) {
//         for (int i = 0; i < isSelected.length; i++) {
//           isSelected[i] = i == index;
//           print("Current Index is ${index}");
//         }
//       },
//       children: const <Widget>[
//         Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Text("වෙනත්"),
//         ),
//         Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Text("ධාන්‍ය වර්ග"),
//         ),
//         Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Text("පිටි වර්ග"),
//         ),
//       ]);
// }
