import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_time_tracker/models_and_managers/models/custom_user_model.dart';
import 'package:my_time_tracker/common_widgets/avatar.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/true_or_false_switch.dart';
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
  File _pickedImage;

  void _pickImage(CustomUser user, TrueOrFalseSwitch onSwitch) {
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
                    onSwitch.toggle();
                    final pickedImageFile =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    _pickedImage = File(pickedImageFile.path);
                    Navigator.pop(context);

                    final imageURL = await uploadImage(_pickedImage)
                        .whenComplete(() => onSwitch.toggle());
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
                    onSwitch.toggle();
                    final pickedImageFile = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    _pickedImage = File(pickedImageFile.path);
                    Navigator.pop(context);
                    final imageURL = await uploadImage(_pickedImage);
                    await auth
                        .updateUserImageURL(imageURL)
                        .whenComplete(() => onSwitch.toggle());
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
    @required TrueOrFalseSwitch onSwitch,
  }) {
    return Stack(
      children: [
        Avatar(
          photoUrl: photoUrl,
          radius: 75,
        ),
        Positioned(
          bottom: 10,
          left: 80,
          child: RawMaterialButton(
            fillColor: Color.fromRGBO(0, 144, 144, 1.0),
            child: Icon(
              Icons.add_a_photo_sharp,
              size: 25,
            ),
            padding: EdgeInsets.all(8.0),
            shape: CircleBorder(),
            onPressed: onSwitch.value ? null : onPressed,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrueOrFalseSwitch>(builder: (context, _onSwitch, child) {
      CustomUser user = widget.user;
      if (user == null) {
        return _imageViewBuilder(photoUrl: '', onSwitch: _onSwitch);
      } else {
        return _imageViewBuilder(
          photoUrl: user.photoUrl,
          onSwitch: _onSwitch,
          onPressed: _enableImagePicker(user)
              ? () => _pickImage(user, _onSwitch)
              : () {},
        );
      }
    });
  }
}
