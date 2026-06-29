import 'package:flutter/material.dart';

enum AfButtonVariant { filled, outlined, text }

class AfButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final AfButtonVariant variant;
  final IconData? icon;

  const AfButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.variant = AfButtonVariant.filled,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    Widget button;

    switch (variant) {
      case AfButtonVariant.filled:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
        break;
      case AfButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
        break;
      case AfButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
