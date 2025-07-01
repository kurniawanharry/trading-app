import 'package:flutter/services.dart';

class PriceInputFormatter extends TextInputFormatter {
  final int decimalRange;

  PriceInputFormatter({this.decimalRange = 8}) : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    // Empty or just "." → allow "0."
    if (newText == '.') {
      return TextEditingValue(
        text: '0.',
        selection: TextSelection.collapsed(offset: 2),
      );
    }

    // Regex to allow only valid decimal numbers
    final regex = RegExp(r'^\d*\.?\d{0,' + decimalRange.toString() + r'}$');

    // Reject input if it doesn't match valid pattern
    if (!regex.hasMatch(newText)) {
      return oldValue;
    }

    return newValue;
  }
}
