import 'package:analyzer/dart/element/element.dart';

class Model {
  final ClassElement classElement;
  final String name;
  final List<ModelField> fields;

  Model(this.classElement, this.name, this.fields);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Model &&
          runtimeType == other.runtimeType &&
          classElement == other.classElement &&
          name == other.name &&
          fields == other.fields;

  @override
  int get hashCode => classElement.hashCode ^ name.hashCode ^ fields.hashCode;
}

/// ModelField contains metadata about a form field.
class ModelField {
  final FieldElement fieldElement;
  final String name;
  final List<ModelFieldAnnotation> annotations;

  ModelField(this.fieldElement, this.name, this.annotations);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelField &&
          runtimeType == other.runtimeType &&
          fieldElement == other.fieldElement &&
          name == other.name &&
          annotations == other.annotations;

  @override
  int get hashCode =>
      fieldElement.hashCode ^ name.hashCode ^ annotations.hashCode;
}

class ModelFieldAnnotation {
  final String name;

  ModelFieldAnnotation(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelFieldAnnotation &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
