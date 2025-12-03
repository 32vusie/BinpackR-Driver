import 'package:flutter/material.dart';
import 'dart:ui';

OverlayEntry? _loadingOverlayEntry;

/// Shows a global loading overlay with a blurred background and a green loader.
void showLoadingOverlay(BuildContext context) {
  final overlay = Overlay.of(context);
  _loadingOverlayEntry = OverlayEntry(
    builder: (context) => Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.5),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 8, 116, 13)),
            ),
          ),
        ),
      ),
    ),
  );
  overlay.insert(_loadingOverlayEntry!);
}

/// Hides the global loading overlay.
void hideLoadingOverlay() {
  _loadingOverlayEntry?.remove();
  _loadingOverlayEntry = null;
}
