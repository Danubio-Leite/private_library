import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/preferences_model.dart';
import '../helpers/preferences_db_helper.dart';
import '../utils.dart';
import 'home_page.dart';

class FirstAccessPage extends StatefulWidget {
  @override
  _FirstAccessPageState createState() => _FirstAccessPageState();
}

class _FirstAccessPageState extends State<FirstAccessPage> {
  String libraryName = '';
  String userName = '';
  String selectedLogo = 'assets/images/logo/logo1.png'; // Default logo

  final logos = [
    'assets/images/logo/logo1.png',
    'assets/images/logo/logo2.png',
    'assets/images/logo/logo3.png',
    'assets/images/logo/logo4.png',
    'assets/images/logo/logo5.png',
    'assets/images/logo/logo6.png',
    'assets/images/logo/logo7.png',
    'assets/images/logo/logo8.png',
    'assets/images/logo/logo9.png',
    'assets/images/logo/logo10.png',
    'assets/images/logo/logo11.png',
    'assets/images/logo/logo12.png',
    'assets/images/logo/logo13.png',
    'assets/images/logo/logo14.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Primeiro Acesso')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  libraryName = value;
                });
              },
              decoration:
                  const InputDecoration(labelText: 'Nome da Biblioteca'),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Seu Nome'),
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: logos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLogo = logos[index];
                    });
                  },
                  child: Image.asset(
                    logos[index],
                    color:
                        selectedLogo == logos[index] ? Colors.blueGrey : null,
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                Preferences preferences = Preferences(
                  id: 001,
                  libraryName: libraryName,
                  userName: userName,
                  logoPath: selectedLogo,
                  theme: 'default',
                  language: 'pt',
                );

                await Provider.of<PreferencesDbHelper>(context, listen: false)
                    .insert(preferences);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (BuildContext context) => const HomePage()),
                );
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}
