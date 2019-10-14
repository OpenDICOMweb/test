// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.
//
import 'dart:math';

import 'package:charcode/ascii.dart';
import 'package:base/base.dart';

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

/// The Type of a function that generates [String]s, with length
/// between [min] and max].
typedef StringGenerator = String Function([int min, int max]);

//TODO: doc and remove dead code
/// Returns a random [String].
String randomString(int length,
    {bool noLowerCase = true,
    bool noCharacter = false,
    bool noNumber = false,
    bool noSpecialCharacter = false,
    bool isDecimal = false}) {
  final rand = Random();
  var dotOne = false, keKEOne = false;
  int prevCode, plusMinusCount = 0, iterations = 0;
  final codeUnits = List.generate(length, (index) {
    var alpha = rand.nextInt(122);
    while (!((!noCharacter && alpha >= $a && alpha <= $z && !noLowerCase) ||
            (!noCharacter && alpha >= $A && alpha <= $Z) ||
            (!noNumber && alpha >= $0 && alpha <= $9) ||
            (!noSpecialCharacter &&
                (alpha == $space || alpha == $underscore))) ||
        isDecimal) {
      iterations++;
      if (iterations > 500) break;
      if (isDecimal &&
          ((alpha >= $0 && alpha <= $9) ||
              (alpha == $dot ||
                  alpha == $E ||
                  alpha == $e ||
                  alpha == $plus ||
                  alpha == $minus))) {
        if ((index == length - 1) &&
            (alpha == $E || alpha == $e || alpha == $plus || alpha == $minus)) {
          alpha = rand.nextInt(122);
          continue;
        }

        if ((prevCode == null && alpha == $E || alpha == $e) ||
            (prevCode == $e ||
                prevCode == $E &&
                    (alpha >= $0 && alpha <= $9 || alpha == $dot))) {
          alpha = rand.nextInt(122);
          continue;
        }

        if ((prevCode == $E || prevCode == $e || prevCode == null) &&
            (alpha == $plus || alpha == $minus) &&
            plusMinusCount < 3) {
          plusMinusCount++;
          prevCode = alpha;
          break;
        }

        if ((alpha == $plus || alpha == $minus) &&
            (prevCode == $dot ||
                (prevCode >= $0 && prevCode <= $9) ||
                prevCode == $minus ||
                prevCode == $plus)) {
          alpha = rand.nextInt(122);
          continue;
        }

        if ((alpha == $minus || alpha == $plus || alpha == $e || alpha == $E) &&
            (prevCode == $minus || prevCode == $plus || prevCode == $dot)) {
          alpha = rand.nextInt(122);
          continue;
        }

        if ((prevCode == $plus || prevCode == $minus) &&
            alpha >= $0 &&
            alpha <= $9) {
          prevCode = alpha;
          break;
        }

        if ((dotOne && alpha == $dot) ||
            (keKEOne && (alpha == $e || alpha == $E)) ||
            (plusMinusCount > 2 && (alpha == $plus || alpha == $minus))) {
          alpha = rand.nextInt(122);
          continue;
        }

        if (!dotOne && alpha == $dot) {
          dotOne = true;
          prevCode = alpha;
        }

        if (!keKEOne && (alpha == $e || alpha == $E)) {
          keKEOne = true;
          prevCode = alpha;
        }

        if (alpha >= $0 && alpha <= $9) {
          prevCode = alpha;
          break;
        }

        break;
      } else
        alpha = rand.nextInt(122);
    }
    return alpha;
  });

  return String.fromCharCodes(codeUnits);
}

/*
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





*/

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
/*



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
*/

/// Generates DICOM Code String(CS) characters.
/// Visible ASCII characters, except Backslash.
String generateCSString(int length) {
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

/// Generates DICOM String characters
/// Visible ASCII characters, except Backslash.
String generateDcmString(int minLength, int maxLength) {
  final length = getLength(minLength, maxLength);
  final codeUnits = List.generate(length, getDcmChar);
  return String.fromCharCodes(codeUnits);
}

/// Generates a valid DICOM String for VR.kSH.
String generateSHString([int min = 0, int max = 16]) =>
    generateDcmString(min, max);

/// Generates a valid DICOM String for VR.kLO.
String generateLOString([int min = 0, int max = 64]) =>
    generateDcmString(min, max);

/// Generates a valid DICOM String for VR.kUC.
String generateUCString([int min = 0, int max = kMaxLongVF]) =>
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
