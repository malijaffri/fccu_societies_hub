import 'package:flutter/material.dart';

import 'main_navigation_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: SingleChildScrollView(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          SizedBox(height: 64),
          Text('FCCU Societies Hub', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          SizedBox(height: 64),
          SignUpForm(),
        ],
      ),
    ),
  );
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _pass = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _formKey,
    child: Column(
      spacing: 16,
      children: [
        TextFormField(
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          validator: (value) => value!.trim().isEmpty ? 'Name is required' : null,
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Email is required';
            }
            if (!RegExp(r'^[^@\s]+@[^@\s]+$').hasMatch(value)) {
              return 'Enter a valid email address';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _pass,
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
          validator: (value) => value!.length < 8 ? 'Min 8 characters' : null,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Password Confirmation',
            prefixIcon: const Icon(Icons.password),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          obscureText: _obscureConfirm,
          validator: (value) => value!.isEmpty || value != _pass.text ? 'Passwords do not match' : null,
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
                child: const Text('Sign Up'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
