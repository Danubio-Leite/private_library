import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const CustomButton({
    Key? key,
    required this.texto,
    required this.onPressed,
    this.backgroundColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor ?? const Color.fromARGB(255, 103, 145, 92),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        texto,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 53, 53, 53)),
      ),
    );
  }
}
