import 'package:flutter/material.dart';

/// Cerebellum OS Design System
/// Fitness OS Inspired - Vibrant, energetic, motivational
class DesignTokens {
  // ============================================================================
  // COLORS - FITNESS OS INSPIRED
  // ============================================================================
  
  /// Primary accent colors - Vibrant Orange & Electric Blue
  static const Color primary = Color(0xFFFF6B35);        // Vibrant Orange
  static const Color primaryDark = Color(0xFFE55A2B);    // Darker Orange
  static const Color primaryLight = Color(0xFFFF8A65);   // Light Orange
  
  /// Secondary accent - Electric Blue
  static const Color secondary = Color(0xFF00D4FF);      // Electric Blue
  static const Color secondaryDark = Color(0xFF00B8E6);  // Darker Blue
  static const Color secondaryLight = Color(0xFF4DE2FF); // Light Blue
  
  /// Backgrounds - Modern dark with subtle warmth
  static const Color backgroundPrimary = Color(0xFF0F0F0F);   // Deep Black
  static const Color backgroundSecondary = Color(0xFF1A1A1A); // Dark Gray
  static const Color backgroundTertiary = Color(0xFF2A2A2A);  // Medium Gray
  
  /// Surface colors with fitness energy
  static const Color surfaceDefault = Color(0xFF1E1E1E);
  static const Color surfaceElevated = Color(0xFF2D2D2D);
  static const Color surfaceHover = Color(0xFF3A3A3A);
  
  /// Text colors - High contrast for readability
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8B8B8);
  static const Color textTertiary = Color(0xFF888888);
  static const Color textDisabled = Color(0xFF555555);
  
  /// Border colors with subtle energy
  static const Color borderDefault = Color(0xFF404040);
  static const Color borderSubtle = Color(0xFF2A2A2A);
  static const Color borderStrong = Color(0xFF606060);
  static const Color borderAccent = Color(0xFFFF6B35);  // Orange border for highlights
  
  /// Semantic colors - Fitness motivated
  static const Color success = Color(0xFF00E676);        // Bright Green
  static const Color warning = Color(0xFFFFAB00);        // Amber
  static const Color error = Color(0xFFFF5252);          // Bright Red
  static const Color info = Color(0xFF00D4FF);           // Electric Blue
  
  /// Fitness-specific colors
  static const Color energyOrange = Color(0xFFFF6B35);   // Main energy color
  static const Color powerBlue = Color(0xFF00D4FF);      // Power/focus color
  static const Color successGreen = Color(0xFF00E676);   // Achievement color
  static const Color warningAmber = Color(0xFFFFAB00);   // Caution color
  static const Color motivationPurple = Color(0xFF9C27B0); // Motivation color
  static const Color focusTeal = Color(0xFF00BCD4);      // Focus/calm color
  
  // ============================================================================
  // TYPOGRAPHY
  // ============================================================================
  
  /// Display text (page titles)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );
  
  /// Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.2,
    height: 1.3,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0,
    height: 1.4,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0,
    height: 1.4,
  );
  
  /// Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.5,
  );
  
  /// Labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    letterSpacing: 0.1,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    letterSpacing: 0.3,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: textTertiary,
    letterSpacing: 0.5,
  );
  
  /// Data/Numbers - Monospace for clarity
  static const TextStyle dataLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const TextStyle dataMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );
  
  static const TextStyle dataSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0,
  );
  
  // ============================================================================
  // SPACING - 8px grid system
  // ============================================================================
  
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;
  
  // ============================================================================
  // BORDER RADIUS
  // ============================================================================
  
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  
  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(radiusSmall));
  static const BorderRadius borderRadiusMedium = BorderRadius.all(Radius.circular(radiusMedium));
  static const BorderRadius borderRadiusLarge = BorderRadius.all(Radius.circular(radiusLarge));
  static const BorderRadius borderRadiusXLarge = BorderRadius.all(Radius.circular(radiusXLarge));
  
  // ============================================================================
  // SHADOWS
  // ============================================================================
  
  static List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  // ============================================================================
  // ELEVATION (for subtle depth)
  // ============================================================================
  
  static BoxDecoration elevationLow = BoxDecoration(
    color: surfaceDefault,
    borderRadius: borderRadiusMedium,
    border: Border.all(color: borderSubtle),
  );
  
  static BoxDecoration elevationMedium = BoxDecoration(
    color: surfaceElevated,
    borderRadius: borderRadiusMedium,
    border: Border.all(color: borderDefault),
    boxShadow: shadowSmall,
  );
  
  static BoxDecoration elevationHigh = BoxDecoration(
    color: surfaceElevated,
    borderRadius: borderRadiusMedium,
    border: Border.all(color: borderStrong),
    boxShadow: shadowMedium,
  );
  
  // ============================================================================
  // DURATIONS (for animations)
  // ============================================================================
  
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);
  
  // ============================================================================
  // UTILITY METHODS
  // ============================================================================
  
  /// Get color for risk levels (0-100)
  static Color getRiskColor(double risk) {
    if (risk >= 80) return error;
    if (risk >= 60) return warning;
    if (risk >= 40) return info;
    return success;
  }
  
  /// Get color for mastery levels (0-100)
  static Color getMasteryColor(double mastery) {
    if (mastery >= 80) return success;
    if (mastery >= 60) return info;
    if (mastery >= 40) return warning;
    return error;
  }
  
  /// Get trend icon based on change
  static IconData getTrendIcon(double change) {
    if (change > 0) return Icons.trending_up;
    if (change < 0) return Icons.trending_down;
    return Icons.trending_flat;
  }
  
  /// Get trend color based on change (positive = good)
  static Color getTrendColor(double change) {
    if (change > 0) return success;
    if (change < 0) return error;
    return textSecondary;
  }
}

