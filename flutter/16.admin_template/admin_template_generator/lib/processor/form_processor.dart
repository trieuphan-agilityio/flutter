import 'package:admin_template_annotation/admin_template_annotation.dart';
import 'package:admin_template_generator/misc/type_utils.dart';
import 'package:admin_template_generator/processor/model_processor.dart';
import 'package:admin_template_generator/processor/processor.dart';
import 'package:admin_template_generator/value_object/form.dart';
import 'package:analyzer/dart/element/element.dart';

class FormProcessor implements Processor<Form> {
  final ClassElement _classElement;

  FormProcessor(final ClassElement classElement)
      : assert(classElement != null),
        _classElement = classElement;

  @override
  Form process() {
    final name = _classElement.displayName;
    final formAnnotation = _classElement.getAnnotation(AgForm);
    final modelElement = formAnnotation
        .getField('modelType')
        .toTypeValue()
        .element as ClassElement;

    return Form(
      _classElement,
      name,
      ModelProcessor(modelElement).process(),
    );
  }
}
