import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';

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

  /// Annotation that indicates the type of form field.
  final ModelFieldAnnotation formFieldAnnotation;

  final List<ModelFieldAnnotation> annotations;

  ModelField(
    this.fieldElement,
    this.name,
    this.annotations, {
    this.formFieldAnnotation,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ModelField &&
            runtimeType == other.runtimeType &&
            fieldElement == other.fieldElement &&
            name == other.name &&
            formFieldAnnotation == other.formFieldAnnotation &&
            const ListEquality<ModelFieldAnnotation>()
                .equals(annotations, other.annotations);
  }

  @override
  int get hashCode =>
      fieldElement.hashCode ^
      name.hashCode ^
      formFieldAnnotation.hashCode ^
      annotations.hashCode;

  @override
  String toString() {
    return 'ModelField{fieldElement: $fieldElement, name: $name, formFieldAnnotation: $formFieldAnnotation, annotations: $annotations}';
  }
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

  @override
  String toString() {
    return 'ModelFieldAnnotation{name: $name}';
  }
}
