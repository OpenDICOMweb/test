import 'dart:io';
import 'package:path/path.dart';

// Urgent Sharath: fix and document or remove this file.

/// A File to be edited.
class EditFile {
  /// Input file.
  String readFromFile;

  /// Output File
  String writeToFile;

  /// IOSink
  IOSink sink;

  /// The path to the [readFromFile] directory.
  String dirPath;

  /// Constructor
  EditFile(this.readFromFile, [String writeToFile])
      : sink = File(writeToFile ??= readFromFile).openWrite();

  /// Constructor
  EditFile.fromDirectory(this.dirPath);

  /// Add [copyright] to the beginning of each file.
  static void addCopyrightToDir(List<String> copyright, String dirPath) {
    final dir = Directory(dirPath);
    final eList = dir.listSync(recursive: true);

    for (var file in eList)
      if (file is File) addCopyrightToFile(copyright, file.path);
  }

  /// Add [copyright] to the beginning of file.
  void addCopyrightToFile2() {
    final copyright = <String>[
      '// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.-----',
      '// Use of this source code is governed by the open source license-----',
      '// that can be found in the LICENSE file.-----',
      '// Original author: Jim Philbin <jfphilbin@gmail.edu> -----',
      '// See the   AUTHORS file for other contributors.-----',
      '//'
    ];

    final file = File('C:/odw/sdk/element/lib/src/tag/integer.dart');
    final filename = basename(file.path);
    final outFile = File('C:/odw/sdk/element/lib/src/tag/TestInteger.dart');
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
      copyright.forEach(sink.writeln);
      outData.forEach(sink.writeln);
      sink.close();
    }
  }

  /// Add [copyright] to file.
  static void addCopyrightToFile(List<String> copyright, String readFromFile,
      [String outFilePath, String readFrom = 'import']) {
    final file = File(readFromFile);
    final outFile = File(outFilePath ??= readFromFile);
    var outData = <String>[];

    if (basename(file.path).endsWith('.dart')) {
      outData = readFile(file, readFrom);

      writeFile(outFile, copyright, outData);
    }
  }

  /// Read a file.
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
      File outFile, List<String> copyright, List<String> outData) {
    final sink = outFile.openWrite();
    if (copyright != null && copyright.isNotEmpty)
      copyright.forEach(sink.writeln);

    addEmptyLine(sink);

    if (outData != null && outData.isNotEmpty) outData.forEach(sink.writeln);

    closeSink(sink);
  }

  /// Add an empty line.
  static void addEmptyLine(IOSink sink) => sink.writeln();

  /// Close [sink].
  static void closeSink(IOSink sink) => sink.close();
}
