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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrowed Books'),
      ),
      body: FutureBuilder<List<Loan>>(
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
            return ListView.builder(
              itemCount: borrowedBooks.length,
              itemBuilder: (context, index) {
                final loan = borrowedBooks[index];
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Emprestado para:${loan.user.name}'),
                                Text(
                                    'Data de empréstimo: ${loan.startDateLoan}'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        });
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await Provider.of<LoanDbHelper>(context, listen: false)
                          .deleteLoan(loan.id);
                      setState(() {});
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text('No borrowed books'),
          );
        },
      ),
    );
  }
}
