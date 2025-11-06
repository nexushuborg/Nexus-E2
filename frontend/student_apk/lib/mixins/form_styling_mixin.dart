import 'package:flutter/material.dart';
import '../theme.dart';

mixin FormStylingMixin {
  TextStyle get inputTextStyle => const TextStyle(
        color: AppTheme.textColor2,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  InputDecoration getInputDecoration({
    required String labelText,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: labelText,
      errorText: errorText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      suffixIcon: suffixIcon,
      hintStyle: TextStyle(
        color: AppTheme.textColor2.withOpacity(0.6),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: TextStyle(
        color: Colors.red.shade700,
      ),
    );
  }
}
