import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  String? title2;
  String? imagePath;

  CustomAppBar({
    required this.title,
    this.imagePath,
    this.title2,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 2);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 103, 145, 92),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(1),
          bottomRight: Radius.circular(1),
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ), // tamanho do texto
                  ),
                  if (title2 != null) const SizedBox(height: 8),
                  if (title2 != null) // adiciona espaço entre os dois títulos
                    Text(
                      title2!,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold), // tamanho do texto
                    ),
                ],
              ),
              if (imagePath != null)
                Image.asset(
                  imagePath!,
                  fit: BoxFit.contain,
                  height: kToolbarHeight * 1.5, // altura da imagem
                ),
            ],
          ),
        ),
      ),
    );
  }
}
