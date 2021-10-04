import 'package:flutter/foundation.dart';

class CustomUser {
  CustomUser({
    @required this.photoUrl,
    @required this.displayName,
    @required this.uid,
    @required this.email,
    this.phone,
    this.isoCode,
  });

  final String uid;
  final String photoUrl;
  final String displayName;
  final String email;
  final String phone;
  final String isoCode;

  factory CustomUser.fromMap(Map<String, dynamic> data, String uid) {
    if (data == null) {
      return null;
    }
    final String displayName = data['displayName'];
    final String email = data['email'];
    final String phone = data['phone'];
    final String photoURL = data['imageURL'];
    final String isoCode = data['countryCode'];

    return CustomUser(
      uid: uid,
      displayName: displayName,
      email: email,
      phone: phone,
      photoUrl: photoURL,
      isoCode: isoCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "displayName": displayName,
      "email": email,
      "phone": phone,
      "imageURL": photoUrl,
      "countryCode": isoCode,
    };
  }

  @override
  String toString() =>
      'displayName : $displayName, email: $email, uid: $uid, phone: $phone, imageURL: $photoUrl, countryCode : $isoCode';
}
