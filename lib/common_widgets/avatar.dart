import 'package:flutter/material.dart';
import 'package:user_profile_avatar/user_profile_avatar.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key key, this.radius, this.photoUrl}) : super(key: key);

  //final String photoUrl;
  final double radius;
  final String photoUrl;

  // CachedNetworkImageProvider _getNetworkImage(String url) {
  //   return CachedNetworkImageProvider(url);
  // }

  @override
  Widget build(BuildContext context) {
    print("PhotoURL: $photoUrl");
    return Container(
      width: 150,
      height: 150,
      //color: Colors.blue,
      // decoration: BoxDecoration(
      //   shape: BoxShape.circle,
      //   border: Border.all(
      //     color: Colors.white,
      //     width: 5.0,
      //   ),
      // ),
      child: UserProfileAvatar(
        avatarUrl: photoUrl != '' ? photoUrl : null,
        radius: radius,
        isActivityIndicatorSmall: false,
        avatarBorderData:
            AvatarBorderData(borderWidth: 5.0, borderColor: Colors.white),
      ),
      // CircleAvatar(
      //   radius: radius,
      //   onBackgroundImageError: null,
      //   backgroundColor: Colors.deepOrangeAccent,
      //
      //   foregroundColor: Colors.white,
      //   backgroundImage:  photoUrl != '' ? _getNetworkImage(photoUrl) : null,
      //   child: photoUrl == ''
      //       ? Icon(
      //     Icons.person,
      //     size: 90.0,
      //   ) : null,
      // ),
    );
  }
}
