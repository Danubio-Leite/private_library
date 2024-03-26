import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:private_library/components/custom_button.dart';
import 'package:provider/provider.dart';

import '../components/custom_home_button.dart';
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
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          Preferences preferences = snapshot.data!.first;
          libraryNameController.text = preferences.libraryName;
          userNameController.text = preferences.userName;

          return Scaffold(
              appBar: AppBar(
                title: const Text('Preferências'),
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.HOME);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
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
                                  title:
                                      const Text('Alterar Nome da Biblioteca'),
                                  content: TextField(
                                    controller: libraryNameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Digite o novo nome',
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            preferences.libraryName =
                                                libraryNameController.text;
                                            Provider.of<PreferencesDbHelper>(
                                                    context,
                                                    listen: false)
                                                .update(preferences);
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Color.fromARGB(
                                                    255, 109, 149, 169),
                                                content: Text(
                                                  'Novo nome definido!',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text('Salvar'),
                                        ),
                                      ],
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            preferences.userName =
                                                userNameController.text;
                                            Provider.of<PreferencesDbHelper>(
                                                    context,
                                                    listen: false)
                                                .update(preferences);
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Color.fromARGB(
                                                    255, 109, 149, 169),
                                                content: Text(
                                                  'Seu nome foi atualizado!',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text('Salvar'),
                                        ),
                                      ],
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
                                          return Padding(
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
                                                    preferences.logoPath =
                                                        logos[index];
                                                    Provider.of<PreferencesDbHelper>(
                                                            context,
                                                            listen: false)
                                                        .update(preferences);
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                109, 149, 169),
                                                        content: Text(
                                                          'Nova logo selecionada!',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    );
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Escolha um tema:'),
                                  content: SizedBox(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: Scrollbar(
                                        child: GridView.count(
                                      crossAxisCount: 2,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              preferences.theme = 'green';
                                              Provider.of<PreferencesDbHelper>(
                                                      context,
                                                      listen: false)
                                                  .update(preferences);
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 101, 171, 128),
                                                  content: Text(
                                                    'Tema alterado para Verde!',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 101, 171, 128),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Flexible(
                                                  child: Image.asset(
                                                      'assets/images/icons/green/add-book.png'),
                                                ),
                                                const AutoSizeText(
                                                  'Green',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 53, 53, 53),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              preferences.theme = 'default';
                                              Provider.of<PreferencesDbHelper>(
                                                      context,
                                                      listen: false)
                                                  .update(preferences);
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 109, 149, 169),
                                                  content: Text(
                                                    'Tema alterado para Default!',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 109, 149, 169),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Flexible(
                                                  child: Image.asset(
                                                      'assets/images/icons/default/add-book.png'),
                                                ),
                                                const AutoSizeText(
                                                  'Default',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 53, 53, 53),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              preferences.theme = 'light';
                                              Provider.of<PreferencesDbHelper>(
                                                      context,
                                                      listen: false)
                                                  .update(preferences);
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 141, 199, 228),
                                                  content: Text(
                                                    'Tema alterado para Light!',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 141, 199, 228),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Flexible(
                                                  child: Image.asset(
                                                      'assets/images/icons/light/add-book.png'),
                                                ),
                                                const AutoSizeText(
                                                  'Light',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 53, 53, 53),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              preferences.theme = 'flat';
                                              Provider.of<PreferencesDbHelper>(
                                                      context,
                                                      listen: false)
                                                  .update(preferences);
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 143, 142, 198),
                                                  content: Text(
                                                    'Tema alterado para Flat!',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 143, 142, 198),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Flexible(
                                                  child: Image.asset(
                                                      'assets/images/icons/flat/add-book.png'),
                                                ),
                                                const AutoSizeText(
                                                  'Flat',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 53, 53, 53),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                  ),
                                );
                              },
                            );
                          },
                          texto: 'Alterar Tema',
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        }
      },
    );
  }
}
