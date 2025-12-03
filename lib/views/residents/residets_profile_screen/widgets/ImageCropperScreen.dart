import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCropperScreen extends StatefulWidget {
  const ImageCropperScreen({super.key});

  @override
  _ImageCropperScreenState createState() => _ImageCropperScreenState();
}

class _ImageCropperScreenState extends State<ImageCropperScreen> {
  // Function to pick an image and crop it
  Future<void> pickAndCropImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {

      // Handle the cropped file (croppedFile) here...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Cropper Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: pickAndCropImage,
          child: const Text('Pick and Crop Image'),
        ),
      ),
    );
  }
}
