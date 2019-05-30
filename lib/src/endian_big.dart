// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

// ignore: public_member_api_docs

// Conversion to Endian.big

Uint8List getInt16BE(Int16List list) {
  final bd = Int16List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setInt16(i * 2, list[i], Endian.big);
  return bd.buffer.asUint8List();
}

Uint8List getInt32BE(Int32List list) {
  final bd = Int32List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setInt32(i * 4, list[i], Endian.big);
  return bd.buffer.asUint8List();
}

Uint8List getInt64BE(Int64List list) {
    final bd = Int64List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setInt64(i * 8, list[i], Endian.big);
  return bd.buffer.asUint8List();
}


Uint8List getUint16BE(Uint16List list) {
    final bd = Uint16List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setUint16(i * 2, list[i], Endian.big);
  return bd.buffer.asUint8List();
}

Uint8List getUint32BE(Uint32List list) {
    final bd = Uint32List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setUint32(i * 4, list[i], Endian.big);
  return bd.buffer.asUint8List();
}

Uint8List getUint64BE(Uint64List list) {
    final bd = Uint64List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setUint64(i * 8, list[i], Endian.big);
  return bd.buffer.asUint8List();
}

Uint8List getFloat32BE(Float32List list) {
    final bd = Float32List.fromList(list).buffer.asByteData();
    for (var i = 0; i < list.length; i++)
      bd.setFloat32(i * 4, list[i], Endian.big);
  return bd.buffer.asUint8List();
}

Uint8List getFloat64BE(Float64List list) {
    final bd = Float64List.fromList(list).buffer.asByteData();
  for (var i = 0; i < list.length; i++)
    bd.setFloat64(i * 8, list[i], Endian.big);
  return bd.buffer.asUint8List();
}
