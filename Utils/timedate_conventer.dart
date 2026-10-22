import 'package:cloud_firestore/cloud_firestore.dart';

class TimeDateConventor {
  String date({required Timestamp timeStamp}) {
    int year = timeStamp.toDate().year;
    int month = timeStamp.toDate().month;
    int day = timeStamp.toDate().day;

    String yyMmDd = "$year/$month/$day";
    return yyMmDd;
  }

  String time({required Timestamp timeStamp}) {
    int hour = timeStamp.toDate().hour;
    int min = timeStamp.toDate().minute;
    int sec = timeStamp.toDate().second;

    String hms = "$hour:$min:$sec";
    return hms;
  }
}
