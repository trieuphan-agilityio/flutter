import 'package:admin_template_annotation/admin_template_annotation.dart';
import 'package:admin_template_generator/processor/processor.dart';
import 'package:admin_template_generator/value_object/model.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

class ModelFieldProcessor implements Processor<ModelField> {
  final FieldElement fieldElement;
  final ModelFieldAnnotation formFieldAnnotation;

  ModelFieldProcessor(
    this.fieldElement,
    this.formFieldAnnotation,
  )   : assert(fieldElement != null),
        assert(formFieldAnnotation != null);

  @override
  ModelField process() {
    final name = fieldElement.displayName;
    return ModelField(
      fieldElement,
      name,
      const [],
      formFieldAnnotation: formFieldAnnotation,
    );
  }
}
