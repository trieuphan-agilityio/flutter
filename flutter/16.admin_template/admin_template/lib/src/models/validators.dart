typedef PropertyResolver<M, P> = P Function(M);
//
//abstract class Validator<T> {
//  Map<String, String> validate(T object, String propertyName);
//}
//
//mixin CompositeValidator<T> implements Validator<T> {
//  Map<String, Validator> get validators;
//
//  Map<String, String> validate(T object, String propertyName) {
//    return validators.map((key, value) {
//      return MapEntry(key, value.validate(object, key)[key]);
//    });
//  }
//}
//
//class EmailValidator implements Validator<String> {
//  @override
//  Map<String, String> validate(String email, String propertyName) {
//    return {propertyName: '$email is not valid'};
//  }
//
//  const EmailValidator();
//}

abstract class Validator<M, P> {
  const Validator();

  PropertyResolver<M, P> get propertyResolver;

  String validate(M model);
}

class RegExpValidator<M> implements Validator<M, String> {
  final PropertyResolver<M, String> _propertyResolver;
  final String pattern;

  RegExp get regExp => RegExp(pattern);

  const RegExpValidator({
    this.pattern,
    PropertyResolver<M, String> propertyResolver,
  }) : _propertyResolver = propertyResolver;

  @override
  PropertyResolver<M, String> get propertyResolver => _propertyResolver;

  @override
  String validate(M model) {
    final String value = propertyResolver(model);
    if (regExp.hasMatch(value)) return '$regExp does not match.';
    return null;
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
