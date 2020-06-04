// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WebPage extends WebPage {
  @override
  final String title;
  @override
  final String slug;
  @override
  final bool live;
  @override
  final DateTime firstPublishedAt;
  @override
  final DateTime lastPublishedAt;

  factory _$WebPage([void Function(WebPageBuilder) updates]) =>
      (new WebPageBuilder()..update(updates)).build();

  _$WebPage._(
      {this.title,
      this.slug,
      this.live,
      this.firstPublishedAt,
      this.lastPublishedAt})
      : super._() {
    if (title == null) {
      throw new BuiltValueNullFieldError('WebPage', 'title');
    }
    if (slug == null) {
      throw new BuiltValueNullFieldError('WebPage', 'slug');
    }
    if (live == null) {
      throw new BuiltValueNullFieldError('WebPage', 'live');
    }
  }

  @override
  WebPage rebuild(void Function(WebPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WebPageBuilder toBuilder() => new WebPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WebPage &&
        title == other.title &&
        slug == other.slug &&
        live == other.live &&
        firstPublishedAt == other.firstPublishedAt &&
        lastPublishedAt == other.lastPublishedAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, title.hashCode), slug.hashCode), live.hashCode),
            firstPublishedAt.hashCode),
        lastPublishedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('WebPage')
          ..add('title', title)
          ..add('slug', slug)
          ..add('live', live)
          ..add('firstPublishedAt', firstPublishedAt)
          ..add('lastPublishedAt', lastPublishedAt))
        .toString();
  }
}

class WebPageBuilder implements Builder<WebPage, WebPageBuilder> {
  _$WebPage _$v;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _slug;
  String get slug => _$this._slug;
  set slug(String slug) => _$this._slug = slug;

  bool _live;
  bool get live => _$this._live;
  set live(bool live) => _$this._live = live;

  DateTime _firstPublishedAt;
  DateTime get firstPublishedAt => _$this._firstPublishedAt;
  set firstPublishedAt(DateTime firstPublishedAt) =>
      _$this._firstPublishedAt = firstPublishedAt;

  DateTime _lastPublishedAt;
  DateTime get lastPublishedAt => _$this._lastPublishedAt;
  set lastPublishedAt(DateTime lastPublishedAt) =>
      _$this._lastPublishedAt = lastPublishedAt;

  WebPageBuilder();

  WebPageBuilder get _$this {
    if (_$v != null) {
      _title = _$v.title;
      _slug = _$v.slug;
      _live = _$v.live;
      _firstPublishedAt = _$v.firstPublishedAt;
      _lastPublishedAt = _$v.lastPublishedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WebPage other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$WebPage;
  }

  @override
  void update(void Function(WebPageBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$WebPage build() {
    final _$result = _$v ??
        new _$WebPage._(
            title: title,
            slug: slug,
            live: live,
            firstPublishedAt: firstPublishedAt,
            lastPublishedAt: lastPublishedAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
