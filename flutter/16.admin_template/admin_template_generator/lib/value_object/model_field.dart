import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:equatable/equatable.dart';

/// ModelField contains metadata about a form field.
class ModelField extends Equatable {
  final FieldElement fieldElement;
  final String name;

  /// Annotation that indicates the type of form field.
  final DartObject formFieldAnnotation;

  final List<FieldAttribute> attributes;

  ModelField(
    this.fieldElement,
    this.name, {
    this.attributes = const [],
    this.formFieldAnnotation,
  });

  @override
  List<Object> get props => [fieldElement, name, attributes];

  @override
  String toString() {
    return 'ModelField{fieldElement: $fieldElement, name: $name, attributes: $attributes}';
  }
}

class FieldAttribute<T> extends Equatable {
  final String name;
  final T value;

  const FieldAttribute(this.name, this.value);

  @override
  List<Object> get props => [name, value];

  @override
  String toString() {
    return 'FieldAttribute{name: $name, value: $value}';
  }
}

class ModelFieldAnnotation extends Equatable {
  final String name;

  ModelFieldAnnotation(this.name);

  @override
  List<Object> get props => [name];
}
