// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'dart:math';

import 'package:system/system.dart';

/// The Type of a function that generates [String]s, with length
/// between [min] and max].
typedef String StringGenerator([int min, int max]);

//TODO: doc and remove dead code
/// Returns a random [String].
String randomString(int length,
    {bool noLowerCase = true,
    bool noCharacter = false,
    bool noNumber = false,
    bool noSpecialCharacter = false,
    bool isDecimal = false}) {
  var rand = new Random();
  bool dotOne = false, keKEOne = false;
  int prevCode, plusMinusCount = 0, iterations = 0;
  var codeUnits = new List.generate(length, (index) {
    var alpha = rand.nextInt(122);
    while (!((!noCharacter && alpha >= ka && alpha <= kz && !noLowerCase) ||
            (!noCharacter && alpha >= kA && alpha <= kZ) ||
            (!noNumber && alpha >= k0 && alpha <= k9) ||
            (!noSpecialCharacter &&
                (alpha == kSpace || alpha == kUnderscore))) ||
        isDecimal) {
      iterations++;
      if (iterations > 500) break;
      if (isDecimal &&
          ((alpha >= k0 && alpha <= k9) ||
              (alpha == kDot ||
                  alpha == kE ||
                  alpha == ke ||
                  alpha == kPlusSign ||
                  alpha == kMinusSign))) {
        //if ((alpha == kPlusSign || alpha == kMinusSign) && (prevCode == null || prevCode == null)){
        //
        // }
        if ((index == length - 1) &&
            (alpha == kE ||
                alpha == ke ||
                alpha == kPlusSign ||
                alpha == kMinusSign)) {
          alpha = rand.nextInt(122);
          continue;
        }

        if ((prevCode == null && alpha == kE || alpha == ke) ||
            (prevCode == ke ||
                prevCode == kE &&
                    (alpha >= k0 && alpha <= k9 || alpha == kDot))) {
          alpha = rand.nextInt(122);
          continue;
        }

        if ((prevCode == kE || prevCode == ke || prevCode == null) &&
            (alpha == kPlusSign || alpha == kMinusSign) &&
            plusMinusCount < 3) {
          plusMinusCount++;
          prevCode = alpha;
          break;
        }

        if ((alpha == kPlusSign || alpha == kMinusSign) &&
            (prevCode == kDot ||
                (prevCode >= k0 && prevCode <= k9) ||
                prevCode == kMinusSign ||
                prevCode == kPlusSign)) {
          alpha = rand.nextInt(122);
          continue;
        }

        if ((alpha == kMinusSign ||
                alpha == kPlusSign ||
                alpha == ke ||
                alpha == kE) &&
            (prevCode == kMinusSign ||
                prevCode == kPlusSign ||
                prevCode == kDot)) {
          alpha = rand.nextInt(122);
          continue;
        }

        if ((prevCode == kPlusSign || prevCode == kMinusSign) &&
            alpha >= k0 &&
            alpha <= k9) {
          prevCode = alpha;
          break;
        }

        if ((dotOne && alpha == kDot) ||
            (keKEOne && (alpha == ke || alpha == kE)) ||
            (plusMinusCount > 2 &&
                (alpha == kPlusSign || alpha == kMinusSign))) {
          alpha = rand.nextInt(122);
          continue;
        }

        if (!dotOne && alpha == kDot) {
          dotOne = true;
          prevCode = alpha;
        }

        if (!keKEOne && (alpha == ke || alpha == kE)) {
          keKEOne = true;
          prevCode = alpha;
        }

        if (alpha >= k0 && alpha <= k9) {
          prevCode = alpha;
          break;
        }

        break;
      } else
        alpha = rand.nextInt(122);
    }
    return alpha;
  });

  return new String.fromCharCodes(codeUnits);
}

Random rand = new Random();

int getLength(int min, int max) {
  int n = rand.nextInt(max);
  if (n < min || n > max) return getLength(min, max);
  return n;
}

int nextChar() {
  int c = rand.nextInt(127);
  while (!isDcmTextChar(c)) c = rand.nextInt(kDelete - 1);
  return c;
}

