import 'package:flutter/material.dart';
import 'package:private_library/components/custom_appbar.dart';
import '../components/custom_home_button.dart';
import '../routes/routes.dart';
import '../i18n/app_localizations.dart';
import 'add_book_page.dart';

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
                imagePath: 'assets/images/icons/add-book.png',
                buttonText: Localizations.of(context, AppLocalizations).addBook,
                onPressed: () {
                  //Teste de navegação com o pushReplacementNamed
                  Navigator.pushReplacementNamed(context, Routes.ADD_BOOK);
                },
              ),
              CustomHomeButton(
                imagePath: 'assets/images/icons/bookshelf.png',
                buttonText: Localizations.of(context, AppLocalizations).myBooks,
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.MY_BOOKS);
                },
              ),
              CustomHomeButton(
                imagePath: 'assets/images/icons/desk.png',
                buttonText: 'Minhas Leituras',
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.MY_READINGS);
                },
              ),
              CustomHomeButton(
                  imagePath: 'assets/images/icons/trolley.png',
                  buttonText:
                      Localizations.of(context, AppLocalizations).wishList,
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.WISH_LIST);
                  }),
              CustomHomeButton(
                imagePath: 'assets/images/icons/hand-book.png',
                buttonText: Localizations.of(context, AppLocalizations).loans,
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.LOANS);
                },
              ),
              CustomHomeButton(
                imagePath: 'assets/images/icons/signage.png',
                buttonText: Localizations.of(context, AppLocalizations).contact,
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.CONTACT);
                },
              ),
              CustomHomeButton(
                imagePath: 'assets/images/icons/smartphone.png',
                buttonText:
                    Localizations.of(context, AppLocalizations).aboutApp,
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.ABOUT);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
