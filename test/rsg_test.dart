// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:test/test.dart';
import 'package:test_tools/src/random_string_generator.dart';

final Logger _log = new Logger('rsg_test.dart', watermark: Severity.debug);

void main() {
  RSG rsg = new RSG(1);

  String s = rsg.dcmString(10);
  _log.debug('dcmString: (${s.length})"$s"');

 // rsgTest();
}

//TODO: doc
void rsgTest() {
  
  group('Generate Random Strings', () {

  //  RSG rsg = new RSG(1);

    test('DICOM Strings (SH, LO, UC)', () {
      
    });
    
  });

}