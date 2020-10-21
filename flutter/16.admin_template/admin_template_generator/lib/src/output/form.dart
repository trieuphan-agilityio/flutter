import 'package:admin_template_core/core.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';

import 'form_field.dart';

const kCallSuper = Code('super(key: key)');
const kFlutterBuildContext = Reference('BuildContext');
const kFlutterColumn = Reference('Column');
const kFlutterContainer = Reference('Container');
const kFlutterKey = Reference('Key');
const kFlutterStatefulWidget = Reference('StatefulWidget');
const kFlutterWidget = Reference('Widget');
const kOverride = Reference('override');

class Form {
  final String name;
  final String modelType;
  final Iterable<FormField> fields;

  Form(this.name, this.modelType, this.fields);

  Spec toSpec() {
    return Library((b) => b
      ..body.addAll([
        _buildStatefulWidgetSpec(),
        _buildStateSpec(),
        _buildTmpReference(),
      ]));
  }

  Spec _buildStatefulWidgetSpec() {
    final initialModelField = Field((b) => b
      ..modifier = FieldModifier.final$
      ..type = refer(modelType)
      ..name = 'initialModel');

    final callbackFields = [
      Field((b) => b
        ..modifier = FieldModifier.final$
        ..type = refer('WillPopCallback')
        ..name = 'onWillPop'),
      Field((b) => b
        ..modifier = FieldModifier.final$
        ..type = refer('VoidCallback')
        ..name = 'onChanged'),
      Field((b) => b
        ..modifier = FieldModifier.final$
        ..type = refer('ValueChanged')
        ..name = 'onSaved'),
    ];

    return Class((b) => b
      ..name = name
      ..extend = kFlutterStatefulWidget
      ..fields.addAll([
        initialModelField,
        ...callbackFields,
        ...fields.map((f) => Field((b) => b
          ..modifier = FieldModifier.final$
          ..type = kFlutterWidget
          ..name = f.name)),
      ])
      ..constructors.add(_buildConstructor())
      ..methods.add(_buildCreateStateMethod()));
  }

  Constructor _buildConstructor() {
    final keyParam = Parameter((b) => b
      ..type = kFlutterKey
      ..name = 'key'
      ..named = true);

    final initialModelParam = Parameter((b) => b
      ..name = 'initialModel'
      ..toThis = true
      ..named = true);

    final callbackParams = [
      Parameter((b) => b
        ..name = 'onWillPop'
        ..toThis = true
        ..named = true),
      Parameter((b) => b
        ..name = 'onChanged'
        ..toThis = true
        ..named = true),
      Parameter((b) => b
        ..name = 'onSaved'
        ..toThis = true
        ..named = true),
    ];

    return Constructor((b) => b
      ..constant = true
      ..optionalParameters = ListBuilder<Parameter>([
        keyParam,
        initialModelParam,
        ...callbackParams,
        ...fields.map((f) => Parameter((b) => b
          ..name = f.name
          ..toThis = true
          ..named = true))
      ])
      ..initializers.add(kCallSuper));
  }

  Method _buildCreateStateMethod() {
    return Method((b) => b
      ..annotations.add(kOverride)
      ..name = 'createState'
      ..returns = refer('_$name')
      ..body = refer('_$name').call([]).code);
  }

  Spec _buildStateSpec() {
    return Class((b) => b
      ..name = '_$name'
      ..extend = refer('State<$name>')
      ..fields.add(Field((b) => b
        ..type = refer(modelType)
        ..name = 'model'))
      ..methods = ListBuilder([
        _buildInitStateMethod(),
        _buildFlutterBuildMethod(),
        ...fields
            .map((f) => Method((b) => b
              ..returns = kFlutterWidget
              ..name = '_build${f.name.toPascalCase()}'
              ..body = f.toWidgetExpression().returned.statement))
            .toList(),
      ]));
  }

  Method _buildInitStateMethod() {
    return Method((b) => b
      ..name = 'initState'
      ..annotations.add(kOverride)
      ..returns = refer('void')
      ..body = Block.of([
        refer('model')
            .assign(refer('widget').property('initialModel'))
            .statement,
        refer('super').property('initState').call([]).statement,
      ]));
  }

  Method _buildFlutterBuildMethod() {
    final loadFormFieldWidgets = fields
        .map((f) => 'widget.${f.name} ?? _build${f.name.toPascalCase()}()')
        .join(',');

    return Method((b) => b
      ..name = 'build'
      ..annotations.add(kOverride)
      ..returns = kFlutterWidget
      ..requiredParameters.add(Parameter((b) => b
        ..type = kFlutterBuildContext
        ..name = 'context'))
      ..body = Code('''
return Shortcuts(
  shortcuts: <LogicalKeySet, Intent>{
    // Pressing enter on the field will now move to the next field.
    LogicalKeySet(LogicalKeyboardKey.enter): NextFocusIntent(),
  },
  child: FocusTraversalGroup(
    child: Form(
      onWillPop: widget.onWillPop,
      onChanged: widget.onChanged,
      child: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                $loadFormFieldWidgets,
              ],
            ),
          );
        }
      ),
    ),
  ),
);
      '''));
  }

  Spec _buildTmpReference() {
    return Code('''// ignore: unused_element
    final _tmp = ${name.replaceAll("\$", "")}();''');
  }
}
