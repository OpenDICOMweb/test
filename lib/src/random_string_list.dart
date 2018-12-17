// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:math';
import 'dart:typed_data';

import 'package:core/core.dart';

/// A class used to create random DICOM List<String>.
class RandomStringList {
  static final Random _rng = Random(1);

  /// The name of the RandomList] generator.
  final String name;

  /// The minimum value that can be generated.
  final int min;

  /// The maximum value that can be generated.
  final int max;

  /// Constructor
  const RandomStringList(this.name, this.min, this.max);

  /// A valid DICOM String [String].
  static const RandomStringList dcmString =
      RandomStringList('dcmString', 1, 16);

  /// A valid DICOM Text [String].
  static const RandomStringList dcmText = RandomStringList('dcmText', 1, 100);

  /// A valid DICOM Code String [String].
  static const RandomStringList dcmCodeString =
      RandomStringList('dcmCodeString', 1, Int16.kMaxValue);

  /// A valid DICOM String [List<String>].
  static const RandomStringList dcmDate =
      RandomStringList('dcmDate', 1, Uint16.kMaxValue);

  /// A valid DICOM Time [List<String>].
  static const RandomStringList dcmTime =
      RandomStringList('dcmTime', 1, Int32.kMaxValue);

  /// A valid DICOM DateTime [List<String>].
  static const RandomStringList dcmDateTime =
      RandomStringList('dcmDateTime', 1, Uint32.kMaxValue);

  /// A valid DICOM Decimal [List<String>].
  static const RandomStringList dcmDecimal =
      RandomStringList('dcmDecimal', 1, Int64.kMaxValue);

  /// A valid DICOM Integer [List<String>].
  static const RandomStringList dcmInteger =
      RandomStringList('dcmInteger', 1, Uint64.kMaxValue);

  /// A valid DICOM Person Name [List<String>].
  static const RandomStringList dcmPersonName =
      RandomStringList('dcmPersonName', 1, null);

  /// A valid DICOM UID String [List<String>].
  static const RandomStringList uid = RandomStringList('uid', 1, null);

  /// A valid DICOM URI String [List<String>].
  static const RandomStringList uri = RandomStringList('uri', 1, null);

  /// A call method for _this_.
  List<num> call(int length) => _makeList<num>(length);

  List<num> _makeList<E>(int length) {
    List<num> list;
    //log.debug('name: $name, type: $type, max: $max');
    //log.debug('length: $length');
    if (name == 'Int8') {
      list = Int8List(length);
      // log.debug('Int8List: $list');
    } else if (name == 'Uint8') {
      list = Uint8List(length);
    } else if (name == 'Int16') {
      list = Int16List(length);
    } else if (name == 'Uint16') {
      list = Uint16List(length);
    } else if (name == 'Int32') {
      list = Int32List(length);
    } else if (name == 'Uint32') {
      list = Uint32List(length);
    } else if (name == 'Int64') {
      list = Int64List(length);
      return randomInt64List(length);
    } else if (name == 'Uint64') {
      return randomUint64List(length);
    } else if (name == 'Float32') {
      return randomFloat32List(length);
    } else if (name == 'Float64') {
      return randomFloat64List(length);
    } else {
      // ignore: only_throw_errors
      throw 'Invalid';
    }
    for (var i = 0; i < length; i++) {
      list[i] = _rng.nextInt(max);
    }
    return list;
  }

  /// Returns a random [Uint64List].
  Uint64List randomUint64List(int length) {
    final list = Uint64List(length);
    for (var i = 0; i < list.length; i++) {
      final n1 = _rng.nextInt(1 << 32);
      final n2 = _rng.nextInt(1 << 32);
      list[i] = (n1 << 32) + n2;
    }
    return list;
  }

  /// Returns a random [Int64List].
  Int64List randomInt64List(int length) {
    final list = Int64List(length);
    for (var i = 0; i < list.length; i++) {
      final sign = (_rng.nextBool()) ? -1 : 1;
      final n1 = _rng.nextInt(kMaxHighInt);
      final n2 = _rng.nextInt(0xFFFFFFFF);
      list[i] = sign * (n1 << 32) + n2;
    }
    return list;
  }

  /// Returns a random [Float32List].
  Float32List randomFloat32List(int length) =>
      _fillFloatList(Float32List(length));

  /// Returns a random [Float64List].
  Float64List randomFloat64List(int length) =>
      _fillFloatList(Float64List(length));

  List<double> _fillFloatList(List<double> list) {
    for (var i = 0; i < list.length; i++) list[i] = _rng.nextDouble();
    return list;
  }
}

/// Maximum positive integer.
int kMaxHighInt = 0x7FFFFFFF;

