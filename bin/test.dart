// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:string/string.dart';
import 'package:test_tools/src/random_string_generator.dart';

/// Logger
final Logger log = new Logger('rsg_test.dart', Level.debug);

void main() {
  RSG rsg = new RSG();

  String s = rsg.getSH(5, 10);
  log.debug('dcmString: (${s.length})"$s"');
  bool v = isSHString(s);
  log.debug('isValid dcmString: $v');

  s = rsg.getLT(10);
  log.debug('dcmTextString: (${s.length})"$s"');

  s = rsg.getCS(10);
  log.debug('dcmCodeString: (${s.length})"$s"');

  s = rsg.getIS(10);
  log.debug('dcmDigitString: (${s.length})"$s"');

}
