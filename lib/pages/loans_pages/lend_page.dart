import 'package:flutter/material.dart';
import 'package:private_library/models/loan_model.dart';
import 'package:provider/provider.dart';

import '../../helpers/book_db_helper.dart';
import '../../helpers/loan_db_helper.dart';
import '../../helpers/user_db_helper.dart';
import '../../models/book_model.dart';
import '../../models/user_model.dart';

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
                                onTap: () {
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
                                                  width: constraints.maxWidth *
                                                      0.8, // 80% da largura da tela
                                                  child: SingleChildScrollView(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    child: Column(
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 24.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              'O livro está sendo emprestado para:',
                                                              style: TextStyle(
                                                                  fontSize: 21,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
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
                                                                        List<
                                                                            User>>
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
                                                                      child: Text(
                                                                          'Erro: ${snapshot.error}'));
                                                                } else {
                                                                  final users =
                                                                      snapshot
                                                                          .data!;
                                                                  return Scrollbar(
                                                                    thickness:
                                                                        4.0,
                                                                    radius: const Radius
                                                                        .circular(
                                                                        5.0),
                                                                    child: ListView
                                                                        .builder(
                                                                      itemCount:
                                                                          users
                                                                              .length,
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemBuilder:
                                                                          (_, index) {
                                                                        return Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              ListTile(
                                                                            title:
                                                                                Text(users[index].name),
                                                                            onTap:
                                                                                () {
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
                                                    icon:
                                                        const Icon(Icons.close),
                                                    onPressed: () {
                                                      Navigator.of(context)
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
                                },
                              ),
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
