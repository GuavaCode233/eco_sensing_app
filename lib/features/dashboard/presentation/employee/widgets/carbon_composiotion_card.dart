import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eco_sensing_app/core/theme/app_colors.dart';
import 'package:eco_sensing_app/core/widgets/app_card.dart';

class CarbonCompositionCard extends ConsumerWidget {
  const CarbonCompositionCard({super.key});

  static const _weeklyEmissions = [22.0, 19.0, 16.0, 13.0];
  static const _weekLabels = ['W1', 'W2', 'W3', 'W4'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildCarbonCompositionCard(context)],
    );
  }

  Widget _buildCarbonCompositionCard(BuildContext context) {
    const double travelEmission = 42;
    const double wasteEmission = 28;
    const double totalEmission = 70;
    const int travelPercent = 60;
    const int wastePercent = 40;
    final maxWeekly = _weeklyEmissions.reduce((a, b) => a > b ? a : b);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '月度碳排組成',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 148,
                child: Column(
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: AppColors.starbucksGreen,
                              value: travelEmission,
                              title: '',
                              radius: 52,
                            ),
                            PieChartSectionData(
                              color: AppColors.greenAccent,
                              value: wasteEmission,
                              title: '',
                              radius: 52,
                            ),
                          ],
                          centerSpaceRadius: 0,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '本月趨勢',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _WeeklySparkline(
                      values: _weeklyEmissions,
                      labels: _weekLabels,
                      maxValue: maxWeekly,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendRow(
                      context,
                      label: '差旅',
                      value: '${travelEmission.toInt()} kg',
                      percent: '$travelPercent%',
                      color: AppColors.starbucksGreen,
                    ),
                    const SizedBox(height: 16),
                    _buildLegendRow(
                      context,
                      label: '廢棄物',
                      value: '${wasteEmission.toInt()} kg',
                      percent: '$wastePercent%',
                      color: AppColors.greenAccent,
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.ceramic),
                    const SizedBox(height: 12),
                    _buildTotalRow(context, totalEmission),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow(
    BuildContext context, {
    required String label,
    required String value,
    required String percent,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Text(
          percent,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(BuildContext context, double total) {
    return Row(
      children: [
        Text(
          '合計',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          '${total.toInt()} kg CO₂e',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.starbucksGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _WeeklySparkline extends StatelessWidget {
  const _WeeklySparkline({
    required this.values,
    required this.labels,
    required this.maxValue,
  });

  final List<double> values;
  final List<String> labels;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    const barMaxHeight = 48.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(values.length, (index) {
        final value = values[index];
        final height = (value / maxValue) * barMaxHeight;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 4, right: index == 3 ? 0 : 4),
            child: Column(
              children: [
                Container(
                  height: barMaxHeight,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: height.clamp(6, barMaxHeight),
                    decoration: BoxDecoration(
                      color: index == values.length - 1
                          ? AppColors.greenAccent
                          : AppColors.starbucksGreen.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  labels[index],
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
