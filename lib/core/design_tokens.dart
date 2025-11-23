import 'package:flutter/material.dart';

/// Cerebellum OS Design System
/// Professional, data-driven, weaponized intelligence
class DesignTokens {
  // ============================================================================
  // COLORS
  // ============================================================================
  
  /// Primary accent color - Electric Blue
  static const Color primary = Color(0xFF0EA5E9);
  static const Color primaryDark = Color(0xFF0284C7);
  static const Color primaryLight = Color(0xFF38BDF8);
  
  /// Backgrounds - Deep blacks and charcoals
  static const Color backgroundPrimary = Color(0xFF0A0A0A);
  static const Color backgroundSecondary = Color(0xFF1A1A1A);
  static const Color backgroundTertiary = Color(0xFF242424);
  
  /// Surface colors
  static const Color surfaceDefault = Color(0xFF1A1A1A);
  static const Color surfaceElevated = Color(0xFF242424);
  static const Color surfaceHover = Color(0xFF2E2E2E);
  
  /// Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textTertiary = Color(0xFF71717A);
  static const Color textDisabled = Color(0xFF52525B);
  
  /// Border colors
  static const Color borderDefault = Color(0xFF3F3F46);
  static const Color borderSubtle = Color(0xFF27272A);
  static const Color borderStrong = Color(0xFF52525B);
  
  /// Semantic colors - Professional, not dramatic
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  /// Data visualization colors
  static const Color dataBlue = Color(0xFF0EA5E9);
  static const Color dataGreen = Color(0xFF10B981);
  static const Color dataYellow = Color(0xFFF59E0B);
  static const Color dataRed = Color(0xFFEF4444);
  static const Color dataPurple = Color(0xFF8B5CF6);
  static const Color dataTeal = Color(0xFF14B8A6);
  
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

