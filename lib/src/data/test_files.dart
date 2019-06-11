//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.

// ignore_for_file: public_member_api_docs

// Urgent create test files for
class TransferSyntaxPhantom {
  final int x;
  const TransferSyntaxPhantom(this.x);

  static const kImplicitVRLittleEndian = TransferSyntaxPhantom(0);
  static const kExplicitVRLittleEndian = TransferSyntaxPhantom(1);
  static const kJpeg2000ImageCompression = TransferSyntaxPhantom(2);
}

/// A base class for Test Files.
abstract class TestFileBase {
  /// Element count.
  final int eCount;

  /// Sequence count.
  final int sqCount;

  /// Private Element count.
  final int privateCount;

  /// Constructor
  const TestFileBase(this.eCount, this.sqCount, this.privateCount);

  /// Transfer Syntax
  TransferSyntaxPhantom get ts;

  /// File path.
  String get fPath;
}

/// IVR Test Files.
class IvrTestFile extends TestFileBase {
  @override
  final String fPath;

  /// Constructor
  const IvrTestFile(int eCount, int sqCount, int privateCount, this.fPath)
      : super(eCount, sqCount, privateCount);

  @override
  TransferSyntaxPhantom get ts => TransferSyntaxPhantom.kImplicitVRLittleEndian;

  /// First file.
  static IvrTestFile f1 = const IvrTestFile(-1, -1, -1, '');
}

/// EVR Test Files.
class EvrTestFile extends TestFileBase {
  @override
  final String fPath;

  /// Constructor
  const EvrTestFile(int eCount, int sqCount, int privateCount, this.fPath)
      : super(eCount, sqCount, privateCount);

  @override
  TransferSyntaxPhantom get ts => TransferSyntaxPhantom.kExplicitVRLittleEndian;

  /// First file.
  static EvrTestFile f1 = const EvrTestFile(-1, -1, -1, '');
}

/// JPEG Test Files.
class JpegTestFile extends TestFileBase {
  @override
  final String fPath;

  /// Constructor
  const JpegTestFile(int eCount, int sqCount, int privateCount, this.fPath)
      : super(eCount, sqCount, privateCount);

  @override
  TransferSyntaxPhantom get ts =>
      TransferSyntaxPhantom.kJpeg2000ImageCompression;

  /// First file.
  static EvrTestFile f1 = const EvrTestFile(-1, -1, -1, '');
}
