import 'package:binpack_residents/utils/InputDecoration.dart';
import 'package:flutter/material.dart';

class PasswordStrengthChecker extends StatefulWidget {
  final TextEditingController passwordController;

  const PasswordStrengthChecker({super.key, required this.passwordController});

  @override
  _PasswordStrengthCheckerState createState() =>
      _PasswordStrengthCheckerState();
}

class _PasswordStrengthCheckerState extends State<PasswordStrengthChecker> {
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Password TextFormField
        TextFormField(
          controller: widget.passwordController,
          decoration: inputDecorationStyle.copyWith(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _hidePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _hidePassword = !_hidePassword;
                });
              },
            ),
          ),
          obscureText: _hidePassword,
          onChanged: (value) {
            setState(() {});
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 8 ||
                !RegExp(r'[A-Z]').hasMatch(value) ||
                !RegExp(r'[a-z]').hasMatch(value) ||
                !RegExp(r'[0-9]').hasMatch(value) ||
                !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
              return 'Password must have at least 8 characters, including uppercase, lowercase, numbers, and special characters.';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),
        PasswordStrength(password: widget.passwordController.text),
        const SizedBox(height: 16),

        // Confirm Password TextFormField
        TextFormField(
          decoration: inputDecorationStyle.copyWith(
            labelText: 'Confirm Password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _hideConfirmPassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _hideConfirmPassword = !_hideConfirmPassword;
                });
              },
            ),
          ),
          obscureText: _hideConfirmPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            } else if (value != widget.passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class PasswordStrength extends StatelessWidget {
  final String password;

  const PasswordStrength({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    int strength = 0;

    if (password.length >= 8) strength += 1;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 1;
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 1;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 1;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 1;

    Color progressColor;
    if (strength == 0) {
      progressColor = Colors.grey;
    } else if (strength < 3) {
      progressColor = Colors.red;
    } else if (strength < 5) {
      progressColor = Colors.orange;
    } else {
      progressColor = const Color.fromARGB(255, 8, 116, 13);
    }

    double progressValue = strength / 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(
          value: progressValue,
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 8),
        Text(
          'Password Strength: ${_getStrengthText(strength)}',
          style: TextStyle(
            color: progressColor,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _getStrengthText(int strength) {
    if (strength == 0) return 'Weak';
    if (strength < 3) return 'Fair';
    if (strength < 5) return 'Strong';
    return 'Very Strong';
  }
}
