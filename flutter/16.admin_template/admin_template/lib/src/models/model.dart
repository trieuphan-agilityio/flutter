abstract class Model<T> {
  /// Model instance of this wrapper
  final T model;

  Model({this.model});

  /// List of business rules
  List<BusinessRule> rules;
}
//
//typedef Validator<T> = bool Function(T value);
//
//class Validators {
//  static Validator<dynamic> required = Required();
//}

abstract class BusinessRule<T> {
  const BusinessRule();
}
