import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MaterialApp(
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('en', ''),
      Locale('pt', ''),
      Locale('es', ''),
    ],
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyMedium:
              GoogleFonts.jacquesFrancois(textStyle: textTheme.bodyMedium),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 103, 145, 92),
          foregroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown)
            .copyWith(background: const Color.fromARGB(255, 255, 226, 209)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
