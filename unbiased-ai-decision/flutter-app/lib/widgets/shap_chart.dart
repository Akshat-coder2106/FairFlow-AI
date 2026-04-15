import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ShapChart extends StatelessWidget {
  const ShapChart({
    super.key,
    required this.shapValues,
  });

  final List<Map<String, dynamic>> shapValues;

  @override
  Widget build(BuildContext context) {
    final rows = shapValues.take(10).toList(growable: false);
    if (rows.isEmpty) {
      return const Center(
        child: Text('No SHAP values available for this audit.'),
      );
    }

    return SizedBox(
      height: 320,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: rows
              .map((row) => (row['value'] as num?)?.abs().toDouble() ?? 0)
              .fold<double>(0, (maxValue, value) => value > maxValue ? value : maxValue) +
              0.1,
          barTouchData: BarTouchData(enabled: true),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= rows.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${rows[index]['feature']}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(rows.length, (index) {
            final value = (rows[index]['value'] as num?)?.toDouble() ?? 0;
            final isPositive = value >= 0;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value.abs(),
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                  color: isPositive ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
