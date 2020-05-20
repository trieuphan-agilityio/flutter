import 'package:analyzer/dart/element/element.dart';

import 'model.dart';

class Form {
  final ClassElement classElement;
  final String name;

  /// The model class of this form. This property is settle by using annotation
  /// @AgForm(modelType: Foo)
  final Model model;

  Form(this.classElement, this.name, this.model);
}
