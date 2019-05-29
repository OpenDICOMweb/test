// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.
//
import 'dart:math';
import 'dart:typed_data';

import 'package:test_tools/src/constants.dart';

//TODO: Merge with common/random/rng.dart
/// TODO: doc or delete
class RandomList<T> {
  /// The name of the RandomList] generator.
  final String name;

  /// The type of the RandomList] generator.
  final Type type;

  /// The minimum value that can be generated.
  final num min;

  /// The maximum value that can be generated.
  final num max;

  const RandomList._(this.name, this.type, this.min, this.max);

  //TODO: add Type variable T
  /// A generator for [Int8List]s.
  static const RandomList int8 =
      RandomList<int>._('Int8', Int8List, kInt8MinValue, kInt8MaxValue);

  /// A generator for [Uint8List]s.
  static const RandomList uint8 =
      RandomList<int>._('Uint8', Uint8List, 0, kUint8MaxValue);

  /// A generator for [Int16List]s.
  static const RandomList int16 =
      RandomList<int>._('Int16', Int16List, kInt16MinValue, kInt16MaxValue);

  /// A generator for [Uint16List]s.
  static const RandomList uint16 =
      RandomList<int>._('Uint16', Uint16List, 0, kUint16MaxValue);

  /// A generator for [Int32List]s.
  static const RandomList int32 =
      RandomList<int>._('Int32', Int32List, kInt32MinValue, kInt32MaxValue);

  /// A generator for [Uint32List]s.
  static const RandomList uint32 =
      RandomList<int>._('Uint32', Uint32List, 0, kUint32MaxValue);

  /// A generator for [Int64List]s.
  static const RandomList int64 =
      RandomList<int>._('Int64', Int64List, kInt64MinValue, kInt64MaxValue);

  /// A generator for [Uint64List]s.
  static const RandomList uint64 =
      RandomList<int>._('Uint64', Uint64List, 0, kUint64MaxValue);

  /// A generator for [Float32List]s.
  static const RandomList float32 =
      RandomList<double>._('Float32', Float32List, null, null);

  /// A generator for [Float64List]s.
  static const RandomList float64 =
      RandomList<double>._('Float64', Float64List, null, null);

  /// Returns a [List<num>] containing [length] values;
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
      return _fill64List(list);
    } else if (name == 'Uint64') {
      list = Uint64List(length);
      return _fill64List(list);
    } else if (name == 'Float32') {
      list = Float32List(length);
      return _fillFloatList(list);
    } else if (name == 'Float64') {
      list = Float32List(length);
      return _fillFloatList(list);
    } else {
      // ignore: only_throw_errors
      throw 'Invalid';
    }
    for (var i = 0; i < length; i++) {
      list[i] = _rng.nextInt(max);
    }
    return list;
  }

  List<int> _fill64List(List<int> list) {
    for (var i = 0; i < list.length; i++) {
      final n1 = _rng.nextInt(0xFFFFFFFF);
      final n2 = _rng.nextInt(0xFFFFFFFF);
      list[i] = (n1 << 32) + n2;
    }
    return list;
  }

  List<double> _fillFloatList(List<double> list) {
    for (var i = 0; i < list.length; i++) list[i] = _rng.nextDouble();
    return list;
  }
}

final Random _rng = Random(1);
const _validNBits = <int>[2, 4, 8, 16, 32, 64];

// Flush if not used by V0.9.0
/// Returns a random unsigned integer with a maximum length of [nBits],
/// which must be a power of 2 between 1 and 6.
int getRandomUnsigned(int nBits) {
  // ignore: only_throw_errors
  if (!_validNBits.contains(nBits)) throw 'Invalid nBits: $nBits';
  final max = pow(2, nBits) - 1;
  final n = _rng.nextInt(max);
  assert(n >= 0 && n <= max);
  return n;
}

// Flush if not used by V0.9.0
/// Returns a random signed integer with a maximum length of [nBits],
/// which must be a power of 2 between 1 and 6.
int getRandomSigned(int nBits) {
  // ignore: only_throw_errors
  if (!_validNBits.contains(nBits)) throw 'Invalid nBits: $nBits';
  final limit = pow(2, nBits - 1);
  final min = -limit;
  final max = limit - 1;
  final sign = _rng.nextBool() ? -1 : 1;
  final n = _rng.nextInt(limit);
  var v = sign * n;
  v = (v > max) ? max : v;
  assert(v >= min && v <= max);
  return v;
}
