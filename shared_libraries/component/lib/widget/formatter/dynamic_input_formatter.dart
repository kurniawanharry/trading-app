import 'package:flutter/services.dart';

class DynamicInputFormatter extends TextInputFormatter {
  final int decimalRange;
  DynamicInputFormatter({required this.decimalRange}) : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    if (text == '.') {
      return TextEditingValue(
        text: '0.',
        selection: const TextSelection.collapsed(offset: 2),
      );
    }

    final sanitized = _sanitize(text);
    final regex = RegExp(r'^\d*\.?\d{0,' + decimalRange.toString() + r'}$');
    if (!regex.hasMatch(sanitized)) {
      return oldValue;
    }

    final stripped = _stripLeadingZeros(sanitized);
    return TextEditingValue(
      text: stripped,
      selection: TextSelection.collapsed(offset: stripped.length),
    );
  }

  String _sanitize(String input) {
    final parts = input.split('.');
    final before = parts[0].replaceAll(RegExp(r'[^0-9]'), '');
    final after = parts.length > 1 ? parts[1].replaceAll(RegExp(r'[^0-9]'), '') : '';
    return after.isEmpty ? before : '$before.$after';
  }

  String _stripLeadingZeros(String input) {
    if (input.startsWith('0') && input.length > 1 && !input.startsWith('0.')) {
      return input.replaceFirst(RegExp(r'^0+'), '');
    }
    return input;
  }
}
