import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary colors
  static const Color primaryColor =
      Color(0xFFC5E1A5); // Colors.lightGreen.shade200
  static const Color primaryLight =
      Color(0xFFDCEDC8); // Colors.lightGreen.shade100
  static const Color primaryDark =
      Color(0xFFAED581); // Colors.lightGreen.shade300

  // Accent colors
  static const Color accentColor = Color(0xFF8BC34A); // Colors.lightGreen
  static const Color accentLight =
      Color(0xFF9CCC65); // Colors.lightGreen.shade400
  static const Color accentDark =
      Color(0xFF7CB342); // Colors.lightGreen.shade600

  // Semantic colors
  static const Color success = Color(0xFF4CAF50); // Colors.green
  static const Color warning = Color(0xFFFFC107); // Colors.amber
  static const Color error = Color(0xFFE57373); // Colors.red.shade300
  static const Color info = Color(0xFF64B5F6); // Colors.blue.shade300

  // Text colors
  static const Color textPrimary =
      Color(0xFF212121); // Dark for light backgrounds
  static const Color textSecondary = Color(0xFF757575); // Medium gray
  static const Color textHint = Color(0xFFBDBDBD); // Light gray
  static const Color textOnPrimary =
      Color(0xFF33691E); // Dark green for primary background
  static const Color textOnDark =
      Color(0xFFF5F5F5); // Light for dark backgrounds

  // Background colors
  static const Color background = Color(0xFFF5F5F5); // Light gray background
  static const Color backgroundDark =
      Color(0xFFE0E0E0); // Darker gray background
  static const Color cardBackground = Color(0xFFFFFFFF); // White for cards
  static const Color scaffoldBackground = Color(0xFFFAFAFA); // Very light gray

  // Border colors
  static const Color border = Color(0xFFE0E0E0); // Light gray borders
  static const Color divider = Color(0xFFBDBDBD); // Medium gray dividers
}
