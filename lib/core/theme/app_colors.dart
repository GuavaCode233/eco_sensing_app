import 'package:flutter/material.dart';

/// Starbucks-inspired design tokens (getdesign.md).
abstract final class AppColors {
  // Primary greens
  static const starbucksGreen = Color(0xFF006241);
  static const greenAccent = Color(0xFF00754A);
  static const houseGreen = Color(0xFF1E3932);
  static const greenUplift = Color(0xFF2B5148);
  static const greenLight = Color(0xFFD4E9E2);

  // Rewards gold (ceremony only)
  static const gold = Color(0xFFCBA258);
  static const goldLight = Color(0xFFDFC49D);
  static const goldLightest = Color(0xFFFAF6EE);

  // Surfaces
  static const white = Color(0xFFFFFFFF);
  static const neutralCool = Color(0xFFF9F9F9);
  static const neutralWarm = Color(0xFFF2F0EB);
  static const ceramic = Color(0xFFEDEBE9);
  static const black = Color(0xFF000000);

  // Text
  static const textPrimary = Color(0xDE000000);
  static const textSecondary = Color(0x94000000);
  static const rewardsGreen = Color(0xFF33433D);

  // Semantic
  static const red = Color(0xFFC82014);
  static const warning = Color(0xFFFBBC05);

  // Medal tiers (leaderboard)
  static const silver = Color(0xFFB0B7C3);
  static const bronze = Color(0xFFCD7F32);
}
