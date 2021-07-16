import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time_tracker/app/home/account/Phone_page.dart';
import 'package:my_time_tracker/app/home/account/components/otp_input_box.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:provider/provider.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({
    Key key,
    @required this.number,
    @required this.verificationId,
    @required this.isoCode,
  }) : super(key: key);

  final String number, verificationId, isoCode;
  static void show({
    BuildContext context,
    String number,
    String verificationId,
    String isoCode,
  }) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (
        context,
      ) =>
          OTPPage(
        number: number,
        verificationId: verificationId,
        isoCode: isoCode,
      ),
    ));
  }

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  bool isLoading = true;
  final TextEditingController _pinPutController = TextEditingController();

  void _showVerifyNumberError(
      BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Operation failed',
      exception: exception,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst)
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     fullscreenDialog: true,
            //     builder: (context) => PhonePage(),
            //   ),
            // ),
            ),
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
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => PhonePage(
                            number: widget.number,
                            isoCode: widget.isoCode,
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
            Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(20.0),
              child: OTPInputBox(
                isLoading: isLoading,
                controller: _pinPutController,
                onSubmit: (String pin) {
                  setState(() {
                    isLoading = false;
                    String _otp = pin;
                    try {
                      auth.phoneCredential(
                        context: context,
                        otp: _otp,
                        verificationId: widget.verificationId,
                        number: widget.number,
                        isoCode: widget.isoCode,
                      );
                    } on PlatformException catch (e) {
                      _showVerifyNumberError(context, e);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
