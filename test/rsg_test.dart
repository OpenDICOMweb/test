// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:system/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/src/random_string_generator.dart';


/// The number of random numbers each test is run on.
int count = 1000;

/// The seed for the RSG.
int seed = 1;

/// A Random String Generator
RSG rsg = new RSG(seed: seed);

void main() {

  Server.initialize(name: 'rsg_test', level: Level.info0);

  /// Test DICOM IS values.
  test('Random IS Test', () {
    for (var i = 0; i < count; i++) {
      final s = (rsg.isString);
      // ignore: only_throw_errors
      if (s.length > 12) throw '"$s".length = ${s.length}';
      if (s.length == 1) log.debug('***  IS: "$s".length = ${s.length}');
      if (s.length == 12) log.debug('*** IS: "$s".length = ${s.length}');
      log.debug(' IS: ${s.length}: "$s"');
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
	      final s = (rsg.getFixedDSString(14));
	      final len = s.length.toString().padLeft(2, ' ');
        // ignore: only_throw_errors
        if (s.length > 16) throw '"$s".length = ${s.length}';
        if (s.length < 8) log.debug('*** FDS $len: "$s".length');
        if (s.length > 14) log.debug('*** FDS $len: "$s".length');
        log.debug('    FDS $len: "$s"');
        expect(s.length <= 16, true);
	      final x = double.parse(s);
        expect(x is double, true);
      }
    });

    test('Random DS Exponential Test', () {
      for (var i = 0; i < count; i++) {
	      final s = (rsg.getExpoDSString(13));
	      final len = s.length.toString().padLeft(2, ' ');
        // ignore: only_throw_errors
        if (s.length > 16) throw '"$s".length = ${s.length}';
        if (s.length == 8) log.debug('*** EDS $len: "$s".length');
        if (s.length == 16) log.debug('*** EDS $len: "$s".length');
        log.debug('    EDS $len: "$s"');
        expect(s.length <= 16, true);
	      final x = double.parse(s);
        expect(x is double, true);
      }
    });

    test('Random DS Precision Test', () {
      for (var i = 0; i < count; i++) {
	      final s = (rsg.getPrecisionDSString());
	      final len = s.length.toString().padLeft(2, ' ');
        RangeError.checkValidRange(1, s.length, 16);
        log.debug('    PDS $len: "$s"');
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
	        final s = (rsg.getPrecisionDSString(j));
	        final len = s.length.toString().padLeft(2, ' ');
	        final p = j.toString().padLeft(2, ' ');
          // ignore: only_throw_errors
          if (s.length > 16) throw '"$s".length = ${s.length}';
          if (s.length < 8) log.debug('*** $p PDS $len: "$s".length');
          if (s.length == 16) log.debug('*** $p PDS $len: "$s".length');
          log.debug('   $p PDS $len: "$s"');
          expect(s.length <= 16, true);
	        final x = double.parse(s);
          expect(x is double, true);
        }
      }
    });

    test('Random DS String Test', () {
      for (var i = 0; i < count; i++) {
	      final s = (rsg.getDSString());
        // ignore: only_throw_errors
        if (s.length > 16) throw '"$s".length = ${s.length}';
        if (s.length < 5) log.debug('*** RDS: "$s".length = ${s.length}');
        if (s.length == 16) log.debug('*** RDS: "$s".length = ${s.length}');
        log.debug('    RDS: ${s.length}: "$s"');
        expect(s.length <= 16, true);
	      final x = double.parse(s);
        expect(x is double, true);
      }
    });

  });
}


