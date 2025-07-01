import 'package:flutter/services.dart';

class AmountInputFormatter extends TextInputFormatter {
  final int decimalRange;

  AmountInputFormatter({this.decimalRange = 8}) : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    if (newText == '.') {
      return TextEditingValue(
        text: '0.',
        selection: const TextSelection.collapsed(offset: 2),
      );
    }

    // Allow only digits and one "."
    final sanitized = _sanitizeInput(newText);

    // Limit decimal places
    final regex = RegExp(r'^\d*\.?\d{0,' + decimalRange.toString() + r'}$');
    if (!regex.hasMatch(sanitized)) {
      return oldValue;
    }

    final formatted = _stripLeadingZeros(sanitized);
    final offset = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  String _sanitizeInput(String input) {
    int dotIndex = input.indexOf('.');
    if (dotIndex >= 0) {
      final beforeDot = input.substring(0, dotIndex).replaceAll(RegExp(r'[^0-9]'), '');
      final afterDot = input.substring(dotIndex + 1).replaceAll(RegExp(r'[^0-9]'), '');
      return '$beforeDot.$afterDot';
    } else {
      return input.replaceAll(RegExp(r'[^0-9]'), '');
    }
  }

  String _stripLeadingZeros(String input) {
    if (input.startsWith('0') && input.length > 1 && !input.startsWith('0.')) {
      return input.replaceFirst(RegExp(r'^0+'), '');
    }
    return input;
  }
}
