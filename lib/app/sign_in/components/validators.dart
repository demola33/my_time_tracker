abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidator {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final StringValidator confirmPasswordValidator = NonEmptyStringValidator();
  final StringValidator firstNameValidator = NonEmptyStringValidator();
  final StringValidator lastNameValidator = NonEmptyStringValidator();
  final StringValidator firstNamevalidator1 = NameValidator();
  final String invalidEmailErrorText = "Email can't be empty";
  final String invalidPasswordErrorText = "Password can't be empty";
  final String invalidFirstNameErrorText = "First Name can't be empty";
  final String invalidFirstNameErrorText1 =
      'Please enter only alphabetical characters.';
  final String invalidLastNameErrorText = "Last Name can't be empty";
  final String invalidConfirmPasswordErrorText = "Password do not match";
}

class TextFieldValidator {
  final StringValidator jobNameValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = "Job name can't be empty";
  final String invalidPasswordErrorText = "Job rate can't be empty";
}

class NameValidator implements StringValidator {
  @override
  bool isValid(String value) {
    if (value.isEmpty) {
      return false;
    }
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return false;
    }
    return true;
  }
}


