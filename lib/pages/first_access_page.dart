import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:private_library/components/custom_button.dart';
import 'package:private_library/components/custom_textformfield.dart';
import 'package:provider/provider.dart';
import '../models/preferences_model.dart';
import '../helpers/preferences_db_helper.dart';
import '../routes/routes.dart';
import '../utils.dart';
import 'home_page.dart';

class FirstAccessPage extends StatefulWidget {
  @override
  _FirstAccessPageState createState() => _FirstAccessPageState();
}

class _FirstAccessPageState extends State<FirstAccessPage> {
  String selectedLogo = 'assets/images/logo/nologo.png';
  final TextEditingController libraryNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  Future<List<Preferences>>? preferencesFuture;

  @override
  void initState() {
    super.initState();
    preferencesFuture =
        Provider.of<PreferencesDbHelper>(context, listen: false).queryAllRows();
  }

  final logos = [
    'assets/images/logo/logo01.png',
    'assets/images/logo/logo02.png',
    'assets/images/logo/logo03.png',
    'assets/images/logo/logo04.png',
    'assets/images/logo/logo05.png',
    'assets/images/logo/logo06.png',
    'assets/images/logo/logo07.png',
    'assets/images/logo/logo08.png',
    'assets/images/logo/logo09.png',
    'assets/images/logo/logo10.png',
    'assets/images/logo/logo11.png',
    'assets/images/logo/logo12.png',
    'assets/images/logo/logo13.png',
    'assets/images/logo/logo14.png',
    'assets/images/logo/nologo.png',
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Preferences>>(
        future: preferencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            Preferences preferences = snapshot.data?.isEmpty ?? true
                ? Preferences(
                    id: 001,
                    libraryName: '',
                    userName: '',
                    theme: 'green',
                    logoPath: 'assets/images/logo/nologo.png',
                    language: 'pt',
                  )
                : snapshot.data!.first;

            return Scaffold(
              appBar: AppBar(
                title: const Text('Bem Vindo'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Antes de começar, precisamos de algumas informações:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomFormField(
                        label: 'Dê um nome para sua Biblioteca',
                        controller: libraryNameController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomFormField(
                        label: 'Qual seu nome?',
                        controller: userNameController,
                      ),
                    ),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Selecione uma logo para a Biblioteca:',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: logos.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (context, index) {
                              return Card(
                                color: selectedLogo == logos[index]
                                    ? Colors.blueGrey
                                    : Colors.white70,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedLogo = logos[index];
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: index == logos.length - 1
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child: Image.asset(
                                                  logos[index],
                                                ),
                                              ),
                                              const Flexible(
                                                child: Center(
                                                    child: AutoSizeText(
                                                        'Sem Logo')),
                                              ),
                                            ],
                                          )
                                        : Image.asset(
                                            logos[index],
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          theme: preferences.theme,
                          onPressed: () async {
                            Preferences preferences = Preferences(
                              id: 001,
                              libraryName: libraryNameController.text,
                              userName: userNameController.text,
                              logoPath: selectedLogo,
                              theme: 'green',
                              language: 'pt',
                            );

                            await Provider.of<PreferencesDbHelper>(context,
                                    listen: false)
                                .insert(preferences);

                            await PreferencesService().setFirstAccess();

                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            }
                          },
                          texto: 'Confirmar',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
