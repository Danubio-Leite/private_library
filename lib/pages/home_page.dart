import 'package:flutter/material.dart';
import 'package:private_library/components/custom_appbar.dart';
import 'package:private_library/pages/add_book_page.dart';
import 'package:private_library/pages/my_books_pages.dart/my_books_page.dart';

import '../components/custom_home_button.dart';
import 'contact.dart';
import '../i18n/app_localizations.dart';
import 'loans_pages/loans_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 139, 107, 88),
      appBar: CustomAppBar(
        title: Localizations.of(context, AppLocalizations).title,
      ),
      body: Stack(
        children: [
          ListView(
            primary: false,
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 72),
            children: [
              CustomHomeButton(
                imagePath: 'assets/images/icons/reading.png',
                buttonText: Localizations.of(context, AppLocalizations).addBook,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddBookPage(),
                    ),
                  );
                },
              ),
              CustomHomeButton(
                imagePath: 'assets/images/icons/binder.png',
                buttonText: Localizations.of(context, AppLocalizations).myBooks,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyBooksPage(),
                    ),
                  );
                },
              ),
              CustomHomeButton(
                imagePath: 'assets/images/icons/online-shopping.png',
                buttonText:
                    Localizations.of(context, AppLocalizations).wishList,
                onPressed: null,
              ),
              CustomHomeButton(
                imagePath: 'assets/images/icons/notebook.png',
                buttonText: Localizations.of(context, AppLocalizations).loans,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoanPage(),
                    ),
                  );
                },
              ),
              CustomHomeButton(
                imagePath: 'assets/images/icons/library.png',
                buttonText: Localizations.of(context, AppLocalizations).contact,
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
                imagePath: 'assets/images/icons/ebook.png',
                buttonText:
                    Localizations.of(context, AppLocalizations).aboutApp,
                onPressed: null,
              ),
            ],
          )
        ],
      ),
    );
  }
}
