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

  test('Create form from given model', () async {
    final form = await _createForm();

    final actual = FormWriter(form).write();

    expect(
      actual,
      equalsDart(r'''
      class _$WebsiteForm extends WebsiteForm {
        _$WebsiteForm(this.model) : super._();
        
        Website model;
        
        @override
        FormBuilder get builder {
          return (
            BuildContext context, {
            bool autovalidate = false,
            WillPopCallback onWillPop,
            VoidCallback onChanged,
            ValueChanged<User> onSaved,
          }) {
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
                    autovalidate: autovalidate,
                    onWillPop: onWillPop,
                    onChanged: onChanged,
                    child: Builder(
                      builder: (BuildContext fContext) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              hostname,
                              const SizedBox(height: 24),
                              siteName,
                              const SizedBox(height: 24),
                              isDefault,
                              const SizedBox(height: 24),
                              options,
                              const SizedBox(height: 24),
                              Row(children: [
                                RaisedButton(
                                  color: Theme.of(context).buttonColor,
                                  child: Text('Save'),
                                  onPressed: () {
                                    final formState = Form.of(fContext);
                                    if (formState.validate()) {
                                      Form.of(fContext).save();
                                      onSaved(model);
                                    }
                                  },
                                ),
                                RaisedButton(
                                  child: Text('Reset'),
                                  onPressed: () {
                                    Form.of(fContext).reset();
                                  },
                                ),
                                RaisedButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    print('Cancel');
                                  },
                                ),
                              ]),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          };
        }
        
        Widget get hostname {
          return AgTextField(
            initialValue: model.hostname,
            labelText: 'Hostname',
            onSaved: (newValue) {
              model = model.rebuild((b) => b.hostname = newValue);
            },
          );
        }
        
        Widget get siteName {
          return AgTextField(
            helperText: 'Human-readable name of the site.',
            initialValue: model.siteName,
            labelText: 'Site Name',
            onSaved: (newValue) {
              model = model.rebuild((b) => b.siteName = newValue);
            },
          );
        }
        
        Widget get isDefault {
          return AgCheckboxField(
            helperText: 
                'If true, this site will handle request for all other hostnames that do not have a site entry of their own.',
            initialValue: model.isDefault,
            labelText: 'Is default site',
            onSaved: (newValue) {
              model = model.rebuild((b) => b.isDefault = newValue);
            },
          );
        }
        
        Widget get options {
          return AgCheckboxListField(
            initialValue: model.options,
            labelText: 'Site Options',
            onSaved: (newValue) {
              model = model.rebuild((b) => b.options = newValue);
            },
            choices: const [
              Option.ssl,
              Option.autoWAF,
            ],
          );
        }
      }
      '''),
    );
  });
}

Future<Form> _createForm() async {
  final library = await resolveSource(
    '''
    library test;
    
    import 'package:built_collection/built_collection.dart';
    import 'package:built_value/built_value.dart';
    import 'package:admin_template_annotation/admin_template_annotation.dart';
    
    class Website {
      @AgText()
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
      
      @AgList(
        choices: const [Option.ssl, Option.autoWAF],
        labelText: 'Site Options',
      )
      final BuiltList<Option> options;
      
      Website(this.hostname, this.siteName, this.isDefault, this.options);
    }
    
    class Option extends EnumClass {
      const Option._(String name) : super(name);
      static const Option ssl = Option._('ssl');
      static const Option autoWAF = Option._('autoWAF');
    }
    
    @AgForm(modelType: Website)
    abstract class WebsiteForm {
      factory WebsiteForm.edit(Website model) = _\$WebsiteForm(model);
    }
    ''',
    (resolver) async {
      return LibraryReader(await resolver.findLibraryByName('test'));
    },
  );

  final formClass = library.classes
      .firstWhere((classElement) => classElement.displayName == 'WebsiteForm');

  return FormProcessor(formClass).process();
}
