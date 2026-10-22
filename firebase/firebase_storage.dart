import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';

UploadTask? uploadTask;
Future<String?> upLoadImage(
    {required String imagePath, required Uint8List data}) async {
  // #####   empty work return  ##########
  if (imagePath.isEmpty) return imagePath;

  final ref = FirebaseStorage.instance.ref().child("img/$imagePath");
  uploadTask = ref.putData(data, SettableMetadata(contentType: "image/jpeg"));
  final getSnapShot = await uploadTask?.whenComplete(() => null);

  final getUrl = await getSnapShot?.ref.getDownloadURL();
  // print("url :::: ${getUrl}");

  return getUrl;
}

Future<bool?> deleteCloudImage({required String imagePath}) async {
  final ref = FirebaseStorage.instance.ref().child("img/$imagePath");
  try {
    await ref.delete();
    return true;
  } catch (e) {
    //  print('Error deleting image: $e');
    return false;
  }
}
