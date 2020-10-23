// import 'package:code_builder/code_builder.dart';
// import 'package:test/test.dart';

// import 'util.dart';

// main() {
//   useDartfmt();

//   group('Bool field', () {
//     test('is specified AgCheckboxField widget', () async {
//       final input = await makeFormFieldInput(
//         'AgFieldTemplate<bool> get optIn => AgFieldTemplate((b) => b));',
//       );

//       expect(
//           input.toFormField().toWidgetExpression(),
//           equalsDart(
//             "AgCheckboxField("
//             "initialValue: model.optIn,"
//             " onSaved: (newValue) {"
//             "  model = model.copyWith(optIn: newValue);"
//             " } )",
//           ));
//     });

//     test(
//         'uses AgBoolTemplate to explicitly '
//         'specify AgCheckboxField widget', () async {
//       final input = await makeFormFieldInput(
//         'AgBoolTemplate get optIn => AgBoolTemplate((b) => b));',
//       );

//       expect(
//           input.toFormField().toWidgetExpression(),
//           equalsDart(
//             "AgCheckboxField("
//             "initialValue: model.optIn,"
//             " onSaved: (newValue) {"
//             "  model = model.copyWith(optIn: newValue);"
//             " } )",
//           ));
//     });
//   });
// }
