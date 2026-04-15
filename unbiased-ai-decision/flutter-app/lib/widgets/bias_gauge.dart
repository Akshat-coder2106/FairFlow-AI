import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BiasGauge extends StatefulWidget {
  const BiasGauge({
    super.key,
    required this.score,
  });

  final double score;

  @override
  State<BiasGauge> createState() => _BiasGaugeState();
}

class _BiasGaugeState extends State<BiasGauge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.score.clamp(0.0, 100.0).toDouble(),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant BiasGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _scoreAnimation = Tween<double>(
        begin: _scoreAnimation.value,
        end: widget.score.clamp(0.0, 100.0).toDouble(),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ),
      );
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _riskColor(double score) {
    if (score <= 30) return AppColors.success;
    if (score <= 60) return AppColors.warning;
    return AppColors.danger;
  }

  String _riskLabel(double score) {
    if (score <= 30) return 'Low Risk';
    if (score <= 60) return 'Moderate Risk';
    return 'High Risk';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, _) {
        final animatedScore =
            _scoreAnimation.value.clamp(0.0, 100.0).toDouble();
        final riskColor = _riskColor(animatedScore);

        return Column(
          children: [
            SizedBox(
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(320, 240),
                    painter: _GaugePainter(
                      progress: animatedScore / 100,
                      riskColor: riskColor,
                      backgroundColor: theme.brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.08)
                          : const Color(0xFFE5EAF5),
                    ),
                  ),
                  Positioned(
                    bottom: 44,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          animatedScore.toStringAsFixed(0),
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 52,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Fairness Score',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: riskColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                _riskLabel(animatedScore),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: riskColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.progress,
    required this.riskColor,
    required this.backgroundColor,
  });

  final double progress;
  final Color riskColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.86);
    final radius = math.min(size.width * 0.37, size.height * 0.78);
    const startAngle = math.pi;
    const sweepAngle = math.pi;

    final trackPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 18;

    final greenPaint = Paint()
      ..color = AppColors.success
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 18;
    final amberPaint = Paint()
      ..color = AppColors.warning
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 18;
    final redPaint = Paint()
      ..color = AppColors.danger
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 18;

    final gaugeRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(gaugeRect, startAngle, sweepAngle, false, trackPaint);
    canvas.drawArc(gaugeRect, startAngle, sweepAngle * 0.30, false, greenPaint);
    canvas.drawArc(
      gaugeRect,
      startAngle + sweepAngle * 0.30,
      sweepAngle * 0.30,
      false,
      amberPaint,
    );
    canvas.drawArc(
      gaugeRect,
      startAngle + sweepAngle * 0.60,
      sweepAngle * 0.40,
      false,
      redPaint,
    );

    final needleAngle = startAngle + (sweepAngle * progress);
    final needleLength = radius - 18;
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    final needlePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          riskColor.withOpacity(0.78),
          riskColor,
        ],
      ).createShader(
        Rect.fromPoints(center, needleEnd),
      )
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    canvas.drawLine(center, needleEnd, needlePaint);
    canvas.drawCircle(
      center,
      12,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      center,
      7,
      Paint()..color = riskColor,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.riskColor != riskColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
