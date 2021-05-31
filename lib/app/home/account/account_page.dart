import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        exception: e,
        title: 'Sign-out failed',
      ).show(context);
    }
  }

  Future<void> _confirmLogOut(BuildContext context) async {
    final didRequestLogOut = await PlatformAlertDialog(
      title: 'Log Out',
      content: 'Are you sure you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestLogOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double popUpMenuFontSize = 15.0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.teal,
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Account',
          style: CustomTextStyles.textStyleTitle(color: Colors.teal),
        ),
        centerTitle: false,
        elevation: 0.0,
        actions: [
          PopupMenuButton<String>(
            color: Colors.teal,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'SignOut',
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmLogOut(context);
                    },
                    child: Text(
                      'Sign out',
                      style: CustomTextStyles.textStyleTitle(
                        fontSize: popUpMenuFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Profile',
                      style: CustomTextStyles.textStyleTitle(
                        fontSize: popUpMenuFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Settings',
                      style: CustomTextStyles.textStyleTitle(
                        fontSize: popUpMenuFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Help',
                      style: CustomTextStyles.textStyleTitle(
                        fontSize: popUpMenuFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'About',
                      style: CustomTextStyles.textStyleTitle(
                        fontSize: popUpMenuFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ];
            },
          )
        ],
      ),
    );
  }
}
