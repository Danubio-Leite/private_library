// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:private_library/models/loan_model.dart';
import 'package:provider/provider.dart';

import '../../components/custom_dialog.dart';
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
  Future<List<Book>>? _booksFuture;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
    _booksFuture = Provider.of<BookDbHelper>(context, listen: false).getBooks();
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
              future: _booksFuture,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else {
                    final books = (snapshot.data ?? []).where((book) {
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
                                    final book = books[index];
                                    if (users.isEmpty) {
                                      customDialogBox(
                                        context,
                                        'Nenhum usuário cadastrado',
                                        book,
                                        const Text(
                                            'Por favor, cadastre um usuário antes de emprestar um livro.'),
                                        [
                                          TextButton(
                                            child: const Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Cadastrar'),
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return const AddUserPage(
                                                      twoPop: true);
                                                },
                                              ));
                                            },
                                          ),
                                        ],
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
                                        customDialogBox(
                                            context,
                                            'Livro já emprestado',
                                            book,
                                            const Text(
                                                'Este livro já está emprestado. Por favor, escolha outro livro ou verifique o status do empréstimo.'),
                                            [
                                              TextButton(
                                                child: const Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ]);
                                      } else if (readings.any((reading) =>
                                          reading.book.id == books[index].id &&
                                          reading.endDateReading == null)) {
                                        customDialogBox(
                                            context,
                                            'Leitura em andamento',
                                            book,
                                            const Text(
                                                'Você está lendo este livro. Deseja registrar o término da leitura?'),
                                            [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Não'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  final reading = readings
                                                      .firstWhere((reading) =>
                                                          reading.book.id ==
                                                              books[index].id &&
                                                          reading.endDateReading ==
                                                              null);
                                                  reading.endDateReading =
                                                      DateTime.now();
                                                  Provider.of<ReadingDbHelper>(
                                                          context,
                                                          listen: false)
                                                      .updateReading(reading);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Leitura finalizada com sucesso.'),
                                                    ),
                                                  );
                                                },
                                                child: const Text('Sim'),
                                              ),
                                            ]);
                                      } else
                                        customDialogBox(
                                            context,
                                            'Escolha um usuário para emprestar o livro:',
                                            book,
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              child: FutureBuilder<List<User>>(
                                                future:
                                                    Provider.of<UserDbHelper>(
                                                            context,
                                                            listen: false)
                                                        .getUsers(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<List<User>>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  } else {
                                                    if (snapshot.hasError) {
                                                      return Center(
                                                          child: Text(
                                                              'Erro: ${snapshot.error}'));
                                                    } else {
                                                      final users =
                                                          snapshot.data!;
                                                      return Scrollbar(
                                                        thickness: 4.0,
                                                        radius: const Radius
                                                            .circular(5.0),
                                                        child: ListView.builder(
                                                          itemCount:
                                                              users.length,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (_, index) {
                                                            return Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: ListTile(
                                                                title: Text(
                                                                    users[index]
                                                                        .name),
                                                                onTap: () {
                                                                  customDialogBox(
                                                                      context,
                                                                      'Confirmação de Empréstimo',
                                                                      book,
                                                                      Text(
                                                                          'Deseja emprestar o livro para ${users[index].name}?'),
                                                                      [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text('Não'),
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                final loan = Loan(
                                                                                  id: DateTime.now().millisecondsSinceEpoch,
                                                                                  user: users[index],
                                                                                  book: book,
                                                                                  startDateLoan: DateTime.now(),
                                                                                );
                                                                                Provider.of<LoanDbHelper>(context, listen: false).saveLoan(loan);
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  SnackBar(
                                                                                    backgroundColor: const Color.fromARGB(255, 77, 144, 117),
                                                                                    content: Text('Livro Emprestado para ${users[index].name}.'),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              child: const Text('Sim'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ]);
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
                                            [
                                              SingleChildScrollView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                          'Cancelar'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return const AddUserPage(
                                                                twoPop: true,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      child: const Text(
                                                          'Cadastrar Novo'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]);
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
