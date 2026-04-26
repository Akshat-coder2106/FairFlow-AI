import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _revealController;
  late final AnimationController _pulseController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _contentOffset;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoScale = Tween<double>(begin: 0.88, end: 1).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: Curves.easeOutBack,
      ),
    );
    _logoOpacity = CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeOut,
    );
    _contentOffset = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: Curves.easeOutCubic,
      ),
    );

    _revealController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _revealController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color cardColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.white.withOpacity(0.18);
    final Color cardBorder = isDark
        ? Colors.white.withOpacity(0.10)
        : Colors.white.withOpacity(0.32);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDark ? AppColors.deepNavyDark : AppColors.deepNavy,
              const Color(0xFF24345F),
              const Color(0xFF304675),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: _SplashBackdrop()),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: FadeTransition(
                          opacity: _logoOpacity,
                          child: SlideTransition(
                            position: _contentOffset,
                            child: ScaleTransition(
                              scale: _logoScale,
                              child: Semantics(
                                label: 'Unbiased AI Decision loading screen',
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 420,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 18,
                                        sigmaY: 18,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 28,
                                          vertical: 32,
                                        ),
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius:
                                              BorderRadius.circular(28),
                                          border: Border.all(
                                            color: cardBorder,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                isDark ? 0.30 : 0.14,
                                              ),
                                              blurRadius: 32,
                                              offset: const Offset(0, 18),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Hero(
                                              tag: 'app-logo',
                                              child: AnimatedBuilder(
                                                animation: _pulseController,
                                                builder: (context, child) {
                                                  final double scale =
                                                      1 +
                                                          (_pulseController
                                                                  .value *
                                                              0.06);
                                                  return Transform.scale(
                                                    scale: scale,
                                                    child: child,
                                                  );
                                                },
                                                child: Container(
                                                  width: 112,
                                                  height: 112,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient:
                                                        AppGradients.accent,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: AppColors
                                                            .accentAmber
                                                            .withOpacity(0.30),
                                                        blurRadius: 32,
                                                        spreadRadius: 2,
                                                        offset:
                                                            const Offset(0, 12),
                                                      ),
                                                    ],
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Semantics(
                                                    label:
                                                        'Shield icon showing secure AI fairness checks',
                                                    child: const Icon(
                                                      Icons.gpp_good_rounded,
                                                      size: 56,
                                                      color:
                                                          AppColors.deepNavy,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            Text(
                                              'Unbiased AI Decision',
                                              textAlign: TextAlign.center,
                                              style: theme
                                                  .textTheme.headlineLarge
                                                  ?.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'Preparing your fairness workspace with secure checks, clear insights, and a smoother audit experience.',
                                              textAlign: TextAlign.center,
                                              style: theme.textTheme.bodyLarge
                                                  ?.copyWith(
                                                color: Colors.white
                                                    .withOpacity(0.82),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Semantics(
                      label: 'Loading progress',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          minHeight: 4,
                          backgroundColor: Colors.white.withOpacity(0.12),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.accentAmber,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashBackdrop extends StatelessWidget {
  const _SplashBackdrop();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -20,
            child: _GlowOrb(
              size: 200,
              color: AppColors.accentAmber.withOpacity(0.16),
            ),
          ),
          Positioned(
            left: -70,
            bottom: 100,
            child: _GlowOrb(
              size: 240,
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          Positioned(
            right: 36,
            bottom: 160,
            child: _GlowOrb(
              size: 120,
              color: const Color(0xFF8FA7FF).withOpacity(0.14),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size * 0.42,
            spreadRadius: size * 0.06,
          ),
        ],
      ),
    );
  }
}
