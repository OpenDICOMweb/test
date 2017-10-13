// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:string/string.dart';
import 'package:system/system.dart';
import 'package:test_tools/src/random_string_generator.dart';

void main() {
  final rsg = new RSG();

  var s = rsg.getSH(5, 10);
  log.debug('dcmString: (${s.length})"$s"');
  final v = isSHString(s);
  log.debug('isValid dcmString: $v');

  s = rsg.getLT(10);
  log.debug('dcmTextString: (${s.length})"$s"');

  s = rsg.getCS(10);
  log.debug('dcmCodeString: (${s.length})"$s"');

  s = rsg.getIS(10);
  log.debug('dcmDigitString: (${s.length})"$s"');

}
