import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:private_library/helpers/wish_db_helper.dart';
import 'package:private_library/pages/about_app_page.dart';
import 'package:private_library/pages/add_book_page.dart';
import 'package:private_library/pages/contact.dart';
import 'package:private_library/pages/loans_pages/loans_page.dart';
import 'package:private_library/pages/my_%20readings_page.dart';
import 'package:private_library/pages/my_books_pages.dart/my_books_page.dart';
import 'package:private_library/pages/wish_list_page.dart';
import 'package:provider/provider.dart';
import 'helpers/book_db_helper.dart';
import 'helpers/loan_db_helper.dart';
import 'helpers/reading_db_helper.dart';
import 'helpers/user_db_helper.dart';
import 'i18n/app_localizations.dart';
import 'pages/home_page.dart';
import 'routes/routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BookDbHelper>(create: (_) => BookDbHelper()),
        ChangeNotifierProvider<UserDbHelper>(create: (_) => UserDbHelper()),
        ChangeNotifierProvider<LoanDbHelper>(create: (_) => LoanDbHelper()),
        ChangeNotifierProvider<WishDbHelper>(create: (_) => WishDbHelper()),
        ChangeNotifierProvider<ReadingDbHelper>(
            create: (_) => ReadingDbHelper()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add AppLocalizations delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('pt', ''), // Portuguese
      ],
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyMedium:
              GoogleFonts.jacquesFrancois(textStyle: textTheme.bodyMedium),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 109, 149, 169),
          foregroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey)
            .copyWith(background: const Color.fromARGB(255, 255, 226, 209)),
        useMaterial3: true,
      ),
      routes: {
        Routes.HOME: (context) => const HomePage(),
        Routes.ADD_BOOK: (context) => const AddBookPage(),
        Routes.MY_BOOKS: (context) => const MyBooksPage(),
        Routes.MY_READINGS: (context) => const MyReadingsPage(),
        Routes.WISH_LIST: (context) => const WishListPage(),
        Routes.LOANS: (context) => const LoanPage(),
        Routes.CONTACT: (context) => const ContactPage(),
        Routes.ABOUT: (context) => const AboutAppPage(),
      },
    );
  }
}
