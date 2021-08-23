import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:country_codes/country_codes.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/form_submit_button.dart';
import 'package:my_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:my_time_tracker/services/auth_base.dart';

class PhonePage extends StatefulWidget {
  const PhonePage(
      {Key key,
      @required this.number,
      @required this.isoCode,
      @required this.editNumberCallback,
      this.token})
      : super(key: key);
  final String number;
  final String isoCode;
  final int token;
  final bool editNumberCallback;

  static void show({
    @required BuildContext context,
    @required String phone,
    @required String isoCode,
    int token,
    @required bool editNumberCallback,


  }) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => PhonePage(
          number: phone,
          isoCode: isoCode,
          token: token,
          editNumberCallback: editNumberCallback,
        ),
      ),
    );
  }

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  bool get editNumberCallback => widget.editNumberCallback;
  PhoneNumber _number;
  bool validate = false;
  FocusNode _submitButtonNode;

  @override
  void initState() {
    super.initState();
    _submitButtonNode = FocusNode();
    Locale local = CountryCodes.getDeviceLocale();
    String isoCode = local.countryCode;

    PhoneNumber phoneNumber =
        PhoneNumber(isoCode: widget.isoCode == '' ? isoCode : widget.isoCode);
    _number = phoneNumber;

    if (widget.number != '') {
      PhoneNumber phoneNumber =
          PhoneNumber(isoCode: widget.isoCode, phoneNumber: widget.number);
      _number = phoneNumber;
      validate = true;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _buildRemoveNumberButton() {
    return TextButton(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
      onPressed: () => _confirmRemoveNumber(context),
      child: Padding(
        padding: EdgeInsets.zero,
        child: Text("Remove number",
            style: CustomTextStyles.textStyleBold(color: Colors.redAccent)),
      ),
    );
  }

  Future<void> _confirmRemoveNumber(BuildContext context) async {
    final didRequestRemove = await PlatformAlertDialog(
      title: 'Remove Number',
      content: 'Are you sure you want to remove ${widget.number} ?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Remove',
    ).show(context);
    if (didRequestRemove == true) {
      _press();
    }
  }

  void _press() async {
    FocusScope.of(context).requestFocus(FocusNode());
    bool error = false;
    final auth = Provider.of<AuthBase>(context, listen: false);
    await auth.removeUserPhone().catchError((e) {
      error = true;
      _showRemovePhoneNumberError(context, e);
    }).whenComplete(() {
      if (!error) {
        Navigator.pop(context);
      }
    });
  }

  void _phoneNumberEditingComplete() {
    FocusScope.of(context).requestFocus(_submitButtonNode);
  }

  void _showRemovePhoneNumberError(
      BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Operation failed',
      exception: exception,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => key.currentState.maybePop(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.clear_sharp),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              await Future.delayed(Duration(milliseconds: 100)).then((value) =>
                  Navigator.of(context).popUntil((route) => route.isFirst));
            },
          ),
          iconTheme: IconThemeData(
            color: Colors.teal,
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                              widget.number == ''
                                  ? 'Enter a phone number'
                                  : 'Update your phone number',
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
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {},
                    inputDecoration: InputDecoration(
                      isDense: true,
                      hintText: 'Enter your phone number',
                      hintStyle: CustomTextStyles.textStyleNormal(),
                      labelText: 'PHONE NUMBER',
                      labelStyle:
                          CustomTextStyles.textStyleBold(color: Colors.teal[600]),
                      border: OutlineInputBorder(),
                    ),
                    autoFocus: true,
                    onInputValidated: (bool value) {
                      if (value == true) {
                        setState(() {
                          validate = value;
                        });
                      } else {
                        setState(() {
                          validate = value;
                        });
                      }
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    initialValue: _number,
                    textFieldController: controller,
                    formatInput: true,
                    keyboardAction: TextInputAction.next,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    onSaved: (PhoneNumber number) {
                      _number = number;
                    },
                    onSubmit: _phoneNumberEditingComplete,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: FormSubmitButton(
                      onPressed: validate ? _submit : null,
                      text: 'Next',
                      focusNode: _submitButtonNode,
                    ),
                  ),
                  if (widget.number != '' && editNumberCallback == false)
                    Container(
                      padding: EdgeInsets.all(5),
                      child: _buildRemoveNumberButton(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  void _navigateAndVerifyNumber() async {

    ProgressDialog progressDialog = ProgressDialog(
      context: (context),
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Please wait...',
    );

    final auth = Provider.of<AuthBase>(context, listen: false);
    progressDialog.show();
    await auth.verifyUserPhoneNumber(
      context: context,
      number: _number.phoneNumber,
      isoCode: _number.isoCode,
      token: widget.token,
    );

  }

  void _submit() {
    if (_validateAndSaveForm()) {
      _navigateAndVerifyNumber();
    }
  }
}
