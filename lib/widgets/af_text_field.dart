import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class AfTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool enabled;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;

  const AfTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
    this.textInputAction,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      enabled: enabled,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      style: const TextStyle(
        fontFamily: 'Playfair',
        fontSize: 14,
        color: AppTheme.charcoal,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                size: 20,
                color: AppTheme.terracotta.withOpacity(0.7),
              )
            : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
