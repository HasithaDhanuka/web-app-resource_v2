import 'dart:convert';
import 'dart:html' as html;
import 'package:universal_html/html.dart' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:web_app/invoice_pdf/invoice_title.dart';
import 'package:web_app/model/food.dart';

class PdfApi {
  static Future<Uint8List> genarateInvoice({
    required int indexNumber,
    required int userTelephoneNumber,
    required int orderPrice,
    required String userName,
    required String userID,
    required String userAddrass,
    required Timestamp timeOfOrder,
    required List<FoodItem> orders,
  }) async {
    final pdf = Document();
    final font = await PdfGoogleFonts.sawarabiMinchoRegular();
    final img = await rootBundle.load('iconLogo.jpg');
    final imageBytes = await img.buffer.asUint8List();
    Image image1 = await Image(MemoryImage(imageBytes));

    pdf.addPage(MultiPage(
      build: (context) => [
        PdfTital.buildTitle(
          font: font,
          indexNumber: indexNumber,
          userTelephoneNumber: userTelephoneNumber,
          timeOfOrder: timeOfOrder,
          userName: userName,
          userID: userID,
          userAddrass: userAddrass,
        ),
        headers(font: font, colorHex: "#DC7633"),
        itemCartBuilder(orders: orders, font: font),
        totalPrice(
            font: font,
            fontSize: 15,
            totalAmount: orderPrice,
            colorHex: "#E74C3C"),
      ],
      footer: (context) =>
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "ありがとうございました。",
          style:
              TextStyle(font: font, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Container(
          alignment: Alignment.center,
          height: 90,
          child: image1,
        )
      ]),
    ));
    final pdfDocumentData = await pdf.save();
    return pdfDocumentData;
  }

/*##############    Headers    #################
*****************************************************/
  static Widget headers({
    required Font font,
    String? colorHex,
    String? row1 = "Item Name",
    String? row2 = "Quantity",
    String? row3 = "Price",
  }) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      itemsRow(
          font: font,
          colorHex: colorHex,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          itemName: row1!,
          textSpaceLeft: 20,
          height: 30,
          width: 300,
          alignment: Alignment.centerLeft),
      itemsRow(
          colorHex: "#58D68D",
          fontSize: 14,
          fontWeight: FontWeight.bold,
          font: font,
          itemName: row2!,
          height: 30,
          width: 80,
          alignment: Alignment.center),
      itemsRow(
          colorHex: "#E74C3C",
          fontSize: 14,
          fontWeight: FontWeight.bold,
          font: font,
          itemName: row3!,
          textSpaceRight: 20,
          height: 30,
          width: 100,
          alignment: Alignment.centerRight),
    ]);
  }

/*##############    Item Builder    #################
*****************************************************/
  static Widget itemCartBuilder({
    required List<FoodItem> orders,
    required Font font,
  }) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, int index) {
        final orderItem = orders[index];
        return itemCart(
            font: font,
            itemName: orderItem.itemName,
            netImg: orderItem.itemUrl,
            itemPrice: orderItem.itemPrice);
      },
    );
  }

  static Widget itemCart({
    required String itemName,
    required String netImg,
    required int itemPrice,
    required Font font,
  }) {
    //  final netImage =await networkImage(netImg);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      itemsRow(
          font: font,
          itemName: itemName,
          textSpaceLeft: 20,
          height: 30,
          width: 300,
          alignment: Alignment.centerLeft),
      itemsRow(
          font: font,
          itemName: "Qty X 1",
          height: 30,
          width: 80,
          alignment: Alignment.center),
      itemsRow(
          font: font,
          itemName: "$itemPrice 円",
          textSpaceRight: 20,
          height: 30,
          width: 100,
          alignment: Alignment.centerRight),
    ]);
  }

  static Container itemsRow({
    required String itemName,
    double? textSpaceLeft = 0,
    double? textSpaceRight = 0,
    required double height,
    double? width,
    String? colorHex = "#ABB2B9",
    required Alignment alignment,
    required Font font,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return Container(
        height: height,
        width: width,
        color: PdfColor.fromHex("$colorHex"),
        child: Align(
          alignment: alignment,
          child: Padding(
            padding:
                EdgeInsets.only(left: textSpaceLeft!, right: textSpaceRight!),
            child: Text("$itemName",
                style: TextStyle(
                    font: font, fontSize: fontSize, fontWeight: fontWeight)),
          ),
        ));
  }

  static Widget totalPrice({
    required Font font,
    required double fontSize,
    String colorHex = "#F1948A",
    required int totalAmount,
  }) {
    return Container(
        height: 50,
        width: 600,
        color: PdfColor.fromHex("$colorHex"),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          PdfTital.textMethod(
              font: font,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              text: "Total Amount :",
              alignment: Alignment.centerRight),
          PdfTital.textMethod(
              font: font,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              text: " $totalAmount 円",
              alignment: Alignment.centerRight),
          SizedBox(width: 40),
        ]));
  }

/*##############    Save PDF    #################
*************************************************/
  static Future<bool> saveDocument({
    required Uint8List pdfBytes,
    required String userName,
  }) async {
    // // Save the PDF
    // List<int> fileInts = List.from(pdfBytes);
    // final blob = pdfMemoryBytesToBlob(fileInts);
    // final url = getUrlFromBlob(blob);

    // // Trigger download
    // final anchor = html.AnchorElement(href: url)
    //   ..setAttribute(
    //       "download", "${userName}${DateTime.now().millisecondsSinceEpoch}.pdf")
    //   ..click();

    List<int> fileInts = List.from(pdfBytes);
    await html.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
      ..setAttribute(
          "download", "${userName}${DateTime.now().millisecondsSinceEpoch}.pdf")
      ..click();
    return true;
  }
}

// html.Blob pdfMemoryBytesToBlob(List<int> bytes) {
//   final blob = html.Blob([bytes], 'application/pdf');
//   return blob;
// }

// String getUrlFromBlob(html.Blob blob) {
//   return html.Url.createObjectUrlFromBlob(blob);
// }
