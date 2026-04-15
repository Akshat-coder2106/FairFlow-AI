import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../widgets/sdg_badge.dart';
import 'history_screen.dart';
import 'login_screen.dart';
import 'report_screen.dart';
import 'upload_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> _summaryFuture;

  @override
  void initState() {
    super.initState();
    _summaryFuture = _loadSummary();
  }

  Future<Map<String, dynamic>> _loadSummary() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {
        'auditsRun': 0,
        'avgBiasScore': 0.0,
        'sdgAlignment': 'SDG 10.3',
        'recentAudits': <Map<String, dynamic>>[],
      };
    }

    final summary = await FirebaseService.instance.computeDashboardSummary(
      user.uid,
      includeSample: user.isAnonymous,
    );
    final cachedAudit = AuthService.instance.consumePreloadedGuestAudit();
    if (cachedAudit != null &&
        (summary['recentAudits'] as List<Map<String, dynamic>>).isEmpty) {
      return {
        ...summary,
        'recentAudits': [cachedAudit],
        'auditsRun': 1,
        'avgBiasScore': (cachedAudit['bias_score'] as num?)?.toDouble() ?? 0.0,
      };
    }
    return summary;
  }

  Future<void> _logout() async {
    await AuthService.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  String _formatDate(dynamic value) {
    if (value == null) {
      return 'Unknown date';
    }
    if (value is DateTime) {
      return DateFormat.yMMMd().format(value);
    }
    if (value.toString().contains('Timestamp')) {
      return value.toString();
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unbiased AI'),
        actions: [
          IconButton(
            tooltip: 'History',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
            icon: const Icon(Icons.history_rounded),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const UploadScreen()),
          );
        },
        backgroundColor: const Color(0xFFF59E0B),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Audit'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _summaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final summary = snapshot.data ??
              {
                'auditsRun': 0,
                'avgBiasScore': 0.0,
                'sdgAlignment': 'SDG 10.3',
                'recentAudits': <Map<String, dynamic>>[],
              };
          final recentAudits =
              (summary['recentAudits'] as List?)?.cast<Map<String, dynamic>>() ??
                  <Map<String, dynamic>>[];

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _summaryFuture = _loadSummary();
              });
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Audits Run',
                        value: '${summary['auditsRun']}',
                        icon: Icons.analytics_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Avg Bias Score',
                        value: (summary['avgBiasScore'] as num?)?.toStringAsFixed(1) ?? '0',
                        icon: Icons.speed_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: _StatCard(
                        title: 'SDG Alignment',
                        value: 'Aligned',
                        icon: Icons.verified_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const SdgBadge(),
                const SizedBox(height: 24),
                const Text(
                  'Recent Audits',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                if (recentAudits.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'No audits yet. Run your first audit to see bias scores, SHAP feature impact, and SDG alignment.',
                    ),
                  ),
                ...recentAudits.map(
                  (audit) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      title: Text('${audit['model_name'] ?? 'Untitled model'}'),
                      subtitle: Text(_formatDate(audit['created_at'])),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE68A),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text('${audit['bias_score'] ?? 0}/100'),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ReportScreen(initialAudit: audit),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFF59E0B)),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
