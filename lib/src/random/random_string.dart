// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Sharath chandra  <sharath.ch@mwebware.com>
// See the AUTHORS file for other contributors.

import 'dart:math';
import 'package:common/common.dart';


String _randomString(int length,
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