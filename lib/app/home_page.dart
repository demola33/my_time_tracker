import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(
        e.toString(),
      );
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
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        elevation: 10.0,
        actions: [
          FlatButton(
            onPressed: () => _confirmLogOut(context),
            child: Text(
              'Log Out',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
