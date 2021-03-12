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
  final String invalidEmailErrorText = "Email can't be empty";
  final String invalidPasswordErrorText = "Password can't be empty";
  final String invalidFirstNameErrorText = "First Name can't be empty";
  final String invalidLastNameErrorText = "Last Name can't be empty";
  final String invalidConfirmPasswordErrorText = "Password do not match";
}
