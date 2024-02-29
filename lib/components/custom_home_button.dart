import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomHomeButton extends StatelessWidget {
  String imagePath;
  String buttonText;
  VoidCallback? onPressed;
  CustomHomeButton(
      {super.key,
      required this.imagePath,
      required this.buttonText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Material(
            color: const Color.fromARGB(255, 103, 145, 92),
            borderRadius: BorderRadius.circular(2),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(2),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: AutoSizeText(
                            buttonText,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 24.0, top: 8.0, bottom: 8.0),
                          child: Image.asset(
                            imagePath,
                            height: 65,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onPressed == null)
                    Positioned(
                      right: 0.0,
                      top: 0.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(2),
                            bottomLeft: Radius.circular(4),
                          ),
                          color: Color.fromARGB(255, 227, 96, 94),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        child: const Text(
                          'Em breve',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
