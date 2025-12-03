import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/utils/NoNetworkWidget.dart';
import 'package:binpack_residents/views/auth/functions/login_functions.dart';
import 'package:binpack_residents/views/auth/login_screen/widgets/ForgotPasswordScreen.dart';
import 'package:binpack_residents/views/auth/login_screen/widgets/logo_slogand.dart';
import 'package:binpack_residents/views/auth/register_screen/register_screen.dart';
import 'package:binpack_residents/views/residents/residets_home_screen/residents_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:binpack_residents/utils/responsive_layout.dart';
import 'package:binpack_residents/utils/InputDecoration.dart';
import 'package:binpack_residents/utils/buttton.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: ResponsiveLayout(
            mobile: LoginScreenContent(
              padding: 16.0,
              logoSize: 150.0,
              layoutType: LayoutType.singleColumn,
            ),
            tablet: LoginScreenContent(
              padding: 32.0,
              logoSize: 200.0,
              layoutType: LayoutType.twoColumn,
            ),
            desktop: LoginScreenContent(
              padding: 64.0,
              logoSize: 250.0,
              layoutType: LayoutType.twoColumn,
            ),
          ),
        ),
      ),
    );
  }
}

enum LayoutType { singleColumn, twoColumn }

class LoginScreenContent extends StatefulWidget {
  final double padding;
  final double logoSize;
  final LayoutType layoutType;

  const LoginScreenContent({
    super.key,
    required this.padding,
    required this.logoSize,
    required this.layoutType,
  });

  @override
  _LoginScreenContentState createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<LoginScreenContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _isLoading = false;
  bool _isPasswordInvalid = false;
  bool _isBiometricAvailable = false;
  bool _showBiometricOption = false;
  bool _isConnected = true;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _attemptBiometricLogin();
    _checkNetworkConnectivity();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkNetworkConnectivity() async {
    final List<ConnectivityResult> result =
        await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          setState(() {
            _isConnected = result != ConnectivityResult.none;
          });
        } as void Function(List<ConnectivityResult> event)?);
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      _isBiometricAvailable = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
      if (_isBiometricAvailable) {
        setState(() => _showBiometricOption = true);
      }
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      _isBiometricAvailable = false;
    }
  }

  Future<void> _attemptBiometricLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final biometricEnabled = prefs.getBool('biometricEnabled') ?? false;
    final userId = prefs.getString('userId');

    if (biometricEnabled && userId != null && _isBiometricAvailable) {
      bool authenticated = await _authenticateWithBiometrics();
      if (authenticated) {
        await _navigateToHomeScreen(userId);
      }
    }
  }

  Future<bool> _authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate with biometrics to log in',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      debugPrint('Biometric authentication failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric authentication failed.')),
      );
      return false;
    }
  }

  Future<void> _biometricLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      bool authenticated = await _authenticateWithBiometrics();
      if (authenticated) {
        await _navigateToHomeScreen(userId);
      }
    }
  }

  Future<void> _navigateToHomeScreen(String userId) async {
    try {
      final residentDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (residentDoc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResidentsHome(
              resident: Residents.fromJson(residentDoc.data()!),
              userId: userId,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resident account not found.')),
        );
      }
    } catch (e) {
      debugPrint('Error navigating to home screen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred during navigation.')),
      );
    }
  }

  Future<void> _saveLoginFlag(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometricEnabled', true);
    await prefs.setString('userId', userId);
  }

  Future<void> _loginWithEmailPassword() async {
    if (_formKey.currentState?.validate() == true && _isConnected) {
      setState(() => _isLoading = true);

      final String? userId = await loginUser(
        context,
        _formKey,
        _emailController,
        _passwordController,
        false,
      );

      setState(() => _isLoading = false);

      if (userId != null) {
        await _saveLoginFlag(userId);
        await _navigateToHomeScreen(userId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } else if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!_isConnected)
          NoNetworkWidget(
            onRetry: _checkNetworkConnectivity,
          )
        else
          Padding(
            padding: EdgeInsets.all(widget.padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LogoWidget(logoSize: widget.logoSize),
                const SizedBox(height: 24),
                const SloganWidget(),
                const SizedBox(height: 24),
                _buildForm(),
                if (_showBiometricOption) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _biometricLogin,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Login with Fingerprint'),
                    style: elevatedButtonStyle,
                  ),
                ],
              ],
            ),
          ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecorations.email(),
            style: Theme.of(context).textTheme.bodyMedium,
            validator: InputValidationUtil.validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecorations.password(
              label: 'Password',
              isPasswordInvalid: _isPasswordInvalid,
            ).copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() => _hidePassword = !_hidePassword);
                },
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            obscureText: _hidePassword,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                setState(() => _isPasswordInvalid = true);
                return 'Password is required';
              }
              setState(() => _isPasswordInvalid = false);
              return null;
            },
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen()),
                );
              },
              style: textButtonStyle,
              child: const Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: 4),
          ElevatedButton(
            onPressed: _loginWithEmailPassword,
            style: elevatedButtonStyle,
            child: const Text('Login with Email'),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Not a member?",
                  style: TextStyle(color: Colors.black87)),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
                style: textButtonStyle,
                child: const Text("Register now"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}