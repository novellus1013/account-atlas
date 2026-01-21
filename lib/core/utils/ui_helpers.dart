import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyFormatter {
  static String formatCurrency(int amount, String locale, String symbol) {
    return NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 0,
    ).format(amount);
  }
}

//next billing date: 2026 - 02 - 12
String? billingTextFormatter(DateTime date) {
  final dateLabel =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  return 'Next: $dateLabel';
}

//price text : null or $16,99
String? priceTextFormatter(int amount, Currency currency) {
  final String locale = currency == Currency.en ? "en_Us" : "ko_Kr";
  final String symbol = currency == Currency.en ? '\$' : '₩';

  return MoneyFormatter.formatCurrency(amount, locale, symbol);
}

//show warning dialog
Future<bool?> showWarningPopDialog(
  BuildContext context,
  String title,
  String main,
  String btn,
) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: AppColor.black,
          fontWeight: FontWeight.bold,
          fontSize: AppTextSizes.xl,
        ),
      ),
      content: Text(main, style: TextStyle(color: AppColor.textGrey)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
          child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w500)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            btn,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColor.white,
            ),
          ),
        ),
      ],
    ),
  );
}
