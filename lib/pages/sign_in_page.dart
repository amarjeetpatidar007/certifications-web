import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Certification Tracker',
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 24),
            Consumer<AuthProvider>(
              builder: (context, auth, _) {
                return ElevatedButton(
                  onPressed: () async {
                    try {
                      context.read<AuthProvider>().signInWithGoogle(context);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error signing in: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('Sign in with Google'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
