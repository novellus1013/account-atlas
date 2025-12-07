import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  //함수 - ThemeData light() - 대신 getter를 사용하면, AppTheme.ligth() 대신 AppTheme.light 로 호출 가능

  static ThemeData get light {
    // flutter에서 기본적으로 제공하는 light 테마를 가져온 후, 필요한 값만 덮어씌우기
    final base = ThemeData.light();

    // 재사용성을 위해 colorScheme와 textTheme 정의
    final colorScheme = ColorScheme.light(
      primary: AppColor.primary, // 주요 색, 버튼 등
      secondary: AppColor.secondary,
      surface: AppColor.backgroundGrey, // Scaffold 기본 배경 색
      error: AppColor.error, // 에러 색
    );

    // colorScheme의 경우 불필요한 값들을 가져오지 않기 위해 copyWith를 사용하지 않는다.
    final textTheme = base.textTheme.copyWith(
      displayLarge: base.textTheme.displayLarge?.copyWith(
        fontSize: AppTextSizes.base,
      ),
      displayMedium: base.textTheme.displayMedium?.copyWith(
        fontSize: AppTextSizes.md,
      ),
      displaySmall: base.textTheme.displaySmall?.copyWith(
        fontSize: AppTextSizes.sm,
        color: AppColor.textGrey,
      ),

      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontSize: AppTextSizes.display,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontSize: AppTextSizes.xl,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.textTheme.titleSmall?.copyWith(
        fontSize: AppTextSizes.lg,
        fontWeight: FontWeight.w600,
      ),
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: AppColor.black,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: AppColor.black,
          // 공통 크기를 할당해주기 위함
          minimumSize: const Size(80, 44),

          padding: EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.basic,
          ),
          textStyle: TextStyle(
            inherit: false,
            fontSize: AppTextSizes.base,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      dividerColor: AppColor.borderGrey,
    );
  }
}
