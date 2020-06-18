import 'package:admin_template_core/core.dart';
import 'package:built_value/built_value.dart';

part 'web_page.g.dart';

abstract class WebPage implements Built<WebPage, WebPageBuilder> {
  String get title;

  String get slug;

  @nullable
  DateTime get firstPublishedAt;

  @nullable
  DateTimeRange get publishDateRange;

  factory WebPage([void Function(WebPageBuilder) updates]) = _$WebPage;
  WebPage._();
}
