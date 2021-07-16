import 'package:form_field_validator/form_field_validator.dart';
import 'package:my_time_tracker/app/sign_in/components/validators.dart';

class EditJobPageManager with ErrorText {
  MultiValidator get firstNameValidator {
    final validator = MultiValidator([
      RequiredValidator(errorText: requiredJobNameError),
      JobNameValidator(errorText: jobNameError),
    ]);
    return validator;
  }

  JobRateValidator get jobRateValidator {
    return JobRateValidator(errorText: jobRateError);
  }
}
