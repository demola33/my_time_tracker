import 'package:flutter/foundation.dart';

class CustomUser {
  CustomUser({
    @required this.photoUrl,
    @required this.displayName,
    @required this.uid,
    @required this.email,
    this.phone,
  });

  final String uid;
  final String photoUrl;
  final String displayName;
  final String email;
  final String phone;

  // set phone(String phone) {
  //   this.phone = phone;
  // }

  // set displayName(String displayName) {
  //   this.displayName = displayName;
  // }

  factory CustomUser.fromMap(Map<String, dynamic> data, String uid) {
    if (data == null) {
      return null;
    }
    final String displayName = data['displayName'];
    //final String lastName = data['lastName'];
    final String email = data['email'];
    final String phone = data['phone'];
    final String photoURL = data['imageURL'];

    return CustomUser(
      uid: uid,
      displayName: displayName,
      email: email,
      phone: phone,
      photoUrl: photoURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "displayName": displayName,
      "email": email,
      "phone": phone,
      "imageURL": photoUrl,
    };
  }

  @override
  String toString() =>
      'displayName : $displayName, email: $email, uid: $uid, phone: $phone, imageURL: $photoUrl';
}
