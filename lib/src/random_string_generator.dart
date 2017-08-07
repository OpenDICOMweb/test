// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:common/common.dart';
import 'package:dictionary/dictionary.dart';

//Enhancement: if performance needs to be improved us StringBuffer.
//Enhancement: show that a normal distribution is generated

// Returns [true] if [char] satisfies predicate.
//typedef bool _CharPredicate(int char);

/// Returns a random integer
typedef int _CharGenerator();

typedef String _StringGenerator([int min, int max]);

/// Logger
final Logger log = new Logger('rsg_test.dart', Level.debug);

/*
bool _isDcmStringChar(int char) =>
    (char >= kSpace && char < kDelete && char != kBackslash);
*/

/*
bool _isDcmTextChar(int char) => (char >= kSpace && char < kDelete);
*/

/*
bool _isDcmCodeStringChar(int c) =>
    (isUppercaseChar(c) || isDigitChar(c) || c == kSpace || c == kUnderscore);
*/

/*
int _charFilter(_CharPredicate pred, _CharGenerator genChar) {
  int getChar() {
    int c = genChar();
    return (pred(c)) ? c : getChar();
  }

  return getChar();
}
*/

/*
int _getTextChar(_CharPredicate pred, _CharGenerator genChar) {
  int getChar() {
    int c = genChar();
    return ((c >= kSpace && c < kDelete)) ? c : getChar();
  }

  return getChar();
}
*/

/// Random String Generator for DICOM Strings.
class RSG {
  /// An [int] that can be used to generate the same values repeatedly.
  final int seed;

  /// The Random Number Generator.
  final RNG rng;
  //TODO implement.
  /// [true] if [String]s should be padded to even length.
  final bool shouldPad;

  /// Creates a Random String Generator ([RSG]) using [RNG] from common.
  RSG([this.seed, this.shouldPad = true]) : rng = new RNG(seed);

  /// Returns a valid VR.kAE [String].
  String get aeString => shString;

  /// Returns a valid VR.kAS [String].
  String get asString => getAS();

  /// Returns a valid VR.kCS [String].
  String get csString => getCS();

  /// Returns a valid VR.kDA [String].
  String get daString => getDA();

  /// Returns a valid VR.kDS [String].
  String get dsString => getDS();

  /// Returns a valid VR.kDT [String].
  String get dtString => getDT();

  /// Returns a valid VR.kIS [String].
  String get isString => getIS();

  /// Returns a valid VR.kLO [String].
  String get loString => getLO();

  /// Returns a valid VR.kLT [String].
  String get ltString => getLT();

  /// Returns a valid VR.kPN [String].
  String get pnString => getPN();

  /// Returns a valid VR.kSH [String].
  String get shString => getSH();

  /// Returns a valid VR.kST [String].
  String get stString => getST();

  /// Returns a valid VR.kTM [String].
  String get tmString => getTM();

  /// Returns a valid VR.kUC [String].
  String get ucString => getUC();

  /// Returns a valid VR.kUC [String].
  String get uiString => getUI();

  /// Returns a valid VR.kUR [String].
  String get urString => getUR();

  /// Returns a valid VR.kUT [String].
  String get utString => getUT();

  /// Returns an ASCII Code Point.
  int _nextAscii() => rng.nextUint7;

  /// Returns an UTF-8 Code Unit.
  int _nextUtf8() => rng.nextUint8;

//  int _digitChar() => _charFilter(isDigitChar, _nextAscii);

//  int _getSign() => (rng.nextBool) ? 1 : -1;

  String _maybePlusPad(String s, bool isPositive, int maxLength) {
    if (s.length == maxLength) return s;
    var out = s;
    if (isPositive && rng.nextBool) out = '+$out';
    // Maybe add training kSpace
    if (out.length < maxLength && rng.nextBool) out = '$out ';
    // Maybe add leading kSpace
    if (out.length < maxLength && rng.nextBool) out = ' $out';
    return out;
  }

  int _getLength(int min, [int max]) {
    // If no max is given, or if min and max have the same value,
    // then [min] is returned.
    if (max == null || min == max) return min;
    assert(min <= max, 'min($min) > max($max)');
    int length = rng.nextUint(min, max);
    assert(length >= min && length <= max);
    return length;
  }

