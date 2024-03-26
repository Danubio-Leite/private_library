import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? texto;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final IconData? icon;
  String theme;

  CustomButton({
    super.key,
    this.texto,
    required this.onPressed,
    this.backgroundColor,
    this.padding,
    this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    switch (theme) {
      case 'green':
        buttonColor = const Color.fromARGB(255, 101, 171, 128);
        break;
      case 'default':
        buttonColor = const Color.fromARGB(255, 109, 149, 169);
        break;
      case 'light':
        buttonColor = const Color.fromARGB(255, 141, 199, 228);
        break;
      case 'flat':
        buttonColor = const Color.fromARGB(255, 143, 142, 198);
        break;
      default:
        buttonColor = const Color.fromARGB(255, 109, 149, 169);
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? buttonColor,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: icon != null
          ? Row(
              children: [
                Icon(icon, color: Colors.black, size: 26),
              ],
            )
          :
          // ignore: prefer_const_constructors
          AutoSizeText(
              texto!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 53, 53, 53),
              ),
            ),
    );
  }
}
