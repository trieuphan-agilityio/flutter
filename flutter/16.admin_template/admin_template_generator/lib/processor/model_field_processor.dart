import 'package:admin_template_annotation/annotations.dart';
import 'package:admin_template_generator/processor/processor.dart';
import 'package:admin_template_generator/value_object/model.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

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
    final hasAnnotation =
        TypeChecker.fromRuntime(AgBase).hasAnnotationOf(_fieldElement);
    if (hasAnnotation) {
      final annotations =
          TypeChecker.fromRuntime(AgBase).annotationsOf(_fieldElement);
      return annotations.map((a) {
        return ModelFieldAnnotation(a.type.getDisplayString());
      }).toList();
    }
    return List(0);
  }
}
