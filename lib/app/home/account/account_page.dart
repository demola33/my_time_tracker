import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/account/phone_page.dart';
import 'package:my_time_tracker/app/home/account/account_page_manager.dart';
import 'package:my_time_tracker/app/home/account/components/user_image_picker.dart';
import 'package:my_time_tracker/app/home/account/reset_password_page.dart';
import 'package:my_time_tracker/models_and_managers/models/custom_user_model.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key key, @required this.manager}) : super(key: key);
  final AccountPageManager manager;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    CustomUser user;
    final userProfile = Provider.of<CustomUser>(context);

    if (userProfile != null) {
      user = userProfile;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromRGBO(0, 144, 144, 0.5),
        title: Text(
          'Account',
          style: CustomTextStyles.textStyleTitle(),
        ),
        centerTitle: false,
        elevation: 5.0,
        actions: [
          IconButton(
            iconSize: 30.0,
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => manager.showSettings(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(size * 0.3),
          child: Container(
            child: _buildUserInfo(user),
          ),
        ),
      ),
      body: Container(
        //height: 250,
        color: Colors.white,
        child: _buildContent(context, user),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CustomUser user) {
    if (user != null) {
      double size = MediaQuery.of(context).size.height;
      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
        Card(
          elevation: 5.0,
          color: const Color.fromRGBO(0, 144, 144, 0.5),
          child: Container(
            margin: const EdgeInsets.only(top: 8.0),
            alignment: Alignment.center,
            height: size * 0.066,
            child: Text(
              'ACCOUNT INFORMATION',
              style: CustomTextStyles.textStyleExtraBold(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            //color: Colors.blue,
            margin: const EdgeInsets.all(8.0),
            child: _accountInformation(context, user),
          ),
        ),
      ]);
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _buildUserInfo(CustomUser user) {
    return Column(
      children: [
        UserImagePicker(user),
        const SizedBox(
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
    return Expanded(
      child: ListTile(
        onTap: onTap,
        dense: true,
        enabled: enabled,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: Icon(
          icon,
          color: enabled ? Colors.grey[700] : null,
        ),
        trailing: SizedBox(
          width: 270,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 220,
                child: Text(
                  label,
                  textAlign: TextAlign.right,
                  style: CustomTextStyles.textStyleBold(
                    color: enabled ? Colors.teal : null,
                  ),
                ),
              ),
              if (showChevronIcon == true)
                const Icon(Icons.chevron_right, size: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountInformation(BuildContext context, CustomUser user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildListTile(
          user: user,
          onTap: () {},
          enabled: true,
          icon: Icons.person,
          label: user.displayName == ''
              ? 'Display name not found'
              : user.displayName,
        ),
        const Divider(
          thickness: 2.0,
        ),
        _buildListTile(
          user: user,
          enabled: true,
          onTap: () {},
          icon: Icons.email,
          label: user.email == '' ? 'Anonymous@email.com' : user.email,
        ),
        const Divider(
          thickness: 2.0,
        ),
        _buildListTile(
          user: user,
          enabled: manager.enableTile(user),
          showChevronIcon: true,
          onTap: () => PhonePage.show(
            context: context,
            phone: user.phone,
            isoCode: user.isoCode,
            editNumberCallback: false,
          ),
          icon: Icons.phone,
          label: user.phone == '' ? 'Add phone  ' : user.phone,
        ),
        const Divider(
          thickness: 2.0,
        ),
        _buildListTile(
          user: user,
          enabled: manager.didUserSignUpWithPassword(context)
              ? manager.enableTile(user)
              : false,
          showChevronIcon: true,
          onTap: () => ResetPassword.show(context, false),
          icon: Icons.lock,
          label: '',
        ),
        const Divider(
          thickness: 2.0,
        ),
      ],
    );
  }
}
