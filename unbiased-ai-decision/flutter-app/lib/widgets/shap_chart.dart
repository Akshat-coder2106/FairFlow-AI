import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ShapChart extends StatelessWidget {
  const ShapChart({
    super.key,
    required this.shapValues,
  });

  final List<Map<String, dynamic>> shapValues;

  @override
  Widget build(BuildContext context) {
    final rows = shapValues
        .map(
          (row) => {
            'feature': row['feature']?.toString() ?? 'Unknown feature',
            'value': (row['value'] as num?)?.toDouble() ??
                (row['shap_value'] as num?)?.toDouble() ??
                0.0,
          },
        )
        .toList(growable: false)
      ..sort((a, b) => (b['value'] as double)
          .abs()
          .compareTo((a['value'] as double).abs()));

    final topRows = rows.take(10).toList(growable: false);
    if (topRows.isEmpty) {
      return Center(
        child: Text(
          'No SHAP values available for this audit.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final maxMagnitude = topRows
        .map((row) => (row['value'] as double).abs())
        .fold<double>(0, math.max);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.04)
            : const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.08)
              : const Color(0xFFE3EAF6),
        ),
      ),
      child: Column(
        children: topRows
            .map(
              (row) => Padding(
                padding: EdgeInsets.only(
                  bottom: row == topRows.last ? 0 : 14,
                ),
                child: _ShapBarRow(
                  feature: row['feature'] as String,
                  value: row['value'] as double,
                  maxMagnitude: maxMagnitude == 0 ? 1 : maxMagnitude,
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _ShapBarRow extends StatelessWidget {
  const _ShapBarRow({
    required this.feature,
    required this.value,
    required this.maxMagnitude,
  });

  final String feature;
  final double value;
  final double maxMagnitude;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isPositive = value >= 0;
    final Color labelColor =
        isPositive ? AppColors.danger : AppColors.success;
    final double ratio =
        (value.abs() / maxMagnitude).clamp(0.08, 1.0).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                feature,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              value.toStringAsFixed(3),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 18,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.06)
                        : const Color(0xFFE9EEF8),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: ratio),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, animatedValue, _) {
                    return Container(
                      width: constraints.maxWidth * animatedValue,
                      height: 18,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isPositive
                              ? [
                                  AppColors.danger,
                                  AppColors.accentAmber,
                                ]
                              : [
                                  const Color(0xFF34D399),
                                  AppColors.success,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
