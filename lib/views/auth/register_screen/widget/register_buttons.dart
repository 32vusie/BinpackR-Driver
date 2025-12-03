import 'package:binpack_residents/utils/buttton.dart';
import 'package:flutter/material.dart';

class RegisterButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRegisterPressed;
  final VoidCallback onGoogleSignInPressed;

  const RegisterButtons({
    super.key,
    required this.isLoading,
    required this.onRegisterPressed,
    required this.onGoogleSignInPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: onRegisterPressed,
                style: elevatedButtonStyle,
                child: const Text('Register'),
              ),
        const SizedBox(height: 16),
        // ElevatedButton.icon(
        //   onPressed: onGoogleSignInPressed,
        //   icon: const Icon(Icons.login),
        //   label: const Text('Register with Google'),
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.red,
        //   ),
        // ),
      ],
    );
  }
}
