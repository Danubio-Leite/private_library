import 'package:flutter/material.dart';
import 'package:private_library/pages/loans_pages/borrowed_page.dart';
import 'package:private_library/pages/loans_pages/lend_page.dart';
import 'package:provider/provider.dart';

import '../../components/custom_home_button.dart';
import 'users_pages/users_page.dart';
import '../../helpers/preferences_db_helper.dart';
import '../../models/preferences_model.dart';

class LoanPage extends StatelessWidget {
  const LoanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Preferences>(
      future: Provider.of<PreferencesDbHelper>(context, listen: false)
          .queryAllRows()
          .then((value) => value.first),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          Preferences preferences = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Empréstimos'),
            ),
            body: ListView(
              primary: false,
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 15, bottom: 72),
              children: [
                CustomHomeButton(
                  imagePath: 'assets/images/icons/book.png',
                  buttonText: 'Emprestar Livro',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LendPage();
                    }));
                  },
                  theme: preferences.theme,
                ),
                CustomHomeButton(
                  imagePath: 'assets/images/icons/books.png',
                  buttonText: 'Livros Emprestados',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const BorrowedBooksPage();
                    }));
                  },
                  theme: preferences.theme,
                ),
                CustomHomeButton(
                  imagePath: 'assets/images/icons/notebook.png',
                  buttonText: 'Usuários',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const UsersPage();
                    }));
                  },
                  theme: preferences.theme,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
