import 'package:flutter/material.dart';
import 'package:student_apk/utils/ui_constants.dart';

class CommonWidgets {
  static Widget buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: UIConstants.bodyStyle,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: UIConstants.bodyStyle.copyWith(color: UIConstants.textColor.withAlpha(179)),
        prefixIcon: Icon(prefixIcon, color: UIConstants.textColor),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.inputRadius),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withAlpha(25),
      ),
    );
  }

  static Widget buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: UIConstants.buttonColor,
        foregroundColor: UIConstants.textColor2,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.buttonRadius),
        ),
      ),
      child: Text(text),
    );
  }

  static Widget buildOutlinedButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: UIConstants.textColor,
        side: const BorderSide(color: UIConstants.textColor),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.buttonRadius),
        ),
      ),
      child: Text(text),
    );
  }

  static Widget buildDropdownField<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String Function(T) itemText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(UIConstants.inputRadius),
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        dropdownColor: UIConstants.primaryColor,
        style: UIConstants.bodyStyle,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: UIConstants.bodyStyle.copyWith(color: UIConstants.textColor.withAlpha(179)),
          border: InputBorder.none,
        ),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(itemText(item)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  static Widget buildGlassCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withAlpha(51),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  static PreferredSizeWidget buildAppBar({
    required BuildContext context,
    required String title,
    bool showBackButton = true,
    bool showSettings = false,
    VoidCallback? onSettingsTap,
  }) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: UIConstants.textColor),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(title, style: UIConstants.headingStyle),
      centerTitle: true,
      actions: [
        if (showSettings)
          IconButton(
            icon: const Icon(Icons.settings, color: UIConstants.textColor),
            onPressed: onSettingsTap ?? () {},
          ),
      ],
    );
  }
}
