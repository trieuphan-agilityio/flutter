abstract class Validator<T> {
  final String property;
  final String error;

  Validator(this.property, this.error);

  bool validate(T value);
}

class RequiredValidator extends Validator<dynamic> {
  RequiredValidator(String property)
      : super(property, '${property} is not valid');

  @override
  bool validate(dynamic value) {
    return value != null;
  }
}
