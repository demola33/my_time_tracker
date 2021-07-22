import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String message;
  final PackageImage packageImage;

  const EmptyContent({
    Key key,
    this.title: 'Nothing here',
    this.message: 'Add a new item to get started',
    this.packageImage: PackageImage.Image_2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyWidget(
        //image: "images/EmptyOrangeBox.png",

        /// Image from package assets
        packageImage: packageImage,
        title: title,
        subTitle: message,
        titleTextStyle: CustomTextStyles.textStyleBold(
            fontSize: 22, color: Colors.deepOrangeAccent.withOpacity(.7)),

        subtitleTextStyle: CustomTextStyles.textStyleBold(
            color: Colors.deepOrangeAccent.withOpacity(.7)),

        hideBackgroundAnimation: true,
      ),
    );
  }
}
