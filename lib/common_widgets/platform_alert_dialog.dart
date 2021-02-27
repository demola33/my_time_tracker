import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/platform_widget.dart';

import 'custom_bold_text_style.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final String content;
  final String defaultActionText;
  final String cancelActionText;

  PlatformAlertDialog({
    @required this.title,
    @required this.content,
    this.cancelActionText,
    @required this.defaultActionText,
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
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(PlatformAlertDialogAction(
        press: () => Navigator.of(context).pop(false),
        child: CustomBoldTextStyle(
          text: cancelActionText,
        ),
      ));
    }
    actions.add(PlatformAlertDialogAction(
      press: () => Navigator.of(context).pop(true),
      child: CustomBoldTextStyle(
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
    return FlatButton(
      child: child,
      onPressed: press,
    );
  }
}
