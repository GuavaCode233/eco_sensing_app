import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppDecorations {
  static const double cardRadius = 12;
  static const double pillRadius = 25;

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static BoxDecoration card({Color color = AppColors.white}) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(cardRadius),
    boxShadow: cardShadow,
  );

  static BoxDecoration featureBand({List<Color>? colors}) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors ?? [AppColors.houseGreen, AppColors.greenUplift],
    ),
  );

  static BoxDecoration rewardsBand() => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.gold, const Color(0xFFE0A010)],
    ),
  );

  static BoxDecoration pillChip({
    required Color color,
    bool filled = false,
  }) => BoxDecoration(
    color: filled ? color : color.withValues(alpha: 0.12),
    borderRadius: BorderRadius.circular(pillRadius),
    border: Border.all(color: color.withValues(alpha: filled ? 1 : 0.35)),
  );

  static BoxDecoration tintedSurface(Color color) => BoxDecoration(
    color: color.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(cardRadius),
    border: Border.all(color: color.withValues(alpha: 0.25)),
  );
}
