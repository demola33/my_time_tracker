abstract class StringValidator {
  bool isValid(String value);
}

abstract class IntValidator {
  bool isValid(int value);
}

class NonEmptyIntegerValidator implements IntValidator {
  @override
  bool isValid(int value) {
    return value.isNaN;
  }
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
  final String invalidEmailErrorText = "Email can't be empty";
  final String invalidPasswordErrorText = "Password can't be empty";
  final String invalidFirstNameErrorText = "First Name can't be empty";
  final String invalidLastNameErrorText = "Last Name can't be empty";
  final String invalidConfirmPasswordErrorText = "Password do not match";
}

class TextFieldValidator {
  final StringValidator jobNameValidator = NonEmptyStringValidator();
  final IntValidator jobRateValidator = NonEmptyIntegerValidator();
  final String invalidEmailErrorText = "Job name can't be empty";
  final String invalidPasswordErrorText = "Job rate can't be empty";
}
