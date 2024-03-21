import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helpers/loan_db_helper.dart';
import '../../models/loan_model.dart';

class BorrowedBooksPage extends StatefulWidget {
  const BorrowedBooksPage({super.key});

  @override
  State<BorrowedBooksPage> createState() => _BorrowedBooksPageState();
}

class _BorrowedBooksPageState extends State<BorrowedBooksPage> {
  bool showReturnedBooks = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lended Books'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text(
                      'Emprestados',
                      style: TextStyle(
                        color:
                            showReturnedBooks ? Colors.blueGrey : Colors.black,
                        fontWeight: !showReturnedBooks
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showReturnedBooks = false;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                    child: VerticalDivider(
                      // color: Colors.black,
                      thickness: 1,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Devolvidos',
                      style: TextStyle(
                        color:
                            !showReturnedBooks ? Colors.blueGrey : Colors.black,
                        fontWeight: showReturnedBooks
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showReturnedBooks = true;
                      });
                    },
                  ),
                ],
              ),
              const Divider(
                height: 1,
                thickness: 1,
              )
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Loan>>(
              future: Provider.of<LoanDbHelper>(context).getLoans(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  final borrowedBooks = snapshot.data;
                  if (borrowedBooks!.isEmpty) {
                    return const Center(
                      child: Text('No Lended Books'),
                    );
                  }
                  final filteredBooks = borrowedBooks.where((loan) {
                    return showReturnedBooks
                        ? loan.endDateLoan != null
                        : loan.endDateLoan == null;
                  }).toList();

                  if (filteredBooks.isEmpty) {
                    return Center(
                      child: Text(showReturnedBooks
                          ? 'No returned books'
                          : 'No Lended Books'),
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final loan = filteredBooks[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(loan.book.title),
                            subtitle: Text(loan.book.author),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(loan.book.title),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              'Emprestado para: ${loan.user.name}'),
                                          const SizedBox(height: 10),
                                          Text(
                                              'Emprestado em: ${DateFormat('dd/MM/yyyy').format(loan.startDateLoan)}'),
                                          const SizedBox(height: 10),
                                          if (loan.endDateLoan != null)
                                            Text(
                                                'Devolvido em: ${DateFormat('dd/MM/yyyy').format(loan.endDateLoan!)}'),
                                        ],
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Fechar'),
                                            ),
                                            if (loan.endDateLoan == null)
                                              TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Devolução de Livro'),
                                                        content: const Text(
                                                            'Confirma que o livro foi devolvido?'),
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
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    'Cancelar'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  loan.endDateLoan =
                                                                      DateTime
                                                                          .now();
                                                                  Provider.of<LoanDbHelper>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .updateLoan(
                                                                          loan);
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      backgroundColor: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          77,
                                                                          144,
                                                                          117),
                                                                      content: Text(
                                                                          'Registrada a devolução de ${loan.book.title}.'),
                                                                    ),
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Sim'),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: const Text(
                                                    'Devolver Livro'),
                                              )
                                          ],
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                          ),
                        ],
                      );
                    },
                  );
                }
                return const Center(
                  child: Text('No borrowed books'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
