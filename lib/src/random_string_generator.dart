// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:core/core.dart';

// ignore_for_file only_throw_errors

//Enhancement: if performance needs to be improved us StringBuffer.
//Enhancement: show that a normal distribution is generated

// Returns [true] if [char] satisfies predicate.
//typedef bool _CharPredicate(int char);

/// Returns a random integer
typedef int _CharGenerator();

typedef String _StringGenerator([int min, int max]);

/// Random String Generator for DICOM Strings.
class RSG {
  /// An [int] that can be used to generate the same values repeatedly.
  final int seed;

  /// The Random Number Generator.
  final RNG rng;

  //TODO implement.
  /// _true_ if [String]s should be padded to even length.
  final bool shouldPad;

  /// Creates a Random String Generator ([RSG]) using [RNG] from number.
  RSG({this.seed, this.shouldPad = true}) : rng = new RNG(seed);

  /// Returns a valid VR.kAE [String].
  String get aeString => shString;

  /// Returns a valid VR.kAS [String].
  String get asString => getValidAS();

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

  // If no max is given, or if min and max have the same value,
  // then [min] is returned.
  int _getLength(int min, [int max]) {
    if (max == null || min == max || max < min) return min;
    RangeError.checkValueInInterval(min, 0, 0xFFFF, 'min');
    RangeError.checkValueInInterval(max, min, 0xFFFF, 'max');

    assert(min <= max, 'min($min) > max($max)');
    final length = rng.nextUint(min, max);
    assert(length >= min && length <= max);
    return length;
  }

  String _getString(_CharGenerator genChar, int minLength, int maxLength) {
    final length = _getLength(minLength, maxLength);
    final bytes = new Uint8List(length);
    for (var i = 0; i < length; i++) bytes[i] = genChar();
    return new String.fromCharCodes(bytes);
  }

  /// Returns a [String] conforming to a DICOM String VR (SH, LO, UC).
  String getDcmString([int minLength, int maxLength]) =>
      _getString(_getDcmStringChar, minLength, maxLength);

  int _getDcmStringChar() {
    final c = rng.nextAscii;
    return ((c >= kSpace && c < kDelete) && c != kBackslash)
        ? c
        : _getDcmStringChar();
  }

  /// Returns a [String] conforming to a DICOM Text VR (ST, LT, UT).
  String getDcmText(int minLength, int maxLength) =>
      _getString(_getDcmTextChar, minLength, maxLength);

  int _getDcmTextChar() {
    final c = rng.nextUtf8;
    return (c >= kSpace && c < kDelete) ? c : _getDcmTextChar();
  }

  /// Generates a valid DICOM String for VR.kAE.
  String getAE([int min = 0, int max = 16]) => getSH(min, max);

  /// Generates a valid DICOM String for VR.kAS.
  /// Note: A count == 0 can only be in Days
  String getValidAS([int minDays = 0, int maxDays = 999]) {
    const tokens = 'DWMY';
    var tokenIndex = rng.nextUint(0, 3);
    final count = rng.nextUint(minDays, maxDays);
    if (count == 0) tokenIndex = 0;
    return '${count.toString().padLeft(3, '0')}${tokens[tokenIndex]}';
  }

  /// Generates a valid DICOM String for VR.kAS.
  String getInvalidAS([int minDays = 1000, int maxDays = 10000]) {
    String letter;
    do {
      final charCode = rng.nextAsciiVChar;
      letter = new String.fromCharCode(charCode);
    } while ('DWMY'.contains(letter));
    final count = rng.nextUint(minDays, maxDays);
    return '${count.toString()}$letter';
  }

  /// Generates a valid DICOM String for VR.kCS.
  String getCS([int minLength = 1, int maxLength = 16]) =>
      _getString(_getCSChar, minLength, 16);

  int _getCSChar() {
    final c = rng.nextAscii;
    return (_isValidCSChar(c)) ? c : _getCSChar();
  }

  bool _isValidCSChar(int c) =>
      isUppercaseChar(c) || isDigitChar(c) || c == kSpace || c == kUnderscore;

