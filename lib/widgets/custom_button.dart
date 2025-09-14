import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
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
              Flexible(child: Text(text)),
            ],
          );

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: type == ButtonType.primary
          ? ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              child: child,
            )
          : type == ButtonType.secondary
              ? OutlinedButton(
                  onPressed: isLoading ? null : onPressed,
                  child: child,
                )
              : TextButton(
                  onPressed: isLoading ? null : onPressed,
                  child: child,
                ),
    );
  }
}

enum ButtonType {
  primary,
  secondary,
  text,
}