  String _getString(_CharGenerator genChar, int minLength, int maxLength) {
    int length = _getLength(minLength, maxLength);
    var bytes = new Uint8List(length);
    for (int i = 0; i < length; i++) bytes[i] = genChar();
    return new String.fromCharCodes(bytes);
  }

  /// Returns a [String] conforming to a DICOM String VR (SH, LO, UC).
  String getDcmString([int minLength, int maxLength]) {
    int _getChar() {
      int c = _nextAscii();
      return (c >= kSpace && c < kDelete && c != kBackslash) ? c : _getChar();
    }

    return _getString(_getChar, minLength, maxLength);
  }

  /// Returns a [String] conforming to a DICOM Text VR (ST, LT, UT).
  String getDcmText(int minLength, int maxLength) {
    int _getChar() {
      int c = _nextUtf8();
      return (c >= kSpace && c < kDelete) ? c : _getChar();
    }

    return _getString(_getChar, minLength, maxLength);
  }

  /// Generates a valid DICOM String for VR.kAE.
  String getAE([int min = 0, int max = 16]) => getSH(min, max);

  /// Generates a valid DICOM String for VR.kAS.
  String getAS() {
    const String tokens = 'DWMY';
    var tIndex = rng.nextInt(0, 3);
    var count = rng.nextInt(0, 999);
    return '${count.toString().padLeft(3, '0')}${tokens[tIndex]}';
  }

  /// Generates a valid DICOM String for VR.kCS.
  String getCS([int minLength = 1, int maxLength = 16]) {
    bool isValid(int c) =>
        isUppercaseChar(c) || isDigitChar(c) || c == kSpace || c == kUnderscore;

    int getChar() {
      int c = _nextUtf8();
      return (isValid(c)) ? c : getChar();
    }

    return _getString(getChar, minLength, 16);
  }

  /// Generates a valid DICOM String for VR.kDA.
  String getDA([int minLength = 8, int maxLength = 8]) => _getDateString();

  String _getDateString() => throw new UnimplementedError();

  /// Generates a valid DICOM String for VR.kDS.
  String getDS([int minLength = 1, int maxLength = 16]) =>
      getDSString(minLength, maxLength);

  /// Generates a valid DICOM String for VR.kDT.
  String getDT([int minLength = 2, int maxLength = 26]) =>
      _getTimeString(minLength, maxLength);

  String _getTimeString(int minLength, int maxLength) =>
      throw new UnimplementedError();

  /// Generates a valid DICOM String for VR.kDT.
  String getIS([int minLength = 1, int maxLength = 12]) {
    RangeError.checkValueInInterval(minLength, 0, 12);
    RangeError.checkValueInInterval(maxLength, minLength, 12);
    String s = rng.nextIntString(minLength, maxLength);
    RangeError.checkValidRange(1, s.length, 12);
    return s;
  }


  /// Generates a valid DICOM String for VR.kLO.
  String getLO([int min = 1, int max = 64]) => getDcmString(min, max);

  /// Generates a valid DICOM String for VR.kLO.
  String getLT([int min = 1, int max = 10240]) => getDcmText(min, max);

  /// Generates a valid DICOM String for VR.kSH.
  String getPN([int min = 1, int max = 64]) => _getPNString(min, max);

  //Urgent: this needs to generate the entire range of PN strings.
  String _getPNString([int minLength = 1, int maxLength = 64]) {
    int nParts = rng.getLength(1,  5);
    int partMax = 13;
    var sList = new List<String>(nParts);
    for(int i = 0; i < nParts; i++) {
      sList[i] = rng.nextAsciiWord(1, partMax);
    }
    var s = sList.join('^');
    log.debug('s.length: ${s.length}');
    RangeError.checkValidRange(1, s.length, 64);
    return s;
  }


  /// Generates a valid DICOM String for VR.kSH.
  String getSH([int min = 1, int max = 16]) {
    assert(min >= 1 && min <= 16);
    assert(max >= 1 && max <= 16);
    return getDcmString(min, max);
  }

