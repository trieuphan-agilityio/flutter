import 'package:admin_template_core/core.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

import 'input/form_settings.dart';

/// Return an instance of [FormSettings] corresponding to a the provided
/// [reader] of [AgFormTemplate] annotation.
FormSettings _valueForAnnotation(ConstantReader reader) => FormSettings(
      modelType: reader.read('modelType').typeValue.getDisplayString(),
    );

/// Returns a [AgFormTemplate] with values from the [AgFormTemplate]
/// instance represented by [reader].
///
/// For fields that are not defined in [AgFormTemplate] or `null` in [reader],
/// use the values in [config].
FormSettings mergeSettings(
  FormSettings config,
  ConstantReader reader, {
  @required ClassElement classElement,
}) {
  final annotation = _valueForAnnotation(reader);

  return FormSettings(
    modelType: annotation.modelType ?? config.modelType,
  );
}
