import 'package:binpack_residents/utils/buttton.dart';
import 'package:binpack_residents/views/auth/login_screen/widgets/ForgotPasswordScreen.dart';
import 'package:binpack_residents/views/auth/register_screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:binpack_residents/utils/InputDecoration.dart';
import 'package:binpack_residents/utils/theme.dart';

class LoginFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final Future<void> Function() onLoginPressed;

  const LoginFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLoginPressed,
  });

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool hidePassword = true;

  void togglePasswordVisibility() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.isLoading
            ? LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 8, 116, 13),
                ),
              )
            : const SizedBox(height: 4),
        Form(
          key: widget.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: widget.emailController,
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
                controller: widget.passwordController,
                decoration: inputDecorationStyle.copyWith(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: togglePasswordVisibility,
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
                onPressed: widget.onLoginPressed,
                style: elevatedButtonStyle,
                child: widget.isLoading
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
          ),
        ),
      ],
    );
  }
}
