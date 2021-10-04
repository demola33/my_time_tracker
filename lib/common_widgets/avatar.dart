import 'package:flutter/material.dart';
import 'package:user_profile_avatar/user_profile_avatar.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key key, this.radius, this.photoUrl}) : super(key: key);

  final double radius;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: UserProfileAvatar(
        avatarUrl: photoUrl != '' ? photoUrl : null,
        radius: radius,
        isActivityIndicatorSmall: false,
        avatarBorderData:
            AvatarBorderData(borderWidth: 5, borderColor: Colors.white),
      ),
    );
  }
}