  /// Generates a valid DICOM String for VR.kDA.
  String getDA([int minLength = 8, int maxLength = 8]) {
    final us = toValidEpochMicrosecond(rng.nextMicrosecond);
    log.debug('DA : $us');
    assert(us >= kMinEpochMicrosecond && us <= kMaxEpochMicrosecond);
    // ignore: only_throw_errors
    if (isNotValidDateMicroseconds(us)) throw 'Invalid Date microseconds: $us';
    final date = microsecondToDateString(us);
    return date;
  }

  /// Generates an _invalid_ DICOM String for VR.kDA.
  String getInvalidDA([int minLength = 0, int maxLength = 16]) =>
    //TODO Sharath: implement
     null;


  String getDateString() => microsecondToDateString(rng.nextMicrosecond);

  /// Generates a valid DICOM String for VR.kDS.
  String getDS([int minLength = 1, int maxLength = 16]) =>
      getDSString(minLength, maxLength);

  /// Generates a valid DICOM String for VR.kDT.
  String getDT([int minIndex = 0, int maxIndex = 12]) {
    final us = toValidEpochMicrosecond(rng.nextMicrosecond);
    log.debug('DT: $us');
    // ignore: only_throw_errors
    if (isNotValidEpochMicroseconds(us)) throw 'Invalid Time microseconds: $us';
    final dt = microsecondToDateTimeString(us);
    final length = _getDateTimeLengthIndex(minIndex, maxIndex);
    //final length = _validDateTimeLengths[index];
    log.debug('DT: "$dt" length: $length');
    final dts = dt.substring(0, length);
    log.debug('DTS: "$dts"');
    return dts;
  }

  /// Generates an _invalid_ DICOM String for VR.kDA.
  String getInvalidDT([int minLength = 0, int maxLength = 64]) =>
    //TODO Sharath: implement
    null;

  static const _validDateTimeLengths = const <int>[
    4, 6, 8, 10, 12, 14, 16, 17, 18, 19, 20, 21, 26 // No reformat
  ];

  int _getDateTimeLengthIndex(int minIndex, int maxIndex) {
    RangeError.checkValueInInterval(minIndex, 0, 12);
    RangeError.checkValueInInterval(maxIndex, minIndex, 12);
    final offset = rng.nextInt(minIndex, maxIndex);
    return _validDateTimeLengths[offset];
  }

  String getTimeString() {
    final us = rng.nextMicrosecond % kMicrosecondsPerDay;
    return microsecondToTimeString(us);
  }

  /// Generates a valid DICOM String for VR.kDT.
  String getIS([int minLength = 1, int maxLength = 12]) {
    RangeError.checkValueInInterval(minLength, 0, 12);
    RangeError.checkValueInInterval(maxLength, minLength, 12);
    final s = rng.nextIntString(minLength, maxLength);
    RangeError.checkValidRange(1, s.length, 12);
    return s;
  }

  /// Generates a valid DICOM String for VR.kLO.
  String getLO([int min = 1, int max = 64]) => getDcmString(min, max);

  /// Generates a valid DICOM String for VR.kLO.
  String getLT([int min = 1, int max = 10240]) => getDcmText(min, max);

  /// Generates a valid DICOM String for VR.kSH.
  // Note: max is 63 to allow for adding '^' characters.
  String getPN([int min = 1, int max = 63]) => _getPNString(min, max);

