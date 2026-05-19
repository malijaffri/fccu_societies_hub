import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/auth/providers/auth_repository_provider.dart';
import 'package:fccu_societies_hub/features/auth/utils/auth_error_message.dart';
import 'package:fccu_societies_hub/features/auth/utils/auth_validators.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _isLoading = false;

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authRepositoryProvider)
          .register(email: _emailController.text.trim(), password: _passwordController.text);

      TextInput.finishAutofillContext();

      if (!mounted) {
        return;
      }

      context.go(AppRoutes.homeFeed);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(.new(content: Text(authErrorMessage(error))));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),

    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const .all(AppSpacing.s_24),

          child: ConstrainedBox(
            constraints: const .new(maxWidth: 420),

            child: Form(
              key: _formKey,

              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: .stretch,

                  children: [
                    Text(
                      'Create Account',

                      textAlign: .center,

                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: .w700),
                    ),

                    const SizedBox(height: AppSpacing.s_32),

                    TextFormField(
                      controller: _emailController,

                      keyboardType: .emailAddress,

                      autofillHints: const [AutofillHints.email],

                      decoration: const .new(labelText: 'Email'),

                      validator: emailValidator(checkFormat: true),
                    ),

                    const SizedBox(height: AppSpacing.s_16),

                    TextFormField(
                      controller: _passwordController,

                      obscureText: _obscurePassword,

                      autofillHints: const [AutofillHints.password],

                      decoration: .new(
                        labelText: 'Password',

                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),

                          icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        ),
                      ),

                      onEditingComplete: () => TextInput.finishAutofillContext(),

                      validator: passwordValidator(checkFormat: true),
                    ),

                    const SizedBox(height: AppSpacing.s_24),

                    FilledButton(
                      onPressed: _isLoading ? null : _register,

                      child: Padding(
                        padding: const .symmetric(vertical: AppSpacing.s_12),

                        child: _isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Register'),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.s_20),

                    TextButton(
                      onPressed: () => context.replace(AppRoutes.login),

                      child: const Text('Use existing account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
