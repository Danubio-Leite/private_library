import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'helpers/book_db_helper.dart';
import 'helpers/loan_db_helper.dart';
import 'helpers/reading_db_helper.dart';
import 'helpers/user_db_helper.dart';
import 'i18n/app_localizations.dart';
import 'pages/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BookDbHelper>(create: (_) => BookDbHelper()),
        ChangeNotifierProvider<UserDbHelper>(create: (_) => UserDbHelper()),
        ChangeNotifierProvider<LoanDbHelper>(create: (_) => LoanDbHelper()),
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
      home: const HomePage(),
    );
  }
}
