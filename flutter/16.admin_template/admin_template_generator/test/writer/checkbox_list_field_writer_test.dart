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

  test('Initialise form with @AgList', () async {
    final form = await _createForm();

    final actual = FormWriter(form).write();
    expect(
      actual,
      equalsDart(r'''
      class _$UserForm extends UserForm {
        _$UserForm(this.model) : super._();
        
        User model;
        
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
                              groups,
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
      
        Widget get groups {
          return AgCheckboxListField(
            initialValue: model.groups,
            onSaved: (newValue) {
              model = model.rebuild((b) => b.groups = newValue);
            },
            labelText: 'Groups',
            choices: const [
              Group.staff,
              Group.admin,
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
    
    class User {
      @AgList(choices: const [Group.staff, Group.admin])
      final BuiltList<Group> groups;
      
      User(this.groups);
    }
    
    class Group extends EnumClass {
      const Group._(String name) : super(name);
      static const Group staff = Group._('staff');
      static const Group admin = Group._('admin');
    }
    
    @AgForm(modelType: User)
    abstract class UserForm {
      factory UserForm.edit(User model) = _\$UserForm(model);
    }
    ''',
    (resolver) async {
      return LibraryReader(await resolver.findLibraryByName('test'));
    },
  );

  final formClass = library.classes
      .firstWhere((classElement) => classElement.displayName == 'UserForm');

  return FormProcessor(formClass).process();
}
