import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStorageServices {
  FirebaseStorageServices._();
  static final instance = FirebaseStorageServices._();

  Future<String> uploadImage(File image, String fileName) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(fileName + '.jpg');
    await ref.putFile(image).whenComplete(() => CircularProgressIndicator());
    final url = await ref.getDownloadURL();
    return url;
  }
}
