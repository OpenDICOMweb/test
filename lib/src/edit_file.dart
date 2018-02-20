import 'dart:io';
import 'package:path/path.dart';

class EditFile {

  String readFromFile;

  String writeToFile;

  IOSink sink;

  String dirPath;

  EditFile(String readFromFile,[String writeToFile]):
    readFromFile = readFromFile,
    sink = new File(writeToFile ??= readFromFile).openWrite();

  EditFile.fromDirectory(String dirPath): dirPath = dirPath;
  //
  static void addCopyrightToDir(List<String> copyright, String dirPath) {
    final dir = new Directory(dirPath);
    final eList = dir.listSync(recursive: true);

    for (var file in eList)
      if (file is File) addCopyrightToFile(copyright, file.path);
  }

  void addCopyrightToFile2() {
    final copyright = <String>[
      '// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.-----',
      '// Use of this source code is governed by the open source license-----',
      '// that can be found in the LICENSE file.-----',
      '// Original author: Jim Philbin <jfphilbin@gmail.edu> -----',
      '// See the   AUTHORS file for other contributors.-----'
    ];

    final file = new File('C:/odw/sdk/element/lib/src/tag/integer.dart');
    final filename = basename(file.path);
    final outFile = new File('C:/odw/sdk/element/lib/src/tag/TestInteger.dart');
    final outData = <String>[];
    var start = false;
    if (filename.endsWith('.dart')) {
      final cont = file.readAsLinesSync();
      for (var c in cont) {
        if (start = c.startsWith('import') ? true : start) {
          outData.add(c);
        }
      }

      final sink = outFile.openWrite();
      for (var s in copyright) {
        sink.writeln(s);
      }
      sink.writeln();
      for (var s in outData) {
        sink.writeln(s);
      }

      sink.close();
    }
  }

  //
  static void addCopyrightToFile(List<String> copyright, String readFromFile,
      [String outFilePath, String readFrom = 'import']) {
    final file = new File(readFromFile);
    final outFile = new File(outFilePath ??= readFromFile);
    var outData = <String>[];

    if (basename(file.path).endsWith('.dart')) {
      outData = readFile(file, readFrom);

      writeFile(outFile, copyright, outData);
    }
  }

  //
  static List<String> readFile(File file, String readFrom) {
    final outData = <String>[];
    var start = false;
    var count = 5;

    for (var content in file.readAsLinesSync()) {
      if(content.startsWith(readFrom))
      if (start = content.startsWith(readFrom) ? true : start)
        outData.add(content);
    }

    return outData;
  }

  //
  static void writeFile(File outFile, List<String> copyright, List<String> outData) {
    final sink = outFile.openWrite();
    if (copyright != null && copyright.isNotEmpty)
      copyright.forEach((s) => sink.writeln(s));

    addEmptyLine(sink);

    if (outData != null && outData.isNotEmpty)
      outData.forEach((s) => sink.writeln(s));

    closeSink(sink);
  }

  //
  static void addEmptyLine(IOSink sink) => sink.writeln();

  //
  static void closeSink(IOSink sink) => sink.close();
}
