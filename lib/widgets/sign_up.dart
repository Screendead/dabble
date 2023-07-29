import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({
    super.key,
    required this.formKey,
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.submit,
    required this.toggle,
  });

  final GlobalKey<FormState> formKey;
  final GlobalKey<FormFieldState<String>> email;
  final GlobalKey<FormFieldState<String>> password;
  final GlobalKey<FormFieldState<String>> passwordConfirm;
  final void Function()? submit;
  final void Function()? toggle;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/logo-no-background.png',
            width: 250,
          ),
          const SizedBox(height: 32),
          TextFormField(
            key: email,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email.';
              }

              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: password,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
            obscureText: true,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password.';
              }

              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: passwordConfirm,
            decoration: const InputDecoration(
              hintText: 'Confirm Password',
            ),
            obscureText: true,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password.';
              }

              if (value != password.currentState!.value) {
                return 'Passwords do not match.';
              }

              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: submit,
            child: const Text('Sign Up'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: toggle,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? Log in'),
                SizedBox(width: 8),
                Icon(Icons.arrow_right_alt),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
