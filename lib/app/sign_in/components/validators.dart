import 'package:form_field_validator/form_field_validator.dart';

class ErrorText {
  final String invalidEmailError = "Enter a valid email address";
  final String requiredPasswordError = "Password is required";
  final String requiredEmailError = "Email is required";
  final String passwordPatternError =
      "Passwords must have at least one special character";
  final String firstNameError = "Enter a valid first name";
  final String jobNameError = "Enter a valid job name";
  final String requiredJobNameError = "Job Name is required";
  final String jobRateError = "Enter a valid job Rate";
  final String lastNameError = "Enter a valid last name";
  final String passwordMatchError = "Passwords do not match";
  final String minLengthError = 'Password must be at least 8 digits long';
}

class NameValidator extends TextFieldValidator {
  // pass the error text to the super constructor
  NameValidator({String errorText = 'enter a valid text'}) : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String value) {
    // return true if the value is valid according the your condition
    return hasMatch(r'^[A-Za-z]+$', value);
  }
}

class JobNameValidator extends TextFieldValidator {
  // pass the error text to the super constructor
  JobNameValidator({String errorText = 'enter a valid text'})
      : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String value) {
    // return true if the value is valid according the your condition
    return hasMatch(r'^[A-Za-z/-\s]+$', value);
  }
}

class JobRateValidator extends TextFieldValidator {
  // pass the error text to the super constructor
  JobRateValidator({String errorText = 'enter a valid text'})
      : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String value) {
    // return true if the value is valid according the your condition
    return hasMatch(r'^[0-9]+$', value);
  }
}

class CommentValidator extends TextFieldValidator {
  // pass the error text to the super constructor
  CommentValidator({String errorText = 'Please enter a valid comment'})
      : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String value) {
    // return true if the value is valid according the your condition
    return hasMatch(r"^[A-Za-z-$%.&!',\s]+$", value);
  }
}
