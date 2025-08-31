import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF4C5454);
  static const Color secondaryColor = Color(0xFFFBAF03);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF4F4F4);
  static const Color cardBackgroundColor = Color(0xFF454AA6);
  static const Color textPrimaryColor = Color(0xFF000000);
  static const Color textSecondaryColor = Color(0xFF000000);
  static const Color dividerColor = Color(0xFFF2F2F2);

  // Text styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    color: secondaryColor,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 19.89,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    color: primaryColor,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: AppConstants.titleFontSize,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: AppConstants.titleFontSize,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: AppConstants.titleFontSize,
    fontWeight: FontWeight.w400,
    color: textPrimaryColor,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: AppConstants.bodyFontSize,
    fontWeight: FontWeight.w400,
    color: textSecondaryColor,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: AppConstants.smallFontSize,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: 1.5,
    fontFamily: 'Roboto',
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    color: primaryColor,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    color: Colors.white,
  );

  // Button style
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: textPrimaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    minimumSize: const Size(0, 38),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  // Card decoration
  static final BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: backgroundColor,
  );

  static final BoxDecoration railPillDecoration = BoxDecoration(
    color: dividerColor,
    borderRadius: BorderRadius.circular(12),
  );

  // Spacing
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 12;
  static const double spacingL = 16;
  static const double spacingXL = 20;
  static const double spacingXXL = 24;

  // Border radius
  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 16;
  static const double radiusXL = 20;

  // Card heights
  static const double heightHC1 = AppConstants.heightHC1;
  static const double heightHC3 = AppConstants.heightHC3;
  static const double heightHC5 = AppConstants.heightHC5;
  static const double heightHC6 = AppConstants.heightHC6;
  static const double heightHC9 = AppConstants.heightHC9;
}
