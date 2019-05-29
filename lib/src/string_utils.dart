// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.
//
import 'dart:math';

import 'package:charcode/ascii.dart';

/// The Type of a function that generates [String]s, with length
/// between [min] and max].
typedef StringGenerator = String Function([int min, int max]);

Random _rng = Random();

/// Returns a random length between [min] and [max] inclusive.
int getLength(int min, int max) {
  final n = _rng.nextInt(max);
  if (n < min || n > max) return getLength(min, max);
  return n;
}

/// Generate a random Non-Text character code.
int nextChar() {
  var c = _rng.nextInt(127);
  while (!isDcmTextChar(c)) c = _rng.nextInt($del - 1);
  return c;
}

/// Returns true if [c] is an uppercase ASCII character.
bool isUppercaseChar(int c) => c >= $A && c <= $Z;

/// Returns true if [c] is a valid ASCII digit.
bool isDigitChar(int c) =>
    c >= $0 && c < $backslash || c > $backslash && c < $del;

/// Returns true if [c] is a valid DICOM String character code.
bool isDcmChar(int c) => c >= $space && c < $del && c != $backslash;

/// Returns true if [c] is a valid DICOM Text character code.
bool isDcmTextChar(int c) => c >= $space && c < $del;

/// Returns true if [c] is a valid DICOM Code String character code.
bool isDcmCodeStringChar(int c) =>
    isUppercaseChar(c) || isDigitChar(c) || c == $space || c == $underscore;

typedef CharFilter = int Function(int char);

typedef CharPredicate = bool Function(int char);

/// Generates a random character generator that satisfies [predicate].
CharFilter charPredicate(CharPredicate predicate) => (index) {
      var char = nextChar();
      while (!predicate(char)) char = nextChar();
      return char;
    };

/// Returns a DICOM String character (SH, LO, UC).
/// Visible ASCII characters, except Backslash.
CharFilter getDcmChar = charPredicate(isDcmChar);

/// Returns a DICOM Text character (ST, LT, UT)
CharFilter getTextChar = charPredicate(isDcmTextChar);

/// Generates DICOM String characters
/// Visible ASCII characters, except Backslash.
String generateDcmString(int minLength, int maxLength) {
  final length = getLength(minLength, maxLength);
  final codeUnits = List.generate(length, getDcmChar);
  return String.fromCharCodes(codeUnits);
}

/// Generates a valid DICOM String for VR.kSH.
String gemerateSHString([int min = 0, int max = 16]) =>
    generateDcmString(min, max);

/// Generates a valid DICOM String for VR.kLO.
String gemerateLOString([int min = 0, int max = 64]) =>
    generateDcmString(min, max);

const kMaxLongVF = 0xFFFFFFFF - 1;

/// Generates a valid DICOM String for VR.kUC.
String gemerateUCString([int min = 0, int max = kMaxLongVF]) =>
    generateDcmString(min, max);

/// Generates DICOM Text characters. All visible ASCII characters
/// (including Backslash), plus CR, LF, FF, and HT.
// TODO extend to handle valid ISO1022 escape sequences.
String generateDcmTextString(int minLength, int maxLength) {
  final length = getLength(minLength, maxLength);
  final codeUnits = List.generate(length, getTextChar);
  return String.fromCharCodes(codeUnits);
}

/// Generates a valid DICOM String for VR.kSH.
String generateSTString([int min = 0, int max = 16]) =>
    generateDcmTextString(min, max);

/// Generates a valid DICOM String for VR.kLO.
String generateLTString([int min = 0, int max = 64]) =>
    generateDcmTextString(min, max);

/// Generates a valid DICOM String for VR.kUC.
String generateUTString([int min = 0, int max = kMaxLongVF]) =>
    generateDcmTextString(min, max);

/*
/// Generates DICOM Text characters. All visible ASCII characters
/// are legal including Backslash.
String generateTextChar(int length) {
  var rand =  Random();
//  int iterations = 0;
  var codeUnits =  List.generate(length, (index) {
    var alpha = rand.nextInt(127);
    while ((alpha < kSpace || alpha == $del)) {
      /*iterations++;
      if (iterations > 500) break;*/
      alpha = rand.nextInt(126);
    }
    return alpha;
  });
  return  String.fromCharCodes(codeUnits);
}
*/

/// Generates DICOM Code String(CS) characters.
/// Visible ASCII characters, except Backslash.
String gemerateCSString(int length) {
  final rand = Random();
  var iterations = 0;
  final codeUnits = List.generate(length, (index) {
    var alpha = rand.nextInt(127);
    while (!(isUppercaseChar(alpha) ||
        isDigitChar(alpha) ||
        alpha == $space ||
        alpha == $underscore)) {
      iterations++;
      if (iterations > 500) break;
      alpha = rand.nextInt(126);
    }
    return alpha;
  });
  return String.fromCharCodes(codeUnits);
}

/// Generates a random Person name with specified number of groups [nGroups],
/// components [nComponents] and component length [maxComponentLength]
String generateDcmPersonName(
    int nGroups, int nComponents, int maxComponentLength) {
  final listGroup = <String>[];
  for (var i = 0; i < nGroups; i++) {
    final listComponent = <String>[];
    for (var j = 0; j < nComponents; j++) {
      final rand = Random();
//      int iterations = 0;
      final codeUnits = List.generate(maxComponentLength, (index) {
        var alpha = rand.nextInt(127);
        while (!(alpha >= $space &&
            alpha < $del &&
            alpha != $backslash &&
            alpha != $circumflex &&
            alpha != $equal)) {
          alpha = rand.nextInt(126);
        }
        return alpha;
      });
      listComponent.add(String.fromCharCodes(codeUnits));
    }
    listGroup.add(listComponent.join('^'));
  }
  return listGroup.join('=');
}
