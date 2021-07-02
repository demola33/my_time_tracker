import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time_tracker/app/home/account/Phone_page.dart';
import 'package:my_time_tracker/common_widgets/custom_text_field.dart';
//import 'package:my_time_tracker/app/home/account/Phone_page.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:provider/provider.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({
    Key key,
    @required this.number,
    @required this.verificationId,
  }) : super(key: key);

  final String number, verificationId;
  static void show(BuildContext context, String number, String verificationId) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (
        context,
      ) =>
          OTPPage(number: number, verificationId: verificationId),
    ));
  }

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  bool isLoading = true;

  var _text1 = TextEditingController();
  var _text2 = TextEditingController();
  var _text3 = TextEditingController();
  var _text4 = TextEditingController();
  var _text5 = TextEditingController();
  var _text6 = TextEditingController();

  void _showVerifyNumberError(
      BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Operation failed',
      exception: exception,
    ).show(context);
  }

  Widget _buildOTPField({
    @required TextEditingController controller,
    @required void Function(String) onChanged,
    FocusNode focusNode,
  }) {
    return Expanded(
      child: CustomTextField(
        labelText: '',
        enabled: isLoading,
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
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
              padding: EdgeInsets.all(20.0),
              child: Column(
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
                    //padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) =>
                                    PhonePage(number: widget.number),
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
                    child: Row(
                      children: [
                        _buildOTPField(
                          controller: _text1,
                          onChanged: (value) {
                            if (value.length == 1) {
                              node.nextFocus();
                            }
                          },
                        ),
                        SizedBox(width: 10),
                        _buildOTPField(
                          controller: _text2,
                          onChanged: (value) {
                            if (value.length == 1) {
                              node.nextFocus();
                            }
                          },
                        ),
                        SizedBox(width: 10),
                        _buildOTPField(
                          controller: _text3,
                          onChanged: (value) {
                            if (value.length == 1) {
                              node.nextFocus();
                            }
                          },
                        ),
                        SizedBox(width: 10),
                        _buildOTPField(
                          controller: _text4,
                          onChanged: (value) {
                            if (value.length == 1) {
                              node.nextFocus();
                            }
                          },
                        ),
                        SizedBox(width: 10),
                        _buildOTPField(
                          controller: _text5,
                          onChanged: (value) {
                            if (value.length == 1) {
                              node.nextFocus();
                            }
                          },
                        ),
                        SizedBox(width: 10),
                        _buildOTPField(
                          controller: _text6,
                          onChanged: (value) {
                            if (value.length == 1) {
                              if (_text1.text.length == 1) {
                                if (_text2.text.length == 1) {
                                  if (_text3.text.length == 1) {
                                    if (_text4.text.length == 1) {
                                      if (_text5.text.length == 1) {
                                        if (_text6.text.length == 1) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          String _otp =
                                              '${_text1.text}${_text2.text}${_text3.text}${_text4.text}${_text5.text}${_text6.text}';
                                          try {
                                            auth.phoneCredential(
                                              context: context,
                                              otp: _otp,
                                              verificationId:
                                                  widget.verificationId,
                                              number: widget.number,
                                            );
                                          } on PlatformException catch (e) {
                                            _showVerifyNumberError(context, e);
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
