import 'package:binpack_residents/utils/theme.dart';
import 'package:flutter/material.dart';

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: primaryColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(150),
  ),
  minimumSize: const Size(double.infinity, 50),
);

final ButtonStyle textButtonStyle = TextButton.styleFrom(
  foregroundColor: primaryColor,
);

// Cancel button style
final ButtonStyle cancelButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.black,
  backgroundColor: Colors.grey[300], // Light grey for cancel button
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(150),
  ),
  minimumSize: const Size(double.infinity, 50),
);

// Delete button style
final ButtonStyle deleteButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor:
      const Color.fromARGB(255, 206, 25, 13), // Red for delete button
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(150),
  ),
  minimumSize: const Size(double.infinity, 50),
);
