import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:universal_html/universal_html.dart' as html;
import 'package:web_app/Utils/colors.dart';
import 'package:web_app/Utils/timedate_conventer.dart';
import 'package:web_app/model/food.dart';
import 'package:animated_expandable_fab/animated_expandable_fab.dart';

//import 'package:pdfx/pdfx.dart';

class InvoiceView extends StatelessWidget {
  const InvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenshotController screenshotController = ScreenshotController();

    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final int userTelNumber = args["telephoneNum"];
    final int orderPrice = args["orderPrice"];
    final String userName = args["userName"];
    final String userAddress = args["userAddrass"];
    final bool isDeliver = args["isDeliver"];
    // Older invoice routes may not provide a saved fee, so retain the old rate.
    final int deliveryCharge =
        (args["deliveryCharge"] as num?)?.toInt() ?? (isDeliver ? 200 : 0);
    final Timestamp timeOfOrder = args["timeOfOrder"];
    final List<FoodItem> orderItem = args["orders"];

    final int totalAmount = orderPrice + deliveryCharge;

    // Capture the invoice widget and download the resulting PNG in the browser.
    Future<void> _downloadInvoicePng() async {
      try {
        final invoicePng = await screenshotController.capture(pixelRatio: 2);
        if (invoicePng == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not capture the invoice.')),
          );
          return;
        }

        final now = DateTime.now();
        final customerName = userName
            .trim()
            .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '-');
        final year = (now.year % 100).toString().padLeft(2, '0');
        final month = now.month.toString().padLeft(2, '0');
        final day = now.day.toString().padLeft(2, '0');
        final hour = now.hour.toString().padLeft(2, '0');
        final minute = now.minute.toString().padLeft(2, '0');
        final second = now.second.toString().padLeft(2, '0');
        // Replace filename-invalid slashes and colons with hyphens.
        final fileName =
            '${customerName}_date($year-$month-$day)_time($hour-$minute-$second).png';
        final blob = html.Blob([invoicePng], 'image/png');
        final objectUrl = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: objectUrl)
          ..download = fileName
          ..click();
        Future<void>.delayed(const Duration(seconds: 1), () {
          html.Url.revokeObjectUrl(objectUrl);
        });
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invoice PNG downloaded.')),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not download the invoice PNG.')),
        );
        debugPrint('Invoice PNG download failed: $error');
      }
    }

