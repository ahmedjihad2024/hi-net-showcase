import 'package:hi_net/app/phone_number_validator.dart';
import 'package:hi_net/presentation/common/utils/fast_function.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';

abstract class ValidatorMediator {
  void addValidator(Validator validator);

  void validate(
    void Function(String msg, Validator validator) onInvalid,
    void Function() onDone,
  );
}

abstract class Validator {
  String? _text;
  String get errorMessage;
  String? get text => _text;
  set text(String value) => _text = value;
  final ValidatorMediator validatorMediator;

  Validator(this.validatorMediator);

  bool validate();

  @override
  String toString() => runtimeType.toString();
}

class FieldsValidator implements ValidatorMediator {
  final List<Validator> validators = [];

  @override
  void addValidator(Validator validator) => validators.add(validator);

  @override
  void validate(
    void Function(String msg, Validator validator) onInvalid, [
    void Function()? onDone,
  ]) {
    for (var validator in validators) {
      if (!validator.validate()) {
        onInvalid(validator.errorMessage, validator);
        return;
      }
    }
    onDone?.call();
  }
}

// Check if the full name is empty
class EmptyFullNameValidator extends Validator {
  EmptyFullNameValidator(super.validatorMediator) {
    validatorMediator.addValidator(this);
  }

  @override
  String get errorMessage => "";

  @override
  bool validate() => text != null && text!.isNotEmpty;
}


// Check if the phone number is empty
class EmptyPhoneValidator extends Validator {
  EmptyPhoneValidator(super.validatorMediator) {
    validatorMediator.addValidator(this);
  }

  @override
  String get errorMessage => "";

  @override
  bool validate() => text != null && text!.isNotEmpty;
}

// Check if the phone number is invalid
class InvalidPhoneValidator extends Validator {
  InvalidPhoneValidator(super.validatorMediator) {
    validatorMediator.addValidator(this);
  }

  @override
  String get errorMessage => Translation.error_invalid_number.tr;

  String countryCode = "";

  @override
  bool validate() {
    return CountryUtils.validateFullPhoneNumber(countryCode, text!).isValid;
  }
}

class InvalidEmailValidator extends Validator {
  InvalidEmailValidator(super.validatorMediator) {
    validatorMediator.addValidator(this);
  }

  @override
  String get errorMessage => Translation.error_invalid_email.tr;

  @override
  bool validate() {
    if(text != null && text!.trim().isEmpty) return true;
    return isValidEmail(text!);
  }
}

class SmallFullNameValidator extends Validator {
  SmallFullNameValidator(super.validatorMediator) {
    validatorMediator.addValidator(this);
  }

  @override
  String get errorMessage => Translation.name_small.tr;

  @override
  bool validate() => text != null && text!.length > 3;
}

// Check if the phone number is valid
class PhoneValidator extends Validator {
  late EmptyPhoneValidator emptyPhoneValidator;
  late InvalidPhoneValidator invalidPhoneValidator;

  PhoneValidator(super.validatorMediator) {
    validatorMediator.addValidator(this);
    emptyPhoneValidator = EmptyPhoneValidator(validatorMediator);
    invalidPhoneValidator = InvalidPhoneValidator(validatorMediator);
  }

  @override
  String get errorMessage => "";

  @override
  set text(String value) {
    super.text = value;
    invalidPhoneValidator.text = value;
  }

  set emptyText(String value) {
    emptyPhoneValidator.text = value;
  }

  set countryCode(String value) {
    invalidPhoneValidator.countryCode = value;
  }

  @override
  bool validate() => true;
}
