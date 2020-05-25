import 'package:analyzer/dart/element/element.dart';
import 'package:equatable/equatable.dart';

import 'model_field.dart';

class Model extends Equatable {
  final ClassElement classElement;
  final String name;
  final List<ModelField> fields;

  Model(this.classElement, this.name, this.fields);

  @override
  List<Object> get props => [classElement, name, fields];

  @override
  String toString() {
    return 'Model{classElement: $classElement, name: $name, fields: $fields}';
  }
}
