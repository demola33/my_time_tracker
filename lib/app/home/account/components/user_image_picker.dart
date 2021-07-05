import 'dart:io';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_time_tracker/blocs/models/custom_user_model.dart';
import 'package:my_time_tracker/common_widgets/avatar.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:my_time_tracker/services/firebase-storage_services.dart';
import 'package:provider/provider.dart';

class UserImagePicker extends StatefulWidget {
  final CustomUser user;

  const UserImagePicker(this.user);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final _service = FirebaseStorageServices.instance;
  bool isLoading = false;
  File _pickedImage;

  // CachedNetworkImageProvider _getNetworkImage(String url) {
  //   CachedNetworkImageProvider image;
  //   if (url == '') {
  //     image = null;
  //   } else {
  //     image = CachedNetworkImageProvider(url);
  //   }
  //   return image;
  // }

  void _pickImage(CustomUser user) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Choose option',
            style: CustomTextStyles.textStyleTitle(color: Colors.teal[600]),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                InkWell(
                  onTap: () async {
                    final pickedImageFile =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    _pickedImage = File(pickedImageFile.path);
                    Navigator.pop(context);
                    setState(() {
                      isLoading = true;
                    });
                    final imageURL = await uploadImage(_pickedImage)
                        .whenComplete(() => this.isLoading = false);
                    await auth.updateUserImageURL(imageURL);
                  },
                  splashColor: Colors.teal[600],
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.camera_alt),
                      ),
                      Text('Camera', style: CustomTextStyles.textStyleBold())
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final pickedImageFile = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    _pickedImage = File(pickedImageFile.path);
                    Navigator.pop(context);
                    setState(() {
                      isLoading = true;
                    });
                    final imageURL = await uploadImage(_pickedImage)
                        .whenComplete(() => this.isLoading = false);
                    await auth.updateUserImageURL(imageURL);
                  },
                  splashColor: Colors.teal[600],
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.image),
                      ),
                      Text('Gallery', style: CustomTextStyles.textStyleBold())
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final imageURL = '';
                    await auth.updateUserImageURL(imageURL);
                    Navigator.pop(context);
                  },
                  splashColor: Colors.teal[600],
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.remove_circle),
                      ),
                      Text(
                        'Remove',
                        style:
                            CustomTextStyles.textStyleBold(color: Colors.red),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  bool _enableImagePicker(CustomUser user) {
    if (user.displayName == 'Anonymous') {
      return false;
    } else {
      return true;
    }
  }

  Future<String> uploadImage(File image) async {
    return _service.uploadImage(image, widget.user.uid);
  }

  Widget _imageViewBuilder({
    String photoUrl,
    void Function() onPressed,
  }) =>
      Stack(
        children: [
          Avatar(
            photoUrl: photoUrl,
            radius: 70,
          ),
          Positioned(
            top: 100,
            left: 80,
            child: RawMaterialButton(
              fillColor: Color.fromRGBO(0, 144, 144, 1.0),
              child: Icon(
                Icons.add_a_photo_sharp,
                size: 25,
              ),
              padding: EdgeInsets.all(8.0),
              shape: CircleBorder(),
              onPressed: isLoading ? null : onPressed,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    //final auth = Provider.of<AuthBase>(context, listen: false);

    //return StreamBuilder<CustomUser>(
    //stream: auth.userChanges,
    //builder: (context, snapshot) {
    CustomUser user = widget.user;
    if (user == null) {
      return _imageViewBuilder(photoUrl: '');
    } else {
      return _imageViewBuilder(
        photoUrl: user.photoUrl,
        onPressed: _enableImagePicker(user) ? () => _pickImage(user) : () {},
      );
    }
    // var userProfileImage =
    //     user.photoUrl != null ? getNetworkImage(user.photoUrl) : null;
    //print('userProfileImage : $userProfileImage');
  }
//);
}
