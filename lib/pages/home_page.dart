import 'package:flutter/material.dart';
import 'package:private_library/components/custom_appbar.dart';

import '../components/custom_home_button.dart';
import 'contact.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 139, 107, 88),
      appBar: CustomAppBar(
        title: 'Biblioteca Particular',
      ),
      body: Stack(
        children: [
          ListView(
            primary: false,
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 72),
            children: [
              CustomHomeButton(
                imagePath: 'assets/images/icons/openBook.png',
                buttonText: 'Adicionar Livro',
                onPressed: null,
              ),
              CustomHomeButton(
                imagePath: 'assets/images/icons/sear.png',
                buttonText: 'Meus Livros',
                onPressed: null,
              ),
              CustomHomeButton(
                imagePath: 'assets/images/icons/bookss.png',
                buttonText: 'Lista de Desejos',
                onPressed: null,
              ),
              CustomHomeButton(
                imagePath: 'assets/images/icons/dictionary.png',
                buttonText: 'Empréstimos',
                onPressed: null,
              ),
              CustomHomeButton(
                imagePath: 'assets/images/icons/owl.png',
                buttonText: 'Fale Conosco',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactPage(),
                    ),
                  );
                },
              ),
              CustomHomeButton(
                imagePath: 'assets/images/icons/enc.png',
                buttonText: 'Sobre o App',
                onPressed: null,
              ),
            ],
          )
        ],
      ),
    );
  }
}
