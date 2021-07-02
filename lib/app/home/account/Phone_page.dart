import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
//import 'package:my_time_tracker/blocs/models/custom_user_model.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:provider/provider.dart';

class PhonePage extends StatefulWidget {
  //static final _formKey = GlobalKey<FormState>();

  const PhonePage({Key key, @required this.number}) : super(key: key);
  final String number;
  //final AuthBase auth;

  static void show(BuildContext context, {String phoneNumber, AuthBase auth}) {
    //final user = Provider.of<CustomUser>(context, listen: false);
    //final auth = Provider.of<AuthBase>(context, listen: false);
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => PhonePage(
        number: phoneNumber,
        //auth: auth,
      ),
    ));
  }

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  String _userNumber;
  var countryCodeController = TextEditingController(text: '+234');
  var phoneNumberController = TextEditingController();

  bool validate = false;
  FocusNode _submitButtonNode, _phoneNumberNode;

  @override
  void initState() {
    super.initState();
    _submitButtonNode = FocusNode();
    _phoneNumberNode = FocusNode();

    if (widget.number != '') {
      _userNumber = widget.number;
      validate = true;
      phoneNumberController =
          TextEditingController(text: _userNumber.substring(4));
      countryCodeController =
          TextEditingController(text: _userNumber.substring(0, 4));
      print(_userNumber);
    }
  }

  // showAlertDialog(BuildContext context) {
  //   AlertDialog alert = AlertDialog(
  //     content: Row(
  //       children: [
  //         CircularProgressIndicator(
  //           valueColor:
  //               AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
  //         ),
  //         SizedBox(width: 25),
  //         Text(
  //           'Please Wait...',
  //           style: CustomTextStyles.textStyleBold(),
  //         ),
  //       ],
  //     ),
  //   );
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
  Widget _buildRemoveNumberButton(AuthBase auth) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
      onPressed: () => _press(auth),
      child: Padding(
        padding: EdgeInsets.zero,
        child: Text("Remove number",
            style: CustomTextStyles.textStyleBold(color: Colors.redAccent)),
      ),
    );
  }

  void _press(AuthBase auth) async {
    await auth.removeUserPhone();
    Navigator.pop(context);
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_submitButtonNode);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);

    ProgressDialog progressDialog = ProgressDialog(
      context: (context),
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Please wait...',
    );

    Future<OkCancelResult> showErrorDialog({
      final String message,
    }) {
      return showOkAlertDialog(
        context: context,
        title: 'Operation Failed',
        message: message,
        barrierDismissible: false,
        alertStyle: AdaptiveStyle.adaptive,
      );
    }

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        iconTheme: IconThemeData(
          color: Colors.teal,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                          'Enter a phone number',
                          style: CustomTextStyles.textStyleBold(
                              fontSize: 20.0, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'You will receive a text message with a verification code.',
                          style: CustomTextStyles.textStyleBold(
                              fontSize: 12.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: countryCodeController,
                            enabled: false,
                            autofocus: true,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'COUNTRY',
                              labelStyle: CustomTextStyles.textStyleBold(
                                  color: Colors.teal[600]),

                              //errorText: 'Error message',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: 22,
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        focusNode: _phoneNumberNode,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: _emailEditingComplete,
                        maxLength: 10,
                        onChanged: (value) {
                          if (value.length == 10) {
                            setState(
                              () {
                                validate = true;
                              },
                            );
                          }
                          if (value.length < 10) {
                            setState(() {
                              validate = false;
                            });
                          }
                        },
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Enter your phone number',
                          hintStyle: CustomTextStyles.textStyleNormal(),
                          labelText: 'PHONE NUMBER',
                          labelStyle: CustomTextStyles.textStyleBold(
                              color: Colors.teal[600]),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  focusNode: _submitButtonNode,
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.resolveWith<double>(
                        (Set<MaterialState> states) => 10.0),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => Colors.deepOrangeAccent),
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (Set<MaterialState> states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5);
                        else if (states.contains(MaterialState.disabled))
                          return Colors.teal[600];
                        return null;
                      },
                    ),
                  ),
                  onPressed: validate
                      ? () {
                          progressDialog.show();
                          String number =
                              '${countryCodeController.text}${phoneNumberController.text}';
                          try {
                            auth.verifyUserPhoneNumber(context, number);
                          } catch (e) {
                            print('Hello Error');
                            showErrorDialog(
                              message: e.message,
                            );
                          }
                        }
                      : null,
                  child: Text('Next'),
                ),
              ),
              if (widget.number != '')
                Container(
                  padding: EdgeInsets.all(5),
                  child: _buildRemoveNumberButton(auth),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
