// Copyright (c) 2018, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'plugin_tester.dart';

void main() {
  group('corrects class definition', () {
    test('when class is not hidden', () async {
      await expectCorrection(
        r'''
part '_resolve_source.g.dart';

class Person {
  final String name;
  Person({this.name});
}

@AgFormTemplate(modelType: Person)
class PersonForm {

}''',
        r'''
part '_resolve_source.g.dart';

class Person {
  final String name;
  Person({this.name});
}

@AgFormTemplate(modelType: Person)
class _PersonForm {

}''',
      );
    });
  });
}
