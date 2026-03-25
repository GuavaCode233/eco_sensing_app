import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarbonCompositionCard extends ConsumerWidget {
  const CarbonCompositionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildCarbonCompositionCard(context)],
    );
  }

  Widget _buildCarbonCompositionCard(BuildContext context) {
    // 碳排數據卡片（圓餅圖）
    final double travelEmission = 45.5;
    final double wasteEmission = 12.3;
    final double totalEmission = travelEmission + wasteEmission;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '月度碳排組成',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // 圓餅圖
          Center(
            child: SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue.shade400,
                      value: travelEmission,
                      title:
                          '${(travelEmission / totalEmission * 100).toStringAsFixed(1)}%',
                      radius: 70,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.green.shade400,
                      value: wasteEmission,
                      title:
                          '${(wasteEmission / totalEmission * 100).toStringAsFixed(1)}%',
                      radius: 70,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  centerSpaceRadius: 0,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 圖例和數據
          Row(
            children: [
              Expanded(
                child: _buildEmissionLegend(
                  label: '差旅',
                  value: '${travelEmission.toStringAsFixed(1)} kg',
                  color: Colors.blue.shade400,
                  context: context,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEmissionLegend(
                  label: '廢棄物',
                  value: '${wasteEmission.toStringAsFixed(1)} kg',
                  color: Colors.green.shade400,
                  context: context,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 總計
          Container(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '本月總碳排量',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${totalEmission.toStringAsFixed(1)} kg',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmissionLegend({
    // 碳排圖例
    required String label,
    required String value,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
