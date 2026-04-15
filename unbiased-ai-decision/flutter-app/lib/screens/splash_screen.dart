import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.gpp_good_rounded, size: 72, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Unbiased AI Decision',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 12),
            CircularProgressIndicator(color: Color(0xFFF59E0B)),
          ],
        ),
      ),
    );
  }
}
