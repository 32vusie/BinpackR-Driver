import 'package:binpack_residents/utils/InputDecoration.dart';
import 'package:binpack_residents/utils/buttton.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:binpack_residents/views/auth/login_screen/widgets/ForgotPasswordScreen.dart';
import 'package:binpack_residents/views/auth/register_screen/register_screen.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool hidePassword;
  final bool isLoading;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onLoginPressed;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.hidePassword,
    required this.isLoading,
    required this.onPasswordVisibilityToggle,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: inputDecorationStyle.copyWith(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email),
          ),
          style: const TextStyle(color: primaryColor),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: passwordController,
          decoration: inputDecorationStyle.copyWith(
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                hidePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onPasswordVisibilityToggle,
            ),
          ),
          style: const TextStyle(color: primaryColor),
          obscureText: hidePassword,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onLoginPressed,
          style: elevatedButtonStyle,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Login'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                style: textButtonStyle,
                child: const Text('Forgot Password?'),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                style: textButtonStyle,
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
