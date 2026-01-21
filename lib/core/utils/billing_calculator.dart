import 'dart:math' as math;

import 'package:account_atlas/core/constants/app_color.dart';
import 'package:flutter/material.dart';

/// Utility class for billing-related calculations.
class BillingCalculator {
  const BillingCalculator._();

  /// Returns the last day of a given month.
  static int lastDayOfMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Gets the effective billing day for a given month.
  /// Handles months with fewer days (e.g., billing day 31 in February -> 28/29).
  static int getEffectiveDay(int year, int month, int billingDay) {
    final lastDay = lastDayOfMonth(year, month);
    return math.min(billingDay, lastDay);
  }

  /// Computes the next billing date based on the stored billing day.
  /// Returns the closest upcoming billing date from today.
  static DateTime computeNextBillingDate(DateTime storedNextBillingDate) {
    final billingDay = storedNextBillingDate.day;
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    // Try current month first
    final effectiveDayThisMonth = getEffectiveDay(
      today.year,
      today.month,
      billingDay,
    );
    final billingThisMonth = DateTime(
      today.year,
      today.month,
      effectiveDayThisMonth,
    );

    if (!billingThisMonth.isBefore(todayDateOnly)) {
      return billingThisMonth;
    }

    // Move to next month
    int nextMonth = today.month + 1;
    int nextYear = today.year;
    if (nextMonth > 12) {
      nextMonth = 1;
      nextYear++;
    }

    final effectiveDayNextMonth = getEffectiveDay(
      nextYear,
      nextMonth,
      billingDay,
    );
    return DateTime(nextYear, nextMonth, effectiveDayNextMonth);
  }

  /// Calculates D-day (days until next billing).
  static int calculateDDay(DateTime storedNextBillingDate) {
    final nextBilling = computeNextBillingDate(storedNextBillingDate);
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    return nextBilling.difference(todayDateOnly).inDays;
  }

  /// Calculates total spent based on subscription start date and monthly price.
  /// Counts billing events that have already occurred.
  static int calculateTotalSpent({
    required DateTime? subscriptionStartDate,
    required DateTime nextBillingDate,
    required int monthlyAmount,
  }) {
    if (subscriptionStartDate == null) return monthlyAmount;

    final billingDay = nextBillingDate.day;
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    int billingCount = 0;

    // Start from the subscription start date's month
    int year = subscriptionStartDate.year;
    int month = subscriptionStartDate.month;

    // Calculate the first billing date
    final effectiveStartDay = getEffectiveDay(year, month, billingDay);
    DateTime billingDate = DateTime(year, month, effectiveStartDay);

    // If subscription started after the billing day of that month, start from next month
    if (subscriptionStartDate.isAfter(billingDate)) {
      month++;
      if (month > 12) {
        month = 1;
        year++;
      }
    }

    // Count all billing dates up to and including today
    while (true) {
      final effectiveDay = getEffectiveDay(year, month, billingDay);
      billingDate = DateTime(year, month, effectiveDay);

      if (billingDate.isAfter(todayDateOnly)) {
        break;
      }

      // Only count if billing date is after or on subscription start
      if (!billingDate.isBefore(
        DateTime(
          subscriptionStartDate.year,
          subscriptionStartDate.month,
          subscriptionStartDate.day,
        ),
      )) {
        billingCount++;
      }

      month++;
      if (month > 12) {
        month = 1;
        year++;
      }

      // Safety limit to prevent infinite loop
      if (billingCount > 1000) break;
    }

    return billingCount * monthlyAmount;
  }
}

/// Result class for D-day colors.
class DDayColors {
  final Color backgroundColor;
  final Color textColor;

  const DDayColors({
    required this.backgroundColor,
    required this.textColor,
  });

  /// Gets the appropriate colors based on days until billing.
  factory DDayColors.fromDDay(int dDay) {
    if (dDay <= 3) {
      return const DDayColors(
        backgroundColor: AppColor.dDayUrgentBg,
        textColor: AppColor.dDayUrgentText,
      );
    } else if (dDay <= 7) {
      return const DDayColors(
        backgroundColor: AppColor.dDayWarningBg,
        textColor: AppColor.dDayWarningText,
      );
    }
    return const DDayColors(
      backgroundColor: AppColor.dDaySafeBg,
      textColor: AppColor.dDaySafeText,
    );
  }

  /// Formats D-day text (e.g., "D-Day", "D-3", "D-14")
  static String formatDDay(int dDay) {
    return dDay == 0 ? 'D-Day' : 'D-$dDay';
  }
}
