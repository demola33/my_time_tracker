import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_time_tracker/app/home/account/reset_password_page.dart';
import 'package:my_time_tracker/app/home/home_app.dart';
import 'package:my_time_tracker/app/sign_in/components/time_tracker_logo.dart';
import 'package:my_time_tracker/models_and_managers/models/custom_user_model.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/show_snack_bar.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:provider/provider.dart';

class AccountPageManager {
  bool didUserSignUpWithPassword(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final providerId = auth.userProviderId();
    if (providerId == 'password' || providerId == 'phone') {
      return true;
    }
    return false;
  }

  bool enableTile(CustomUser user) {
    if (user.displayName == 'Anonymous') {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> _signOut(BuildContext context) async {
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

  Future<void> _showHelpDialog(BuildContext context) async {
    await showAdaptiveActionSheet(
      context: context,
      title: Text(
        'Please kindly send a mail to:',
        style: CustomTextStyles.textStyleExtraBold(
          fontSize: 13.0,
          color: Colors.grey[700],
        ),
      ),
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: Text(
            'deymorlah@gmail.com',
            style: CustomTextStyles.textStyleBold(
              color: Colors.red,
            ),
          ),
          onPressed: null,
          leading: SvgPicture.asset(
            'images/5.svg',
            height: 50.0,
            width: 50.0,
            fit: BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    await showAdaptiveActionSheet(
      context: context,
      title: Text(
        'Are you sure you want to sign out?',
        style: CustomTextStyles.textStyleExtraBold(
          fontSize: 13.0,
          color: Colors.grey[700],
        ),
      ),
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: Text(
            'Sign Out',
            style: CustomTextStyles.textStyleBold(
              color: Colors.red,
            ),
          ),
          onPressed: () async {
            await _signOut(context);
          },
          leading: const Icon(
            Icons.logout,
            size: 25,
            color: Colors.red,
          ),
        ),
        BottomSheetAction(
          title: Text(
            'Cancel',
            style: CustomTextStyles.textStyleBold(
              color: Colors.teal[600],
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          leading: Icon(
            Icons.cancel_outlined,
            size: 25,
            color: Colors.teal[600],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    String userProviderId = auth.userProviderId();
    await showAdaptiveActionSheet(
      context: context,
      title: Text(
        'Permanently delete your account and all of your content.',
        textAlign: TextAlign.center,
        style: CustomTextStyles.textStyleExtraBold(
          fontSize: 13.0,
          color: Colors.grey[700],
        ),
      ),
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: Text(
            'Delete',
            style: CustomTextStyles.textStyleBold(
              color: Colors.red,
            ),
          ),
          onPressed: () async {
            Navigator.pop(context);
            if (userProviderId == 'facebook.com') {
              MyCustomSnackBar(
                text:
                    'Please log in again with Facebook to verify user action.',
              ).show(context);
              await Future.delayed(const Duration(seconds: 3))
                  .whenComplete(() => _delete(context));
            } else {
              _delete(context);
            }
          },
          leading: const Icon(
            Icons.delete_forever,
            size: 25,
            color: Colors.red,
          ),
        ),
        BottomSheetAction(
          title: Text(
            'Cancel',
            style: CustomTextStyles.textStyleBold(
              color: Colors.teal[600],
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          leading: Icon(
            Icons.cancel_outlined,
            size: 25,
            color: Colors.teal[600],
          ),
        ),
      ],
    );
  }

  Future<void> _showAboutDialog(BuildContext context) async {
    await showAdaptiveActionSheet(
      context: context,
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: RichText(
            text: TextSpan(
              text: 'TimeTracker Application \n',
              style: CustomTextStyles.textStyleExtraBold(
                fontSize: 15,
              ),
              children: [
                TextSpan(
                  text: 'Version 1.0.0\n',
                  style: CustomTextStyles.textStyleBold(
                    fontSize: 12.0,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: '@2021 DemoCodes',
                  style: CustomTextStyles.textStyleNormal(
                    fontSize: 12.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          onPressed: null,
          leading: const TimeTrackerLogo(
            topPadding: 0,
          ),
        ),
      ],
    );
  }

  Future<void> showSettings(BuildContext context) async {
    await showAdaptiveActionSheet(
      context: context,
      actions: <BottomSheetAction>[
        BottomSheetAction(title: const SizedBox(), onPressed: null),
        BottomSheetAction(
          title: Text(
            'Help',
            style: CustomTextStyles.textStyleBold(
              color: Colors.teal[600],
            ),
          ),
          onPressed: () async {
            Navigator.pop(context);
            await _showHelpDialog(context);
          },
          leading: Icon(
            Icons.help,
            size: 25,
            color: Colors.teal[600],
          ),
        ),
        BottomSheetAction(
          title: Text(
            'About',
            style: CustomTextStyles.textStyleBold(
              color: Colors.teal[600],
            ),
          ),
          onPressed: () async {
            Navigator.pop(context);
            await _showAboutDialog(context);
          },
          leading: Icon(
            Icons.info_outline,
            size: 25,
            color: Colors.teal[600],
          ),
        ),
        BottomSheetAction(
          title: Text(
            'Sign out',
            style: CustomTextStyles.textStyleBold(
              color: Colors.red,
            ),
          ),
          onPressed: () async {
            Navigator.pop(context);
            await _confirmSignOut(context);
          },
          leading: const Icon(
            Icons.logout,
            size: 25,
            color: Colors.red,
          ),
        ),
        BottomSheetAction(
          title: Text(
            'Delete your account',
            style: CustomTextStyles.textStyleBold(
              color: Colors.redAccent,
            ),
          ),
          onPressed: () async {
            if (didUserSignUpWithPassword(context)) {
              Navigator.pop(context);
              ResetPassword.show(context, true);
            } else {
              Navigator.pop(context);
              await _confirmDeleteAccount(context);
            }
          },
          leading: const Icon(
            Icons.delete,
            size: 25,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }

  Future<void> _delete(BuildContext context) async {
    bool result;
    final auth = Provider.of<AuthBase>(context, listen: false);
    String userProviderId = auth.userProviderId();
    switch (userProviderId) {
      case 'facebook.com':
        result = await auth.reAuthenticateFacebookUser().catchError((onError) {
          if (onError.code != "CANCELLED_BY_USER") {
            PlatformExceptionAlertDialog(
              title: 'Sign in failed',
              exception: onError,
            ).show(context);
          }
        });
        break;
      case 'google.com':
        result = await auth.reAuthenticateGoogleUser().catchError((onError) {
          PlatformExceptionAlertDialog(
            title: 'Sign in failed',
            exception: onError,
          ).show(context);
        });
        break;
    }
    if (result == true || userProviderId == 'Anonymous') {
      // After deleting account, Set the current tab back
      // to the jobsPage
      HomeAppState.currentTab = 0;
      await auth.deleteUserAccount();
    }
  }
}
