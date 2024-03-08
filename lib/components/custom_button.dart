import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? texto;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final IconData? icon;

  const CustomButton({
    Key? key,
    this.texto,
    required this.onPressed,
    this.backgroundColor,
    this.padding,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.blueGrey,
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
          Text(
              texto!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 53, 53, 53),
              ),
            ),

      // Text(
      //   texto,
      //   style: const TextStyle(
      //       fontSize: 16,
      //       fontWeight: FontWeight.bold,
      //       color: Color.fromARGB(255, 53, 53, 53)),
      // ),
    );
  }
}
