import 'package:admin_template_annotation/admin_template_annotation.dart';
import 'package:admin_template_generator/processor/model_field_processor.dart';
import 'package:admin_template_generator/processor/processor.dart';
import 'package:admin_template_generator/value_object/model.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

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

  /// Get form fields from model by filtering with Form Annotation
  List<ModelField> _getModelFields() {
    final fields = _classElement.fields.where((e) {
      return TypeChecker.fromRuntime(AgBase).hasAnnotationOf(e) ||
          TypeChecker.fromRuntime(AgBase).hasAnnotationOf(e.getter);
    }).map((e) {
      // allow set annotation on getter
      DartObject annotation =
          TypeChecker.fromRuntime(AgBase).firstAnnotationOf(e) ??
              TypeChecker.fromRuntime(AgBase).firstAnnotationOf(e.getter);

      return ModelFieldProcessor(
        e,
        ModelFieldAnnotation(annotation.type.getDisplayString()),
      ).process();
    }).toList();
    return fields;
  }
}
