import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.white,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: AppDecorations.card(color: color),
      padding: padding,
      child: child,
    );
  }
}

class FeatureBandHeader extends StatelessWidget {
  const FeatureBandHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.height = 160,
    this.useRewardsGold = false,
  });

  final String title;
  final String? subtitle;
  final double height;
  final bool useRewardsGold;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 20,
      ),
      decoration: useRewardsGold
          ? AppDecorations.rewardsBand()
          : AppDecorations.featureBand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white.withValues(alpha: 0.78),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
