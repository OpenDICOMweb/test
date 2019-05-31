// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.
//
import 'package:test/test.dart';
import 'package:test_tools/src/rsg.dart';

/// The number of random numbers each test is run on.
int count = 1000;

/// The seed for the RSG.
int seed = 1;

/// A Random String Generator
RSG rsg = RSG(seed: seed);

void main() {
  /// Test DICOM IS values.
  test('Random IS Test', () {
    for (var i = 0; i < count; i++) {
      final s = rsg.isString;
      // ignore: only_throw_errors
      if (s.length > 12) throw '"$s".length = ${s.length}';
      if (s.length == 1) print('***  IS: "$s".length = ${s.length}');
      if (s.length == 12) print('*** IS: "$s".length = ${s.length}');
      print(' IS: ${s.length}: "$s"');
      expect(s.length <= 12, true);
      //TODO: add error handler to int.parse
      final x = int.parse(s);
      expect(x is int, true);
    }
  });
}
