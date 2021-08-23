import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/layout/custom_text.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final dynamic content;
  final String defaultActionText;
  final String cancelActionText;
  final VoidCallback onPressOk;
  final VoidCallback onPressCancel;

  PlatformAlertDialog({
    @required this.title,
    @required this.content,
    this.onPressOk,
    this.onPressCancel,
    this.cancelActionText,
    @required this.defaultActionText,
    exception,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => this,
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: CustomTextStyles.textStyleTitle(color: Colors.redAccent),
      ),
      content: Text(
        content,
        style: CustomTextStyles.textStyleBold(),
      ),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: CustomTextStyles.textStyleTitle(color: Colors.redAccent),
      ),
      content: Text(
        content,
        style: CustomTextStyles.textStyleBold(
          fontSize: 14.0,
          color: Colors.black54,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(PlatformAlertDialogAction(
        press: onPressCancel == null
            ? () => Navigator.of(context).pop(false)
            : onPressCancel,
        child: CustomText(
          text: cancelActionText,
        ),
      ));
    }
    actions.add(PlatformAlertDialogAction(
      press:
          onPressOk == null ? () => Navigator.of(context).pop(true) : onPressOk,
      child: CustomText(
        text: defaultActionText,
      ),
    ));
    return actions;
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  final Widget child;
  final VoidCallback press;

  PlatformAlertDialogAction({
    @required this.child,
    @required this.press,
  });

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: press,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextButton(
      child: child,
      onPressed: press,
    );
  }
}
