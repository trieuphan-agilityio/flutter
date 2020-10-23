// import 'package:code_builder/code_builder.dart';
// import 'package:test/test.dart';

// import 'util.dart';

// main() {
//   useDartfmt();

//   group('Text field', () {
//     test('has default attributes', () async {
//       final input = await makeFormFieldInput(
//         'AgFieldTemplate<String> get name => AgFieldTemplate((b) => b));',
//       );

//       expect(
//           input.toFormField().toWidgetExpression(),
//           equalsDart(
//             "AgTextField("
//             "labelText: 'Name',"
//             " initialValue: model.name,"
//             " onSaved: (newValue) {"
//             "  model = model.copyWith(name: newValue);"
//             " } )",
//           ));
//     });

//     test('has isRequired attribute', () async {
//       final input = await makeFormFieldInput(
//         """
// AgFieldTemplate<String> get name => AgFieldTemplate((b) => b
//   ..isRequired = true);
// """,
//       );

//       expect(
//           input.toFormField().toWidgetExpression(),
//           equalsDart(
//             "AgTextField("
//             "validator: const RequiredValidator(property: 'name'),"
//             " labelText: 'Name',"
//             " initialValue: model.name,"
//             " onSaved: (newValue) {"
//             "  model = model.copyWith(name: newValue);"
//             " } )",
//           ));
//     });

//     test('has String-type attribute', () async {
//       final input = await makeFormFieldInput(
//         """
// AgFieldTemplate<String> get name => AgFieldTemplate((b) => b
//   ..isRequired = true
//   ..labelText = 'E-mail');
// """,
//       );

//       expect(
//           input.toFormField().toWidgetExpression(),
//           equalsDart(
//             "AgTextField("
//             "validator: const RequiredValidator(property: 'name'),"
//             " labelText: 'E-mail',"
//             " initialValue: model.name,"
//             " onSaved: (newValue) {"
//             "  model = model.copyWith(name: newValue);"
//             " } )",
//           ));
//     });
//   });
// }
