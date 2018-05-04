// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'dart:io';
import 'package:path/path.dart';

const String newCopyrightString = '''
// Copyright (c) 2016, 2017, and 2018 Open DICOMweb Project. 
// All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.
''';

//String inFile;
//String outFile;

bool updateFile(String inPath, [String outPath]) {
   outPath ??= inPath;
  final inFile = new File('C:/odw/sdk/element/lib/src/tag/integer.dart');

  if (inPath.endsWith('.dart')) {
    final inputLines = inFile.readAsLinesSync();
    var line = 0;
    while ((!inputLines[line].startsWith('//'))) line++;

    if (inputLines[line] != '\n' || inputLines[line] != '\r\l') return false;
    final rest = inputLines.sublist(line).join('\n');

    new File('C:/odw/sdk/element/lib/src/tag/TestInteger.dart')
      ..writeAsStringSync(newCopyrightString + rest);
    return true;
  }
  return false;
}

String inRootDir;
String outRootDir;

class EditFile {
  String inFile;
  String outFile;
  String inRootDir;
  String outRootDir;

  EditFile(this.inFile, [String outFile]);

  EditFile.fromDirectory(this.inRootDir, this.outRootDir);

  //
  static void addCopyrightToDir(String copyright, String dirPath) {
    final dir = new Directory(dirPath);
    final eList = dir.listSync(recursive: true);

    for (var file in eList)
      if (file is File) addCopyrightToFile(copyright, file.path);
  }


  static const String kCopyright = '''
// Copyright (c) 2016, 2017, and 2018 Open DICOMweb Project. ',
// All rights reserved.',
// Use of this source code is governed by the open source license',
// that can be found in the LICENSE file.',
// Original author: Jim Philbin <jfphilbin@gmail.edu> ',
// See the   AUTHORS file for other contributors.',
//    
  ''';

  bool addCopyrightToFile3() {
    final inFile = new File('C:/odw/sdk/element/lib/src/tag/integer.dart');
    final filename = basename(inFile.path);
    var rest;

    if (filename.endsWith('.dart')) {
      final inputLines = inFile.readAsLinesSync();
      for (var i = 0; i < 10; i++) {
        if (!inputLines[i].startsWith('//')) continue;
        if (inputLines[i] != '\n' || inputLines[i] != '\r\l') return false;
        rest = inputLines.sublist(i).join('\n');
        break;
      }

      final output = newCopyrightString + rest;
      new File('C:/odw/sdk/element/lib/src/tag/TestInteger.dart')
        ..writeAsStringSync(output);
      return true;
    }
    return false;
  }

  //
  static void addCopyrightToFile(String readFromFile,
      [String outFilePath, String readFrom = 'import']) {
    final file = new File(readFromFile);
    final outFile = new File(outFilePath ??= readFromFile);
    var outData = <String>[];

    if (basename(file.path).endsWith('.dart')) {
      outData = readFile(file, readFrom);

      writeFile(outFile, kCopyright, outData);
    }
  }

  //
  static List<String> readFile(File file, String readFrom) {
    final outData = <String>[];
    var start = false;

    for (var content in file.readAsLinesSync()) {
      if (content.startsWith(readFrom)) if (start =
          content.startsWith(readFrom) ? true : start) outData.add(content);
    }

    return outData;
  }

  //
  static void writeFile(
      File outFile, String copyright, List<String> outData) {
    final sink = outFile.openWrite();
    if (copyright != null && copyright.isNotEmpty)
      sink.writeln(kCopyright);

    addEmptyLine(sink);

    if (outData != null && outData.isNotEmpty)
      outData.forEach(sink.writeln);

    closeSink(sink);
  }

  //
  static void addEmptyLine(IOSink sink) => sink.writeln();

  //
  static void closeSink(IOSink sink) => sink.close();
}
