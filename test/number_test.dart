// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'package:test/test.dart';
import 'package:test_tools/src/random_string_generator.dart';

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

  /// Test DICOM DS values.
  group('Generate Random Decimal Strings', () {
    test('Random DS Fixed Point Test', () {
      for (var i = 0; i < count; i++) {
        final s = rsg.getFixedDSString(14);
        final len = s.length.toString().padLeft(2, ' ');
        // ignore: only_throw_errors
        if (s.length > 16) throw '"$s".length = ${s.length}';
        if (s.length < 8) print('*** FDS $len: "$s".length');
        if (s.length > 14) print('*** FDS $len: "$s".length');
        print('    FDS $len: "$s"');
        expect(s.length <= 16, true);
        final x = double.parse(s);
        expect(x is double, true);
      }
    });

    test('Random DS Exponential Test', () {
      for (var i = 0; i < count; i++) {
        final s = rsg.getExpoDSString(11);
        final len = s.length.toString().padLeft(2, ' ');
        // ignore: only_throw_errors
        if (s.length > 16) throw '"$s".length = ${s.length}';
        if (s.length == 8) print('*** EDS $len: "$s".length');
        if (s.length == 16) print('*** EDS $len: "$s".length');
        print('    EDS $len: "$s"');
        expect(s.length <= 16, true);
        final x = double.parse(s);
        expect(x is double, true);
      }
    });

    test('Random DS Precision Test', () {
      for (var i = 0; i < count; i++) {
        final s = rsg.getPrecisionDSString();
        final len = s.length.toString().padLeft(2, ' ');
        RangeError.checkValidRange(1, s.length, 16);
        print('    PDS $len: "$s"');
        expect(s.length <= 16, true);
        final x = double.parse(s);
        expect(x is double, true);
      }
    });

    //Fix: there is a case where rsg.getPrecissionDSSting generates an
    //     illegal String with 17 characters
    test('increasing DS Precision Test', () {
      final limit = count ~/ 16;
      for (var i = 0; i < limit; i++) {
        for (var j = 1; j < 16; j++) {
          final s = rsg.getPrecisionDSString(j);
          final len = s.length.toString().padLeft(2, ' ');
          final p = j.toString().padLeft(2, ' ');
          // ignore: only_throw_errors
          if (s.length > 16) throw '"$s".length = ${s.length}';
          if (s.length < 8) print('*** $p PDS $len: "$s".length');
          if (s.length == 16) print('*** $p PDS $len: "$s".length');
          print('   $p PDS $len: "$s"');
          expect(s.length <= 16, true);
          final x = double.parse(s);
          expect(x is double, true);
        }
      }
    });

    test('Random DS String Test', () {

      for (var i = 0; i < count; i++) {
        final s = rsg.getDSString();
        print('    RDS: ${s.length}: "$s"');
        // ignore: only_throw_errors
        if (s.length > 16 || s.isEmpty) throw '"$s".length = ${s.length}';
        if (s.isNotEmpty && s.length <= 16)
          print('*** RDS: "$s".length = ${s.length}');
        expect(s.isNotEmpty && s.length <= 16, true);
        print('      S: $s');
        final x = double.parse(s);
        print('      X: $x');
        expect(x is double, true);
      }
    });
  });
}
