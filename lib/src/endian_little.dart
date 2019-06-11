// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

// ignore_for_file: public_member_api_docs

bool isAligned(int index, int size) => (index % size) == 0;

// offset is in bytes
bool isAligned16(int offset) => isAligned(offset, 2);
bool isAligned32(int offset) => isAligned(offset, 4);
bool isAligned64(int offset) => isAligned(offset, 8);
bool isAligned128(int offset) => isAligned(offset, 16);

// Conversion to Endian.little

Uint8List getInt16LE(Int16List list) {
  final bd = Int16List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setInt16(i * 2, list[i], Endian.little);
  return bd.buffer.asUint8List();
}

Uint8List getInt32LE(Int32List list) {
  final bd = Int32List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setInt32(i * 4, list[i], Endian.little);
  return bd.buffer.asUint8List();
}

Uint8List getInt64LE(Int64List list) {
  final bd = Int64List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setInt64(i * 8, list[i], Endian.little);
  return bd.buffer.asUint8List();
}

Uint8List getUint16LE(Uint16List list) {
  final bd = Uint16List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setUint16(i * 2, list[i], Endian.little);
  return bd.buffer.asUint8List();
}

Uint8List getUint32LE(Uint32List list) {
  final bd = Uint32List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setUint32(i * 4, list[i], Endian.little);
  return bd.buffer.asUint8List();
}

Uint8List getUint64LE(Uint64List list) {
  final bd = Uint64List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setUint64(i * 8, list[i], Endian.little);
  return bd.buffer.asUint8List();
}

Uint8List getFloat32LE(Float32List list) {
  final bd = Float32List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setFloat32(i * 4, list[i], Endian.little);
  return bd.buffer.asUint8List();
}

Uint8List getFloat64LE(Float64List list) {
  final bd = Float64List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setFloat64(i * 8, list[i], Endian.little);
  return bd.buffer.asUint8List();
}
