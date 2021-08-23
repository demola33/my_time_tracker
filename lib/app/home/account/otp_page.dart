import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time_tracker/app/home/account/Phone_page.dart';
import 'package:my_time_tracker/app/home/account/components/otp_input_box.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/true_or_false_switch.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:provider/provider.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({
    Key key,
    @required this.number,
    @required this.verificationId,
    @required this.isoCode,
    @required this.resendToken,
  }) : super(key: key);

  final String number, verificationId, isoCode;
  final int resendToken;

  static void show({
    BuildContext context,
    String number,
    String verificationId,
    String isoCode,
    int resendToken,
  }) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: false,
      builder: (
        context,
      ) =>
          OTPPage(
        number: number,
        verificationId: verificationId,
        resendToken: resendToken,
        isoCode: isoCode,
      ),
    ));
  }

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _pinPutController = TextEditingController();

  void _showVerifyNumberError(
      BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Operation failed',
      exception: exception,
    ).show(context);
  }

  void resendOTP(int resendToken, AuthBase auth) async {
    await auth.verifyUserPhoneNumber(
      context: context,
      number: widget.number,
      isoCode: widget.isoCode,
      token: resendToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst)),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.teal,
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Center(
                child: Text(
                  'Verify Your Number',
                  style: CustomTextStyles.textStyleBold(
                      fontSize: 20.0, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Enter the 6 digit code we sent to ',
                          style: CustomTextStyles.textStyleBold(
                              fontSize: 12.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.w800),
                          children: [
                            TextSpan(
                              text: widget.number,
                              style: CustomTextStyles.textStyleBold(
                                fontSize: 12.0,
                                color: Colors.teal[600],
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => PhonePage(
                            number: widget.number,
                            isoCode: widget.isoCode,
                            token: widget.resendToken,
                            editNumberCallback: true,
                          ),
                        ),
                      );
                    },
                    child: Icon(Icons.edit),
                  )
                ],
              ),
            ),
            SizedBox(height: 12),
            Consumer<TrueOrFalseSwitch>(
              builder: (_, _onSwitch, __) => Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(20.0),
                child: OTPInputBox(
                  enabled: !_onSwitch.value,
                  controller: _pinPutController,
                  onSubmit: (String pin) async {
                    _onSwitch.toggle();
                    String _otp = pin;
                    await auth
                        .phoneCredential(
                      context: context,
                      otp: _otp,
                      verificationId: widget.verificationId,
                      number: widget.number,
                      isoCode: widget.isoCode,
                    )
                        .catchError((e) {
                      _showVerifyNumberError(context, e);
                    }).then((value) {
                      _pinPutController.clear();
                      _onSwitch.toggle();
                    });
                  },
                ),
              ),
            ),
            ArgonTimerButton(
              initialTimer: 30, // Optional
              height: 40,
              width: MediaQuery.of(context).size.width * 0.45,
              minWidth: MediaQuery.of(context).size.width * 0.30,
              disabledColor: Colors.teal[600],
              borderRadius: 4.0,
              splashColor: Colors.deepOrangeAccent,
              child: Text(
                "Resend OTP",
                style: CustomTextStyles.textStyleBold(color: Colors.white),
              ),
              loader: (timeLeft) {
                return Text("Request a new code in $timeLeft seconds",
                    style: CustomTextStyles.textStyleBold());
              },
              onTap: (startTimer, btnState) {
                if (btnState == ButtonState.Idle) {
                  startTimer(20);
                  resendOTP(widget.resendToken, auth);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
