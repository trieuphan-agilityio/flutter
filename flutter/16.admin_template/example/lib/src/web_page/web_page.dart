import 'package:admin_template/admin_template.dart';
import 'package:built_value/built_value.dart';

part 'web_page.g.dart';

abstract class WebPage implements Built<WebPage, WebPageBuilder> {
  @AgText()
  String get title;

  @AgText()
  String get slug;

  @AgBool()
  bool get live;

  DateTime get firstPublishedAt;

  DateTime get lastPublishedAt;

  factory WebPage([void Function(WebPageBuilder) updates]) = _$WebPage;
  WebPage._();
}
