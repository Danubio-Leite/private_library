import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final Icon? icon;

  const CustomButton({
    Key? key,
    required this.texto,
    required this.onPressed,
    this.backgroundColor,
    this.padding,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon ??
          const SizedBox(
            width: 0,
          ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor ?? const Color.fromARGB(255, 103, 145, 92),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            texto,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 53, 53, 53)),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
