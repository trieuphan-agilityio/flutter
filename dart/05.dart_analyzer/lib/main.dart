import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

main() {
  final baseDir = ''; // <--- fill absolute path to dart-training
  final parsed = parseFile(
    path: '$baseDir/dart/05.dart_analyzer/lib/src/person_form.dart',
    featureSet: FeatureSet.latestLanguageVersion(),
  );

  print(parsed.errors);
}
