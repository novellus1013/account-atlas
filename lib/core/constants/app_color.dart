import 'package:flutter/material.dart';

class AppColor {
  const AppColor._();

  static const primary = Color(0xFF1e3a8a);
  static const secondary = Color(0xFFF59E0B);

  static const black = Colors.black;
  static const white = Colors.white;
  static const error = Color(0xFFE53935);
  static const success = Color(0xFF16A34A);

  // Grey scale (Tailwind grey 기반)
  static const grey50 = Color(0xFFF9FAFB);
  static const grey100 = Color(0xFFF3F4F6);
  static const grey200 = Color(0xFFE5E7EB);
  static const grey300 = Color(0xFFD1D5DB);
  static const grey400 = Color(0xFF9CA3AF);
  static const grey500 = Color(0xFF6B7280);
  static const grey600 = Color(0xFF4B5563);
  static const grey700 = Color(0xFF374151);
  static const grey800 = Color(0xFF1F2937);
  static const grey900 = Color(0xFF111827);

  static const backgroundGrey = Color(0xFFF5F5F5);
  static const borderGrey = Color(0xFFE0E0E0);
  static const textGrey = Color(0xFF616161);

  // D-day badges 전용 색상
  static const dDayUrgentBg = Color(0xFFFEE2E2);
  static const dDayUrgentText = Color(0xFFDC2626);
  static const dDayWarningBg = Color(0xFFFEF3C7);
  static const dDayWarningText = Color(0xFFD97706);
  static const dDaySafeBg = Color(0xFFDCFCE7);
  static const dDaySafeText = Color(0xFF16A34A);
}
