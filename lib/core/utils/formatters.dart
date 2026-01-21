import 'package:flutter/services.dart';

/// Utility class for formatting values consistently across the app.
class AppFormatters {
  const AppFormatters._();

  /// Formats an integer with thousand separators (e.g., 1234567 -> "1,234,567")
  static String formatPrice(int amount) {
    if (amount == 0) return '0';
    final digits = amount.toString();
    final buffer = StringBuffer();
    final length = digits.length;
    for (int i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  /// Formats a price with currency symbol (e.g., 14990 -> "$14,990")
  static String formatPriceWithSymbol(int amount, {String symbol = '\$'}) {
    return '$symbol${formatPrice(amount)}';
  }

  /// Formats a DateTime to "yyyy.MM.dd" format
  static String formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year.$month.$day';
  }

  /// Formats a DateTime to a more readable format (e.g., "Jan 15, 2024")
  static String formatDateReadable(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// Input formatter that adds thousand separators as user types.
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    final numericOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (numericOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Format with commas
    final formatted = AppFormatters.formatPrice(int.parse(numericOnly));

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Parses a formatted string back to integer
  static int parseToInt(String formatted) {
    final digitsOnly = formatted.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(digitsOnly) ?? 0;
  }
}