  //TODO: this needs to generate the entire range of PN strings.
  String _getPNString([int minLength = 1, int maxLength = 64]) {
    final nParts = rng.getLength(1, 5);
    final partMax = 13;
    final sList = new List<String>(nParts);
    for (var i = 0; i < nParts; i++) {
      sList[i] = rng.nextAsciiWord(1, partMax);
    }
    var s = sList.join('^');
    log.debug('s.length: ${s.length}');
    if (s.length > 64) {
      s = s.substring(1, 64);
    }
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

  /// Generates a valid DICOM String for VR.kTM.
  String getTM([int minLength = 2, int maxLength = 13]) {
    final us = toTimeMicroseconds(rng.nextMicrosecond);
    log.debug('TM: $us');
    final time = microsecondToTimeString(us);
    final length = _getTimeLength(minLength, time.length);
    log.debug('TM: "$time" length: $length');
    final ts = time.substring(0, length);
    log.debug('TM: "$ts"');
    return ts;
  }

  /// Generates an _invalid_ DICOM String for VR.kTM.
  String getInvalidTM([int minLength = 0, int maxLength = 64]) =>
    //TODO Sharath: implement
  null;

  static const _validTimeLengths = const <int>[2, 4, 6, 8, 9, 10, 11, 12, 13];

  int _getTimeLength(int minVLength, int maxVlength) {
    final offset = rng.nextInt(0, _validTimeLengths.length - 1);
    return _validTimeLengths[offset];
  }

  /// Generates a valid DICOM String for VR.kUC.
  String getUC([int min = 1, int max = kMaxLongVF]) => getDcmString(min, max);

  /// Generates a valid DICOM String for VR.kUC.
  String getUI([int min = 6, int max = 64]) {
    final limit = wkUids.length - 1;
    final index = rng.getLength(1, limit);
    final v = wkUids[index].asString;
    log.debug('wkUid: "$v"');
    return v;
  }

  /// Generates a valid DICOM String for VR.kUC.
  String getUR([int min = 7, int max = kMaxLongVF]) => _getURString(min, max);

  String _getURString(int minLength, int maxLength) {
    final length = rng.getLength(1, 5);
    final parts = new List<String>(length);
    for (var i = 0; i < length; i++) parts[i] = rng.nextAsciiWord(3, 8);
    final path = parts.join('/');
    return (rng.nextBool) ? 'http:/$path' : '$path';
  }

  /// Generates a valid DICOM String for VR.kUC.
  String getUT([int min = 1, int max = kMaxLongVF]) => getDcmText(min, max);

  /// Generates a valid DICOM String for VR.kIS.
  String _getIntString([int minLength = 1, int maxLength = 12]) {
    RangeError.checkValueInInterval(minLength, 1, 16);
    RangeError.checkValueInInterval(maxLength, minLength, 16);
//    int limit = math.pow(10, 11);
    final v = rng.nextInt();
    final s = v.toString();
    RangeError.checkValueInInterval(s.length, 1, 12);
    return s;
  }

  /// Generates a valid DICOM String for VR.kDS in fixed point format.
  String getFixedDSString([int max = 16]) {
    final length = _getLength(1, max);
    assert(length >= 1 && length <= max);
    final iLength = (length ~/ 2);
    final fLength = length - iLength;
    assert(iLength + fLength == length);

    final v = _nextDouble() * math.pow(10, iLength);

    var s = v.toStringAsFixed(fLength);
    s = _maybePlusPad(s, !v.isNegative, 16);
    if (s.length > max) {
      final excess = s.length - max;
      final trim = (excess > fLength) ? fLength : excess;
      s = s.substring(0, s.length - trim);
    }
    assert(s.length <= 16);
    return s;
  }

  /// Generates a valid DICOM String for VR.kDS in exponential format.
  String getExpoDSString([int maxLength = 10]) {
    log.debug('maxLength: $maxLength');
    var max = (maxLength > 16) ? 16 : maxLength;
    max = (max > 10) ? 10 : max;
    final fLength = _getLength(1, max);
    log.debug('max: $max fLength: $fLength');
    assert(fLength >= 1 && fLength <= 10);
    final v = _nextDouble();
    log.debug('v: $v');
    var s = v.toStringAsExponential(fLength);
    if (s.length < 14) s = _maybePlusPad(s, !v.isNegative, 16);
    assert(s.length <= 16);
    return s;
  }

  /// Generates a valid DICOM String for VR.kDS in fixed point format.
  /// Generates a valid DICOM String for VR.kDS in exponential format.
  String getPrecisionDSString([int maxLength = 10]) {
    final max = (maxLength > 10) ? 10 : maxLength;
    final pLength = _getLength(1, max);
    final v = _nextDouble();
    var s = v.toStringAsPrecision(pLength);
    s =  _maybePlusPad(s, !v.isNegative, 16);
    assert(s.length <= 16);
    return s;
  }

  double _nextDouble() => ((rng.nextBool) ? 1 : -1) * rng.nextDouble;

  /// Returns a decimal [String].
  String getDSString([int minLength = 1, int maxLength = 16]) {
//    system.level = Level.debug2;
    final max = (maxLength > 16) ? 16 : maxLength;
    final length = _getLength(minLength, max);
    final type = rng.nextUint(0, 2);
    log.debug2('type: $type');
    String s;
    final iLength = _getLength(2, 13);
    final fLength = _getLength(1, 13 - iLength);

    if (type == 0) {
      s = getFixedDSString(length);
    } else if (type == 1) {
      s = getExpoDSString(fLength);
    } else if (type == 2) {
      s = getPrecisionDSString(length);
    } else {
      s = _getIntString(1, 16);
    }
    return s.trim();
  }

  List<String> _getList(_StringGenerator generate, int minLLength,
      int maxLLength, int minVLength, int maxVLength) {
    final length = _getLength(minLLength, maxLLength);
    final sList = new List<String>(length);
    for (var i = 0; i < length; i++)
      sList[i] = generate(minVLength, maxVLength);
    return sList;
  }

  /// Returns a [List] of DICOM [String]s that satisfy VRs of SH, LO, and UC.
  List<String> getDcmStringList(
          [int minLLength, int maxLLength, int minVLength, int maxVLength]) =>
      _getList(getDcmString, minLLength, maxLLength, minVLength, maxVLength);

  /// The default maximum [List] length, if no length is provided.
  static const int defaultMaxListLength = 20;

  /// Returns a [List<String>] of VR.kAE values;
  List<String> getAEList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 16]) =>
      _getList(getAE, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kAS values;
  List<String> getASList(
          [int minLLength = 1,
          int maxLLength = 1,
          int minDays = 0,
          int maxDays = 999]) =>
      (minDays >= 0 && maxDays <= 999)
          ? _getList(getValidAS, minLLength, maxLLength, minDays, maxDays)
          : _getList(getInvalidAS, minLLength, maxLLength, minDays, maxDays);

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

  /// Returns a [List<String>] of _invalid_ VR.kDA values;
  List<String> getInvalidDAList(
          [int minLLength = 0,
          int maxLLength = 16,
          int minVLength = 0,
          int maxVLength = 16]) =>
      _getList(getInvalidDA, minLLength, maxLLength, minVLength, maxVLength);

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
          int minIndex = 0,
          int maxIndex = 12]) =>
      _getList(getDT, minLLength, maxLLength, minIndex, maxIndex);

  /// Returns a [List<String>] of _invalid_ VR.kDT values;
  List<String> getInvalidDTList(
          [int minLLength = 0,
          int maxLLength = 32,
          int minVLength = 0,
          int maxVLength = 16]) =>
      _getList(getInvalidDT, minLLength, maxLLength, minVLength, maxVLength);

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

  /// Returns a [List<String>] of length 1 containing an VR.kLT values.
  /// _Note_: The [minLLength] and [maxLLength] are ignored.
  List<String> getLTList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
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

  /// Returns a [List<String>] of length 1 containing an VR.kST values.
  /// _Note_: The [minLLength] and [maxLLength] are ignored.
  List<String> getSTList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 64]) =>
      _getList(getST, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kTM values;
  List<String> getTMList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 2,
          int maxVLength = 13]) =>
      _getList(getTM, minLLength, maxLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of _invalid_ VR.kTM values;
  List<String> getInvalidTMList(
          [int minLLength = 0,
          int maxLLength = 16,
          int minVLength = 0,
          int maxVLength = 16]) =>
      _getList(getInvalidTM, minLLength, maxLLength, minVLength, maxVLength);

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
  List<String> getURList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 64]) =>
      _getList(getUR, minLLength, minLLength, minVLength, maxVLength);

  /// Returns a [List<String>] of VR.kUT values;
  List<String> getUTList(
          [int minLLength = 1,
          int maxLLength = defaultMaxListLength,
          int minVLength = 1,
          int maxVLength = 10240]) =>
      _getList(getUT, minLLength, maxLLength, minVLength, maxVLength);
}