/* ***************************************************************
 ##################         Invoice       #######################*/
    return Scaffold(
      floatingActionButton: ExpandableFab(
        distance: 100,
        openIcon: Icon(Icons.add),
        closeIcon: Icon(Icons.close),
        children: [
          ActionButton(
            text: const Text("Invoice PNG"),
            onPressed: _downloadInvoicePng,
            icon: const Icon(Icons.image_outlined),
          ),
          ActionButton(
            text: Text("Go Home "),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Screenshot(
            controller: screenshotController,
            // Give the captured invoice an opaque white background.
            child: Theme(
              // Printed invoices stay light and legible even in the dark app.
              data: ThemeData.light(useMaterial3: true),
              child: Container(
                color: MyColor.invoicePaper,
                child: invoiceBody(
                  userName,
                  userAddress,
                  userTelNumber,
                  timeOfOrder,
                  orderItem,
                  orderPrice,
                  deliveryCharge,
                  totalAmount,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget invoiceBody(
      String userName,
      String userAddress,
      int userTelNumber,
      Timestamp timeOfOrder,
      List<FoodItem> orderItem,
      int orderPrice,
      int deliveryCharge,
      int totalAmount) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "Invoice",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        header(
            userName: userName,
            userAddress: userAddress,
            userTelNumber: userTelNumber,
            timeOfOrder: timeOfOrder,
            textAlign: TextAlign.left,
            fontSize: 10),
        tableHeaders(
          itemName: "Item Name",
          itemQty: "Qty",
          itemPrice: "Price",
          rowHeight: 30,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: MyColor.myGreen,
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: orderItem.length,
            itemBuilder: (context, index) {
              final item = orderItem[index];
              return tableHeaders(
                  fontSize: 10,
                  itemName: "${item.itemName}",
                  itemQty: " X 1",
                  itemPrice: "${item.itemPrice} 円",
                  fontWeight: FontWeight.w700,
                  color: MyColor.myOrange,
                  rowHeight: 30);
            }),
        invoiceTotal(
            itemPrice: "$orderPrice 円",
            deliverCharge: "$deliveryCharge 円",
            totalAmount: "$totalAmount 円"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ありがとうございました。",
              style: TextStyle(fontSize: 20),
            ),
            Image.asset(
              "assets/LogoFooter.png",
              height: 100,
              width: 100,
            ),
          ],
        )
      ],
    );
  }
}

/* ***************************************************************
 ##################     Invoice Header   #######################*/
Widget header({
  required String userName,
  required String userAddress,
  required int userTelNumber,
  required Timestamp timeOfOrder,
  required double fontSize,
  required TextAlign textAlign,
}) {
  return Stack(
    //clipBehavior: Clip.antiAliasWithSaveLayer,
    children: [
      Positioned(
        top: 10,
        left: 250,
        child: Image.asset(
          "assets/iconLogo.png",
          height: 100,
          width: 100,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: [
            headTital(
                nameOfRow: "Your Detail", fontSize: 16, textAlign: textAlign),
            headTital(
                nameOfRow: "Name : ${userName}",
                fontSize: fontSize,
                textAlign: textAlign),
            headTital(
                nameOfRow: "Telephone Number : 0${userTelNumber}",
                fontSize: fontSize,
                textAlign: textAlign),
            headTital(
                nameOfRow:
                    "Date : ${TimeDateConventor().date(timeStamp: timeOfOrder)}",
                fontSize: fontSize,
                textAlign: textAlign),
            headTital(
                nameOfRow: "Address : ${userAddress}",
                fontSize: fontSize,
                textAlign: textAlign),
          ],
        ),
      ),
    ],
  );
}

Widget headTital({
  required String nameOfRow,
  required double fontSize,
  required TextAlign textAlign,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 2),
    child: Container(
      width: 500,
      //  height: 20,
      child: AutoSizeText(
        textAlign: textAlign,
        "${nameOfRow}",
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// ***************************************************************//
// ##################   Item Table Header  ####################//

Widget tableHeaders({
  required double fontSize,
  required String itemName,
  required String itemQty,
  required String itemPrice,
  required FontWeight fontWeight,
  required Color color,
  required double rowHeight,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: Row(
      children: [
        tableText(
            rowWidth: 250,
            rowHeight: rowHeight,
            fontSize: fontSize,
            tableName: itemName,
            color: color,
            fontWeight: fontWeight),
        tableText(
            rowWidth: 50,
            rowHeight: rowHeight,
            fontSize: fontSize,
            tableName: itemQty,
            color: color,
            fontWeight: fontWeight),
        tableText(
            rowWidth: 70,
            rowHeight: rowHeight,
            fontSize: fontSize,
            tableName: itemPrice,
            color: color,
            fontWeight: fontWeight),
      ],
    ),
  );
}

Widget tableText({
  required double fontSize,
  required String tableName,
  required FontWeight fontWeight,
  required Color color,
  required double rowHeight,
  double? rowWidth,
}) {
  return Container(
    height: rowHeight,
    width: rowWidth,
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        overflow: TextOverflow.ellipsis,
        tableName,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      ),
    ),
  );
}

/* ***************************************************************
 ##################     Invoice Header   #######################*/
Widget invoiceTotal({
  required String itemPrice,
  required String deliverCharge,
  required String totalAmount,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: Container(
      child: Column(
        children: [
          totalText(
              itemPrice: itemPrice,
              fontSize: 12,
              totalTital: "Item Price",
              fontWeight: FontWeight.w500),
          totalText(
              itemPrice: deliverCharge,
              fontSize: 12,
              totalTital: "Delivery Charges",
              fontWeight: FontWeight.w500),
          totalText(
              itemPrice: totalAmount,
              fontSize: 15,
              totalTital: "Total Amount",
              fontWeight: FontWeight.bold)
        ],
      ),
    ),
  );
}

Widget totalText({
  required String itemPrice,
  required double fontSize,
  required String totalTital,
  required FontWeight fontWeight,
}) {
  return Row(
    children: [
      Container(
        color: MyColor.myYellow,
        width: 200,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "$totalTital",
            style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
          ),
        ),
      ),
      Container(
        color: MyColor.myRed,
        width: 170,
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            textAlign: TextAlign.end,
            "${itemPrice}",
            style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
          ),
        ),
      ),
    ],
  );
}

class Footer extends StatefulWidget {
  const Footer();

  @override
  _Footer createState() => _Footer();
}

class _Footer extends State {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
        ),
      ],
    );
  }
}


// class PdfViewScreen extends StatelessWidget {
//   const PdfViewScreen({
//     super.key,
//   });
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic>? args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     final Uint8List getPdfData = args!["pdfData"];

//     return Scaffold(
//         body: getPdfData.isNotEmpty
//             ? Container(
//                 child: PdfPreview(
//                     maxPageWidth: 600,
//                     allowPrinting: true,
//                     allowSharing: false,
//                     canChangeOrientation: false,
//                     canChangePageFormat: false,
//                     canDebug: false,
//                     build: ((format) => getPdfData)))
//             : Container(
//                 child: Text("Data is not"),
//               ));
//   }
// }

// class PdfViewScreen extends StatelessWidget {
//   const PdfViewScreen({super.key, required this.pdfData});
//   final Uint8List pdfData;
//   @override
//   Widget build(BuildContext context) {
//     final pdfController =
//         PdfController(document: PdfDocument.openData(pdfData));
//     return Container(
//       child: PdfView(controller: pdfController),
//     );
//   }
// }
