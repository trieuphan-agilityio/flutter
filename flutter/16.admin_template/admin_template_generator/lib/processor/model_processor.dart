import 'package:admin_template_generator/processor/model_field_processor.dart';
import 'package:admin_template_generator/processor/processor.dart';
import 'package:admin_template_generator/value_object/model.dart';
import 'package:analyzer/dart/element/element.dart';

class ModelProcessor implements Processor<Model> {
  final ClassElement _classElement;

  ModelProcessor(final ClassElement classElement)
      : assert(classElement != null),
        _classElement = classElement;

  @override
  Model process() {
    final name = _classElement.displayName;
    return Model(
      _classElement,
      name,
      _getModelFields(),
    );
  }

  List<ModelField> _getModelFields() {
    return _classElement.fields
        .map((fieldElement) => ModelFieldProcessor(fieldElement).process())
        .toList();
  }
}
