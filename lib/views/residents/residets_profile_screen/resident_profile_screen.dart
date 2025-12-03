import 'dart:io';
import 'package:binpack_residents/models/users/resident.dart';
import 'package:binpack_residents/views/global/payment_method/PaymentMethodScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  final Residents resident;

  const ProfileEditPage({super.key, required this.resident});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _cellNumberController;
  late TextEditingController _addressController;
  late TextEditingController _suburbController;
  late TextEditingController _cityController;
  late TextEditingController _provinceController;
  late TextEditingController _postalCodeController;
  late ImageProvider<Object> _imageUrl;
  String? _newImageUrl;
  String? _selectedPaymentMethodId;
  String _selectedPaymentCardLast4 = '****';
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.resident.name);
    _emailController = TextEditingController(text: widget.resident.email);
    _cellNumberController =
        TextEditingController(text: widget.resident.cellNumber);
    _addressController =
        TextEditingController(text: widget.resident.streetAddress);
    _suburbController = TextEditingController(text: widget.resident.suburb);
    _cityController = TextEditingController(text: widget.resident.city);
    _provinceController = TextEditingController(text: widget.resident.province);
    _postalCodeController =
        TextEditingController(text: widget.resident.postalCode);
    _imageUrl = NetworkImage(widget.resident.profilePictureUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cellNumberController.dispose();
    _addressController.dispose();
    _suburbController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _isLoading = true);
      try {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('/profilePics/${widget.resident.userID}');
        TaskSnapshot taskSnapshot =
            await storageReference.putFile(File(pickedFile.path));

        if (taskSnapshot.state == TaskState.success) {
          String imageUrl = await storageReference.getDownloadURL();
          setState(() {
            _imageUrl = NetworkImage(imageUrl);
            _newImageUrl = imageUrl;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Profile picture uploaded successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload profile picture')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: ${e.toString()}')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateUserProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final updatedData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'cellNumber': _cellNumberController.text,
      'streetAddress': _addressController.text,
      'suburb': _suburbController.text,
      'city': _cityController.text,
      'province': _provinceController.text,
      'postalCode': _postalCodeController.text,
    };

    if (_newImageUrl != null) {
      updatedData['profilePictureUrl'] = _newImageUrl!;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.resident.userID)
          .update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _openPaymentMethodScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodScreen(
          onSelect: (paymentMethodId, cardHolderName, last4Digits) {
            setState(() {
              _selectedPaymentMethodId = paymentMethodId;
              _selectedPaymentCardLast4 = last4Digits;
            });
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedPaymentMethodId = result['paymentMethodId'];
        _selectedPaymentCardLast4 = result['last4Digits'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _updateUserProfile,
          ),
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: _uploadImage,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ProfileForm(
                  nameController: _nameController,
                  emailController: _emailController,
                  cellNumberController: _cellNumberController,
                  streetAddressController: _addressController,
                  suburbController: _suburbController,
                  cityController: _cityController,
                  provinceController: _provinceController,
                  postalCodeController: _postalCodeController,
                  creditCardLast4: _selectedPaymentCardLast4,
                  imageUrl: _imageUrl,
                  uploadImage: _uploadImage,
                  openPaymentMethodScreen: _openPaymentMethodScreen,
                ),
              ),
            ),
    );
  }
}

class ProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController cellNumberController;
  final TextEditingController streetAddressController;
  final TextEditingController suburbController;
  final TextEditingController cityController;
  final TextEditingController provinceController;
  final TextEditingController postalCodeController;
  final String creditCardLast4;
  final ImageProvider<Object> imageUrl;
  final void Function() uploadImage;
  final void Function() openPaymentMethodScreen;

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
    required this.creditCardLast4,
    required this.imageUrl,
    required this.uploadImage,
    required this.openPaymentMethodScreen,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPersonalDetailsCard(),
          const SizedBox(height: 16.0),
          _buildAddressDetailsCard(),
          const SizedBox(height: 16.0),
          _buildCreditCardDetailsCard(context),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: uploadImage,
              child: CircleAvatar(radius: 64.0, backgroundImage: imageUrl),
            ),
            const SizedBox(height: 16),
            _buildTextField(nameController, 'Name', Icons.person),
            _buildTextField(emailController, 'Email', Icons.email),
            _buildTextField(cellNumberController, 'Phone Number', Icons.phone,
                keyboardType: TextInputType.phone, maxLength: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
                streetAddressController, 'Street Address', Icons.home),
            _buildTextField(suburbController, 'Suburb', Icons.location_city),
            _buildTextField(cityController, 'City', Icons.location_city),
            _buildTextField(provinceController, 'Province', Icons.map),
            _buildTextField(postalCodeController, 'Postal Code', Icons.mail,
                keyboardType: TextInputType.number, maxLength: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardDetailsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: openPaymentMethodScreen,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                const Icon(Icons.credit_card, color: Colors.blue),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    '**** **** **** $creditCardLast4',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.blue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text, int maxLength = 50}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      maxLength: maxLength,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? 'Enter $label' : null,
    );
  }
}
