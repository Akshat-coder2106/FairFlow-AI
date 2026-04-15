import 'package:flutter/material.dart';

import 'sdg_badge.dart';

class GeminiCard extends StatelessWidget {
  const GeminiCard({
    super.key,
    required this.explanation,
  });

  final String explanation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: const Text(
              'AI Fairness Insight',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  explanation,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),
                const SdgBadge(compact: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
