/// ===================================================================
/// Validators
/// ===================================================================
typedef PropertyResolver<M, P> = P Function(M);

abstract class Validator<M, P> {
  const Validator();

  String get propertyName;
  PropertyResolver<M, P> get propertyResolver;

  String validate(M model);
}

class RegExpValidator<M> implements Validator<M, String> {
  final String pattern;
  final String propertyName;
  final PropertyResolver<M, String> propertyResolver;

  RegExp get regExp => RegExp(pattern);

  const RegExpValidator(
      {this.pattern, this.propertyName, this.propertyResolver});

  @override
  String validate(M model) {
    final String value = propertyResolver(model);
    if (regExp.hasMatch(value)) return null;
    return '$regExp does not match.';
  }
}

class RequiredValidator<M> implements Validator<M, dynamic> {
  final String propertyName;
  final PropertyResolver<M, dynamic> propertyResolver;

  const RequiredValidator({this.propertyName, this.propertyResolver});

  @override
  String validate(M model) {
    final dynamic value = propertyResolver(model);
    if (value == null) return '';
    return '$propertyName is required.';
  }
}

class NameValidator<M> extends RegExpValidator<M> {
  const NameValidator({
    PropertyResolver<M, String> propertyResolver,
  }) : super(
          pattern: r'^[A-Za-z ]+$',
          propertyResolver: propertyResolver,
        );
}

class EmailValidator<M> extends RegExpValidator<M> {
  const EmailValidator({
    PropertyResolver<M, String> propertyResolver,
  }) : super(
          pattern: r'^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,7}$',
          propertyResolver: propertyResolver,
        );
}
