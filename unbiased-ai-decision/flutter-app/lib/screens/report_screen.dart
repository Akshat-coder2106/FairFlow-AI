import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../widgets/bias_gauge.dart';
import '../widgets/gemini_card.dart';
import '../widgets/sdg_badge.dart';
import '../widgets/shap_chart.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({
    super.key,
    required this.initialAudit,
  });

  final Map<String, dynamic> initialAudit;

  String _formatDate(dynamic value) {
    if (value is DateTime) {
      return DateFormat.yMMMd().add_jm().format(value);
    }
    return value?.toString() ?? 'Unknown date';
  }

  double _metric(Map<String, dynamic> source, String key) {
    if (source[key] is num) {
      return (source[key] as num).toDouble();
    }
    final nested = source['fairness_metrics'];
    if (nested is Map<String, dynamic> && nested[key] is num) {
      return (nested[key] as num).toDouble();
    }
    return 0;
  }

  List<Map<String, dynamic>> _shapValues() {
    final raw = initialAudit['shap_values'];
    if (raw is List) {
      return raw.whereType<Map>().map((item) => item.cast<String, dynamic>()).toList();
    }
    return <Map<String, dynamic>>[];
  }

  Future<void> _sharePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            initialAudit['model_name']?.toString() ?? 'Unbiased AI Decision Report',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Text('Bias score: ${initialAudit['bias_score'] ?? 0}/100'),
          pw.Text('Dataset: ${initialAudit['dataset_name'] ?? 'Unknown'}'),
          pw.Text('SDG tag: ${initialAudit['sdg_tag'] ?? 'SDG 10.3'}'),
          pw.SizedBox(height: 16),
          pw.Text(initialAudit['gemini_explanation']?.toString() ?? ''),
        ],
      ),
    );
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'unbiased-ai-report.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final shapValues = _shapValues();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Report'),
        actions: [
          IconButton(
            tooltip: 'Share as PDF',
            onPressed: _sharePdf,
            icon: const Icon(Icons.share_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            initialAudit['model_name']?.toString() ?? 'Untitled model',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            _formatDate(initialAudit['created_at']),
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                BiasGauge(score: (initialAudit['bias_score'] as num?)?.toDouble() ?? 0),
                const SizedBox(height: 12),
                const Text(
                  'What was found?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                GeminiCard(
                  explanation: initialAudit['gemini_explanation']?.toString() ??
                      'No Gemini explanation is available for this audit.',
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Feature Impact (SHAP)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                ShapChart(shapValues: shapValues),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SDG Alignment',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                const SdgBadge(),
                const SizedBox(height: 12),
                const Text(
                  'Target 10.3 — Ensure equal opportunity and reduce inequalities of outcome, including by eliminating discriminatory laws, policies, and practices',
                  style: TextStyle(color: Color(0xFF475569), height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fairness Metrics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                _MetricRow(
                  label: 'Demographic Parity Difference',
                  value: _metric(initialAudit, 'demographic_parity'),
                ),
                _MetricRow(
                  label: 'Equalized Odds Difference',
                  value: _metric(initialAudit, 'equalized_odds'),
                ),
                _MetricRow(
                  label: 'Individual Fairness Score',
                  value: _metric(initialAudit, 'individual_fairness'),
                ),
                _MetricRow(
                  label: 'Calibration Error',
                  value: _metric(initialAudit, 'calibration_error'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value.toStringAsFixed(3)),
        ],
      ),
    );
  }
}
