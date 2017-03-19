// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:common/ascii.dart';
import 'package:common/logger.dart';
import 'package:common/random.dart';

final Logger log = new Logger('rsg_test.dart', watermark: Severity.info);

bool isDcmStringChar(int char) =>
    (char >= kSpace && char < kDelete && char != kBackslash);

bool isDcmTextChar(int char) => (char >= kSpace && char < kDelete);

bool isDcmCodeStringChar(int c) =>
    (isUppercaseChar(c) || isDigitChar(c) || c == kSpace || c == kUnderscore);

typedef bool CharPredicate(int char);

typedef int CharFilter(int char);

typedef int CharGenerator();

int _charFilter(CharPredicate pred, CharGenerator genChar) {
  log.debug('_charFilter: $pred, $genChar');
  int c = genChar();
  log.debug('_charFilter: c1: $c');
  while (!pred(c)) {
    log.debug('_charFilter: c: $c, pred(c)${pred(c)}');
    c = genChar();
  }
  log.debug('_charFilter: return $c');
  return c;
}

typedef String StringGenerator(int length);

/*
CharFilter charPredicate(predicate) => (int index) {
  var char = nextChar();
  while (!predicate(char)) char = nextChar();
  return char;
};
*/
class RSG {
    final int seed;
    final RNG rng;

    /// Creates a Random String Generator ([RSG]) using [RNG] from common.
    RSG([this.seed]) : rng =  new RNG(seed);

    int _nextAscii() => rng.nextAscii;
    int _nextUtf8() => rng.nextUtf8;

    /// Returns a DICOM String character (SH, LO, UC)
    int _dcmChar() => _charFilter(isDcmStringChar, _nextAscii);

    /// Returns a DICOM Text character (ST, LT, UT)
    int _textChar() => _charFilter(isDcmTextChar, _nextUtf8);

    int _codeStringChar() => _charFilter(isDcmStringChar, _nextAscii);

    int _digitChar() => _charFilter(isDigitChar, _nextAscii);

    String _getString(CharGenerator genChar, int length) {
      log.debug('_getString $genChar, length($length)');
      var bytes = new Uint8List(length);
      log.debug('_getString bytes length(${bytes.length})');
      for (int i = 0; i < length; i++) {
        log.debug('_getString i: $i');
        int c = genChar();
        log.debug('genChar: $c');
        bytes[i] = c;
      }
      return new String.fromCharCodes(bytes);
    }


    String dcmString(int length) => _getString(_dcmChar, length);
    String dcmTextString(int length) => _getString(_textChar, length);
    String dcmCodeString(int length) => _getString(_codeStringChar, length);
    String dcmDigitString(int length) => _getString(_digitChar, length);
}