  /// Generates a valid DICOM String for VR.kSH.
  String getST([int min = 1, int max = 1024]) => getDcmText(min, max);

  //Urgent TODO:
  /// Generates a valid DICOM String for VR.kTM.
  String getTM([int minLength = 2, int maxLength = 14])  {
    var dt = new DateTime.fromMillisecondsSinceEpoch(rng.nextUint32);
    var dts = dt.toIso8601String();
    var dtsDcm = dts.replaceAll(':', '');
    log.debug('TM: $dts');
    var ts = dtsDcm.substring(11);
    log.debug('TM: $ts');
    return ts;
  }

  /// Generates a valid DICOM String for VR.kUC.
  String getUC([int min = 1, int max = kMax32BitVFLength]) =>
      getDcmString(min, max);

  /// Generates a valid DICOM String for VR.kUC.
  String getUI([int min = 6, int max = 64]) {
    int limit = wkUids.length - 1;
    int index = rng.getLength(1, limit);
    print('getUI index: $index');
    return wkUids[index].asString;
  }


  /// Generates a valid DICOM String for VR.kUC.
  String getUR([int min = 7, int max = kMax32BitVFLength]) =>
      _getURString(min, max);

  String _getURString(int minLength, int maxLength) {
    int length = rng.getLength(1, 5);
    var parts = new List<String>(length);
    for(int i = 0; i < length; i++) parts[i] = rng.nextAsciiWord(3, 8);
    var path = parts.join('/');
    return (rng.nextBool) ? 'http:/$path' : '$path';
  }


  /// Generates a valid DICOM String for VR.kUC.
  String getUT([int min = 1, int max = kMax32BitVFLength]) =>
      getDcmText(min, max);

  /// Generates a valid DICOM String for VR.kIS.
  String _getIntString([int minLength = 1, int maxLength = 12]) {
    RangeError.checkValueInInterval(minLength, 1, 16);
    RangeError.checkValueInInterval(maxLength, minLength, 16);
    int limit = math.pow(10, 11);
    int v = rng.nextInt();
    var s = v.toString();
    RangeError.checkValueInInterval(s.length, 1, 12);
    return s;
  }

  /// Generates a valid DICOM String for VR.kDS in fixed point format.
  String getFixedDSString([int max = 16]) {
    int length = _getLength(1, max);
    assert(length >= 1 && length <= max);
    int iLength = (length ~/ 2);
    int fLength = length - iLength;
    assert(iLength + fLength == length);
//      print('iLength: $iLength, fLength: $fLength, max: $max');

    var v = _nextDouble() * math.pow(10, iLength);
    //  print('v shifted($iLength): $v');
    var s = v.toStringAsFixed(fLength);
    s = _maybePlusPad(s, !v.isNegative, 16);
    if (s.length > max) {
      int excess = s.length - max;
      int trim = (excess > fLength) ? fLength : excess;
      s = s.substring(0, s.length - trim);
    }
    print('s(${s.length}): $s');
    return s;
    //   return (s.length > 16) ? s.substring(0, 16 - fLength) : s;
  }

  /// Generates a valid DICOM String for VR.kDS in exponential format.
  String getExpoDSString([int maxLength = 10]) {
    int max = (maxLength > 16) ? 16 : maxLength;
    max = (max > 11) ? 11 : max;
    int fLength = _getLength(1, max);
    assert(fLength >= 1 && fLength <= 11);
    var v = _nextDouble();
    var s = v.toStringAsExponential(fLength);

    //  print('s(${s.length}): $s');
    if (s.length < 14) s = _maybePlusPad(s, !v.isNegative, 16);
    return s;
  }

  /// Generates a valid DICOM String for VR.kDS in fixed point format.
  /// Generates a valid DICOM String for VR.kDS in exponential format.
  String getPrecisionDSString([int maxLength = 11]) {
    int max = (maxLength > 12) ? 12 : maxLength;
    int pLength = _getLength(1, max);
    var v = _nextDouble();
    var s = v.toStringAsPrecision(pLength);
    s = _maybePlusPad(s, !v.isNegative, 16);
    return s;
  }

