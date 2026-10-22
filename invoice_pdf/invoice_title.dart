import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:web_app/Utils/timedate_conventer.dart';

/*##############    PDF Title    #################
*************************************************/

class PdfTital {
  static Widget buildTitle({
    required Font font,
    required int indexNumber,
    required int userTelephoneNumber,
    required Timestamp timeOfOrder,
    required String userName,
    required String userID,
    required String userAddrass,
  }) =>
      Column(
        children: [
          textMethod(
              font: font,
              text: "Invoice",
              alignment: Alignment.center,
              fontSize: 24,
              fontWeight: FontWeight.bold),
          heightSpace(height: 0.8),
          textMethod(
              font: font,
              text: "Your Details",
              alignment: Alignment.centerRight,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          heightSpace(height: 0.5),
          textMethod(
              font: font,
              text: "$userName : Name",
              alignment: Alignment.centerRight,
              fontSize: 14,
              fontWeight: FontWeight.normal),
          heightSpace(height: 0.3),
          textMethod(
              font: font,
              text: "0$userTelephoneNumber: Telephone Number",
              alignment: Alignment.centerRight,
              fontSize: 14,
              fontWeight: FontWeight.normal),
          heightSpace(height: 0.3),
          textMethod(
              font: font,
              text: "${TimeDateConventor().date(timeStamp: timeOfOrder)}: Date",
              alignment: Alignment.centerRight,
              fontSize: 14,
              fontWeight: FontWeight.normal),
          heightSpace(height: 0.3),
          textMethod(
              font: font,
              text: "$userAddrass: Address",
              alignment: Alignment.centerRight,
              fontSize: 14,
              fontWeight: FontWeight.normal),
          heightSpace(height: 0.8),
        ],
      );

  static Align textMethod({
    required String text,
    required Alignment alignment,
    double? fontSize,
    FontWeight? fontWeight,
    Font? font,
  }) {
    return Align(
        alignment: alignment,
        child: Text(
          text,
          style:
              TextStyle(font: font, fontSize: fontSize, fontWeight: fontWeight),
        ));
  }

  static SizedBox heightSpace({required double height}) =>
      SizedBox(height: height * PdfPageFormat.cm);
}
