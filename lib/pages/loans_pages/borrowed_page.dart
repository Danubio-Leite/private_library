import 'package:flutter/material.dart';

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
      body: const Center(
        child: Text('Lista de livros emprestados'),
      ),
    );
  }
}
