import 'package:flutter/material.dart';
import 'package:private_library/pages/loans_pages/borrowed_page.dart';
import 'package:private_library/pages/loans_pages/lend_page.dart';

import '../../components/custom_home_button.dart';
import 'users_pages/users_page.dart';

class LoanPage extends StatelessWidget {
  const LoanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empréstimos'),
      ),
      body: ListView(
        primary: false,
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 72),
        children: [
          CustomHomeButton(
            imagePath: 'assets/images/icons/book.png',
            buttonText: 'Emprestar Livro',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LendPage();
              }));
            },
          ),
          CustomHomeButton(
            imagePath: 'assets/images/icons/books.png',
            buttonText: 'Livros Emprestados',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const BorrowedBooksPage();
              }));
            },
          ),
          CustomHomeButton(
            imagePath: 'assets/images/icons/notebook.png',
            buttonText: 'Usuários',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const UsersPage();
              }));
            },
          ),
        ],
      ),
    );
  }
}
