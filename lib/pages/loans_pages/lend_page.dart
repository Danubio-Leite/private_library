// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:private_library/models/loan_model.dart';
import 'package:provider/provider.dart';

import '../../helpers/book_db_helper.dart';
import '../../helpers/loan_db_helper.dart';
import '../../helpers/reading_db_helper.dart';
import '../../helpers/user_db_helper.dart';
import '../../models/book_model.dart';
import '../../models/user_model.dart';
import 'users_pages/add_user_page.dart';

class LendPage extends StatefulWidget {
  const LendPage({super.key});

  @override
  State<LendPage> createState() => _LendPageState();
}

class _LendPageState extends State<LendPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lend Book'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            FutureBuilder<List<Book>>(
              future:
                  Provider.of<BookDbHelper>(context, listen: false).getBooks(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else {
                    final books = snapshot.data!.where((book) {
                      return book.title
                              .toLowerCase()
                              .contains(_searchText.toLowerCase()) ||
                          book.author
                              .toLowerCase()
                              .contains(_searchText.toLowerCase());
                    }).toList();
                    return Expanded(
                      child: ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (_, index) {
                          return Column(
                            children: [
                              ListTile(
                                  title: Text(books[index].title),
                                  subtitle: Text(books[index].author),
                                  onTap: () async {
                                    final users =
                                        await Provider.of<UserDbHelper>(context,
                                                listen: false)
                                            .getUsers();
                                    if (users.isEmpty) {
                                      // ignore: use_build_context_synchronously
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Nenhum usuário cadastrado'),
                                            content: const Text(
                                                'Por favor, cadastre um usuário antes de emprestar um livro.'),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TextButton(
                                                    child:
                                                        const Text('Cancelar'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child:
                                                        const Text('Cadastrar'),
                                                    onPressed: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return const AddUserPage(
                                                            twoPop: true,
                                                          );
                                                        },
                                                      ));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      final loans =
                                          await Provider.of<LoanDbHelper>(
                                                  context,
                                                  listen: false)
                                              .getLoans();
                                      final readings =
                                          await Provider.of<ReadingDbHelper>(
                                                  context,
                                                  listen: false)
                                              .getReadings();
                                      if (loans.any((loan) =>
                                          loan.book.id == books[index].id &&
                                          loan.endDateLoan == null)) {
                                        // ignore: use_build_context_synchronously
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Livro já emprestado'),
                                              content: const Text(
                                                  'Este livro já está emprestado. Por favor, escolha outro livro ou verifique o status do empréstimo.'),
                                              actions: [
                                                TextButton(
                                                  child: const Text('OK'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else if (readings.any((reading) =>
                                          reading.book.id == books[index].id &&
                                          reading.endDateReading == null)) {
                                        // ignore: use_build_context_synchronously
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Leitura em andamento'),
                                                content: const Text(
                                                    'Você está lendo este livro. Deseja registrar o término da leitura?'),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Não'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          final reading = readings
                                                              .firstWhere((reading) =>
                                                                  reading.book
                                                                          .id ==
                                                                      books[index]
                                                                          .id &&
                                                                  reading.endDateReading ==
                                                                      null);
                                                          reading.endDateReading =
                                                              DateTime.now();
                                                          Provider.of<ReadingDbHelper>(
                                                                  context,
                                                                  listen: false)
                                                              .updateReading(
                                                                  reading);
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      77,
                                                                      144,
                                                                      117),
                                                              content: Text(
                                                                  'Registrado o término da leitura de ${books[index].title}.'),
                                                            ),
                                                          );
                                                        },
                                                        child:
                                                            const Text('Sim'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                      } else
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return LayoutBuilder(
                                              builder: (BuildContext context,
                                                  BoxConstraints constraints) {
                                                return AlertDialog(
                                                  content: Stack(
                                                    children: [
                                                      SizedBox(
                                                        height: constraints
                                                                .maxHeight *
                                                            0.5, // 50% da altura da tela
                                                        width: constraints
                                                                .maxWidth *
                                                            0.8, // 80% da largura da tela
                                                        child:
                                                            SingleChildScrollView(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          child: Column(
                                                            children: [
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            24.0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    'O livro está sendo emprestado para:',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            21,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: constraints
                                                                        .maxHeight *
                                                                    0.4, // 40% da altura da tela
                                                                child: FutureBuilder<
                                                                    List<User>>(
                                                                  future: Provider.of<
                                                                              UserDbHelper>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getUsers(),
                                                                  builder: (BuildContext
                                                                          context,
                                                                      AsyncSnapshot<
                                                                              List<User>>
                                                                          snapshot) {
                                                                    if (snapshot
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .waiting) {
                                                                      return const Center(
                                                                          child:
                                                                              CircularProgressIndicator());
                                                                    } else {
                                                                      if (snapshot
                                                                          .hasError) {
                                                                        return Center(
                                                                            child:
                                                                                Text('Erro: ${snapshot.error}'));
                                                                      } else {
                                                                        final users =
                                                                            snapshot.data!;
                                                                        return Scrollbar(
                                                                          thickness:
                                                                              4.0,
                                                                          radius: const Radius
                                                                              .circular(
                                                                              5.0),
                                                                          child:
                                                                              ListView.builder(
                                                                            itemCount:
                                                                                users.length,
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemBuilder:
                                                                                (_, index) {
                                                                              return Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: ListTile(
                                                                                  title: Text(users[index].name),
                                                                                  onTap: () {
                                                                                    final loan = Loan(
                                                                                      id: DateTime.now().millisecondsSinceEpoch,
                                                                                      user: users[index],
                                                                                      book: books[index],
                                                                                      startDateLoan: DateTime.now(),
                                                                                    );
                                                                                    Provider.of<LoanDbHelper>(context, listen: false).saveLoan(loan);
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        );
                                                                      }
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: 0,
                                                        child: IconButton(
                                                          icon: const Icon(
                                                              Icons.close),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                    }
                                  }),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Divider(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
