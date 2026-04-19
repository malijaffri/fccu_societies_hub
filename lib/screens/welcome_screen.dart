import 'package:flutter/material.dart';

import 'main_navigation_screen.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text('FCCU Societies Hub', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const Spacer(),
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                FilledButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
                  child: Text('Sign Up'),
                ),
                FilledButton.tonal(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignInScreen())),
                  child: Text('Sign In'),
                ),
                TextButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                    (_) => false,
                  ),
                  child: Text('Guest'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    ),
  );
}
