import 'package:analyzer/dart/element/element.dart';

class FormField {
  final FieldElement fieldElement;
  final String name;

  FormField(this.fieldElement, this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormField &&
          runtimeType == other.runtimeType &&
          fieldElement == other.fieldElement &&
          name == other.name;

  @override
  int get hashCode => fieldElement.hashCode ^ name.hashCode;
}
