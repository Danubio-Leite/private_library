import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:private_library/components/custom_button.dart';
import 'package:provider/provider.dart';

import '../helpers/preferences_db_helper.dart';
import '../models/preferences_model.dart';
import '../routes/routes.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController libraryNameController = TextEditingController();
    final TextEditingController userNameController = TextEditingController();

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

    return FutureBuilder<List<Preferences>>(
      future: Provider.of<PreferencesDbHelper>(context, listen: false)
          .queryAllRows(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          Preferences preferences = snapshot.data!.first;

          return Scaffold(
              appBar: AppBar(
                title: const Text('Preferências'),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Alterar Nome da Biblioteca'),
                                content: TextField(
                                  controller: libraryNameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Digite o nome da biblioteca',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Salvar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        texto: 'Alterar Nome da Biblioteca',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Alterar Nome do Usuário'),
                                content: TextField(
                                  controller: userNameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Digite seu nome',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Salvar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        texto: 'Alterar Meu Nome',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Selecione a Logo:'),
                                content: SizedBox(
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: Scrollbar(
                                    child: GridView.builder(
                                      // physics:
                                      //     const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: logos.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                      ),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              preferences.logoPath =
                                                  logos[index];
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                                border: Border.all(
                                                  color: preferences.logoPath ==
                                                          logos[index]
                                                      ? Colors.blueGrey
                                                      : Colors.transparent,
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    //update logoPath
                                                    preferences.logoPath =
                                                        logos[index];
                                                    // update logoPath in database
                                                    Provider.of<PreferencesDbHelper>(
                                                            context,
                                                            listen: false)
                                                        .update(preferences);
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context)
                                                        .pushNamed(Routes.HOME);
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: index ==
                                                          logos.length - 1
                                                      ? Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              child:
                                                                  Image.asset(
                                                                logos[index],
                                                              ),
                                                            ),
                                                            const Center(
                                                                child: Text(
                                                                    'Sem Logo')),
                                                          ],
                                                        )
                                                      : Image.asset(
                                                          logos[index],
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        texto: 'Alterar Logo',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () {},
                        texto: 'Alterar Tema',
                      ),
                    ),
                  ),
                ],
              ));
        }
      },
    );
  }
}
