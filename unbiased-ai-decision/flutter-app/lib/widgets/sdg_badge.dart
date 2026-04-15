import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SdgBadge extends StatelessWidget {
  const SdgBadge({super.key, this.compact = false});

  final bool compact;

  static const _sdgUrl = 'https://sdgs.un.org/goals/goal10';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => launchUrl(Uri.parse(_sdgUrl), mode: LaunchMode.externalApplication),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 14 : 16,
          vertical: compact ? 10 : 14,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF009EDB),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sync, color: Colors.white),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'SDG 10',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Reduced Inequalities',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
