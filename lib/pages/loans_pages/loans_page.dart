import 'package:flutter/material.dart';

import '../../components/custom_home_button.dart';

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
            buttonText: 'Lend Book',
            onPressed: () {},
          ),
          CustomHomeButton(
            imagePath: 'assets/images/icons/books.png',
            buttonText: 'Borrowed books',
            onPressed: () {},
          ),
          CustomHomeButton(
            imagePath: 'assets/images/icons/notebook.png',
            buttonText: 'Users',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
