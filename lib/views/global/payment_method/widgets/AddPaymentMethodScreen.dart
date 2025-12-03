// add_payment_method_screen.dart

import 'package:binpack_residents/utils/InputDecoration.dart';
import 'package:binpack_residents/utils/buttton.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
// Your validation utilities

class AddPaymentMethodScreen extends StatefulWidget {
  final Map<String, dynamic>? paymentMethod;

  const AddPaymentMethodScreen({this.paymentMethod, super.key});

  @override
  _AddPaymentMethodScreenState createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();

  bool _isSaving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.paymentMethod != null) {
      _cardHolderController.text = widget.paymentMethod!['cardHolderName'];
      _cardNumberController.text = widget.paymentMethod!['cardNumber'];
      _expiryDateController.text = widget.paymentMethod!['expiryDate'];
    }
  }

  Future<void> _saveOrUpdatePaymentMethod() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorText = null;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in');

      final collectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('paymentMethods');

      if (widget.paymentMethod != null) {
        await collectionRef.doc(widget.paymentMethod!['id']).update({
          'cardNumber': _cardNumberController.text
              .replaceAll(' ', '')
              .substring(_cardNumberController.text.replaceAll(' ', '').length -
                  4), // Store last 4 digits
          'expiryDate': _expiryDateController.text,
          'cvv': '*', // Mask CVV for security
          'cardHolderName': _cardHolderController.text,
        });
        Navigator.pop(context, 'Payment method updated successfully');
      } else {
        await collectionRef.add({
          'cardNumber': _cardNumberController.text
              .replaceAll(' ', '')
              .substring(_cardNumberController.text.replaceAll(' ', '').length -
                  4), // Store last 4 digits
          'expiryDate': _expiryDateController.text,
          'cvv': '*', // Mask CVV for security
          'cardHolderName': _cardHolderController.text,
        });
        Navigator.pop(context, 'Payment method added successfully');
      }
    } catch (error) {
      setState(() {
        _errorText = 'Failed to save payment method';
      });
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add or Edit Payment Method')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Cardholder Name Field using name style utility
              TextFormField(
                controller: _cardHolderController,
                decoration: InputDecorations.name(), // Custom name decoration
                validator:
                    InputValidationUtil.validateName, // Custom name validation
              ),
              const SizedBox(height: 16),

              // Card Number Field using credit card style utility
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecorations
                    .creditCard(), // Custom credit card decoration
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  LengthLimitingTextInputFormatter(19), // Limits input length
                  _CardNumberInputFormatter(), // Custom formatter for spacing in card number
                ],
                validator: InputValidationUtil
                    .validateCreditCard, // Custom credit card validation
              ),

              const SizedBox(height: 16),

              // Expiry Date Field using date style utility
              TextFormField(
                controller: _expiryDateController,
                decoration:
                    InputDecorations.dateField(), // Custom date decoration
                keyboardType: TextInputType.datetime,
                validator: InputDecorations
                    .validateExpiryDate, // Custom expiry date validation
              ),
              const SizedBox(height: 16),

              // CVV Field using general secure input style utility
              TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                keyboardType: TextInputType.number,
                validator: _validateCVV,
              ),

              const SizedBox(height: 16),

              if (_errorText != null)
                Text(_errorText!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                style: elevatedButtonStyle,
                onPressed: _isSaving ? null : _saveOrUpdatePaymentMethod,
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Save Payment Method'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? _validateCVV(String? value) {
  if (value == null || value.isEmpty) return 'Please enter the CVV';
  if (value.length != 3) return 'Invalid CVV';
  return null;
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any existing spaces
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    // Add spaces every 4 characters
    for (int i = 0; i < text.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }

    // Return the formatted value with the cursor at the end
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
