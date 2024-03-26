import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  String? title2;
  String? imagePath;
  String theme;

  CustomAppBar({
    required this.title,
    this.imagePath,
    this.title2,
    required this.theme,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 2);

  @override
  Widget build(BuildContext context) {
    Color appBarColor;
    switch (theme) {
      case 'green':
        appBarColor = const Color.fromARGB(255, 101, 171, 128);
        break;
      case 'default':
        appBarColor = const Color.fromARGB(255, 109, 149, 169);
        break;
      case 'light':
        appBarColor = const Color.fromARGB(255, 141, 199, 228);
        break;
      case 'flat':
        appBarColor = const Color.fromARGB(255, 143, 142, 198);
        break;
      default:
        appBarColor = const Color.fromARGB(255, 109, 149, 169);
    }
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 109, 149, 169),
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
        decoration: BoxDecoration(
          color: appBarColor,
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
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: AutoSizeText(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ), // tamanho do texto
                      ),
                    ),
                    if (title2 != null) const SizedBox(height: 8),
                    if (title2 != null) // adiciona espaço entre os dois títulos
                      Flexible(
                        child: AutoSizeText(
                          title2!,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold), // tamanho do texto
                        ),
                      ),
                  ],
                ),
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
