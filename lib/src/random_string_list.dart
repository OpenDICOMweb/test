// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:math';
import 'dart:typed_data';

import 'package:number/number.dart';

//TODO: Merge with common/random/rng.dart
/// TODO: doc or delete
class RandomStringList {
  static final Random _rng = new Random(1);

  /// The name of the RandomList] generator.
  final String name;
  /// The minimum value that can be generated.
  final int min;
  /// The maximum value that can be generated.
  final int max;

  const RandomStringList(this.name, this.min, this.max);

  //TODO: finish these tests.
  static const RandomStringList dcmString =
      const RandomStringList("dcmString", 1, 16);

  static const RandomStringList dcmText =
      const RandomStringList("dcmText", 1, 100);

  static const RandomStringList dcmCodeString =
      const RandomStringList("dcmCodeString", 1, Int16.maxValue);

  static const RandomStringList dcmDate =
      const RandomStringList("dcmDate", 1, Uint16.maxValue);

  static const RandomStringList dcmTime =
      const RandomStringList("dcmTime", 1, Int32.maxValue);

  static const RandomStringList dcmDateTime =
      const RandomStringList("dcmDateTime", 1, Uint32.maxValue);

  static const RandomStringList dcmDecimal =
      const RandomStringList("dcmDecimal", 1, Int64.maxValue);

  static const RandomStringList dcmInteger =
      const RandomStringList("dcmInteger", 1, Uint64.maxValue);

  static const RandomStringList dcmPersonName =
      const RandomStringList("dcmPersonName", 1, null);

  static const RandomStringList uid = const RandomStringList("uid", 1, null);

  static const RandomStringList uri = const RandomStringList("uri", 1, null);

  List<num> call(int length) {
    return _makeList(length);
  }

  List<num> _makeList<E>(int length) {
    List<num> list;
    //log.debug('name: $name, type: $type, max: $max');
    //log.debug('length: $length');
    if (name == "Int8") {
      list = new Int8List(length);
      // log.debug('Int8List: $list');
    } else if (name == "Uint8") {
      list = new Uint8List(length);
    } else if (name == "Int16") {
      list = new Int16List(length);
    } else if (name == "Uint16") {
      list = new Uint16List(length);
    } else if (name == "Int32") {
      list = new Int32List(length);
    } else if (name == "Uint32") {
      list = new Uint32List(length);
    } else if (name == "Int64") {
      list = new Int64List(length);
      return _fill64List(list);
    } else if (name == "Uint64") {
      list = new Uint64List(length);
      return _fill64List(list);
    } else if (name == "Float32") {
      list = new Float32List(length);
      return _fillFloatList(list);
    } else if (name == "Float64") {
      list = new Float32List(length);
      return _fillFloatList(list);
    } else {
      throw "Invalid";
    }
    for (int i = 0; i < length; i++) {
      list[i] = _rng.nextInt(max);
    }
    return list;
  }

  List<int> _fill64List<E>(List<int> list) {
    for (int i = 0; i < list.length; i++) {
      //    int sign = (i.isEven) ? -1 : 1;
      int n1 = _rng.nextInt(1 << 32);
      int n2 = _rng.nextInt(1 << 32);
      list[i] = (n1 << 32) + n2;
    }
    return list;
  }

  List<double> _fillFloatList(List<double> list) {
    for (int i = 0; i < list.length; i++) list[i] = _rng.nextDouble();
    return list;
  }
}
