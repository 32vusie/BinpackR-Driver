import 'package:binpack_residents/utils/InputDecoration.dart';
import 'package:binpack_residents/utils/buttton.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedSupportType = 'App Support';

  static const List<String> supportOptions = [
    'App Support',
    'Sales',
    'Dispatch',
    'Ward',
    'Business',
    'Report Behaviour',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be logged in to submit a support request.'),
          ),
        );
        return;
      }

      try {
        await FirebaseFirestore.instance.collection('support').add({
          'name': _nameController.text,
          'email': _emailController.text,
          'message': _messageController.text,
          'userID': userId,
          'supportID': DateTime.now().millisecondsSinceEpoch.toString(),
          'relatedSupport': _selectedSupportType,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your message has been sent!'),
            ),
          );
        }

        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
        setState(() {
          _selectedSupportType = 'App Support';
        });
      } catch (e) {
        print('Error submitting form: ${e.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send message. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        // backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecorations.name(label: 'Name'),
                    validator: InputValidationUtil.validateName,
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecorations.email(label: 'Email'),
                    validator: InputValidationUtil.validateEmail,
                  ),
                  const SizedBox(height: 16),

                  // Message Field
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecorations.paragraph(label: 'Message'),
                    maxLines: 4,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your message'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Support Type Dropdown
                  Text(
                    'Support related to:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedSupportType,
                    items: supportOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSupportType = newValue!;
                      });
                    },
                    decoration: inputDecorationStyle.copyWith(
                        labelText: 'Select Support Type'),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: elevatedButtonStyle,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
