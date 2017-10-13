// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

// import 'dart:collection';
// import 'dart:typed_data';

//TODO: finish
/// A class used for creating and initializing unaligned TypedData.
/* commented out until implemented
class Unaligned<E> implements ListBase, TypedData {

  Unaligned.int8(int length)
  E operator[](int i)


}

Uint8List unalignedTypedData<E>(TypedData<E> tdList, int offsetAt) {
  if (tdList is! TypedData)
  ByteData bd = new ByteData(tdList.lengthInBytes + offsetAt);
  int length = tdList.lengthInBytes ~/ tdList.elementSizeInBytes;
  for (int i = 0, oib = 0; i < length; i++, oib += tdList.elementSizeInBytes) {
    bd.setUint64(oib + offsetAt, tdList[i], Endianness.HOST_ENDIAN);
  }
  return bd.buffer.asUint8List(offsetAt);
}*/
