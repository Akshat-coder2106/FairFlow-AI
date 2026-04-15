import 'package:flutter/material.dart';

import 'report_screen.dart';

class AuditScreen extends StatelessWidget {
  const AuditScreen({
    super.key,
    required this.audit,
  });

  final Map<String, dynamic> audit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audit Overview')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${audit['model_name'] ?? 'Untitled model'}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              '${audit['dataset_name'] ?? 'Unknown dataset'}',
              style: const TextStyle(fontSize: 16, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                'Bias score: ${audit['bias_score'] ?? 0}/100\nSDG tag: ${audit['sdg_tag'] ?? 'SDG 10.3'}',
                style: const TextStyle(fontSize: 18, height: 1.5),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReportScreen(initialAudit: audit),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
              ),
              child: const Text('Open Full Report'),
            ),
          ],
        ),
      ),
    );
  }
}
