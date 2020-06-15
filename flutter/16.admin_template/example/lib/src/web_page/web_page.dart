import 'package:admin_template/admin_template.dart';
import 'package:admin_template_core/core.dart';
import 'package:built_value/built_value.dart';

part 'web_page.g.dart';

// CAUTION: import entire material causes conflict with Builder from built_value
// It should import DateTimeRange from material package only!!!

abstract class WebPage implements Built<WebPage, WebPageBuilder> {
  @AgText()
  String get title;

  @AgText()
  String get slug;

  @AgBool()
  bool get live;

  @nullable
  DateTime get firstPublishedAt;

  @nullable
  @AgDateRange(startDate: '06/20/2020', endDate: '07/01/2020')
  DateTimeRange get publishDateRange;

  factory WebPage([void Function(WebPageBuilder) updates]) = _$WebPage;
  WebPage._();
}
