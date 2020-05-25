import 'package:recase/recase.dart';

extension RecaseExtension on String {
  String toSnakeCase() => ReCase(this).snakeCase;

  String toDotCase() => ReCase(this).dotCase;

  String toPathCase() => ReCase(this).pathCase;

  String toParamCase() => ReCase(this).paramCase;

  String toPascalCase() => ReCase(this).pascalCase;

  String toHeaderCase() => ReCase(this).headerCase;

  String toTitleCase() => ReCase(this).titleCase;

  String toCamelCase() => ReCase(this).camelCase;

  String toSentenceCase() => ReCase(this).sentenceCase;

  String toConstantCase() => ReCase(this).constantCase;
}
