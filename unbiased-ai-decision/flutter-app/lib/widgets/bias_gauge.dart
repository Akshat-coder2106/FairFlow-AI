import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BiasGauge extends StatelessWidget {
  const BiasGauge({
    super.key,
    required this.score,
  });

  final double score;

  Color get _activeColor {
    if (score <= 30) {
      return const Color(0xFF16A34A);
    }
    if (score <= 60) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    final normalized = score.clamp(0, 100);
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: 180,
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              sections: [
                PieChartSectionData(
                  color: _activeColor,
                  value: normalized,
                  radius: 18,
                  showTitle: false,
                ),
                PieChartSectionData(
                  color: const Color(0xFFE5E7EB),
                  value: 100 - normalized,
                  radius: 18,
                  showTitle: false,
                ),
                PieChartSectionData(
                  color: Colors.transparent,
                  value: 100,
                  radius: 0,
                  showTitle: false,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                normalized.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Text(
                'Fairness Score',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
