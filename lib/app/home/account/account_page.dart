import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time_tracker/app/home/account/Phone_page.dart';
import 'package:my_time_tracker/app/home/account/components/user_image_picker.dart';
import 'package:my_time_tracker/app/home/home_app.dart';
import 'package:my_time_tracker/blocs/models/custom_user_model.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      // After Sign out, Set the current tab back
      // to the jobsPage
      HomeAppState.currentTab = 0;
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

  bool _enableTile(CustomUser user) {
    if (user.displayName == 'Anonymous') {
      return false;
    } else {
      return true;
    }
  }

  PopupMenuItem<String> popupMenuItem({
    @required final String value,
    @required final BuildContext context,
    final VoidCallback onPressed,
    final double popUpMenuFontSize = 15.0,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          value,
          style: CustomTextStyles.textStyleTitle(
            fontSize: popUpMenuFontSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomUser user;
    final userProfile = Provider.of<CustomUser>(context);
    print('UserProfile : $userProfile');

    if (userProfile != null) {
      user = userProfile;
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 220,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(0, 144, 144, 0.5),
        title: Text(
          'Account',
          style: CustomTextStyles.textStyleTitle(),
        ),
        centerTitle: false,
        elevation: 5.0,
        actions: [
          PopupMenuButton<String>(
            color: Color.fromRGBO(0, 144, 144, 1),
            itemBuilder: (context) {
              return [
                popupMenuItem(
                  context: context,
                  value: 'SignOut',
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmLogOut(context);
                  },
                ),
                popupMenuItem(
                  context: context,
                  value: 'Settings',
                  onPressed: () {},
                ),
                popupMenuItem(
                  context: context,
                  value: 'Help',
                  onPressed: () {},
                ),
                popupMenuItem(
                  context: context,
                  value: 'About',
                  onPressed: () {},
                ),
              ];
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(170),
          child: Container(
            child: _buildUserInfo(user),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: _buildContent(context, user),
      ),
    );
    // });
  }

  Widget _buildContent(BuildContext context, CustomUser user) {
    if (user != null) {
      return SingleChildScrollView(
        child: _accountInformation(context, user),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _buildUserInfo(CustomUser user) {
    return Column(
      children: [
        UserImagePicker(user),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget _buildListTile({
    @required CustomUser user,
    VoidCallback onTap,
    @required bool enabled,
    @required IconData icon,
    String label,
    bool showChevronIcon,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      enabled: enabled,
      leading: Icon(
        icon,
        color: enabled ? Colors.grey[700] : null,
      ),
      trailing: SizedBox(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: CustomTextStyles.textStyleBold(
                color: enabled ? Colors.teal : null,
              ),
            ),
            if (showChevronIcon == true) Icon(Icons.chevron_right, size: 40.0),
          ],
        ),
      ),
    );
  }

  Widget _accountInformation(BuildContext context, CustomUser user) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 60,
            child: Card(
              margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'ACCOUNT INFORMATION',
                  style: CustomTextStyles.textStyleBold(),
                ),
              ),
            ),
          ),
          _buildListTile(
            user: user,
            onTap: () {},
            enabled: true,
            icon: Icons.person,
            label: user.displayName == ''
                ? 'Display name not found...'
                : user.displayName,
          ),
          Divider(
            thickness: 2.0,
          ),
          _buildListTile(
            user: user,
            enabled: true,
            onTap: () {},
            icon: Icons.email,
            label: user.email == '' ? 'Anonymous@email.com' : user.email,
          ),
          Divider(
            thickness: 2.0,
          ),
          _buildListTile(
            user: user,
            enabled: _enableTile(user),
            showChevronIcon: true,
            onTap: () => PhonePage.show(context, phoneNumber: user.phone),
            icon: Icons.phone,
            label: user.phone == '' ? '+ Add phone...  ' : user.phone,
          ),
          Divider(
            thickness: 2.0,
          ),
          _buildListTile(
            user: user,
            enabled: _enableTile(user),
            showChevronIcon: true,
            onTap: () {},
            icon: Icons.lock,
            label: '',
          ),
          Divider(
            thickness: 20.0,
            color: Color.fromRGBO(0, 144, 144, 0.5),
          ),
        ],
      ),
    );
  }
}
