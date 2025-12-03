import 'package:binpack_residents/utils/buttton.dart';
// Import your button utilities
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/responsive_layout.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController cellNumberController;
  final TextEditingController streetAddressController;
  final TextEditingController suburbController;
  final TextEditingController cityController;
  final TextEditingController provinceController;
  final TextEditingController postalCodeController;
  final TextEditingController creditCardController;
  final ImageProvider<Object> imageUrl;
  final void Function() uploadImage;

  const ProfileForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.cellNumberController,
    required this.streetAddressController,
    required this.suburbController,
    required this.cityController,
    required this.provinceController,
    required this.postalCodeController,
    required this.creditCardController,
    required this.imageUrl,
    required this.uploadImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ResponsiveLayout(
              mobile: _buildMobileLayout(context),
              tablet: _buildTabletDesktopLayout(context),
              desktop: _buildTabletDesktopLayout(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Mobile layout for smaller screens (single-column layout)
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildPersonalDetailsCard(context),
        const SizedBox(height: 16.0),
        _buildAddressAndCreditCardStack(
            context), // Stack address and credit card details
      ],
    );
  }

  /// Tablet/Desktop layout for larger screens (two-column layout)
  Widget _buildTabletDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildPersonalDetailsCard(
              context), // Left column for personal details
        ),
        const SizedBox(width: 16.0), // Add spacing between columns
        Expanded(
          flex: 1,
          child: _buildAddressAndCreditCardStack(
              context), // Right column for address and credit card details
        ),
      ],
    );
  }

  /// Build the personal details card
  Widget _buildPersonalDetailsCard(BuildContext context) {
    return Card(
      // elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileImage(),
            const SizedBox(height: 16),
            _buildTextField(nameController, 'Name', Icons.person),
            const SizedBox(height: 6.0),
            _buildTextField(emailController, 'Email', Icons.email),
            const SizedBox(height: 6.0),
            _buildTextField(cellNumberController, 'Phone Number', Icons.phone,
                keyboardType: TextInputType.phone, maxLength: 10),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Implement save personal details functionality
              },
              style: elevatedButtonStyle,
              child: const Text('Save Personal Details',
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  /// Stack the Address and Credit Card details (second column for larger screens)
  Widget _buildAddressAndCreditCardStack(BuildContext context) {
    return Column(
      children: [
        _buildAddressDetailsCard(context),
        const SizedBox(height: 16.0),
        _buildCreditCardDetailsCard(context),
      ],
    );
  }

  /// Build the address details card
  Widget _buildAddressDetailsCard(BuildContext context) {
    return Card(
      // elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
                streetAddressController, 'Street Address', Icons.home),
            const SizedBox(height: 6.0),
            _buildTextField(suburbController, 'Suburb', Icons.location_city),
            const SizedBox(height: 6.0),
            _buildTextField(cityController, 'City', Icons.location_city),
            const SizedBox(height: 6.0),
            _buildTextField(provinceController, 'Province', Icons.map),
            const SizedBox(height: 6.0),
            _buildTextField(postalCodeController, 'Postal Code', Icons.mail,
                keyboardType: TextInputType.number, maxLength: 6),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Implement save address functionality
              },
              style: elevatedButtonStyle,
              child: const Text('Save Address', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the credit card details card
  Widget _buildCreditCardDetailsCard(BuildContext context) {
    return Card(
      // elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
                creditCardController, 'Credit Card', Icons.credit_card,
                keyboardType: TextInputType.number, maxLength: 16),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Implement save credit card functionality
              },
              style: elevatedButtonStyle,
              child: const Text('Save Credit Card Details',
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  /// Build profile image with tap to upload functionality
  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: uploadImage,
      child: CircleAvatar(
        radius: 64.0,
        backgroundImage: imageUrl,
      ),
    );
  }

  /// Helper to build text form fields
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text, int maxLength = 50}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color.fromARGB(255, 8, 116, 13)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color.fromARGB(255, 8, 116, 13)),
        ),
      ),
      style: const TextStyle(color: Color.fromARGB(255, 8, 116, 13)),
      keyboardType: keyboardType,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }
}