bool isDcmChar(int char) =>
    (char >= kSpace && char < kDelete && char != kBackslash);

bool isDcmTextChar(int char) => (char >= kSpace && char < kDelete);

bool isDcmCodeStringChar(int c) =>
    (isUppercaseChar(c) || isDigitChar(c) || c == kSpace || c == kUnderscore);

typedef int CharFilter(int char);

CharFilter charPredicate(CharPredicate predicate) => (int index) {
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
  int length = getLength(minLength, maxLength);
  List<int> codeUnits = new List.generate(length, getDcmChar);
  return new String.fromCharCodes(codeUnits);
}

/// Generates a valid DICOM String for VR.kSH.
String generateDcmSHString([int min = 0, int max = 16]) =>
    generateDcmString(min, max);

/// Generates a valid DICOM String for VR.kLO.
String generateDcmLOString([int min = 0, int max = 64]) =>
    generateDcmString(min, max);

/// Generates a valid DICOM String for VR.kUC.
String generateDcmUCString([int min = 0, int max = kMaxLongVF]) =>
    generateDcmString(min, max);

/// Generates DICOM Text characters. All visible ASCII characters
/// (including Backslash), plus CR, LF, FF, and HT.
// TODO extend to handle valid ISO1022 escape sequences.
String generateDcmTextString(int minLength, int maxLength) {
  int length = getLength(minLength, maxLength);
  List<int> codeUnits = new List.generate(length, getTextChar);
  return new String.fromCharCodes(codeUnits);
}

/// Generates a valid DICOM String for VR.kSH.
String generateDcmSTString([int min = 0, int max = 16]) =>
    generateDcmTextString(min, max);

/// Generates a valid DICOM String for VR.kLO.
String generateDcmLTString([int min = 0, int max = 64]) =>
    generateDcmTextString(min, max);

/// Generates a valid DICOM String for VR.kUC.
String generateDcmUTString([int min = 0, int max = kMaxLongVF]) =>
    generateDcmTextString(min, max);

/*
/// Generates DICOM Text characters. All visible ASCII characters
/// are legal including Backslash.
String generateTextChar(int length) {
  var rand = new Random();
//  int iterations = 0;
  var codeUnits = new List.generate(length, (index) {
    var alpha = rand.nextInt(127);
    while ((alpha < kSpace || alpha == kDelete)) {
      /*iterations++;
      if (iterations > 500) break;*/
      alpha = rand.nextInt(126);
    }
    return alpha;
  });
  return new String.fromCharCodes(codeUnits);
}
*/

/// Generates DICOM Code String(CS) characters.
/// Visible ASCII characters, except Backslash.
String generateDcmCSString(int length) {
  var rand = new Random();
  int iterations = 0;
  var codeUnits = new List.generate(length, (index) {
    var alpha = rand.nextInt(127);
    while (!(isUppercaseChar(alpha) ||
        isDigitChar(alpha) ||
        alpha == kSpace ||
        alpha == kUnderscore)) {
      iterations++;
      if (iterations > 500) break;
      alpha = rand.nextInt(126);
    }
    return alpha;
  });
  return new String.fromCharCodes(codeUnits);
}

/// Generates a random Person name with specified number of groups [nGroups],
/// components [nComponents] and component length [maxComponentLength]
String generateDcmPersonName(
    int nGroups, int nComponents, int maxComponentLength) {
  List<String> listGroup = <String>[];
  for (int i = 0; i < nGroups; i++) {
    List<String> listComponent = <String>[];
    for (int j = 0; j < nComponents; j++) {
      var rand = new Random();
//      int iterations = 0;
      var codeUnits = new List.generate(maxComponentLength, (index) {
        var alpha = rand.nextInt(127);
        while (!(alpha >= kSpace &&
            alpha < kDelete &&
            alpha != kBackslash &&
            alpha != kCircumflex &&
            alpha != kEqual)) {
          alpha = rand.nextInt(126);
        }
        return alpha;
      });
      listComponent.add(new String.fromCharCodes(codeUnits));
    }
    listGroup.add(listComponent.join("^"));
  }
  return listGroup.join("=");
}
