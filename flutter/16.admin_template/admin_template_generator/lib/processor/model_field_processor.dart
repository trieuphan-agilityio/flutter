import 'package:admin_template_generator/processor/processor.dart';
import 'package:admin_template_generator/value_object/model.dart';
import 'package:analyzer/dart/element/element.dart';

class ModelFieldProcessor implements Processor<ModelField> {
  final FieldElement _fieldElement;

  ModelFieldProcessor(final FieldElement classElement)
      : assert(classElement != null),
        _fieldElement = classElement;

  @override
  ModelField process() {
    final name = _fieldElement.displayName;
    return ModelField(
      _fieldElement,
      name,
      _getAnnotations(),
    );
  }

  List<ModelFieldAnnotation> _getAnnotations() {
    return _fieldElement.metadata.map((annotation) {
      // TODO find more information on this annotation metadata
      return ModelFieldAnnotation(annotation.toString());
    }).toList();
  }
}
