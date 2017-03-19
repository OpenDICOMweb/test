// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/string.dart';
import 'package:test_tools/src/random_string_generator.dart';

final Logger log = new Logger('rsg_test.dart', watermark: Severity.debug);

void main() {
  RSG rsg = new RSG();

  String s = rsg.dcmString(10);
  log.debug('dcmString: (${s.length})"$s"');
  bool v = isSHString(s);
  log.debug('isValid dcmString: $v');
/*
  s = rsg.dcmTextString(10);
  log.debug('dcmTextString: (${s.length})"$s"');

  s = rsg.dcmCodeString(10);
  log.debug('dcmCodeString: (${s.length})"$s"');

  s = rsg.dcmDigitString(10);
  log.debug('dcmDigitString: (${s.length})"$s"');
*/
}
