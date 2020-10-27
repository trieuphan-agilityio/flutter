import 'package:admin_template_core/core.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:meta/meta.dart';
import 'package:build/build.dart' as build show log;
import 'package:source_gen/source_gen.dart';

import 'base/symbol_path.dart';
import 'input/form_settings.dart';

/// A global log instance
Logger get log => build.log;

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

/// Constructs a serializable path to [element].
SymbolPath getSymbolPath(Element element) {
  if (element is TypeDefiningElement && element.type.isDynamic) {
    throw new ArgumentError('Dynamic element type not supported. This is a '
        'package:admin_template bug. Please report it.');
  }
  return new SymbolPath.fromAbsoluteUri(
    element.library.source.uri,
    element.name,
  );
}

bool _hasAnnotation(Element element, SymbolPath annotationSymbol) {
  return _getAnnotation(element, annotationSymbol, orElse: () => null) != null;
}

ElementAnnotation _getAnnotation(Element element, SymbolPath annotationSymbol,
    {ElementAnnotation orElse()}) {
  List<ElementAnnotation> resolvedMetadata = element.metadata;

  for (int i = 0; i < resolvedMetadata.length; i++) {
    ElementAnnotation annotation = resolvedMetadata[i];
    Element valueElement = annotation.computeConstantValue()?.type?.element;

    if (valueElement == null) {
      String pathToAnnotation = annotationSymbol.toHumanReadableString();
      assert(
        false,
      );
      log.severe(
        annotation.element ?? element,
        'While looking for annotation ${pathToAnnotation} on "${element}", '
        'failed to resolve annotation value. A common cause of this error is '
        'a misspelling or a failure to resolve the import where the '
        'annotation comes from.',
      );
    } else if (getSymbolPath(valueElement).symbol == annotationSymbol.symbol) {
      // Compare the name of annotation regardless of the face that these
      // annotation could not identical, it could come from different packages
      // (in testing, the annotation is fake, come from a fake pacakge).
      return annotation;
    }
  }

  return orElse != null
      ? orElse()
      : throw 'Annotation $annotationSymbol not found on element $element';
}

/// Whether [clazz] is annotated with `@AgFormTemplate()`.
bool isAgFormTemplateClass(ClassElement clazz) => hasAgFormAnnotation(clazz);

/// Whether [e] is annotated with `@AgFormTemplate()`.
bool hasAgFormAnnotation(Element e) =>
    _hasAnnotation(e, SymbolPath.agFormTemplate);