  double _nextDouble() => ((rng.nextBool) ? 1 : -1) * rng.nextDouble;

  // Returns a decimal [String].
  String getDSString([int minLength = 1, int maxLength = 16]) {
    int max = (maxLength > 16) ? 16 : maxLength;
    int length = _getLength(minLength, max);
    var type = rng.nextUint7 >> 5;
    String s;
    int iLength = _getLength(2, 14);
    int fLength = _getLength(1, 14 - iLength);

    //  print('type: $type');
    if (type == 0) {
      s = getFixedDSString(length);
      //  print('type0 s(${s.length}: $s');
    } else if (type == 1) {
      s = getExpoDSString(fLength);
      //  print('type1 s(${s.length}: $s');
    } else if (type == 2) {
      s = getPrecisionDSString(length);
      //  print('type2 s(${s.length}: $s');
    } else {
      // (type == 3)
      s = _getIntString(1, 16);
      //  print('type3 s(${s.length}: $s');
    }
    //  print('s(${s.length}): $s');
    return s;
  }

  List<String> _getList(_StringGenerator generate, int minLLength,
      int maxLLength, minVLength, maxVLength) {
    int length = _getLength(minLLength, maxLLength);
    var v = new List<String>(length);
    for (int i = 0; i < length; i++) v[i] = generate(minVLength, maxVLength);
    return v;
  }

  List<String> getDcmStringList(
          [int minLLength, int maxLLength, int minVLength, int maxVLength]) =>
      _getList(getDcmString, minLLength, maxLLength, minVLength, maxVLength);

  static const int defaultMaxListLength = 20;

  /// Returns a [List<String>] of VR.kAE values;
  List<String> getAEList(
      [int minLLength = 1,
      int maxLLength = defaultMaxListLength,
      int minVLength = 1,
      int maxVLength = 16]) {
    //   if (maxVLength > 16) return null;
    //   assert(minVLength > 0 && minVLength <= 16);
    //   assert(maxVLength >= minVLength && maxVLength <= 16);
    return _getList(getAE, minLLength, maxLLength, minVLength, maxVLength);
  }

  /// Returns a [List<String>] of VR.kAS values;
  List<String> getASList([int minVLength = 1, int maxVLength = 16]) =>
      [getAS()];

  /// Returns a [List<String>] of VR.kCS values;
  List<String> getCSList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 16]) =>
      _getList(getCS, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kDA values;
  List<String> getDAList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 16]) =>
      _getList(getDA, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kDS values;
  List<String> getDSList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 16]) =>
      _getList(getDSString, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kDT values;
  List<String> getDTList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 16]) =>
      _getList(getDT, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kIS values;
  List<String> getISList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 12]) =>
      _getList(getIS, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kLO values;
  List<String> getLOList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 16]) =>
      _getList(getLO, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kLT values;
  List<String> getLTList(
          [int minLLength = 1,
          int maxLLength = 1,
          int minVLength = 1,
          int maxVLength = 16]) =>
      _getList(getLT, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kPNvalues;
  List<String> getPNList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 16]) =>
      _getList(getPN, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kSH values;
  List<String> getSHList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 16]) =>
      _getList(getSH, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kST values;
  List<String> getSTList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 16]) =>
      _getList(getST, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kTM values;
  List<String> getTMList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 16]) =>
      _getList(getTM, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kUC values;
  List<String> getUCList(
          [int minLLength = 1,
          //    int maxLLength = kMax32BitVFLength,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 1024]) =>
      _getList(getUC, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kUI values;
  List<String> getUIList(
      [int minLLength = 1,
        int maxLLength = defaultMaxListLength,
        int minVLength = 1,
        int maxVLength = 64]) =>
      _getList(getUI, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kUR values;
  List<String> getURList([int minVLength = 1, int maxVLength = 16]) =>
      _getList(getUR, 1, 1, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kUT values;
  //TODO: test with larger max
  List<String> getUTList([int minVLength = 1, int maxVLength = 10240]) =>
      _getList(getUT, 1, 1, minVLength, maxVLength);
}
