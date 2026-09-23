import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // biar gak bisa di-instantiate

  static const Color primary = Color(0xFF3B6FE0);
  static const Color primaryLight = Color(0xFF6B94EC);
  static const Color primaryDark = Color(0xFF2A52B0);

  // Neutral / Background
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F7FA);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border / Divider
  static const Color border = Color(0xFFE0E3E8);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Inactive elements (misal dot indicator yang belum aktif)
  static const Color inactive = Color(0xFFD1D5DB);
}
