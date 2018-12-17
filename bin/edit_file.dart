// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.
//
import 'package:test_tools/src/edit_file.dart';

void main() {
  final copyright = <String>[
    '// Copyright (c) 2018, Open DICOMweb Project. All rights reserved.-----',
    '// Use of this source code is governed by the open source license-----',
    '// that can be found in the LICENSE file.-----',
    '// Original author: Sharath chandra chinta',
    '// See the AUTHORS file for other contributors.-----'
  ];

  //final ef = new EditFile();
  //ef.addCopyrightToFile2();

  EditFile.addCopyrightToFile(
      copyright,
      'C:/test/core/lib/src/element/tag/integer.dart');
}
