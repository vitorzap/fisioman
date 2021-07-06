import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class DateTextFormatter extends TextInputFormatter {
  static const _maxChars = 8;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = _format(newValue.text, '/');
    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  String _format(String value, String seperator) {
    value = value.replaceAll(seperator, '');
    var newString = '';

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      newString += value[i];
      if ((i == 1 || i == 3) && i != value.length - 1) {
        newString += seperator;
      }
    }

    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}

bool dateStringValid(String dateTocheck) {
  if (dateTocheck.length != 10) {
    return false;
  } else {
    if (dateTocheck.substring(2, 3) != '/' ||
        dateTocheck.substring(5, 6) != '/') {
      return false;
    }
    final mes = int.parse(dateTocheck.substring(3, 5));
    final dia = int.parse(dateTocheck.substring(0, 2));
    final year = int.parse(dateTocheck.substring(6, 10));
    if (mes > 12) {
      return false;
    }
    if ((mes == 1) ||
        (mes == 3) ||
        (mes == 5) ||
        (mes == 7) ||
        (mes == 8) ||
        (mes == 10) ||
        (mes == 12)) {
      if (dia > 31) {
        return false;
      }
    } else {
      if (mes != 2) {
        if (dia > 30) {
          return false;
        }
      } else {
        if ((year % 4) == 0) {
          if (dia > 29) {
            return false;
          }
        } else {
          if (dia > 28) {
            return false;
          }
        }
      }
    }
  }
  return true;
}
