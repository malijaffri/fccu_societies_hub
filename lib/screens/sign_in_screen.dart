import 'package:flutter/material.dart';

import 'main_navigation_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: SingleChildScrollView(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          SizedBox(height: 64),
          Text('FCCU Societies Hub', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          SizedBox(height: 64),
          SignInForm(),
        ],
      ),
    ),
  );
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) => Form(
    key: _formKey,
    child: Column(
      spacing: 16,
      children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.password),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          obscureText: _obscurePassword,
        ),
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                      (_) => false,
                    );
                  }
                },
                child: const Text('Sign In'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
