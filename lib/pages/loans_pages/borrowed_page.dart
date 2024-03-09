import 'package:flutter/material.dart';
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
        title: const Text('Borrowed Books'),
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
                      child: Text('No borrowed books'),
                    );
                  }
                  final filteredBooks = borrowedBooks.where((loan) {
                    return showReturnedBooks
                        ? loan.endDateLoan != null
                        : loan.endDateLoan == null;
                  }).toList();
                  return ListView.builder(
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final loan = filteredBooks[index];
                      return ListTile(
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
                                      Text('Emprestado para:${loan.user.name}'),
                                      Text(
                                          'Data de empréstimo: ${loan.startDateLoan}'),
                                      if (loan.endDateLoan != null)
                                        Text(
                                            'Data de devolução: ${loan.endDateLoan}'),
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
                                          child: const Text('Close'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            loan.endDateLoan = DateTime.now();
                                            Provider.of<LoanDbHelper>(context,
                                                    listen: false)
                                                .updateLoan(loan);
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Return book'),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              });
                        },
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
