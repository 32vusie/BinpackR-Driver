import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:binpack_residents/utils/location_filtering_field.dart';
import 'package:binpack_residents/views/auth/register_screen/widget/passwordStrengthWidget.dart';
import 'package:binpack_residents/views/auth/register_screen/widget/register_buttons.dart';
import 'package:binpack_residents/utils/InputDecoration.dart';
import 'package:binpack_residents/views/auth/functions/register_functions.dart';
import 'package:binpack_residents/utils/responsive_layout.dart';
import 'package:binpack_residents/utils/theme.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _acceptedTerms = false;

  void _onLocationSelected(String streetAddress, String suburb, String city,
      String province, String postalCode) {
    // Location selection logic
  }

  void _toggleLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<void> _handleRegister() async {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('You must accept the terms and conditions to register.')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly.')),
      );
      return;
    }

    _toggleLoading(true);

    try {
      await registerUser(
        context,
        _formKey,
        _emailController,
        _passwordController,
        _phoneController,
      );
      _toggleLoading(false);
    } catch (e) {
      _toggleLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register Resident',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ResponsiveLayout(
            mobile: _buildMobileLayout(context),
            tablet: _buildTabletDesktopLayout(context),
            desktop: _buildTabletDesktopLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: _buildFormFields(context),
    );
  }

  Widget _buildTabletDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/accesnts/binpackr-logo-name.png',
                    height: 150),
                const SizedBox(height: 20),
                Text(
                  'Join BinpackR Today!',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Register now to get started with our resident services.',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: primaryColor,
                        fontSize: 16,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildFormFields(context),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFormFields(BuildContext context) {
    return [
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: inputDecorationStyle.copyWith(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            LocationSearchField(onLocationSelected: _onLocationSelected),
            const SizedBox(height: 8),
            PasswordStrengthChecker(passwordController: _passwordController),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: inputDecorationStyle.copyWith(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                final phoneNumberRegex = RegExp(r'^\+27\d{9}$');
                if (!phoneNumberRegex.hasMatch(value)) {
                  return 'Please enter a valid South African phone number starting with +27';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _acceptedTerms,
                  onChanged: (value) =>
                      setState(() => _acceptedTerms = value ?? false),
                ),
                Expanded(
                  child: Text(
                    'I accept the terms and conditions',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.green,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : RegisterButtons(
                    isLoading: _isLoading,
                    onRegisterPressed: _handleRegister,
                    onGoogleSignInPressed: () async {
                      try {
                        await _googleSignIn.signIn();
                      } catch (e) {
                        print('Google Sign-In failed: $e');
                      }
                    },
                  ),
          ],
        ),
      ),
    ];
  }
}