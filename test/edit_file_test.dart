import 'package:core/server.dart';
import 'package:test/test.dart';
import 'package:test_tools/src/edit_file.dart';

void main() {
  Server.initialize(name: 'edit_file_test', level: Level.debug);

  test('edit copyright Test', () {
    final copyright = <String>[
      '// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.-----',
      '// Use of this source code is governed by the open source license-----',
      '// that can be found in the LICENSE file.-----',
      '// Original author: Jim Philbin <jfphilbin@gmail.edu> -----',
      '// See the   AUTHORS file for other contributors.-----'
    ];

    /*final ef = new EditFile();
    ef.addCopyrightToFile2();*/

    EditFile.addCopyrightToFile(
        copyright,
        'C:/odw/sdk/core/element/lib/src/tag/integer.dart',
        'C:/odw/sdk/core/element/lib/src/tag/TestInteger.dart');
  }, skip: 'ToDo Fix or flush');
}
