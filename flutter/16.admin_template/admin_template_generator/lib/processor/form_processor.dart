import 'package:admin_template_generator/processor/processor.dart';
import 'package:admin_template_generator/writer/form_writer.dart';
import 'package:analyzer/dart/element/element.dart';

class FormProcessor implements Processor<Form> {
  final ClassElement _classElement;

  FormProcessor(final ClassElement classElement)
      : assert(classElement != null),
        _classElement = classElement;

  @override
  Form process() {
    final name = _classElement.displayName;
    final getters = [
      ..._classElement.fields.where((e) {
        print(e.kind);
        return e.kind == ElementKind.GETTER;
      }),
    ];
    final formFields = _getFormFields(getters);
    return Form(
      _classElement,
      name,
      formFields,
    );
  }

  List<FormField> _getFormFields(final List<FieldElement> elements) {
    return elements.map((e) {
      return FormField(e, e.name, e.type);
    }).toList();
  }
}
