import 'package:admin_template_generator/processor/form_processor.dart';
import 'package:admin_template_generator/value_object/form.dart';
import 'package:admin_template_generator/writer/form_writer.dart';
import 'package:build_test/build_test.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

void main() {
  useDartfmt();

  test('create form from given model', () async {
    final form = await _createForm();

    final actual = FormWriter(form).write();

    expect(actual, equalsDart(r'''
      class _$WebsiteForm extends WebsiteForm {
        _$WebsiteForm(this.model) : super._();
        
        final Website model;
        
        @override
        Widget Function(BuildContext) get builder {
          return (BuildContext context) {
            return Container(
              alignment: Alignment.topLeft,
              width: 800,
              child: Shortcuts(
                shortcuts: <LogicalKeySet, Intent>{
                  // Pressing enter on the field will now move to the next field.
                  LogicalKeySet(LogicalKeyboardKey.enter): NextFocusIntent(),
                },
                child: FocusTraversalGroup(
                  child: Form(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          hostname,
                          const SizedBox(height: 24),
                          siteName,
                          const SizedBox(height: 24),
                          isDefault,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          };
        }
        
        @override
        FormField<String> get hostname {
          return AgTextField(
            labelText: 'hostname',
            onSaved: (newValue) {
              model.rebuild((b) => b.hostname = newValue);
            },
            validator: (value) {
              final validator = NameValidator<Website>(propertyResolver: (m) {
                return m.hostname;
              });
              return validator.validate(model);
            },
          );
        }
        
        @override
        FormField<String> get siteName {
          return AgTextField(
            labelText: 'siteName',
            onSaved: (newValue) {
              model.rebuild((b) => b.siteName = newValue);
            },
            validator: (value) {
              final validator = NameValidator<Website>(propertyResolver: (m) {
                return m.siteName;
              });
              return validator.validate(model);
            },
          );
        }
        
        @override
        FormField<bool> get isDefault {
          return AgCheckboxField(
            labelText: 'Is default site',
            helperText: 
                'If true, this site will handle request for all other hostnames that do not have a site entry of their own.',
            onSaved: (newValue) {
              model.rebuild((b) => b.isDefault = newValue);
            },
          );
        }
      }
      '''));
  });
}

Future<Form> _createForm() async {
  final library = await resolveSource('''
      library test;
      
      import 'package:admin_template_annotation/admin_template_annotation.dart';
      
      class Website {
        @AgText(required: true)
        final String hostname;
        
        @AgText(
          helperText: 'Human-readable name of the site.',
        )
        final String siteName;
        
        @AgBool(
          helperText: 'If true, this site will handle request for all other'
            ' hostnames that do not have a site entry of their own.',
          labelText: 'Is default site',
        )
        final bool isDefault;
        
        Website(this.hostname, this.siteName, isDefault);
      }
      
      @AgForm(modelType: Website)
      abstract class WebsiteForm {
        factory WebsiteForm.edit(Website model) = _\$WebsiteForm(model);
      }
      ''', (resolver) async {
    return LibraryReader(await resolver.findLibraryByName('test'));
  });

  final formClass = library.classes
      .firstWhere((classElement) => classElement.displayName == 'WebsiteForm');

  return FormProcessor(formClass).process();
}
