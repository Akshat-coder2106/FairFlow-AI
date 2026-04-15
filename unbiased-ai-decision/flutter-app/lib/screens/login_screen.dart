import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loadingGoogle = false;
  bool _loadingGuest = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _loadingGoogle = true);
    try {
      await AuthService.instance.signInWithGoogle();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _loadingGoogle = false);
      }
    }
  }

  Future<void> _signInAsGuest() async {
    setState(() => _loadingGuest = true);
    try {
      await AuthService.instance.signInAsGuest();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _loadingGuest = false);
      }
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFFF59E0B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              margin: const EdgeInsets.all(24),
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.balance_rounded, size: 60, color: Color(0xFFF59E0B)),
                    const SizedBox(height: 18),
                    const Text(
                      'Unbiased AI Decision',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Fair AI for everyone',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      onPressed: _loadingGoogle ? null : _signInWithGoogle,
                      icon: _loadingGoogle
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.login_rounded),
                      label: const Text('Sign in with Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('or'),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _loadingGuest ? null : _signInAsGuest,
                      icon: _loadingGuest
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.person_outline_rounded),
                      label: const Text('Try as Guest — no sign-up needed'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0F172A),
                        side: const BorderSide(color: Color(0xFFF59E0B), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'SDG 10 — Reduced Inequalities',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF009EDB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
